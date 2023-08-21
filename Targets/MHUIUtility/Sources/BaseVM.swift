//
//  BaseVM.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/07.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

public class BaseVM: ObservableObject{
    
    @Published public var uiUtilitykind: UIUtility_E?
    
    public func setUIUtility(kind: UIUtility_E?){
        self.uiUtilitykind = kind
    }
}
