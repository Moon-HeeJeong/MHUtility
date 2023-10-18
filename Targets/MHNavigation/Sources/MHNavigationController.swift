//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/10/13.
//

import Foundation
import UIKit

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
                if let info = subTitleInfo{
                    self.subTitleLabel?.isHidden = false
                    self.subTitleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                    self.subTitleLabel?.text = info.text
                    self.subTitleLabel?.textColor = info.fontInfo?.color
                    
                    if let customFontName = info.fontInfo?.fontName{
                        self.subTitleLabel?.font = UIFont(name: customFontName, size: info.fontInfo?.fontSize ?? 0)
                    }else{
                        self.subTitleLabel?.font = UIFont.systemFont(ofSize: info.fontInfo?.fontSize ?? 0)
                    }
                    
                    self.subTitleLabel?.sizeToFit()
                    self.subTitleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                    
                    
                    self.subTitleLabel?.frame.origin.y = self.navigationHeight*(19.0/183.0) + self.statusBarHeight
                    self.titleLabel?.frame.origin.y = (self.subTitleLabel?.frame.origin.y ?? 0) + (self.subTitleLabel?.frame.height ?? 0)
                    
                }else{
                    self.subTitleLabel?.isHidden = true
                    self.titleLabel?.frame.origin.y = (self.navigationHeight - (self.titleLabel?.frame.size.height ?? 0))/2 + self.statusBarHeight
                }
                break
                
                
            case .image(let image):
                let height = self.navigationHeight*(76.0/183.0)
                let width = height*(image.size.width/image.size.height)
                
                self.titleLabel?.isHidden = true
                self.subTitleLabel?.isHidden = true
                self.titleImageView?.image = image
                self.titleImageView?.frame.size = CGSize(width: width, height: height)
                self.titleImageView?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                self.titleImageView?.frame.origin.y = (self.navigationHeight - height)/2 + self.statusBarHeight
            default:
                break
            }
        }
    }
    
    //중간에 바뀌는 거 반영해야함
    var backBtnImage: UIImage?{
        didSet{
            let btnHeight = self.navigationHeight*(118.0/183.0)
            let btnWidth = btnHeight*(135.0/118.0)
            
            let leftMargin = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)*(38.0/1125.0)
            
            self.backBtn = UIButton(frame: CGRect(origin: CGPoint(x: leftMargin, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
            self.backBtn?.center.y = (self.navigationHeight - btnHeight)/2 + self.statusBarHeight
            self.backBtn?.setImage(self.backBtnImage, for: .normal)
            self.backBtn?.addTarget(self, action: #selector(backCallback(_:)), for: .touchUpInside)
        }
    }
    
    var closeBtnImage: UIImage?{
        didSet{
            let btnHeight = self.navigationHeight*(118.0/183.0)
            let btnWidth = btnHeight*(135.0/118.0)
            
            let leftMargin = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)*(38.0/1125.0)
            
            self.closeBtn = UIButton(frame: CGRect(origin: CGPoint(x: leftMargin, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
            self.closeBtn?.center.y = (self.navigationHeight - btnHeight)/2 + self.statusBarHeight
            self.closeBtn?.setImage(self.closeBtnImage, for: .normal)
            self.closeBtn?.addTarget(self, action: #selector(closeCallback(_:)), for: .touchUpInside)
        }
    }
    
    var isNaviBarHidden: Bool = false{
        didSet{
            self.naviBar?.isHidden = self.isNaviBarHidden
        }
    }
    
    var isBackBtnHidden: Bool = false{
        didSet{
            self.backBtn?.isHidden = self.isBackBtnHidden
        }
    }
    
    var isCloseBtnHidden: Bool = false{
        didSet{
            self.closeBtn?.isHidden = self.isCloseBtnHidden
        }
    }
    
    private var navigationHeight: CGFloat{
        didSet{
            self.naviBar = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.statusBarHeight),
                                                     size: CGSize(width: self.view.frame.size.width, height: self.navigationHeight)))
        }
    }
    
    var action: CloseAction?{
        didSet{
            switch action {
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
        self.backEvent = backEvent
        self.closeEvent = closeEvent
        super.init(rootViewController: rootViewController)
        
        
        self.backgroundType = backgroundType
        self.titleType = titleType
        self.backBtnImage = backImage
        
        
        
        self.view.addSubview(self.naviBar!)
        self.naviBar?.addSubview(self.titleLabel!)
        self.naviBar?.addSubview(self.subTitleLabel!)
        self.naviBar?.addSubview(self.backBtn!)
        self.naviBar?.addSubview(self.closeBtn!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func backCallback(_ sender: UIButton){
        if let backEvent = self.backEvent{
            backEvent()
        }else{
            self.popViewController(animated: true)
        }
    }
    
    @objc private func closeCallback(_ sender: UIButton){
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
