//
//  UIUtilityModifier.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

struct UIUtilityModifier: ViewModifier{
    

    @Binding var kind: UIUtility_E?
    
//    @ViewBuilder
    
    func body(content: Content) -> some View {
        
        var isShow: Binding<Bool> {
            Binding {
                self.kind != .stop
            } set: {
                if $0 == false{
                    self.kind = .stop
                }
            }
        }
        
        switch kind {
        case .alert(let info):
           
            content.alert(isPresented: isShow) {
                switch info?.type{
                case .oneBtn_confirm(let actionTitle, let action):
                    let title = actionTitle ?? "확인"
                    
                    if let action = action{
                        let actionBtn = Alert.Button.default(Text(title), action: action)
                        return Alert(title:  Text(info?.title ?? ""), message: Text(info?.message ?? ""), dismissButton: actionBtn)
                    }else{
                        return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""), dismissButton: Alert.Button.default(Text(title)))
                    }
                    
                case .twoBtn(let actionTitle, let action):
                    let actionBtn = Alert.Button.default(Text(actionTitle ?? "확인"), action: action)
                    
                    return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: Alert.Button.cancel(Text("취소")), secondaryButton: actionBtn)
                    
                default:
                    return Alert(title: Text(""))
                }
            }
            
        case .loading(let color):
//            content.overlay(
//
//            let progressView = ProgressView()
//                .scaleEffect(2, anchor: .center)
//                .progressViewStyle(CircularProgressViewStyle(tint: color))
            
            
            content.progressViewStyle(CircularProgressViewStyle(tint: color))
                
//            )
//            ZStack {
//
////                content.overlay {
//                    ProgressView()
//                        .scaleEffect(2, anchor: .center)
//                        .progressViewStyle(CircularProgressViewStyle(tint: color))
////                }
//            }
        default:
            content.background(Color.black)
            
        
        
        }
    }
    
    
}
