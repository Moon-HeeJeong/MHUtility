//
//  MHVideoPlayerWrapper.swift
//  MHVideoPlayerWithDelegateView
//
//  Created by LittleFoxiOSDeveloper on 12/6/23.
//

import Foundation
import UIKit
import SwiftUI
import AVKit
import Combine

enum VideoPlayerStatus{
    case loadFinish(isSuccess: Bool)
    case currentTime(time: Double)
}

struct MHVideoPlayer: UIViewRepresentable{
    
    enum SeekStatus{
        case `do`
        case stop
    }
    
    typealias SeekOperation = (status: SeekStatus, targetTime: Double)
    
    @Binding var isPlaying: Bool
    @Binding var seekOperationValue: SeekOperation
    
    var urlStr: String
    
    var statusCallback: (_ status: VideoPlayerStatus)->()
    
    init(urlStr: String, isPlaying: Binding<Bool>, seekOperationValue: Binding<SeekOperation>, statusCallback: @escaping (_: VideoPlayerStatus) -> Void) {
        _isPlaying = isPlaying
        _seekOperationValue = seekOperationValue
        self.urlStr = urlStr
        self.statusCallback = statusCallback
    }
    
    func makeUIView(context: Context) -> MHVideoPlayerWithDelegateView {
        
        let player = MHVideoPlayerWithDelegateView()
        player.delegate = context.coordinator
        
        if let url = URL(string: self.urlStr){
            player.url = url
        }
               
        return player
    }
    
    func makeCoordinator() -> VideoPlayerViewCoordinator{
        return VideoPlayerViewCoordinator(owner: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        uiView.isPlaying = self.isPlaying
        
//        if self.isSeeking{
//            uiView.seekTime = self.seekTime
//        }
        
//        uiView.seekOperation = self.seekOperationValue
        
        
//        if self.isSeeking{
//            uiView.seekOperation(targetTime: self.seekTime) {
//                self.isSeeking = false
//            }
//        }
        
        
        if self.seekOperationValue.status == .do{
            uiView.seekOperation(targetTime: self.seekOperationValue.targetTime) {
                self.seekOperationValue = (.stop, 0)
            }
        }
        
    }
    
    class VideoPlayerViewCoordinator: NSObject, MHVideoPlayerViewDelegate{
        
        var owner: MHVideoPlayer
        
        init(owner: MHVideoPlayer) {
            self.owner = owner
        }
        
        func mhVideoPlayerCallback(loadStart playerView: MHVideoPlayerWithDelegateView) {
            
        }
        
        func mhVideoPlayerCallback(loadFinish playerView: MHVideoPlayerWithDelegateView, isLoadSuccess: Bool, error: Error?) {
            self.owner.statusCallback(.loadFinish(isSuccess: isLoadSuccess))

        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusPlayer: AVPlayer.Status, error: Error?) {
            
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
            
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, loadedTimeRanges: [CMTimeRange]) {
            
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, duration: Double) {
//            self.playerDurationCallback(duration)
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, currentTime: Double) {
            self.owner.statusCallback(.currentTime(time: currentTime))
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, rate: Float) {
            
        }
        
        func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, isLikelyKeepUp: Bool) {
        
        }
        
        func mhVideoPlayerCallback(playerFinished playerView: MHVideoPlayerWithDelegateView) {
            
        }
    }
}

