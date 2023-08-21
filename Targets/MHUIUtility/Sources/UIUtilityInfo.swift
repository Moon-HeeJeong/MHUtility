//
//  UIUtilityInfo.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation

public enum UIUtility_E: Identifiable, Equatable{
    
    case alert(info: AlertInfo?)
    case loading
    case stop
    
    public var id: String{
        "\(self)"
    }
    
    public static func == (lhs: UIUtility_E, rhs: UIUtility_E) -> Bool {
        lhs.id == rhs.id
    }
}

public enum AlertType{
    case oneBtn_confirm
    case twoBtn(actionTitle:String?, action: ()->())
}

public struct AlertInfo: Identifiable{
    public var id = UUID()
    
    public var type: AlertType
    public var title: String
    public var message: String
}
