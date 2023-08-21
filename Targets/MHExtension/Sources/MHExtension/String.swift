//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation
import UIKit

extension String{

    public var isContainsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                0x1F680...0x1F6FF, // Transport and Map
                0x2600...0x26FF,   // Misc symbols
                0x2700...0x27BF,   // Dingbats
                0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }

//    }
    
    public var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    
    public var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self){
            return date
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: self)
        }
    }
    
    public var date_no_optional: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self){
            return date
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: self) ?? Date()
        }
    }
    
    public var date_m_d_week: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d (E)"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var date_yyyy_m_dd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var date_m_dd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var date_ymd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var time_hour_minute: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var date_time_hour_minute: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d ah:mm"
        if let _ = self.date{
            return formatter.string(from: self.date!)
        }
        return ""
    }
    
    public var toJsonDic: NSDictionary? {
        get{
            if let data = self.data(using: .utf8) {
                return (try? JSONSerialization.jsonObject(with: data, options : .allowFragments)) as? NSDictionary
            }
            return nil
        }
    }
    
    public var toDouble: Double?{
        Double(self)
    }
    
    public func parse<T: Decodable>(type: T.Type) -> T? {
        if let dic = self.toJsonDic {
            let decoder  = JSONDecoder()
            if let data = try? JSONSerialization.data(withJSONObject: dic , options: .prettyPrinted){
                return try? decoder.decode(T.self, from: data)
            }
        }
        return nil
    }
    
    public func makeattributedTextText(highligtedColorCode: String, fontSize: CGFloat, basicColorCode: String = "#FFFFFF", textAligement: NSTextAlignment = .center, isBold: Bool = true) -> NSMutableAttributedString? {
//        let startStr = "<font color=\"\(basicColorCode)\">"
        let endStr = "</font>"
        let midStr = "<font color=\"\(highligtedColorCode)\">"
        
        let replacedText = self.replacingOccurrences(of: "<", with: midStr).replacingOccurrences(of: ">", with: endStr)
        let replayedTextBR = replacedText.replacingOccurrences(of: "\n", with: "<br>")
        let replayedTextB = replayedTextBR.replacingOccurrences(of: "{", with: "<b>").replacingOccurrences(of: "}", with: "</b>")
        
        return replayedTextB.stringForHtml(fontSize: fontSize, textAligement: textAligement, defalutFontColorCode: basicColorCode, isBold: isBold)
    }
    
    public func stringForHtml(fontSize: CGFloat, textAligement: NSTextAlignment = .center, defalutFontColorCode: String = "#FFFFFF", isBold: Bool = true) -> NSMutableAttributedString? {
//        do {
            
            let startColorTag = "<font color=\"\(defalutFontColorCode)\">"
            let endColorTag = "</font>"
            
            let str = startColorTag + self + endColorTag
            
            if let data = str.data(using: .utf8, allowLossyConversion: false){
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = textAligement

                let attributeString = try? NSMutableAttributedString(data: data,
                                                                    options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                              NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
                                                                              ],
                                                                    documentAttributes: nil)
                
                
                
                attributeString?.addAttributes([.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributeString?.length ?? 0))
                if isBold{
                    attributeString?.addAttributes([.font: UIFont.boldSystemFont(ofSize: fontSize)], range: NSRange(location: 0, length: attributeString?.length ?? 0))
                }else{
                    attributeString?.addAttributes([.font: UIFont.systemFont(ofSize: fontSize)], range: NSRange(location: 0, length: attributeString?.length ?? 0))
                }
                
                
                return attributeString
            }else{
                return nil
            }
//        }
//        catch {
//            return nil
//        }
    }
    
    public var convertdOverSentence: String{
        return self.replacingOccurrences(of: "__", with: "\n")
    }
    
    public func replaceWords<T>( words: [T]) -> String?{
        let speSentence = self.components(separatedBy: "??")
        
        if words.count == speSentence.count-1{
            var returnSentece: String = speSentence.first ?? ""
            for i in 0..<words.count{
                returnSentece += ("\(words[i])" + "\(speSentence[i+1])")
            }
            
            return returnSentece
        }
        
        return nil
    }
    
    public var urlEncoded: String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    public var toInt : Int {
        if let intv = Int(self) {
            return intv
        }
        return 0
    }
    
    public var asURL: URL?{
        if let url = URL(string: self){
            return url
        }
        return nil
    }
    
    
    public func getPartyBold(font: UIFont, color: [UIColor], signal:[Character] = ["<", ">"]) -> NSAttributedString {
        var text = self
        
        let firstIndex = text.enumerated().filter{$0.element == signal.first}.map{$0.offset}
        let lastIndex = text.enumerated().filter{$0.element == signal.last}.map{$0.offset}
        
        var ranges = [NSRange]()
        
        if firstIndex.count == lastIndex.count{
            for i in 0..<firstIndex.count{
                let range = NSRange(location: firstIndex[i], length: lastIndex[i]-firstIndex[i])
                ranges.append(range)
            }
        }
        
        let attributedText = NSMutableAttributedString(string: text)
        
//
//        for range in ranges {
//            attributedText.addAttribute(.foregroundColor, value: color, range: range)
//            attributedText.addAttribute(.font, value: font, range: range)
//        }
        
        var cl: UIColor = color.first ?? .black
        
        for i in 0..<ranges.count{
            
            if i < color.count{
                cl = color[i]
            }
            
            attributedText.addAttribute(.foregroundColor, value: cl, range: ranges[i])
            attributedText.addAttribute(.font, value: font, range: ranges[i])
        }
        
        for i in 0..<firstIndex.count{
            attributedText.deleteCharacters(in: NSRange(location: firstIndex[i]-i, length: 1))
        }
        let removedLastIndex = attributedText.string.enumerated().filter{$0.element == signal.last}.map{$0.offset}
        for i in 0..<removedLastIndex.count{
            attributedText.deleteCharacters(in: NSRange(location: removedLastIndex[i]-i, length: 1))
        }
        return attributedText
    }
    
    
    public func getUnderlineColor(font: UIFont, color: [UIColor]) -> NSAttributedString {
        var text = self
        
        let firstIndex = text.enumerated().filter{$0.element == "<"}.map{$0.offset}
        let lastIndex = text.enumerated().filter{$0.element == ">"}.map{$0.offset}
        
        var ranges = [NSRange]()
        
        if firstIndex.count == lastIndex.count{
            for i in 0..<firstIndex.count{
                let range = NSRange(location: firstIndex[i], length: lastIndex[i]-firstIndex[i])
                ranges.append(range)
            }
        }
        
        let attributedText = NSMutableAttributedString(string: text)
        var cl: UIColor = color.first ?? .black
        for i in 0..<ranges.count{
            if i < color.count{
                cl = color[i]
            }
            attributedText.addAttribute(.foregroundColor, value: cl, range: ranges[i])
            attributedText.addAttribute(.font, value: font, range: ranges[i])
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: ranges[i])
        }
        
        for i in 0..<firstIndex.count{
            attributedText.deleteCharacters(in: NSRange(location: firstIndex[i]-i, length: 1))
        }
        let removedLastIndex = attributedText.string.enumerated().filter{$0.element == ">"}.map{$0.offset}
        for i in 0..<removedLastIndex.count{
            attributedText.deleteCharacters(in: NSRange(location: removedLastIndex[i]-i, length: 1))
        }
        return attributedText
    }
    
    public func urlEncoded(denying deniedCharacters: CharacterSet) -> String? {
        return addingPercentEncoding(withAllowedCharacters: deniedCharacters.inverted)
    }
    
    
}

