//
//  API+XT.swift
//  MiTwitProd
//
//  Created by Giovanni Liboni on 27/11/17.
//  Copyright © 2017 MindTek. All rights reserved.
//

import Foundation
import Result
import Moya
import SwiftyJSON


extension API {
    static func responseSuccess(_ result: Result<Moya.Response, MoyaError>, _ completionHandler: SuccessHandler?) {
        API.response(result) { (response) in
            completionHandler?(response != nil)
        }
    }
    
    static func responseJsonArray(_ result: Result<Moya.Response, MoyaError>, _ completionHandler: JsonArraySuccessHandler?) {
        API.responseJson(result) { (json) in
            guard let json = json else {
                completionHandler?(nil)
                return
            }

            completionHandler?(json.array)
        }
    }
    
    static func response(_ result: Result<Moya.Response, MoyaError>, responseHandler: ResponseHandler) {
        switch result {
        case let .success(response):
            API.logRequestAndResponse(response: response)
            responseHandler(response)
        case let .failure(error):
            API.logRequestAndResponse(response: error.response)
            print(error.localizedDescription)
            responseHandler(nil)
        }
    }
    
    static func responseJson(_ result: Result<Moya.Response, MoyaError>, _ completionHandler: JsonSuccessHandler) {
        API.response(result) { (response) in
            guard let response = response else {
                completionHandler(nil)
                return
            }
            
            let json = JSON(response.data)
            if json == JSON.null {
                completionHandler(nil)
                return
            }
            completionHandler(json)
        }
    }
    
    static func logRequestAndResponse(response: Moya.Response?) {
        guard let request = response?.request,
            let url = request.url?.absoluteString,
            let httpMethod = request.httpMethod,
            let statusCode = response?.statusCode
            else {
            return
        }

        print(url)
        print(httpMethod)
        print("\(statusCode)")
    }
}
