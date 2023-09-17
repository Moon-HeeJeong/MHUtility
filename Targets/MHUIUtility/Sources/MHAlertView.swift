//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/09/01.
//

import Foundation
import SwiftUI

struct MHAlertView: View {
    
    @Binding var info: AlertInfo?
    @Binding var isShow: Bool
    
    var body: some View{
        
        Button {
            
        } label: {
            
        }.alert(isPresented: $isShow) {
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
                
            case .twoBtn_custom(let actionTitle, let cancelTitle, let action, let cancelAction):
                let actionBtn = Alert.Button.default(Text(actionTitle ?? "확인"), action: action)
                
                var cancelBtn: Alert.Button
                
                if let cancelAction = cancelAction {
                    cancelBtn = Alert.Button.default(Text(cancelTitle ?? "취소"), action: cancelAction)
                }else{
                    cancelBtn = Alert.Button.default(Text(cancelTitle ?? "취소"))
                }
                
                
                return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: cancelBtn, secondaryButton: actionBtn)
                
            default:
                return Alert(title: Text(""))
            }
        }
    }
}

