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
    
    @ViewBuilder
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
                case .oneBtn_confirm:
                    return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""), dismissButton: Alert.Button.default(Text("확인")))

                case .twoBtn(let actionTitle, let action):
                    let actionBtn = Alert.Button.default(Text(actionTitle ?? "확인"), action: action)

                    return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: Alert.Button.cancel(Text("취소")), secondaryButton: actionBtn)

                default:
                    return Alert(title: Text("aaaa"))
                }
            }
            
        case .loading:
            ZStack {
                content
                ProgressView()
                    .scaleEffect(2, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .mainBtn))
            }
        default:
             content
        }
    }
}
