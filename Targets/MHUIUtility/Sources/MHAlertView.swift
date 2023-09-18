//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/09/01.
//

import Foundation
import SwiftUI

struct MHAlertView: View {
    
    struct AlertInfoWithStatus{
        var info: AlertInfo?
        var isPresented: Bool
        
    }
    
    @Binding var infoWithStatus: AlertInfoWithStatus?
    var isShow: Binding<Bool>{
        Binding {
            infoWithStatus?.isPresented ?? false
        } set: { _ in
            
        }

    }
    var body: some View{
        
//        Button {
//
//        } label: {
//
//        }.aler
        
        
        Button {
            
        } label: {
            
        }.alert(isPresented: isShow) {
            let info = infoWithStatus?.info
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
                let title = actionTitle ?? "확인"
                let actionBtn = Alert.Button.default(Text(title), action: action)
                
                return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: Alert.Button.cancel(Text("취소")), secondaryButton: actionBtn)
                    
                
                
            case .twoBtn_custom(let actionTitle, let cancelTitle, let action, let cancelAction):
//                let actionBtn = Alert.Button.default(Text(actionTitle ?? "확인"), action: action)
//                let cancelBtn = Alert.Button.cancel(Text(cancelTitle ?? "취소"))
                
                let actionTitle = actionTitle ?? "확인"
                let cancelTitle = cancelTitle ?? "취소"
                
                
                if let cancelAction = cancelAction{
                    return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""), primaryButton: .cancel(Text(cancelTitle), action: cancelAction), secondaryButton: .default(Text(actionTitle), action: action))
                }else{
                    return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""), primaryButton: .cancel(Text(cancelTitle)), secondaryButton: .default(Text(actionTitle), action: action))
                }
                
                
//                return Alert(title: Text(info?.title ?? ""), message: Text(info?.message ?? ""),  primaryButton: cancelBtn, secondaryButton: actionBtn)
                
            default:
                return Alert(title: Text(""))
            }
        }
    }
}

