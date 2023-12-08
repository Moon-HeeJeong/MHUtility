//
//  MHVideoPlayer.swift
//  MHVideoPlayerWithDelegateView
//
//  Created by LittleFoxiOSDeveloper on 12/6/23.
//

import SwiftUI
import Combine

public struct MHVideoPlayerTestView: View{

    @State var isPlaying: Bool = false
    @State var currentTime: Double = 0.0
    @State var totalTime: Double = 0.0
    
    @State var seekOperationValue: MHVideoPlayer.SeekOperation = (.stop, 0)
    
    public init(){
        
    }
    
    public var body: some View{
        
        GeometryReader(content: { geo in
           
            ZStack(content: {
       
                VStack(content: {
                    
                    MHVideoPlayer(urlStr: "https://cdn.littlefox.co.kr/contents_5/phonics/movie/1080/ddf23a4bfe/169864286899ba5c4097c6b8fef5ed774a1a6714b8.mp4?_=1698642873", isPlaying: $isPlaying, seekOperationValue: $seekOperationValue) { status in
                        switch status {
                        case .loadFinish(let isSuccess):
                            print("loadFinish \(isSuccess)")
                            self.isPlaying = isSuccess
                        case .currentTime(let time):
                            
                            print("currentTime \(time)")
                            if abs(time - self.currentTime) > 0.1{
                                self.currentTime = time
                            }
                        }
                    }
                    
                    Spacer()
                    Text("current \(currentTime)")
                    
                    Spacer()
                    
                    Button(action: {
                        isPlaying.toggle()
                    }, label: {
                        ZStack(content: {
                            Rectangle().fill(Color.yellow)
                            
                            Text(isPlaying ? "||" : ">>")
                                .foregroundColor(.black)
                        })
                    })
                    Button(action: {
//                        self.seekTime(targetTime: 1.0)
                        self.seekOperationValue = (.do, 1.0)
                    }, label: {
                        ZStack(content: {
                            Rectangle().fill(Color.blue)
                            Text("seek 1.0")
                                .foregroundColor(.white)
                        })
                    })
                    
                    Button(action: {
//                        self.seekTime(targetTime: 5.0)
                        self.seekOperationValue = (.do, 5.0)
                        
                    }, label: {
                        ZStack(content: {
                            Rectangle().fill(Color.blue)
                            Text("seek 5.0")
                                .foregroundColor(.white)
                        })
                    })
                    
                    Spacer()
                })
              //  .ignoresSafeArea([.container])
                
                
            })
        })
    }
    
//    func seekTime(targetTime: Double){
//        
//        let isBeforePlaying = self.isPlaying
//        
//        self.isPlaying = false
//        self.isSeeking = true
//        
//        self.currentTime = targetTime
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            print("seeking finish! play video")
//            self.isSeeking = false
//            self.isPlaying = isBeforePlaying
//        }
//    }
    
//    func seekTime(targetTime: Double){
        
        //MHVideoPlayerWithDelegateView 의 seekTime 변수에서도
        //DispatchQueue asyncAfter를 하는데.. 그냥 합치는게 나을지?
        
//        self.isSeeking = true
//        self.currentTime = targetTime
        
//        self.seekOperationValue = (true, targetTime)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.isSeeking = false
        //        }
        
//        self.seekOperationValue = (true, targetTime)
        
//    }
}

