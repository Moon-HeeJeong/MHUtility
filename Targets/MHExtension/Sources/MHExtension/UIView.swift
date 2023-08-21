//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation
import UIKit

extension UIView {
    public var endPosY: CGFloat {
        get{
            return self.frame.size.height + self.frame.origin.y
        }
    }
    public  var endPosX: CGFloat {
        get{
            return self.frame.size.width + self.frame.origin.x
        }
    }
    
    public func addRound(cornerRadius: CGFloat,borderColor: UIColor ,borderWidth: CGFloat = 1) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    public func addRoundSpecificedCorners(cornerRadius: CGFloat, byRoundingCorners: UIRectCorner, boderColor: UIColor = .clear, boderWidth: CGFloat = 1.5) {
        clipsToBounds = true
        if #available(iOS 11.0, *) {
            
            layer.cornerRadius = cornerRadius
            layer.borderColor = boderColor.cgColor
            layer.borderWidth = boderWidth
            layer.maskedCorners = CACornerMask(rawValue: byRoundingCorners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: byRoundingCorners,
                                    cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.borderColor = boderColor.cgColor
            //                maskLayer.boderWidth = boderWidth
            maskLayer.borderWidth = boderWidth
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            
            layer.mask = maskLayer
        }
        
    }
    
    public func makeBottomShadow(shadowHeight: CGFloat = 5) {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height + shadowHeight))
        shadowPath.addLine(to: CGPoint(x: 0, y: self.bounds.height + shadowHeight))
        shadowPath.close()
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 2
    }
    
    @available(iOS 10.0, *)
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
