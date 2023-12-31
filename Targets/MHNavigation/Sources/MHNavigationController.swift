//
//  MHNavigationController.swift
//
//
//  Created by LittleFoxiOSDeveloper on 2023/10/13.
//

import Foundation
import UIKit
import SwiftUI


public class MHNavigationController: UINavigationController{
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        .landscape
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    public typealias Event = ()->Void
    
    public enum CloseAction{
        case pop
        case dismiss
        case root
    }
    
    public enum BackgroundType: Equatable{
        case paint(color: UIColor)
        case image(image: UIImage)
    }
    
    public enum TitleType: Equatable{
       
        case text(title: TextInfo, subTitle: TextInfo?)
        case image(image: UIImage)
        
        var title: String?{
            switch self {
            case .text(let title, _):
                return title.text
            case .image(_):
                return nil
            }
        }
        var subTitle: String?{
            switch self {
            case .text(_, let subTitle):
                return subTitle?.text
            case .image(_):
                return nil
            }
        }
        
        var titleFontInfo: FontInfo?{
            switch self {
            case .text(let title, _):
                return title.fontInfo
            case .image(_):
                return nil
            }
        }
        var subTitleFontInfo: FontInfo?{
            switch self {
            case .text(_, let subTitle):
                return subTitle?.fontInfo
            case .image(_):
                return nil
            }
        }
        
        var image: UIImage?{
            switch self {
            case .text(_, _):
                return nil
            case .image(let image):
                return image
            }
        }
    }
    
    public struct TextInfo: Equatable{
        var text: String?
        var fontInfo: FontInfo?
        
        public init(text: String?, fontInfo: FontInfo?) {
            self.text = text
            self.fontInfo = fontInfo
        }
    }
    
    public struct FontInfo: Equatable{
        var color: UIColor?
        var fontName: String?
        var fontSize: CGFloat?
        
        public init(color: UIColor?, fontName: String?, fontSize: CGFloat?) {
            self.color = color
            self.fontName = fontName
            self.fontSize = fontSize
        }
    }
    
    var statusBarColor: UIColor = .clear{
        didSet{
            self.statusBarView.backgroundColor = self.statusBarColor
        }
    }
    
    var backgroundType: BackgroundType = .paint(color: .clear){
        didSet{
            switch self.backgroundType {
            case .paint(let color):
                self.naviBar?.backgroundColor = color
            case .image(let image):
                self.naviBar?.image = image
            }
        }
    }
    
    var titleType: TitleType?{
        didSet{
            switch self.titleType {
            case .text(let titleInfo, let subTitleInfo):
                
                guard let _ = titleInfo.text else{
                    return
                }
                
                //title label
                self.titleImageView?.alpha = 0
                
                let defaultTitleFontSize = UIScreen.main.bounds.height*(62.0/2436.0)
                
                if let customFontName =  titleInfo.fontInfo?.fontName{
                    self.titleLabel?.font = UIFont(name: customFontName, size: titleInfo.fontInfo?.fontSize ?? defaultTitleFontSize)
                }else{
                    self.titleLabel?.font = UIFont.systemFont(ofSize: titleInfo.fontInfo?.fontSize ?? defaultTitleFontSize)
                }
                
                self.titleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                self.titleLabel?.text = titleInfo.text
                self.titleLabel?.textColor = titleInfo.fontInfo?.color
                self.titleLabel?.sizeToFit()
                
               
                //subtitle label
                if let subTitle = subTitleInfo?.text{
                    self.subTitleLabel?.alpha = 0
                    
                    let info = subTitleInfo?.fontInfo
                    let defaultSubTitleFontSize = UIScreen.main.bounds.height*(48.0/2436.0)
                    
                    if let customFontName = info?.fontName{
                        self.subTitleLabel?.font = UIFont(name: customFontName, size: info?.fontSize ?? defaultSubTitleFontSize)
                    }else{
                        self.subTitleLabel?.font = UIFont.systemFont(ofSize: info?.fontSize ?? defaultSubTitleFontSize)
                    }
                    
                    self.subTitleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                    self.subTitleLabel?.text = subTitle
                    self.subTitleLabel?.textColor = info?.color
                    self.subTitleLabel?.sizeToFit()
                    
                    UIView.animate(withDuration: 0.3) {
                        self.titleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                        self.titleLabel?.frame.origin.y = (self.subTitleLabel?.frame.origin.y ?? 0) + (self.subTitleLabel?.frame.height ?? 0)
                        self.subTitleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                        self.subTitleLabel?.frame.origin.y = (self.naviBar?.frame.size.height ?? 0)*(19.0/183.0)
                        
                        self.titleLabel?.alpha = 1
                        self.subTitleLabel?.alpha = 1
                    }
                    
                }else{
                    UIView.animate(withDuration: 0.3) {
                        self.titleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                        self.titleLabel?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - (self.titleLabel?.frame.size.height ?? 0))/2
                        self.titleLabel?.alpha = 1
                        self.subTitleLabel?.alpha = 0
                    }
                }
                break
                
                
            case .image(let image):
                
                let height = self.navigationHeight*(76.0/183.0)
                let width = height*(image.size.width/image.size.height)
                
                self.titleImageView?.image = image
                self.titleImageView?.frame.size = CGSize(width: width, height: height)
                
                UIView.animate(withDuration: 0.3) {
                    self.titleLabel?.alpha = 0
                    self.subTitleLabel?.alpha = 0
                    self.titleImageView?.alpha = 1
                    
                    self.titleImageView?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                    self.titleImageView?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - height)/2
                }
            default:
                break
            }
        }
    }

    var backBtnImage: UIImage?{
        didSet{
            guard oldValue != self.backBtnImage else{
                return
            }
            guard let image = self.backBtnImage else{
                return
            }
            
            if self.isInit{
                self.backBtn?.setImage(image, for: .normal)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.backBtn?.frame.origin.y = -(self.naviBar?.frame.size.height ?? 0)
                } completion: { _ in
                    self.backBtn?.setImage(image, for: .normal)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                       
                        self.backBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - ( self.backBtn?.frame.size.height ?? 0))/2 + self.statusBarHeight
                    }
                }
            }
        }
    }
    
    var closeBtnImage: UIImage?{
        didSet{
            guard oldValue != self.closeBtnImage else{
                return
            }
            guard let image = self.closeBtnImage else{
                return
            }
            
            if self.isInit{
                self.closeBtn?.setImage(image, for: .normal)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.closeBtn?.frame.origin.y = -(self.naviBar?.frame.size.height ?? 0)
                } completion: { _ in
                    self.closeBtn?.setImage(image, for: .normal)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                        self.closeBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - ( self.closeBtn?.frame.size.height ?? 0))/2 + self.statusBarHeight
                    }
                }
            }
        }
    }
    
    var isNaviBarHidden: Bool = false{
        didSet{
            
            guard oldValue != self.isNaviBarHidden else{
                return
            }
            
            self.navigationBar.isHidden = self.isNaviBarHidden
            
            if self.isNaviBarHidden{
                self.naviBar?.alpha = 1
                UIView.animate(withDuration: 0.2) {
                    self.backBtn?.alpha = 0
                    self.closeBtn?.alpha = 0
                } completion: { _ in
                    UIView.animate(withDuration: 0.5) {
                        
                        self.naviBar?.frame.origin.y = -(self.statusBarHeight + UINavigationController().navigationBar.frame.size.height)
                        self.additionalSafeAreaInsets.top = 0
                    }
                }
            }else{
                self.naviBar?.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.naviBar?.alpha = 0.5
                    
                    self.additionalSafeAreaInsets.top = self.navigationHeight - UINavigationController().navigationBar.frame.size.height
                    self.naviBar?.frame.origin.y = self.statusBarHeight
                    
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.naviBar?.alpha = 1
                        self.backBtn?.alpha = 1
                        self.closeBtn?.alpha = 1
                    }
                }
            }
        }
    }
    
    var isBackBtnHidden: Bool = false{
        didSet{
            guard oldValue != self.isBackBtnHidden else{
                return
            }
            
            self.backBtn?.alpha = 1
            
            if self.isBackBtnHidden{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.backBtn?.frame.origin.y = -(self.naviBar?.frame.size.height ?? 0)
                }
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.backBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - ( self.backBtn?.frame.size.height ?? 0))/2 + self.statusBarHeight
                }
            }
        
        }
    }
    
    var isCloseBtnHidden: Bool = false{
        didSet{
            guard oldValue != self.isCloseBtnHidden else{
                return
            }
            
            self.closeBtn?.alpha = 1
            
            if self.isCloseBtnHidden{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.closeBtn?.frame.origin.y = -(self.naviBar?.frame.size.height ?? 0)
                }
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.closeBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - ( self.closeBtn?.frame.size.height ?? 0))/2 + self.statusBarHeight
                }
            }
        }
    }
    
    private let navigationHeight: CGFloat
    
    public var closeAction: CloseAction?{
        didSet{
            switch self.closeAction {
            case .pop:
                self.popViewController(animated: true)
                break
            case .dismiss:
                self.dismiss(animated: true)
                break
            case .root:
                self.popToRootViewController(animated: true)
                break
            default:
                break
            }
        }
    }
    
    
    private var statusBarView: UIView!
    private var naviBar: UIImageView?
    private var titleLabel: UILabel?
    private var subTitleLabel: UILabel?
    private var titleImageView: UIImageView?
    private var backBtn: UIButton?
    private var closeBtn: UIButton?
    
    private var backEvent: Event?
    private var closeEvent: Event?
    
    private var isInit: Bool = true
    
    public init(navigationHeight: CGFloat, statusBarColor: UIColor, backgroundType: BackgroundType, titleType: TitleType? = nil, backImage: UIImage?, closeImage: UIImage?, backEvent: Event?, closeEvent: Event?, rootViewController: UIViewController) {
        
        self.navigationHeight = navigationHeight
        super.init(rootViewController: rootViewController)
        
        self.additionalSafeAreaInsets.top = self.navigationHeight - UINavigationController().navigationBar.frame.size.height
        
        self.backEvent = backEvent
        self.closeEvent = closeEvent
        self.initView(statusBarColor: statusBarColor, backgroundType: backgroundType, titleType: titleType, backImage: backImage, closeImage: closeImage)
        
        self.isInit = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(statusBarColor: UIColor, backgroundType: BackgroundType, titleType: TitleType?, backImage: UIImage?, closeImage: UIImage?){
        
        self.naviBar = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.statusBarHeight),
                                                 size: CGSize(width: self.view.frame.size.width, height: self.navigationHeight)))
        
        
        self.titleLabel = UILabel()
        self.subTitleLabel = UILabel()
        self.titleImageView = UIImageView()
        
        let btnHeight = (self.naviBar?.frame.size.height ?? 0)*(135.0/183.0)
        let btnWidth = btnHeight*(119.0/135.0)
        let leftMargin = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)*(38.0/1125.0)
        
        self.backBtn = UIButton(frame: CGRect(origin: CGPoint(x: leftMargin, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
        self.backBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - btnHeight)/2 + self.statusBarHeight
        self.backBtn?.addTarget(self, action: #selector(backCallback(sender:)), for: .touchUpInside)
        
        self.closeBtn = UIButton(frame: CGRect(origin: CGPoint(x: (self.naviBar?.frame.size.width ?? self.view.frame.size.width) - leftMargin - btnWidth, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
        self.closeBtn?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - btnHeight)/2 + self.statusBarHeight
        self.closeBtn?.addTarget(self, action: #selector(closeCallback(sender:)), for: .touchUpInside)
        
        self.backgroundType = backgroundType
        self.titleType = titleType
        self.backBtnImage = backImage
        self.closeBtnImage = closeImage
        
        self.view.addSubview(self.naviBar!)
        self.naviBar?.addSubview(self.titleLabel!)
        self.naviBar?.addSubview(self.subTitleLabel!)
        self.naviBar?.addSubview(self.titleImageView!)
        self.view.addSubview(self.backBtn!)
        self.view.addSubview(self.closeBtn!)
        
        self.statusBarView = UIView()
        self.statusBarColor = statusBarColor
        self.view.addSubview(self.statusBarView)
        
        self.statusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.statusBarView.heightAnchor
            .constraint(equalToConstant: self.statusBarHeight).isActive = true
        self.statusBarView.widthAnchor
            .constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        self.statusBarView.topAnchor
            .constraint(equalTo: self.view.topAnchor).isActive = true
        self.statusBarView.centerXAnchor
            .constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.navigationBar.backgroundColor = .clear
    }
    
    
    @objc private func backCallback(sender: UIButton){
        if let backEvent = self.backEvent{
            backEvent()
        }else{
            self.popViewController(animated: true)
        }
    }
    
    @objc private func closeCallback(sender: UIButton){
        if let closeEvent = self.closeEvent{
            closeEvent()
        }else{
            self.dismiss(animated: true)
        }
    }
    
    func setBackEvent(event: Event?){
        self.backEvent = event
    }
    func setCloseEvent(event: Event?){
        self.closeEvent = event
    }
}

public extension UIViewController{
    var statusBarHeight: CGFloat{
        
        //iOS 15.0 deprecated
        if let safeFrame = UIApplication.shared.windows.first?.safeAreaInsets{
            return Swift.max(safeFrame.top, safeFrame.left)
        }else{
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
    }
}
