//
//  APIInfo.swift
//  Phonics
//
//  Created by Littlefox iOS Developer on 2023/07/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation

/** API INFO **/
public protocol MH_APIInfo_P{
    associatedtype Response: Response_P
    
    var short: String {get}
    var method: HTTPMethod {get}
    var parameters: [String:Any]? {get}
    var extraHeaders: [String:String]? {get}
    var config: MH_APIConfig_P? {get}
}

public extension MH_APIInfo_P{
    var address: String{
        (self.config?.baseURL ?? "") + self.short
    }
    var body: Data?{
        self.parameters?.toData
    }
    var urlRequest: URLRequest{
        var urlRequest = URLRequest(url: URL(string: address)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.config?.headers?.forEach { (key,value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        extraHeaders?.forEach({ (key,value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
//        print("headers = \(urlRequest.allHTTPHeaderFields)")
        urlRequest.httpBody = body
        return urlRequest
    }
}
