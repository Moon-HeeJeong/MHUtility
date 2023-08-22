//
//  MHUserDefaults.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/07/21.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation

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

    public var value: T?{
        UserDefaults.standard.value(forKey: self.rawValue) as? T
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
