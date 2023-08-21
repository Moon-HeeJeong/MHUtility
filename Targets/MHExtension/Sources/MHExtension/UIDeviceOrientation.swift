//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation
import UIKit

extension UIDeviceOrientation{
    public var interfaceOrient: UIInterfaceOrientation{
        switch self {
        case .unknown:
            return .unknown
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .faceUp:
            return .unknown
        case .faceDown:
            return .unknown
        @unknown default:
            return .unknown
        }
    }
}
