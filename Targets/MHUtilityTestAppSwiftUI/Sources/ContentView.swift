//
//  ContentView.swift
//  MHUtilityTestAppSwiftUI
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import SwiftUI
import MHVideoPlayerWithDelegateView


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
    case studyWithVideo
}

class AppRouterVM: ObservableObject{
    func received(event: AppRouterKind) {
        print("event \(event)")
    }
}

struct ContentView: View {
    @StateObject var vm = AppRouterVM()
    @StateObject var router = MovingSheetOperator<AppRouter>()
    
    var body: some View {
        MHVideoPlayerTestView()
//        List {
//            Section {
//                Button("video player") {
//                    router.go(.videoPlayer, animation: .full(animationOn: true))
//                }
//            }
//        }
//        .routering($router.sheets)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
