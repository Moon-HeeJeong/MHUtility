//
//  DisplayOnOpenMenuViewModifier.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

//MARK: - 메뉴를 열고 닫을 때
struct DisplayOnOpenMenuViewModifier: ViewModifier{
    let isOpen: Bool
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(x: isOpen ? 0 : -(offset/1))
            .transition(.moveAndFade)
            .animation(.spring().speed(1.5).delay(0.03))
//            .animation(.ripple())
    }
}
