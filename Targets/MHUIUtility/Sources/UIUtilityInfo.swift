//
//  UIUtilityInfo.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

public enum UIUtility_E: Identifiable{
    
    case alert(info: AlertInfo?)
    case yjAlert(info: AlertInfo?)
    case loading(isEnabled: Bool, color: Color = .blue, bgColor: Color = .black.opacity(0.3))
    case stop
    
    var isLoading: Bool{
        switch self {
        case .loading(_,_,_):
            return true
        default:
            return false
        }
    }
    var isAlert: Bool{
        switch self {
        case .alert(_):
            return true
        default:
            return false
        }
    }
    
    var isYJAlert: Bool{
        switch self {
        case .yjAlert(_):
            return true
        default:
            return false
        }
    }
    
    var loadingColor: Color{
        switch self {
        case .loading(_, let color, _):
            return color
        default:
            return .blue
        }
    }
    
    var bgColor: Color{
        switch self {
        case .loading(_, _, let bgColor):
            return bgColor
        default:
            return .black.opacity(0.3)
        }
    }
    
    var isLoadingEnabled: Bool{
        switch self {
        case .loading(let isEnabled, _, _):
            return isEnabled
        default:
            return false
        }
    }
    
    var alertInfoBinding: Binding<AlertInfo?>{
        Binding {
            switch self {
            case .alert(let info):
                return info
            default:
                return nil
            }
        } set: { _ in
            
        }
    }
    
    var yjAlertInfoBinding: Binding<AlertInfo?>{
        Binding {
            switch self {
            case .yjAlert(let info):
                return info
            default:
                return nil
            }
        } set: { _ in
            
        }
    }
    
    var isYJAlertBinding: Binding<Bool>{
        Binding {
            switch self {
            case .yjAlert(let info):
                return info != nil
            default:
                return false
            }
        } set: { _ in
            
        }
    }

    public var id: String{
        "\(self)"
    }
}

public enum AlertType{
    case oneBtn_confirm(actionTitle: String? = nil, action: (()->())? = nil)
    case twoBtn(actionTitle:String? = nil, action: ()->())
    case twoBtn_custom(actionTitle:String? = nil, cancelTitle:String? = nil, action: ()->(), cancelAction: (()->())? = nil)
}


public enum AlertKind{
    case warnning
    case infomation
}

public struct AlertInfo: Identifiable, Equatable{
    
    public var id: UUID
    
    public var type: AlertType
    public var title: String
    public var message: String
    public var errorDesc: String?
    
    public var kind: AlertKind
    
    public init(id: UUID = UUID(), type: AlertType, title: String, message: String, errorDesc: String? = nil, kind: AlertKind = .infomation) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        
        self.errorDesc = errorDesc
        self.kind = kind
    }
    
    public static func == (lhs: AlertInfo, rhs: AlertInfo) -> Bool {
        lhs.id == rhs.id
    }
}

