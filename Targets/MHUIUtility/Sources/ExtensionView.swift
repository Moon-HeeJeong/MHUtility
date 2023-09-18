//
//  extensionView.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

//버전 1.0.10
//extension View{
//    public func makeUIUtility(kind: Binding<UIUtility_E?>) -> some View{
//        return self.modifier(UIUtilityModifier(kind: kind))
//    }
//}

//버전 1.0.11  
extension View{
    
    @ViewBuilder
    public func initSetUIUtility(kind: Binding<UIUtility_E>) -> some View{

        self.overlay(
            ZStack(content: {
                MHAlertView(info: kind.wrappedValue.alertInfoBinding)
                    .opacity(kind.wrappedValue.isAlert ? 1:0)
                
                MHCircleProgressView(isEnabled: kind.wrappedValue.isLoadingEnabled, color: kind.wrappedValue.loadingColor)
                    .opacity(kind.wrappedValue.isLoading ? 1:0)
            })
        )
    }
}
