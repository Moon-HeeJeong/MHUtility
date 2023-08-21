//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation

extension Double{
    public var time: String?{
        get{
            var temp : String = "00:00"
            
            if self.isNaN {
                return temp
            }
            
            if self == 0{
                return temp
            }
            
            let cTime : Int = Int(self)
            let tTmin : Int = cTime/60
            let sec : Int = cTime%60
            let min : Int = tTmin%60
            
            if (min<10){
                if (sec<10) {
                    temp = "0\(min):0\(sec)"
                }else{
                    temp = "0\(min):\(sec)"
                }
            }else{
                if (sec<10){
                    temp = "\(min):0\(sec)"
                }else{
                    temp = "\(min):\(sec)"
                }
            }
            return temp
        }
    }
    
    public var timeForClassIntroduceVideo: String?{
        get{
            var temp : String = "0:00"
            
            if self.isNaN {
                return temp
            }
            
            if self == 0{
                return temp
            }
            
            let cTime : Int = Int(self)
            let tTmin : Int = cTime/60
            let sec : Int = cTime%60
            let min : Int = tTmin%60
            
            if (min<10){
                if (sec<10) {
                    temp = "\(min):0\(sec)"
                }else{
                    temp = "\(min):\(sec)"
                }
            }else{
                if (sec<10){
                    temp = "\(min):0\(sec)"
                }else{
                    temp = "\(min):\(sec)"
                }
            }
            return temp
        }
    }
    
}
