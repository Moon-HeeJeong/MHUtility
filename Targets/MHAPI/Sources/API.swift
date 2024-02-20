//
//  LoginAPI.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/06/29.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


public typealias Model_T = Decodable

public protocol MHDataType_P: Model_T{
}

public enum APICallError_E: Error{
    case decodingErr(message: String?)
    case noDataErr(message: String?)
    case networkingErr(message: String?)
    case etcErr(message: String?)
    case urlErr(message: String?)
    case inServerError(code: Int, message: String?)
                       
    public var desc: String?{
        switch self {
        case .decodingErr(let message):
            return message
        case .noDataErr(let message):
            return message
        case .networkingErr(let message):
            return message
        case .etcErr(let message):
            return message
        case .urlErr(let message):
            return message
        case .inServerError(_, let message):
            return message
        }
    }
    
    public var code: Int{
        switch self {
        case .decodingErr(_):
            return 1200
        case .noDataErr(_):
            return 1300
        case .networkingErr(_):
            return 5100
        case .etcErr(_):
            return 2000
        case .urlErr(_):
            return 1100
        case .inServerError(let code, _):
            return code
        }
    }
}

public class MHAPI{

    private var session: URLSession
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    public func call<T: MH_APIInfo_P>(apiInfo: T) -> AnyPublisher<T.Response.Model, APICallError_E>{
        
        let sessionConfig = URLSessionConfiguration.default
        
        guard let url = URL(string: apiInfo.address) else{
            return AnyPublisher(Fail<T.Response.Model, APICallError_E>(error: .urlErr(message: "Invalid URL")))
        }

        print("🦊 request ======================= \nurl ::: \(apiInfo.urlRequest)\nmethod ::: \(apiInfo.urlRequest.httpMethod)\nheader ::: \(String(describing: apiInfo.urlRequest.allHTTPHeaderFields))\nparameter ::: \(String(describing: apiInfo.parameters))\n==================================")
        
        return URLSession.shared.dataTaskPublisher(for: apiInfo.urlRequest).tryMap { data, res in
            
            guard res is HTTPURLResponse else{
                throw APICallError_E.etcErr(message: "Server error")
            }
            return data
            
        }
        .decode(type: T.Response.self, decoder: JSONDecoder())
//        .tryMap { data -> T.Response in
//            do {
//                return try JSONDecoder().decode(T.Response.self, from: data)
//            } catch {
//                throw APICallError_E.decodingErr(message: error.localizedDescription)
//            }
//        }
        .tryMap({ res -> T.Response.Model in
            print("🦊 response ::: \(res)")
//            if res.responseType.isOK{
//                if let d = res.data{
//                    return d
//                }else{
//                    throw APICallError_E.noDataErr(message: "No data received")
//                }
//            }else{
//                throw APICallError_E.inServerError(code: res.responseType.code, message: res.responseType.message)
//            }
            
            return res.data
        })
        .mapError { err in
            if let apiCallError = err as? APICallError_E {
                    return apiCallError
            } else {
                return APICallError_E.inServerError(code: (err as NSError).code, message: err.localizedDescription)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
}


public enum HTTPMethod: String{
    case GET
    case POST
    case PUT
    case DELETE
}


extension Dictionary{
    var toData: Data?{
        try? JSONSerialization.data(withJSONObject: self)
    }
}
