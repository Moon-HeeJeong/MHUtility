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
    var color: Color
    
    var body: some View {
            GeometryReader { geo in
                ZStack {
                    Color.black.opacity(isEnabled ? 0 : 0.3)
                    
                    ProgressView()
                        .scaleEffect(2, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: color))
                        .frame(width: geo.size.width, height: geo.size.height)
                }.ignoresSafeArea()
            }
    }
}

