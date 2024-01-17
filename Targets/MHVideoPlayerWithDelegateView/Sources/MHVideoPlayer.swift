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

public struct MHVideoPlayer: UIViewRepresentable{
    public enum VideoPlayerStatus{
        case loadStart
        case loadFinish(isSuccess: Bool)
        case currentTime(time: Double)
        case duration(time: Double)
        case playerFinished
        case playerStatus(status: AVPlayer.Status, error: Error?)
        case playerItemStatus(status: AVPlayerItem.Status, error: Error?)
        case loadedTimeRanges(range: [CMTimeRange])
        case rate(rate: Float)
        case keepUp(isLikelyKeepUp: Bool)
    }
    
    public enum SeekStatus{
        case `do`
        case stop
    }
    
    public typealias SeekOperation = (status: SeekStatus, targetTime: Double)
    
    @Binding var urlStr: String
    @Binding var isPlaying: Bool
    @Binding var seekOperationValue: SeekOperation
    @Binding var velocity: Float
    
    var statusCallback: (_ status: VideoPlayerStatus)->()
    
    public init(urlStr: Binding<String>, isPlaying: Binding<Bool>, seekOperationValue: Binding<SeekOperation>, velocity: Binding<Float>, statusCallback: @escaping (_: VideoPlayerStatus) -> Void) {
        _isPlaying = isPlaying
        _seekOperationValue = seekOperationValue
        _velocity = velocity
        _urlStr = urlStr
        self.statusCallback = statusCallback
    }
    
    public func makeUIView(context: Context) -> MHVideoPlayerWithDelegateView {
        
        let player = MHVideoPlayerWithDelegateView()
        player.delegate = context.coordinator
        
//        if let url = URL(string: self.urlStr){
//            player.url = url
//        }
//        if let url = URL(string: "https://cdn.littlefox.co.kr/contents_5/phonics/movie/1080/ddf23a4bfe/169864286899ba5c4097c6b8fef5ed774a1a6714b8.mp4?_=1698642873"){
//            player.url = url
//        }
        return player
    }
    
    public func makeCoordinator() -> VideoPlayerViewCoordinator{
        return VideoPlayerViewCoordinator(owner: self)
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if let url = URL(string: self.urlStr){
            uiView.url = url
        }
            
//        uiView.rate = self.velocity
//        uiView.isPlaying = self.isPlaying
        
        
        uiView.setPlayerStatus(isPlaying: self.isPlaying, velocity: self.velocity)
        
        if self.seekOperationValue.status == .do{
            uiView.seekOperation(targetTime: self.seekOperationValue.targetTime) {
                self.seekOperationValue = (.stop, 0)
            }
        }
        
    }
    
    public class VideoPlayerViewCoordinator: NSObject, MHVideoPlayerViewDelegate{
        
        var owner: MHVideoPlayer
        
        init(owner: MHVideoPlayer) {
            self.owner = owner
        }
        
        public func mhVideoPlayerCallback(loadStart playerView: MHVideoPlayerWithDelegateView) {
            self.owner.statusCallback(.loadStart)
        }
        
        public func mhVideoPlayerCallback(loadFinish playerView: MHVideoPlayerWithDelegateView, isLoadSuccess: Bool, error: Error?) {
            self.owner.statusCallback(.loadFinish(isSuccess: isLoadSuccess))

        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusPlayer: AVPlayer.Status, error: Error?) {
            self.owner.statusCallback(.playerStatus(status: statusPlayer, error: error))
        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
            self.owner.statusCallback(.playerItemStatus(status: statusItemPlayer, error: error))        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, loadedTimeRanges: [CMTimeRange]) {
            self.owner.statusCallback(.loadedTimeRanges(range: loadedTimeRanges))
        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, duration: Double) {
            self.owner.statusCallback(.duration(time: duration))
        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, currentTime: Double) {
            self.owner.statusCallback(.currentTime(time: currentTime))
        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, rate: Float) {
            self.owner.statusCallback(.rate(rate: rate))
        }
        
        public func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, isLikelyKeepUp: Bool) {
            self.owner.statusCallback(.keepUp(isLikelyKeepUp: isLikelyKeepUp))
        }
        
        public func mhVideoPlayerCallback(playerFinished playerView: MHVideoPlayerWithDelegateView) {
            self.owner.statusCallback(.playerFinished)
        }
    }
}

