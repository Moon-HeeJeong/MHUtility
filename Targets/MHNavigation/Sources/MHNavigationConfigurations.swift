//
//  MHNavigationConfigurations.swift
//  MHNavigation
//
//  Created by Littlefox iOS Developer on 11/21/23.
//

import SwiftUI

public class MHNavigationConfiguration: ObservableObject{
    
    deinit{
        print("deitit \(self)")
    }
    
    @Published public var statusBarColor: Color
    @Published public var navigationBarBackgroundType: MHNavigationController.BackgroundType
    @Published public var navigationBarTitleType: MHNavigationController.TitleType
    @Published public var navigationBarHeight: CGFloat
    @Published public var closeImage: UIImage?
    @Published public var backImage: UIImage?
    @Published public var isNavigationBarHidden: Bool
    @Published public var isBackBtnHidden: Bool
    @Published public var isCloseBtnHidden: Bool
    @Published public var action: MHNavigationController.CloseAction?
    @Published public var isUsePreference: Bool
    
    public var backEvent: MHNavigationController.Event?
    public var closeEvent: MHNavigationController.Event?
    
    public init(statusBarColor: Color,
                navigationBarBackgroundType: MHNavigationController.BackgroundType,
                navigationBarTitleType: MHNavigationController.TitleType,
                navigationBarHeight: CGFloat,
                closeImage: UIImage? = nil,
                backImage: UIImage? = nil,
                isNavigationBarHidden: Bool,
                isBackBtnHidden: Bool,
                isCloseBtnHidden: Bool,
                action: MHNavigationController.CloseAction? = nil,
                isUsePreference: Bool,
                backEvent: MHNavigationController.Event? = nil,
                closeEvent: MHNavigationController.Event? = nil) {
        self.statusBarColor = statusBarColor
        self.navigationBarBackgroundType = navigationBarBackgroundType
        self.navigationBarTitleType = navigationBarTitleType
        self.navigationBarHeight = navigationBarHeight
        self.closeImage = closeImage
        self.backImage = backImage
        self.isNavigationBarHidden = isNavigationBarHidden
        self.isBackBtnHidden = isBackBtnHidden
        self.isCloseBtnHidden = isCloseBtnHidden
        self.action = action
        self.isUsePreference = isUsePreference
        self.backEvent = backEvent
        self.closeEvent = closeEvent
    }
}


public struct MHNavigation<Content: View>: UIViewControllerRepresentable{

    @ObservedObject var config: MHNavigationConfiguration
    var content: () -> Content
//    var callback: (UINavigationController, UIViewController) -> Void
    
    public init(config: MHNavigationConfiguration, content: @escaping () -> Content) {
        self.config = config
        self.content = content
//        self.callback = callback
    }

    public func makeUIViewController(context: Context) -> MHNavigationController {
        let root = content().ignoresSafeArea([.container])
        
        let navigationController = MHNavigationController(navigationHeight: self.config.navigationBarHeight,
                                                          statusBarColor: UIColor(cgColor: self.config.statusBarColor.cgColor!),
                                                          backgroundType: self.config.navigationBarBackgroundType,
                                                          titleType: self.config.navigationBarTitleType,
                                                          backImage: self.config.backImage,
                                                          closeImage: self.config.closeImage,
                                                          backEvent: self.config.backEvent,
                                                          closeEvent: self.config.closeEvent,
                                                          rootViewController: UIHostingController(rootView: root))
        navigationController.delegate = context.coordinator
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: MHNavigationController, context: Context) {
        
        uiViewController.statusBarColor = UIColor(cgColor: self.config.statusBarColor.cgColor!)
        uiViewController.backgroundType = self.config.navigationBarBackgroundType
        uiViewController.titleType = self.config.navigationBarTitleType
        
        if let image = self.config.backImage{
            uiViewController.backBtnImage = image
        }
        if let image = self.config.closeImage{
            uiViewController.closeBtnImage = image
        }

        uiViewController.isBackBtnHidden = self.config.isBackBtnHidden
        uiViewController.isCloseBtnHidden = self.config.isCloseBtnHidden
        uiViewController.isNaviBarHidden = self.config.isNavigationBarHidden
        
        uiViewController.setBackEvent(event: self.config.backEvent)
        uiViewController.setCloseEvent(event: self.config.closeEvent)
        uiViewController.closeAction = self.config.action
    }
    
    public func makeCoordinator() -> NavigationSlave {
        NavigationSlave(owner: self)
    }
    
    public class NavigationSlave: NSObject, UINavigationControllerDelegate{
        
        var owner: MHNavigation
        
        public init(owner: MHNavigation) {
            self.owner = owner
        }
        
        public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//            self.owner.callback(navigationController, viewController)
        }
        
    }
}
