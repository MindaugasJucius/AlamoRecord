//
//  AlamoRecord.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/29/17.
//
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

open class AlamoRecordObject<U: URLProtocol, E: AlamoRecordError>: NSObject, Mappable, NSCoding {
    
    /// Key to encode/decode the id variable
    private let idKey: String = "id"
    
    /// The RequestManager that is tied to all instances of this class
    open class var requestManager: RequestManager<U, E> {
        fatalError("requestManager must be overriden in your AlamoRecordObject subclass")
    }
    
    /// The RequestManager that is tied to this instance
    open var requestManager: RequestManager<U, E> {
        return type(of: self).requestManager
    }
    
    /// The id of this instance. This can be a String or an Int.
    open var id: Any!
    
    /// The root of all instances of this class. This is used when making URL's that relate to a component of this class.
    // Example: '/comment/id' --> '/\(Comment.root)/id'
    open class var root: String {
        fatalError("root must be overriden in your AlamoRecordObject subclass")
    }
    
    /// The root of this instance
    public var root: String {
        return type(of: self).root
    }
    
    /// The plural root of all instances of this class. This is used when making URL's that relate to a component of this class.
    // Example: '/comments/id' --> '/\(Comment.pluralRoot)/id'
    open class var pluralRoot: String {
        return "\(root)s"
    }
    
    /// The pluralRoot of this instance
    public var pluralRoot: String {
        return type(of: self).pluralRoot
    }
    
    /// The key path of all instances of this class. This is used when mapping instances of this class from JSON.
    /*
     Example:
        {
            comment: {
                // json encpasulated here
            }
        }
     
     If this is nil, then the expected JSON woud look like:
        {
            // json encpasulated here
        }
     */
    open class var keyPath: String? {
        return nil
    }
    
    /// The keyPath of this instance
    public var keyPath: String? {
        return type(of: self).keyPath
    }
    
    /// The key path of all instances of this class. This is used when mapping instances of this class from JSON. See keyPath for example
    open class var pluralKeyPath: String? {
        guard let keyPath = keyPath else {
            return nil
        }
        return "\(keyPath)s"
    }
    
    /// The pluralKeyPath of this instance
    public var pluralKeyPath: String? {
        return type(of: self).pluralKeyPath
    }
    
    public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: idKey)
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: idKey)
    }
    
    public required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
    }

    /**
        Returns an array of all objects of this instance if the server supports it
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open class func all<T: AlamoRecordObject>(parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        success: (([T]) -> Void)?,
                        failure: ((E) -> Void)?) -> DataRequest {
        return requestManager.findArray(T.urlForAll(),
                                        parameters: parameters,
                                        keyPath: T.pluralKeyPath,
                                        encoding: encoding,
                                        headers: headers,
                                        success: success,
                                        failure: failure)
    }

    /**
        Creates an object of this instance
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open class func create<T: AlamoRecordObject>(parameters: Parameters? = nil,
                    encoding: ParameterEncoding = URLEncoding.default,
                    headers: HTTPHeaders? = nil,
                    success: ((T) -> Void)?,
                    failure: ((E) -> Void)?) -> DataRequest {
        
        return requestManager.createObject(parameters: parameters,
                                           keyPath: keyPath,
                                           encoding: encoding,
                                           headers: headers,
                                           success: success,
                                           failure: failure)
    }
    
    /**
     Finds an object of this instance based on the given id
     - parameter id: The id of the object to find
     - parameter parameters: The parameters. `nil` by default
     - parameter encoding: The parameter encoding. `URLEncoding.default` by default
     - parameter headers: The HTTP headers. `nil` by default
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open class func find<T: AlamoRecordObject>(id: Any,
                         parameters: Parameters? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: HTTPHeaders? = nil,
                         success: ((T) -> Void)?,
                         failure: ((E) -> Void)?) -> DataRequest {
        
        return requestManager.findObject(id: id,
                                         parameters: parameters,
                                         keyPath: keyPath,
                                         encoding: encoding,
                                         headers: headers,
                                         success: success,
                                         failure: failure)
    }
    
    /**
     Updates the object
     - parameter parameters: The parameters. `nil` by default
     - parameter encoding: The parameter encoding. `URLEncoding.default` by default
     - parameter headers: The HTTP headers. `nil` by default
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open func update<T: AlamoRecordObject>(parameters: Parameters? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil,
                     success: ((T) -> Void)?,
                     failure: ((E) -> Void)?) -> DataRequest {
        
        return T.update(id: id,
                        parameters: parameters,
                        encoding: encoding,
                        headers: headers,
                        success: success,
                        failure: failure)
    }
    
    /**
        Updates an object of this instance based with the given id
        - parameter id: The id of the object to update
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open class func update<T: AlamoRecordObject>(id: Any,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      success: ((T) -> Void)?,
                      failure: ((E) -> Void)?) -> DataRequest {
        
        return requestManager.updateObject(id: id,
                                           parameters: parameters,
                                           keyPath: keyPath,
                                           encoding: encoding,
                                           headers: headers,
                                           success: success,
                                           failure: failure)
    }
    
    /**
     Destroys the object
     - parameter parameters: The parameters. `nil` by default
     - parameter encoding: The parameter encoding. `URLEncoding.default` by default
     - parameter headers: The HTTP headers. `nil` by default
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open func destroy(parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      success: (() -> Void)?,
                      failure: ((E) -> Void)?) -> DataRequest {
        
        return type(of: self).destroy(id: id,
                                      parameters: parameters,
                                      encoding: encoding,
                                      headers: headers,
                                      success: success,
                                      failure: failure)
    }

    /**
        Finds an object of this instance based on the given id
        - parameter id: The id of the object to destroy
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open class func destroy(id: Any,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      success: (() -> Void)?,
                      failure: ((E) -> Void)?) -> DataRequest {
        
        return requestManager.destroyObject(url: urlForDestroy(id),
                                            parameters: parameters,
                                            encoding: encoding,
                                            headers: headers,
                                            success: success,
                                            failure: failure)
    }
    
    /**
     The URL to use when making a create request for all objects of this instance
     */
    open class func urlForCreate() -> U {
        return U(url: "\(pluralRoot)")
    }
    
    public func urlForCreate() -> U {
        return type(of: self).urlForCreate()
    }
    
    /**
        The URL to use when making a find request for all objects of this instance
        - parameter id: The id of the object to find
     */
    open class func urlForFind(_ id: Any) -> U {
        return U(url: "\(pluralRoot)/\(id)")
    }
    
    public func urlForFind(_ id: Any) -> U {
        return type(of: self).urlForFind(id)
    }
    
    /**
        The URL to use when making an update request for all objects of this instance
        - parameter id: The id of the object to update
     */
    open class func urlForUpdate(_ id: Any) -> U {
        return U(url: "\(pluralRoot)/\(id)")
    }
    
    public func urlForUpdate(_ id: Any) -> U {
        return type(of: self).urlForUpdate(id)
    }
    
    /**
        The URL to use when making a destroy request for all objects this instance
        - parameter id: The id of the object to destroy
     */
    open class func urlForDestroy(_ id: Any) -> U {
        return U(url: "\(pluralRoot)/\(id)")
    }
    
    public func urlForDestroy(_ id: Any) -> U {
        return type(of: self).urlForDestroy(id)
    }
    
    /**
     The URL to use when making an all request for all objects of this instance
     */
    open class func urlForAll() -> U {
        return U(url: "\(pluralRoot)")
    }
    
    public func urlForAll() -> U {
        return type(of: self).urlForAll()
    }

}