//
//  MHDevice.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/07/28.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import UIKit

public struct MHDeviceInfo{
    public let modelName: String
    public let devideKind: MHDeviceKind
    public let systemName: String
    public let version: String
    public let uuId: String
}

public enum MHDeviceKind: String{
    case phone
    case pad
    case tv
    case mac
    case etc
    
    init(interfaceIdiom: UIUserInterfaceIdiom){
        switch interfaceIdiom {
        case .phone:
            self = .phone
        case .pad:
            self = .pad
        case .tv:
            self = .tv
        case .mac:
            self = .mac
        default:
            self = .etc
        }
    }
}

protocol MHDevice_P{
    
}
extension MHDevice_P{
    public var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var isPhone: Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    private var deviceModel: String {
        var modelStr = ""
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    private var uuid: String {
//        let serviceIdentifier = Bundle.main.bundleIdentifier ?? ""
//        let keyName: String = serviceIdentifier + ".uuid"
        let uuidStr = UUID().uuidString.lowercased()
//        UIDevice.current.identifierForVendor?.uuidString
        return uuidStr
    }
    
    public var deviceInfo: MHDeviceInfo{
        return MHDeviceInfo(modelName: self.deviceModel, devideKind: MHDeviceKind(interfaceIdiom: UIDevice.current.userInterfaceIdiom), systemName: UIDevice.current.systemName, version: UIDevice.current.systemVersion, uuId: self.uuid)
    }
}

public class MHDevice{
    
    public static let work = MHDevice()
    
    public var isPad: Bool {
//        UIDevice.current.localizedModel == "iPhone"
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var isPhone: Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    private var deviceModel: String = {
        var modelStr = ""
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }()
    
    private var uuid: String = {
//        let serviceIdentifier = Bundle.main.bundleIdentifier ?? ""
//        let keyName: String = serviceIdentifier + ".uuid"
        let uuidStr = UUID().uuidString.lowercased()
//        UIDevice.current.identifierForVendor?.uuidString
        return uuidStr
        
    }()
    
    public var deviceInfo: MHDeviceInfo{
        return MHDeviceInfo(modelName: self.deviceModel, devideKind: MHDeviceKind(interfaceIdiom: UIDevice.current.userInterfaceIdiom), systemName: UIDevice.current.systemName, version: UIDevice.current.systemVersion, uuId: self.uuid)
    }
    
    
}
