//
//  AnyTransition.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import SwiftUI

extension AnyTransition{
    public static var moveAndFade: AnyTransition{
        
        .asymmetric(insertion: .slide.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity))
    }
}
