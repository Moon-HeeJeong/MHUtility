//
//  BrightAnimationStyle.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

public struct BrightAnimationStyle: ButtonStyle{
    
    let scaledAmount: CGFloat
    
    public init(scaledAmount: CGFloat = 1.1) {
        self.scaledAmount = scaledAmount
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.5 : 0)
    }
}
public struct BasicBrightAnimationStyle: ButtonStyle{
    
    let scaledAmount: CGFloat
    
    public init(scaledAmount: CGFloat = 1.1) {
        self.scaledAmount = scaledAmount
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .brightness(configuration.isPressed ? 0.6 : 0.1)
    }
}
