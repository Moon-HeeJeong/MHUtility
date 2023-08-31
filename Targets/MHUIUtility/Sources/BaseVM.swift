//
//  BaseVM.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/07.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

open class BaseVM: ObservableObject{
    
    @Published open var uiUtilitykind: UIUtility_E?
    
    open func setUIUtility(kind: UIUtility_E?){
        self.uiUtilitykind = kind
    }
    
    public init(uiUtilitykind: UIUtility_E? = nil) {
        if let kind = uiUtilitykind{
            self.uiUtilitykind = kind
        }
    }
}
