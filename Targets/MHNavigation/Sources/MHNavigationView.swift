//
//  MHNavigationView.swift
//
//
//  Created by LittleFoxiOSDeveloper on 2023/10/17.
//

import SwiftUI

public struct MHNavigationView<Content: View>: View {
    
    @State var navigationBarHeight: CGFloat
    @State var statusBarColor: Color
    @State var backgroundType: MHNavigationController.BackgroundType
    @State var titleType: MHNavigationController.TitleType
    @State var backImage: UIImage?
    @State var closeImage: UIImage?
    @State var isNavigationBarHidden: Bool
    @Binding var isBackBtnHidden: Bool
    @Binding var isCloseBtnHidden: Bool
    @Binding var isUsePreference: Bool
    
    @Binding var action: MHNavigationController.CloseAction?
    var backEvent: MHNavigationController.Event?
    var closeEvent: MHNavigationController.Event?
    var content: ()->Content
    
    public init(navigationBarHeight: CGFloat, statusBarColor: Color, backgroundType: MHNavigationController.BackgroundType, titleType: MHNavigationController.TitleType, backImage: UIImage? = nil, closeImage: UIImage? = nil, isNavigationBarHidden: Bool, isBackBtnHidden: Binding<Bool>, isCloseBtnHidden: Binding<Bool>, isUsePreference: Binding<Bool> = .constant(true), action: Binding<MHNavigationController.CloseAction?> = .constant(nil), backEvent: MHNavigationController.Event? = nil, closeEvent: MHNavigationController.Event? = nil, content: @escaping () -> Content) {
        self.navigationBarHeight = navigationBarHeight
        self.statusBarColor = statusBarColor
        self.backgroundType = backgroundType
        self.titleType = titleType
        self.backImage = backImage
        self.closeImage = closeImage
        self._isBackBtnHidden = isBackBtnHidden
        self._isCloseBtnHidden = isCloseBtnHidden
        self.isNavigationBarHidden = isNavigationBarHidden
        self._isUsePreference = isUsePreference
        self._action = action
        self.backEvent = backEvent
        self.closeEvent = closeEvent
        self.content = content
    }
    
    public var body: some View {
        MHNavigationViewWrapper(navigationBarHeight: $navigationBarHeight,
                                statusBarColor: $statusBarColor,
                                backgroundType: $backgroundType,
                                titleType: $titleType,
                                backImage: $backImage,
                                closeImage: $closeImage,
                                isNavigationBarHidden: $isNavigationBarHidden,
                                isBackBtnHidden: $isBackBtnHidden,
                                isCloseBtnHidden: $isCloseBtnHidden,
                                action: $action,
                                backEvent: backEvent,
                                closeEvent: closeEvent,
                                content: content, callback: { navi, controller in
            
        })
        
        .onPreferenceChange(StatusBarColorPreferenceKey.self, perform: { color in
            guard self.isUsePreference else{
                return
            }
            self.statusBarColor = color
        })
        .onPreferenceChange(TitleTextPreferenceKey.self, perform: { titles in
            guard self.isUsePreference else{
                return
            }
            
            let titleFont = self.titleType.titleFontInfo
            let subTitleFont = self.titleType.subTitleFontInfo
            
            self.titleType = MHNavigationController.TitleType.text(
                title: MHNavigationController.TextInfo(text: titles.title, fontInfo: titleFont),
                subTitle: MHNavigationController.TextInfo(text: titles.subTitle, fontInfo: subTitleFont))
        })
        .onPreferenceChange(TitleImagePreferenceKey.self, perform: { image in
            guard self.isUsePreference else{
                return
            }
            self.titleType = MHNavigationController.TitleType.image(image: image)
        })
        .onPreferenceChange(BackgroundTypePreferenceKey.self, perform: { type in
            guard self.isUsePreference else{
                return
            }
            guard let type = type else{
                return
            }
            self.backgroundType = type
        })
        .onPreferenceChange(BackButtonImagePreferenceKey.self, perform: { image in
            guard self.isUsePreference else{
                return
            }
            self.backImage = image
        })
        .onPreferenceChange(CloseButtonImagePreferenceKey.self, perform: { image in
            guard self.isUsePreference else{
                return
            }
            self.closeImage = image
        })
        .onPreferenceChange(NavigationBarHiddenPreferenceKey.self, perform: { isHidden in
            guard self.isUsePreference else{
                return
            }
            self.isNavigationBarHidden = isHidden
        })
        .onPreferenceChange(BackButtonHiddenPreferenceKey.self, perform: { isHidden in
            guard self.isUsePreference else{
                return
            }
            self.isBackBtnHidden = isHidden
        })
        .onPreferenceChange(CloseButtonHiddenPreferenceKey.self, perform: { isHidden in
            guard self.isUsePreference else{
                return
            }
            self.isCloseBtnHidden = isHidden
        })
        .ignoresSafeArea([.container])
    }
}
