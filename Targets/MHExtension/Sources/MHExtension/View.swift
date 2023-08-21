//
//  View.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

//extension View{
//    func customFont(kind: CustomFontKind_E = .regular, size: CGFloat) -> some View{
//        self.modifier(CustomFontModifier(fontKind: kind, size: size))
//    }
//}
extension View{
    public func withScaleAnimation(_ scaleAmount: CGFloat = 1.05) -> some View{
        buttonStyle(ScaleAnimationStyle(scaledAmount: scaleAmount))
//        self.scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
//            .opacity(configuration.isPressed ? 0.9 : 1.0)
        
    }
    
    public func displayOnMenuOpen(isOpen: Bool, offset: CGFloat) -> some View{
        modifier(DisplayOnOpenMenuViewModifier(isOpen: isOpen, offset: offset))
    }
}
