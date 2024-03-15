//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/09/01.
//

import Foundation
import SwiftUI

struct MHCircleProgressView: View {
    
    var isEnabled: Bool
    var bgColor: Color
    var progressColor: Color
    
    var body: some View {
            GeometryReader { geo in
                ZStack {
                    bgColor.opacity(isEnabled ? 0 : 1)
                    
                    ProgressView()
                        .scaleEffect(2, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: progressColor))
                        .frame(width: geo.size.width, height: geo.size.height)
                }.ignoresSafeArea()
            }
    }
}

