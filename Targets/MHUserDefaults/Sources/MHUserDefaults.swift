//
//  MHUserDefaults.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/07/21.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import Combine

public protocol MHUserDefaults_P: RawRepresentable where RawValue == String{
    associatedtype T
}
extension MHUserDefaults_P{
    
    public func setValue(_ value: T?){
        guard let value = value else{
            return
        }
        print("UserDefaultsKey Save \(self.rawValue): \(value)")
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func setValueAndGetResult(_ value: T?)->AnyPublisher<Bool, Never>{
        guard let value = value else{
            return Result<Bool, Never>.Publisher(false).eraseToAnyPublisher()
        }
        print("UserDefaultsKey Save \(self.rawValue): \(value)")
        UserDefaults.standard.set(value, forKey: self.rawValue)
        let isSuccess = UserDefaults.standard.synchronize()
        
        return Result<Bool, Never>.Publisher(isSuccess).eraseToAnyPublisher()
    }
    
    public var value: T?{
        UserDefaults.standard.value(forKey: self.rawValue) as? T
    }
    
    public var publishedValue: AnyPublisher<T?, Never>{
        let value = UserDefaults.standard.value(forKey: self.rawValue) as? T
        return Result<T?, Never>.Publisher(value).eraseToAnyPublisher()
    }
    
    public func removeValue(){
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}


//public enum TestUserDefaults<T>: String, MHUserDefaults_P{
//    case pushToken
//    case isCaptionOn
//    case videoVelocity
//    case loginToken
//    case isAutoLogin
//
//    var rawStrValue: String{
//        self.rawValue
//    }
//}
//
//class a{
//    func ff(){
//        TestUserDefaults.isAutoLogin.setValue("ffff")
//    }
//}

//public enum MHUserDefaults<T>: String{
//
//    case pushToken
//    case isCaptionOn
//    case videoVelocity
//    case loginToken
//    case isAutoLogin
//    case isUsePush
//    case userID
//    case userPassword
//
//    public func setValue(_ value: T?){
//        guard let value = value else{
//            return
//        }
//        print("UserDefaultsKey Save \(self.rawValue): \(value)")
//        UserDefaults.standard.set(value, forKey: self.rawValue)
//        UserDefaults.standard.synchronize()
//    }
//
//    public var value: T?{
//        UserDefaults.standard.value(forKey: self.rawValue) as? T
//    }
//}
