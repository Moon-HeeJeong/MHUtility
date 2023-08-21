//
//  ScaleAnimationStyle.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

public struct ScaleAnimationStyle: ButtonStyle{
    
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 1.05) {
        self.scaledAmount = scaledAmount
    }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
        .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}
