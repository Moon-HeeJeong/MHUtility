//
//  Animation.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

extension Animation{
    public static func ripple() -> Animation{
        Animation.spring(dampingFraction: 0.8)
            .speed(2)
            .delay(0.03)
    }
}
