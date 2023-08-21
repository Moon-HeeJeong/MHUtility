//
//  GeometryProxy.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

extension GeometryProxy{
    public var guideResolution: CGSize {
        return CGSize(width: 1125, height: 2436)
    }
    
    public enum Measurement {
        case width(_ amount: CGFloat)
        case height(_ amount: CGFloat)
        case boxHeight(_ amount: CGFloat, guideWidth: CGFloat, guideHeight: CGFloat)
        case boxWidth(_ amount: CGFloat, guideWidth: CGFloat, guideHeight: CGFloat)
        case x(_ amount: CGFloat)
        case y(_ amount: CGFloat)
    }
    
    public func measure(_ kind: Measurement) -> CGFloat{
        switch kind {
        case .width(let amount):
            return self.size.width * (amount/guideResolution.width)
        case .height(let amount):
            return self.size.height * (amount/guideResolution.height)
        case .boxHeight(let amount, guideWidth: let guideWidth, guideHeight: let guideHeight):
            return amount * (guideHeight/guideWidth)
        case .boxWidth( let amount, guideWidth: let guideWidth, guideHeight: let guideHeight):
            return amount * (guideWidth/guideHeight)
        case .x(let amount):
            return self.size.width * (amount/guideResolution.width)
        case .y(let amount):
            return self.size.height * (amount/guideResolution.height)
        }
    }
}
