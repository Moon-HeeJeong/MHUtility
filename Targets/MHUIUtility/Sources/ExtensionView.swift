//
//  extensionView.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation
import SwiftUI

extension View{
    public func makeUIUtility(kind: Binding<UIUtility_E?>) -> some View{
        return self.modifier(UIUtilityModifier(kind: kind))
    }
}
