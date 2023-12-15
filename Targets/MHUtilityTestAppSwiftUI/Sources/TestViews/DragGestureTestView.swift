//
//  DragGestureTestView.swift
//  MHVideoPlayerWithDelegateView
//
//  Created by LittleFoxiOSDeveloper on 12/12/23.
//

import SwiftUI

public struct DragGestureTestView: View {
    @State var firstBtnOffset: Double = 0.0
    @State var secondBtnOffset: Double = 0.0
    
    public init(){
        
    }
    
    public var body: some View {
        GeometryReader(content: { geo in
            let progressBallHeight = geo.size.height*(59.0/2436.0)
            let progressBallWidth = progressBallHeight
            
            VStack(content: {
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: progressBallWidth, height: progressBallHeight, alignment: .leading)
                        .offset(x: 0)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: progressBallWidth, height: progressBallHeight, alignment: .leading)
                        .offset(x: firstBtnOffset)
                        .gesture(
                            
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
//                                    print("translation value :: \(value.translation.width.description)")
                                    print("location value :: \(value.location.x.description)")
                                    firstBtnOffset = value.location.x
                                    
                                })
                                .onEnded({ _ in
                                    print("width \(geo.size.width)")
                                })
                        )
                }.frame(width: geo.size.width/2)
                    .background(Color.orange)
                
                ZStack {
                    Circle()
                        .fill(Color.blue)
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: progressBallWidth, height: progressBallHeight, alignment: .leading)
                        .offset(x: 0)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: progressBallWidth, height: progressBallHeight, alignment: .leading)
                        .offset(x: secondBtnOffset)
                        .gesture(
                            
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    print("translation value :: \(value.translation.width.description)")
                                    print("location value :: \(value.location.x.description)")
                                    secondBtnOffset = value.location.x
                                    
                                    
                                })
                                .onEnded({ _ in
                                    print("width \(geo.size.width)")
                                })
                        )
                }.frame(width: geo.size.width/2)
                    .background(Color.orange)
                
                
            }).frame(width: geo.size.width)
            
            
            
        })//geo
    }//body
}


#Preview {
    DragGestureTestView()
}
