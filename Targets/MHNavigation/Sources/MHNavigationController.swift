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
    }
    
    public struct TextInfo: Equatable{
        var text: String?
        var fontInfo: FontInfo?
        
        public init(text: String? = nil, fontInfo: FontInfo? = nil) {
            self.text = text
            self.fontInfo = fontInfo
        }
    }
    
    public struct FontInfo: Equatable{
        var color: UIColor?
        var fontName: String?
        var fontSize: CGFloat?
        
        public init(color: UIColor? = nil, fontName: String? = nil, fontSize: CGFloat? = nil) {
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
                
                //title label
                self.titleImageView?.isHidden = true
                self.titleLabel?.isHidden = false
                self.titleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                self.titleLabel?.text = titleInfo.text
                self.titleLabel?.textColor = titleInfo.fontInfo?.color
                
                if let customFontName =  titleInfo.fontInfo?.fontName{
                    self.titleLabel?.font = UIFont(name: customFontName, size: titleInfo.fontInfo?.fontSize ?? 0)
                }else{
                    self.titleLabel?.font = UIFont.systemFont(ofSize: titleInfo.fontInfo?.fontSize ?? 0)
                }
                
                self.titleLabel?.sizeToFit()
                self.titleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2

                
                //subtitle label
                if let subTitle = subTitleInfo?.text{
                    
                    let info = subTitleInfo?.fontInfo
                    self.subTitleLabel?.isHidden = false
                    self.subTitleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                    self.subTitleLabel?.text = subTitle
                    self.subTitleLabel?.textColor = info?.color
                    
                    if let customFontName = info?.fontName{
                        self.subTitleLabel?.font = UIFont(name: customFontName, size: info?.fontSize ?? 0)
                    }else{
                        self.subTitleLabel?.font = UIFont.systemFont(ofSize: info?.fontSize ?? 0)
                    }
                    
                    self.subTitleLabel?.sizeToFit()
                    self.subTitleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                    
                    
                    self.subTitleLabel?.frame.origin.y = (self.naviBar?.frame.size.height ?? 0)*(19.0/183.0)
                    self.titleLabel?.frame.origin.y = (self.subTitleLabel?.frame.origin.y ?? 0) + (self.subTitleLabel?.frame.height ?? 0)
                    
                }else{
                    self.subTitleLabel?.isHidden = true
                    self.titleLabel?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - (self.titleLabel?.frame.size.height ?? 0))/2
                }
                break
                
                
            case .image(let image):
                let height = self.navigationHeight*(76.0/183.0)
                let width = height*(image.size.width/image.size.height)
                
                self.titleLabel?.isHidden = true
                self.subTitleLabel?.isHidden = true
                self.titleImageView?.isHidden = false
                self.titleImageView?.image = image
                self.titleImageView?.frame.size = CGSize(width: width, height: height)
                self.titleImageView?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                self.titleImageView?.frame.origin.y = ((self.naviBar?.frame.size.height ?? 0) - (self.titleLabel?.frame.size.height ?? 0))/2
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
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.backBtn?.alpha = 0.3
                self.backBtn?.setImage(image, for: .normal)
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.backBtn?.alpha = 1
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
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.closeBtn?.alpha = 0.3
                self.closeBtn?.setImage(image, for: .normal)
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.closeBtn?.alpha = 1
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
            self.naviBar?.isHidden = self.isNaviBarHidden
            self.backBtn?.isHidden = self.isNaviBarHidden
            self.closeBtn?.isHidden = self.isNaviBarHidden
            
            UIView.animate(withDuration: 0.5) {
                
                if self.isNaviBarHidden{
                    self.naviBar?.alpha = 0.5
                    self.backBtn?.alpha = 0
                    self.closeBtn?.alpha = 0
                    
                    UIView.animate(withDuration: 0.3) {
                        self.naviBar?.frame.origin.y = -(self.statusBarHeight + UINavigationController().navigationBar.frame.size.height)
                        self.additionalSafeAreaInsets.top = 0
                    }
                    
                }else{
                    self.naviBar?.alpha = 0.5
                    self.naviBar?.frame.origin.y = self.statusBarHeight
                    
                    self.additionalSafeAreaInsets.top = self.navigationHeight - UINavigationController().navigationBar.frame.size.height
                
                }
            } completion: { _ in
                self.naviBar?.isHidden = self.isNaviBarHidden
                self.backBtn?.isHidden = self.isNaviBarHidden
                self.closeBtn?.isHidden = self.isNaviBarHidden
                
                if !self.isNaviBarHidden{
                    UIView.animate(withDuration: 0.3) {
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
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.backBtn?.alpha = 0.3
                
                if self.isBackBtnHidden{
                    self.backBtn?.frame.origin.y = -(self.naviBar?.frame.size.height ?? 0)
                }else{
                    self.backBtn?.frame.origin.y = (self.naviBar?.frame.size.height ?? 0 - (self.backBtn?.frame.size.height ?? 0))/2 + self.statusBarHeight
                }
                
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    
                    self.backBtn?.alpha = self.isBackBtnHidden ? 0 : 1
                }
            }
        }
    }
    
    var isCloseBtnHidden: Bool = false{
        didSet{
            guard oldValue != self.isCloseBtnHidden else{
                return
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.closeBtn?.alpha = self.isCloseBtnHidden ? 0:1
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
    
    public init(navigationHeight: CGFloat, statusBarColor: UIColor, backgroundType: BackgroundType, titleType: TitleType? = nil, backImage: UIImage?, closeImage: UIImage?, backEvent: Event?, closeEvent: Event?, rootViewController: UIViewController) {
        
        self.navigationHeight = navigationHeight
        super.init(rootViewController: rootViewController)
        
        self.additionalSafeAreaInsets.top = self.navigationHeight - UINavigationController().navigationBar.frame.size.height
        
        self.backEvent = backEvent
        self.closeEvent = closeEvent
        self.initView(statusBarColor: statusBarColor, backgroundType: backgroundType, titleType: titleType, backImage: backImage, closeImage: closeImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(statusBarColor: UIColor, backgroundType: BackgroundType, titleType: TitleType?, backImage: UIImage?, closeImage: UIImage?){
        
        self.statusBarView = UIView()
        self.statusBarColor = statusBarColor
        self.view.addSubview(self.statusBarView)
        //좀더보기
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
        self.view.addSubview(self.backBtn!)
        self.view.addSubview(self.closeBtn!)
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
