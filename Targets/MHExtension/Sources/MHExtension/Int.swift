//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation

extension Int{
    public var toCGFloat: CGFloat{
        CGFloat(self)
    }
    
    public var decimal: String?{
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.locale = Locale.current
        return formater.string(from: NSNumber.init(value: self))
    }
    
    public var timeSecToStr: String{
        let sec = (self) % 60
        let min = (self) / 60
        
        let secToString = "\(sec)".count == 1 ? "0\(sec)":"\(sec)"
        let minToString = "\(min)".count == 1 ? "0\(min)":"\(min)"
    
        return "\(minToString):\(secToString)"
    }
    
}
