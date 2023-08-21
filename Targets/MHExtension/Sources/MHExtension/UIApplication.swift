//
//  UIApplication.swift
//  MHUtility
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import Foundation
import UIKit

extension UIApplication {
    public var statusBarHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.statusBarManager
            }
            .map {
                $0.statusBarFrame
            }
            .map(\.height)
            .max() ?? 0
    }
}
