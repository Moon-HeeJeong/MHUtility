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
    
    public enum CloseAction{
        case pop
        case dismiss
//        case root
    }
    
    public enum BackgroundType{
        case paint(color: UIColor)
        case image(image: UIImage)
    }
    
    public enum TitleType{
        case text(title: TextInfo, subTitle: TextInfo?)
        case image(image: UIImage)
    }
    
    public struct TextInfo{
        var text: String
        var color: UIColor?
        var fontName: String?
        var fontSize: CGFloat?
    }
    
    private var backgroundType: BackgroundType = .paint(color: .clear){
        didSet{
            switch self.backgroundType {
            case .paint(let color):
                self.naviBar?.backgroundColor = color
            case .image(let image):
                self.naviBar?.image = image
            }
        }
    }
    
    private var titleType: TitleType?{
        didSet{
            switch self.titleType {
            case .text(let titleInfo, let subTitleInfo):
                
                //title label
                self.titleLabel?.isHidden = false
                self.titleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                self.titleLabel?.text = titleInfo.text
                self.titleLabel?.textColor = titleInfo.color
                
                if let customFontName = titleInfo.fontName{
                    self.titleLabel?.font = UIFont(name: customFontName, size: titleInfo.fontSize ?? 0)
                }else{
                    self.titleLabel?.font = UIFont.systemFont(ofSize: titleInfo.fontSize ?? 0)
                }
                
                self.titleLabel?.sizeToFit()
                self.titleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2

                
                //subtitle label
                if let info = subTitleInfo{
                    self.subTitleLabel?.isHidden = false
                    self.subTitleLabel?.frame.size.width = (self.naviBar?.frame.size.width ?? 0) - (self.backBtn?.frame.origin.x ?? 0)*4 - (self.backBtn?.frame.size.width ?? 0)*2
                    self.subTitleLabel?.text = info.text
                    self.subTitleLabel?.textColor = info.color
                    
                    if let customFontName = info.fontName{
                        self.subTitleLabel?.font = UIFont(name: customFontName, size: info.fontSize ?? 0)
                    }else{
                        self.subTitleLabel?.font = UIFont.systemFont(ofSize: info.fontSize ?? 0)
                    }
                    
                    self.subTitleLabel?.sizeToFit()
                    self.subTitleLabel?.center.x = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)/2
                    
                    
                    self.titleLabel?.frame.origin.y = self.navigationHeight*(19.0/183.0) + self.statusBarHeight
                    self.subTitleLabel?.frame.origin.y = (self.titleLabel?.frame.origin.y ?? 0) + (self.titleLabel?.frame.height ?? 0)
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
    private var backBtnImage: UIImage?{
        didSet{
            let btnHeight = self.navigationHeight*(118.0/183.0)
            let btnWidth = btnHeight*(135.0/118.0)
            
            let leftMargin = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)*(38.0/1125.0)
            
            self.backBtn = UIButton(frame: CGRect(origin: CGPoint(x: leftMargin, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
            self.backBtn?.center.y = (self.navigationHeight - btnHeight)/2 + self.statusBarHeight
            self.backBtn?.setImage(self.backBtnImage, for: .normal)
        }
    }
    
    private var closeBtnImage: UIImage?{
        didSet{
            let btnHeight = self.navigationHeight*(118.0/183.0)
            let btnWidth = btnHeight*(135.0/118.0)
            
            let leftMargin = (self.naviBar?.frame.size.width ?? self.view.frame.size.width)*(38.0/1125.0)
            
            self.closeBtn = UIButton(frame: CGRect(origin: CGPoint(x: leftMargin, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
            self.closeBtn?.center.y = (self.navigationHeight - btnHeight)/2 + self.statusBarHeight
            self.closeBtn?.setImage(self.closeBtnImage, for: .normal)
        }
    }
    
    private var navigationHeight: CGFloat{
        didSet{
            self.naviBar = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: self.statusBarHeight),
                                                     size: CGSize(width: self.view.frame.size.width, height: self.navigationHeight)))
        }
    }
    
    private var statusBarView: UIView!
    private var naviBar: UIImageView?
    private var titleLabel: UILabel?
    private var subTitleLabel: UILabel?
    private var titleImageView: UIImageView?
    private var backBtn: UIButton?
    private var closeBtn: UIButton?
    
    init(navigationHeight: CGFloat, statusBarColor: UIColor, backgroundType: BackgroundType, titleType: TitleType? = nil, backImage: UIImage?, closeImage: UIImage?, rootViewController: UIViewController) {
        
        self.navigationHeight = navigationHeight
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
