//
//  CGFloat.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

extension CGFloat{
    public enum Rect_E{
        case w(size: CGFloat, base: CGFloat)
        case h(size: CGFloat, base: CGFloat)
       
        
        init(_ rect: Rect_E){
            self.init(rect)
        }
        
        public var toCGFloat: CGFloat{
            switch self {
            case .w(let size, let base):
                return (size/1125.0)*(base)
            case .h(let size, let base):
                return (size/2436.0)*(base)
            }
        }
    }
    
    func rect(){
        
    }
    
    public init(_ rect: Rect_E, _ size: CGFloat, _ geo: GeometryProxy){
        switch rect {
        case .w:
            self.init((size/1125.0)*(geo.size.width))
        case .h:
            self.init((size/2436.0)*(geo.size.height))
        }
    }
}

