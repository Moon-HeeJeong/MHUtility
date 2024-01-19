//
//  ContentView.swift
//  MHUtilityTestAppSwiftUI
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import SwiftUI
import MHVideoPlayerWithDelegateView
import MHUIUtility

enum AppRouter: SheetRouterProtocol{
  
    case videoPlayer
    
    var id: String {
        "\(self)"
    }
    
    @ViewBuilder func buildView(isSheeted: Binding<Bool>) -> some View {
        switch self {
        case .videoPlayer:
            return MHVideoPlayerTestView()
        }
    }
}
enum AppRouterKind{
    case pop1
    case pop2
    case pop3
}

class AppRouterVM: BaseVM{
    func received(event: AppRouterKind) {
        print("event \(event)")
        switch event {
        case .pop1:
            self.makeUIUtility(kind: .yjAlert(info: .init(type: .oneBtn_confirm(actionTitle: "닫기", action: {
                print("makeUIUtility")
            }), title: "테스트", message: "팝업이 잘열리나?")))
            break
        case .pop2:
            self.makeUIUtility(kind: .yjAlert(info: .init(type: .twoBtn(actionTitle: "로그아웃", action: {
                print("로그아웃")
            }), title: "파닉스", message: "로그아웃 할래?")))
            break
        case .pop3:
            self.makeUIUtility(kind: .yjAlert(info: .init(type: .twoBtn_custom(actionTitle: "닫기",
                                                                               cancelTitle: "로그아웃",
                                                                               action: {
                print("닫기")
            },
                                                                               cancelAction: {
                print("로그아웃")
            }),
                                                          title: "파닉스",
                                                          message: "로그아웃 할래로그아웃 할래로그아웃 할래로그아웃 할래",
                                                          errorDesc: "abdkeoekdo9ekleio", 
                                                          kind: .warnning)))
            break
        }
        
    }
}

/**
 class AppRouterVM: BaseVM{
     func received(event: AppRouterKind) {
         print("event \(event)")
         switch event {
         case .pop1:
             self.makeUIUtility(kind: .yjAlert(info: .init(type: .oneBtn_confirm(actionTitle: "닫기", action: {
                 print("makeUIUtility")
             }), title: "테스트", message: "팝업이 잘열리나?")))
         case .pop2:
             self.makeUIUtility(kind: .yjAlert(info: .init(type: .twoBtn(actionTitle: "로그아웃", action: {
                 print("로그아웃")
             }), title: "파닉스", message: "로그아웃 할래?")))
         case .pop3:
             self.makeUIUtility(kind: .yjAlert(info: .init(type: .twoBtn_custom(actionTitle: "닫기",
                                                                                cancelTitle: "로그아웃",
                                                                                action: {
                 print("닫기")
             },
                                                                                cancelAction: {
                 print("로그아웃")
             }),
                                                           title: "파닉스",
                                                           message: "로그아웃 할래로그아웃 할래로그아웃 할래로그아웃 할래")))
         }
         
     }
 }
 */

struct ContentView: View {
    @StateObject var vm = AppRouterVM()
    @StateObject var router = MovingSheetOperator<AppRouter>()
    
    var body: some View {
        GeometryReader(content: { geometry in
            List {
                Button("pop1") {
                    self.vm.received(event: .pop1)
                }
                Button("pop2") {
                    self.vm.received(event: .pop2)
                }
                Button("pop3") {
                    self.vm.received(event: .pop3)
                }
            }
        })
        .initSetUIUtility(kind: $vm.uiUtilitykind)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
