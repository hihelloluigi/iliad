//
//  APIEndpoint+Core.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation
import Moya

extension APIEndpoint: TargetType {
    
    var headers: [String: String]? {
        return [
            "Content-Type": contentType
        ]
    }
    
    var baseURL: URL {
        return getProperEndpoint(api: self)
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var contentType: String {
        return "application/json"
    }
    
    var sampleData: Data {
        return try! JSONSerialization.data(withJSONObject: [String: String](), options: .prettyPrinted)
    }
    
    private func getProperEndpoint(api: APIEndpoint) -> URL {
        return URL(string: AppConfig.shared.apiBaseURL)!
    }
}
