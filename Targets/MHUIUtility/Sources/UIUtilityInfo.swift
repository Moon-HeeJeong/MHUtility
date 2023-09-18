//
//  UIUtilityInfo.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

public enum UIUtility_E: Identifiable, Equatable{
    
    case alert(info: AlertInfo?)
    case loading(isEnabled: Bool, color: Color = .blue)
    case stop
    
    var isLoading: Bool{
        switch self {
        case .loading(_,_):
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
    var loadingColor: Color{
        switch self {
        case .loading(_, let color):
            return color
        default:
            return .blue
        }
    }
    
    var isLoadingEnabled: Bool{
        switch self {
        case .loading(let isEnabled, _):
            return isEnabled
        default:
            return false
        }
    }
    
    var alertInfo: Binding<AlertInfo?>{
        Binding {
            switch self {
            case .alert(let info):
                return info!
            default:
                return nil
            }
        } set: { _ in
            
        }
    }

    public var id: String{
        "\(self)"
    }

    public static func == (lhs: UIUtility_E, rhs: UIUtility_E) -> Bool {
        lhs.id == rhs.id
    }
}

public enum AlertType{
    case oneBtn_confirm(actionTitle: String? = nil, action: (()->())? = nil)
    case twoBtn(actionTitle:String? = nil, action: ()->())
    case twoBtn_custom(actionTitle:String? = nil, cancelTitle:String? = nil, action: ()->())
}

public struct AlertInfo: Identifiable{
    public var id: UUID
    
    public var type: AlertType
    public var title: String
    public var message: String
    
    public init(id: UUID = UUID(), type: AlertType, title: String, message: String) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
    }
}

