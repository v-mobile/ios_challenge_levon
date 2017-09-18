//
//  NetworkManager.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol ResponseSerializable {
    init?(json: JSON?)
}

class NetworkManager {
    
    // MARK: - Variables
    
    static let shared = NetworkManager()
    
    var reachabilityManager: NetworkReachabilityManager?
    var headers: [String: String] = [:]
    
    var isInternetReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    // MARK: - Init
    
    init() {
        
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                self.showNoInternetConnection()
            case .reachable(_), .unknown:
                self.handleConnectedState()
            }
        }
        reachabilityManager?.startListening()
    }
    
    // MARK: - Methods
    
    func handleResponse(response: DataResponse<Any>, completion: @escaping (Any?, ResponseError?) -> Void) {
        
        guard let dict = response.value as? NSDictionary else {
            var message = "Response is not in valid format."
            if let msg = response.value as? String {
                message = msg
            }
            return completion(nil, ResponseError.custom(reason: message))
        }
        if let result = dict["results"] {
            return completion(result, nil)
        }
        return completion(nil, nil)
    }
    
    func setHeaders(additional: [String: String]?) {
        
        // Place default headers here.
        
        if let additional = additional {
            for (key, value) in additional {
                headers[key] = value
            }
        }
    }
}

extension NetworkManager {
    
    func invokeWithRequest(method: RequestMethod, url: String, queryParams: [String: Any]? = nil, additionalHeaders: [String: String]? = nil, completion: @escaping (Any?, ResponseError?) -> Void) {
        
        setHeaders(additional: additionalHeaders)
        
        Alamofire.SessionManager.default.request(url, method: method.type, parameters: queryParams, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            
            if response.result.isFailure && !self.isInternetReachable {
                // TODO
                completion(nil, nil)
                return
            }
            self.handleResponse(response: response, completion: completion)
        }
    }
    
    func invokeRequestWithObject<T: ResponseSerializable>(method: RequestMethod, url: String, queryParams:[String:Any]? = nil, additionalHeaders: [String: String]? = nil, completion: @escaping (T?, ResponseError?) -> Void) {
        
        setHeaders(additional: additionalHeaders)
        
        Alamofire.SessionManager.default.request(url, method: method.type, parameters: queryParams, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response: DataResponse<Any>) in
              
                if response.result.isFailure && !self.isInternetReachable {
                    completion(nil, nil)
                    return
                }
                
                self.handleResponse(response: response, completion: { (result, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    guard let result = result else {
                        completion(nil, ResponseError.custom(reason: "Result is not in expected format"))
                        return
                    }
                    let json = JSON(result)
                    guard let object = T(json: json) else {
                        completion(nil, ResponseError.custom(reason: "Could not create object from response"))
                        return
                    }
                    completion(object, nil)
                })
        }
    }
}

extension NetworkManager {
    
    func showNoInternetConnection() {
        //        isToastShown = true
        //
        //        let view = MessageView.viewFromNib(layout: .StatusLine)
        //        view.backgroundView.backgroundColor = UIColor.errorRed
        //        view.bodyLabel?.textColor = UIColor.white
        //        view.configureContent(body: "error_no_internet".localized())
        //        var viewConfig = SwiftMessages.defaultConfig
        //        viewConfig.duration = .forever
        //        viewConfig.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        //        viewConfig.preferredStatusBarStyle = .lightContent
        //
        //        SwiftMessages.show(config: viewConfig, view: view)
    }
    
    fileprivate func handleConnectedState() {
        
        //        guard isToastShown else {
        //            return
        //        }
        //
        //        isToastShown = false
        //        let connected = MessageView.viewFromNib(layout: .StatusLine)
        //        connected.backgroundView.backgroundColor = UIColor.connectedGreen
        //        connected.bodyLabel?.textColor = UIColor.white
        //        connected.configureContent(body: "status_connected".localized())
        //        var connectedConfig = SwiftMessages.defaultConfig
        //        connectedConfig.duration = .seconds(seconds: 1.5)
        //        connectedConfig.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        //        connectedConfig.preferredStatusBarStyle = .lightContent
        //        SwiftMessages.hide()
        //        SwiftMessages.show(config: connectedConfig, view: connected)
    }
}
