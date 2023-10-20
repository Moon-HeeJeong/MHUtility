//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/10/16.
//

import Foundation
import UIKit
import SwiftUI

public struct MHNavigationViewWrapper<Content: View>: UIViewControllerRepresentable{
    
    @Binding var navigationBarHeight: CGFloat
    @Binding var statusBarColor: Color
    @Binding var backgroundType: MHNavigationController.BackgroundType
    @Binding var titleType: MHNavigationController.TitleType
    @Binding var backImage: UIImage?
    @Binding var closeImage: UIImage?
    @Binding var isNavigationBarHidden: Bool
    @Binding var isBackBtnHidden: Bool
    @Binding var isCloseBtnHidden: Bool
    
    @Binding var action: MHNavigationController.CloseAction?
    var backEvent: MHNavigationController.Event?
    var closeEvent: MHNavigationController.Event?
    var content: () -> Content
    
    var callback: (UINavigationController, UIViewController) -> Void
    
    public init(navigationBarHeight: Binding<CGFloat>, statusBarColor: Binding<Color>, backgroundType: Binding<MHNavigationController.BackgroundType>, titleType: Binding<MHNavigationController.TitleType>, backImage: Binding<UIImage?>, closeImage: Binding<UIImage?>, isNavigationBarHidden: Binding<Bool>, isBackBtnHidden: Binding<Bool>, isCloseBtnHidden: Binding<Bool>, action: Binding<MHNavigationController.CloseAction?>, backEvent: MHNavigationController.Event?, closeEvent: MHNavigationController.Event?, content: @escaping () -> Content, callback: @escaping (UINavigationController, UIViewController)->Void) {
        _statusBarColor = statusBarColor
        _backgroundType = backgroundType
        _titleType = titleType
        _backImage = backImage
        _closeImage = closeImage
        _isNavigationBarHidden = isNavigationBarHidden
        _isBackBtnHidden = isBackBtnHidden
        _isCloseBtnHidden = isCloseBtnHidden
        _navigationBarHeight = navigationBarHeight
        _action = action
        
        self.backEvent = backEvent
        self.closeEvent = closeEvent
        self.content = content
        self.callback = callback
    }
    
    public func makeUIViewController(context: Context) -> MHNavigationController {
        let root = content()
            .naviViewStatusBarColor(self.statusBarColor)
            .naviViewTitle(self.titleType.title, self.titleType.subTitle)
            .naviViewTitleImage(self.titleType.image)
            .naviViewBackgroundType(self.backgroundType)
            .naviViewBackButtonImage(self.backImage)
            .naviViewCloseButtonImage(self.closeImage)
            .naviViewHidden(self.isNavigationBarHidden)
            .naviViewBackButtonHidden(self.isBackBtnHidden)
            .naviViewCloseButtonHidden(self.isCloseBtnHidden)
        
        let navigationController = MHNavigationController(navigationHeight: navigationBarHeight,
                                                          statusBarColor: UIColor(cgColor: statusBarColor.cgColor!),
                                                          backgroundType: backgroundType,
                                                          titleType: titleType,
                                                          backImage: backImage,
                                                          closeImage: closeImage,
                                                          backEvent: backEvent,
                                                          closeEvent: closeEvent,
                                                          rootViewController: UIHostingController(rootView: root))
        navigationController.delegate = context.coordinator
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        uiViewController.statusBarColor = UIColor(cgColor: self.statusBarColor.cgColor!)
        uiViewController.backgroundType = self.backgroundType
        uiViewController.titleType = self.titleType
        
        if let image = self.backImage{
            uiViewController.backBtnImage = image
        }
        if let image = self.closeImage{
            uiViewController.closeBtnImage = image
        }
        
        print("self \(self.isBackBtnHidden), controller \(uiViewController.isBackBtnHidden), owner \(context.coordinator.owner.isBackBtnHidden)")
        if uiViewController.isBackBtnHidden != context.coordinator.owner.isBackBtnHidden {//!= uiViewController.isBackBtnHidden{
            uiViewController.isBackBtnHidden = self.isBackBtnHidden
            
        }

//        uiViewController.isBackBtnHidden = self.isBackBtnHidden
        uiViewController.isCloseBtnHidden = self.isCloseBtnHidden
        uiViewController.isNaviBarHidden = self.isNavigationBarHidden
        
        uiViewController.setBackEvent(event: self.backEvent)
        uiViewController.setCloseEvent(event: self.closeEvent)
        uiViewController.closeAction = self.action
    }
    
    public func makeCoordinator() -> NavigationSlave {
        NavigationSlave(owner: self)
    }
    
    public class NavigationSlave: NSObject, UINavigationControllerDelegate{
        
        var owner: MHNavigationViewWrapper
        
        public init(owner: MHNavigationViewWrapper) {
            self.owner = owner
        }
        
        public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            self.owner.callback(navigationController, viewController)
        }
        
    }
}


