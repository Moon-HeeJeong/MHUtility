//
//  APIResponse.swift
//  Phonics
//
//  Created by Littlefox iOS Developer on 2023/07/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import Combine

public protocol Response_P: Model_T{
    
    associatedtype Model: Model_T
    
    var responseType: Response_E {get set}
    var data: Model {get set}
    
    init(responseType: Response_E, data: Model)
}

public enum Response_E{
    case ok(code: Int, message: String?)
    case error(code: Int, message: String?)
    
    public var message: String?{
        switch self {
        case .ok(_, let message):
            return message
        case .error(_, let message):
            return message
        }
    }
    
    public var isOK: Bool{
        switch self {
        case .ok(_, _):
            return true
        case .error(_, _):
            return false
        }
    }
    
    public var code: Int{
        switch self {
        case .ok(let code, _):
            return code
        case .error(let code, _):
            return code
        }
    }
}


//example
public struct Response<Model: MHDataType_P>: Response_P{
    
    public var responseType: Response_E
    public var data: Model
    
    public var accessToken: String?{
        get{
            UserDefaults.standard.value(forKey: "loginToken") as? String
        }
        set{
            if let newValue = newValue{
                UserDefaults.standard.set(newValue, forKey: "loginToken")
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case status
        case message
        case data
        case access_token
    }
    
    public init(responseType: Response_E, data: Model) {
        self.responseType = responseType
        self.data = data
    }
    
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try? container.decode(Int.self, forKey: .status)
        let message = try? container.decode(String.self, forKey: .message)
        
        self.data = try container.decode(Model.self, forKey: .data)
        
        if status == 200{
//            self.responseType = .ok(message: message)
            self.responseType = .ok(code: 200, message: message)
        }else{
//            if let _ = self.data{
//                self.responseType = .ok(message: message)
//                self.responseType = .ok(code: status ?? 200, message: message)
//            }else{
                self.responseType = .error(code: status ?? -1, message: message)
//            }
        }
        
        self.accessToken = try? container.decode(String.self, forKey: .access_token)
    }
}
