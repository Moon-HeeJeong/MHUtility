//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/09/01.
//

import Foundation
import SwiftUI

struct YJAlertView: View {
    
    @Binding var info: AlertInfo?
    @State var isShow: Bool = true
    
    var body: some View{
        GeometryReader(content: { geometry in
            
            ZStack{
                
                let color = info?.kind == .infomation ? 
                Color.init(red: 0, green: 180/255, blue: 255)
                :Color.init(red: 255/255, green: 201/255, blue: 0)
                
                let systemNameImage = info?.kind == .infomation ?
                Image(systemName: "bell.circle.fill")
                :Image(systemName: "exclamationmark.triangle.fill")
                
                Rectangle()
                    .fill(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
                    .opacity(self.isShow ? 1 : 0)
                    .animation(.easeIn(duration: 0.1), value: self.isShow)
                //817*526
                let wRate: CGFloat = 817 * (UIDevice.current.userInterfaceIdiom == .pad ? 0.9 : 1)
                let hRate: CGFloat = 526 * (UIDevice.current.userInterfaceIdiom == .pad ? 0.9 : 1)
                
                let thRate: CGFloat = hRate*0.2467
                let bhRate: CGFloat = hRate - thRate
//                if self.isShow {
                    let w: CGFloat = {
                        if UIDevice.current.userInterfaceIdiom == .pad{
                            let s = max(geometry.size.width, geometry.size.height)
                            return s*(wRate/2436)
                        }else{
                            let s = min(geometry.size.width, geometry.size.height)
                            return s*0.7
                        }
                    }()
                    let h = w * (hRate/wRate)
                    
                    VStack(spacing: 0){
                        
                        let topH = h * thRate/hRate
                        let bottomH = h - topH
                        HStack{
                            Spacer()
                                .frame(width: w*(35/wRate))
                            systemNameImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: topH*0.5)
                                .foregroundColor(.white)
//                                .colorInvert()
                            Spacer()
                                .frame(width: w*(35/wRate))
                            Text(info?.title ?? "")
                                .font(.system(size: topH*0.4, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(width: w, height: topH)
                        .background(color)
                        
                        VStack(spacing: 0){
                            HStack{
                                Text(info?.message ?? "")
                                    .font(.system(size: bottomH*((UIDevice.current.userInterfaceIdiom == .pad ? 45 : 50)/bhRate), weight:.regular))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            if let errorDesc = info?.errorDesc{
                                Spacer()
                                HStack{
                                    Text(errorDesc)
                                        .font(.system(size: bottomH*(40/bhRate), weight:.light))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            Spacer()
                            HStack{
                                let fontSize = bottomH*((UIDevice.current.userInterfaceIdiom == .pad ? 40 : 45)/bhRate)
                                switch info?.type{
                                case .oneBtn_confirm(let actionTitle, let action):
                                    HStack{
                                        Spacer()
                                        Button {
                                            
                                            action?()
                                            self.isShow = false
//                                            self.info = nil
                                        } label: {
                                            Text(actionTitle ?? "닫기")
                                                .font(.system(size: fontSize, weight: .bold))
                                                .foregroundColor(color)
                                        }
                                    }
                                case .twoBtn(let actionTitle, let action):
                                    HStack{
                                        Spacer()
                                        Button {
                                            self.isShow = false
                                        } label: {
                                            Text("닫기")
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                            .frame(width: w*(60/817))
                                        Button {
                                            action()
                                            self.isShow = false
                                        } label: {
                                            Text(actionTitle ?? "닫기")
                                                .font(.system(size: fontSize, weight: .bold))
                                                .foregroundColor(color)
                                        }
                                    }
                                case .twoBtn_custom(let actionTitle, let cancelTitle, let action, let cancelAction):
                                    HStack{
                                        Spacer()
                                        Button {
                                            action()
                                            self.isShow = false
                                        } label: {
                                            Text(actionTitle ?? "확인")
                                                .font(.system(size: fontSize, weight: .bold))
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                            .frame(width: w*(60/817))
                                        Button {
                                            cancelAction?()
                                            self.isShow = false
                                        } label: {
                                            Text(cancelTitle ?? "닫기")
                                                .font(.system(size: fontSize, weight: .bold))
                                                .foregroundColor(color)
                                        }
                                    }
                                case .none:
                                    EmptyView()
                                }
                            }
                            
                        }
                        .padding(w*0.05)
                        .frame(width: w, height: h-topH)
                        .background(Color.white)
                    }
                    .frame(width: w, height: h)
                    .cornerRadius(15)
                    .scaleEffect(CGSize(width: self.isShow ? 1 : 1.1, height: self.isShow ? 1 : 1.1))
                    .opacity(self.isShow ? 1 : 0)
                    .animation(.easeIn(duration: 0.1), value: self.isShow)
                }
//            }
        })
        .onChange(of: self.info) { newValue in
                if let _ = newValue{
                    
                    self.isShow = true
                }else{
                    self.isShow = false
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
//    YJAlertView(info: .constant(AlertInfo(type: .twoBtn(actionTitle: "확인", action: {
//        
//    }), 
//                                          title: "API Error",
//                                          message: "예상치 못한 오류가 발생했습니다.\n잠시 후 다시 시도해주세요!",
//                                          errorDesc: "오류 내용 : API Error 404",
//                                          kind: .warnning)))
    
    YJAlertView(info: .constant(.init(type: .twoBtn_custom(actionTitle: "취소", cancelTitle: "로그아웃", action: {
        print("취소")
    }, cancelAction: {
        print("로그아웃")
    }), title: "APIError", message: "로그아웃 하시겠습니까? 로그아웃을 어케어케해서 저렇게저렇게 어리너리ㅏㅇ쇼셔ㅛ셔ㅛ셔")))
}
