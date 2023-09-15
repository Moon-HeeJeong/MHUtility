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
            
            case .twoBtn(let actionTitle, let cancelTitle, let action):
                let actionBtn = Alert.Button.default(Text(actionTitle ?? "확인"), action: action)
                let cancelBtn = Alert.Button.cancel(Text(cancelTitle ?? "취소"))
//                let noneActionBtn = Alert.Button.cancel(Text(noneActionTitle ?? "취소"))
                
//                return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: noneActionBtn, secondaryButton: actionBtn)
                return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: cancelBtn, secondaryButton: actionBtn)
                
            default:
                return Alert(title: Text(""))
            }
        }
    }
}

