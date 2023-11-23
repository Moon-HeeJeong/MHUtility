//
//  BaseVM.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/07.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

open class BaseVM: ObservableObject{
    
    deinit{
        self.makeUIUtility(kind: .stop)
        print("\(self) deinit")
    }
    
    @Published open var uiUtilitykind: UIUtility_E
    public var cancellables = Set<AnyCancellable>()
    
    open func makeUIUtility(kind: UIUtility_E){
        DispatchQueue.main.async {
            self.uiUtilitykind = kind
        }
        
    }
    
    public init(uiUtilitykind: UIUtility_E = .stop) {
        self.uiUtilitykind = uiUtilitykind
    }
}
