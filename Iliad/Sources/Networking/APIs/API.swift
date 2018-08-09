//
//  RemoteAPI+USers.swift
//  BikeApp
//
//  Created by Francesco Colleoni on 16/01/17.
//  Copyright © 2017 Mindtek srl. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import Result

/**
 This class exposes all methods that can be used to send requests to the remote APIs and manage their responses.
 */
class API {
    /**
     Returns a provider, that may use a user authentication token.

        - returns: a Moya provider
     */
    class func provider() -> MoyaProvider<APIEndpoint> {
        let closure = { (target: APIEndpoint) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            
            return Endpoint(url: url,
                            sampleResponseClosure: { .networkResponse(200, Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let networkActivityPlugin = NetworkActivityPlugin { (type, _) in
            switch type {
            case .began:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            case .ended:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
        return MoyaProvider<APIEndpoint>(
            endpointClosure: closure,
            manager: Alamofire.SessionManager(configuration: configuration),
            plugins: [networkActivityPlugin]
        )
    }
}
