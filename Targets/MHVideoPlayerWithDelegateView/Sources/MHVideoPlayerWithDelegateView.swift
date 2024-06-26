//
//  MHVideoPlayerWithDelegateView.swift
//
//
//  Created by LittleFoxiOSDeveloper on 12/6/23.
//

import Foundation
import AVKit
import MediaPlayer

public enum MHVideoPlayerViewFillModeType{
    case resizeAspect
    case resizeAspectFill
    case resize
    
    var AVLayerVideoGravity: AVLayerVideoGravity{
        get{
            switch self {
            case .resizeAspect:
                return .resizeAspect
            case .resizeAspectFill:
                return .resizeAspectFill
            case .resize:
                return .resize
            }
        }
    }
}

public struct PlayingInfo{ //백그라운드 컨트롤러에서 띄울 플레이어 정보
    let titleStr: String
    let imgUrlStr: String?
    
    public init(titleStr: String, imgUrlStr: String?) {
        self.titleStr = titleStr
        self.imgUrlStr = imgUrlStr
    }
}

public protocol MHVideoPlayerViewDelegate: AnyObject{
    func mhVideoPlayerCallback(loadStart playerView: MHVideoPlayerWithDelegateView)
    func mhVideoPlayerCallback(loadFinish playerView: MHVideoPlayerWithDelegateView, isLoadSuccess: Bool, error: Error?)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusPlayer: AVPlayer.Status, error: Error?)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, statusItemPlayer: AVPlayerItem.Status, error: Error?)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, loadedTimeRanges: [CMTimeRange])
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, duration: Double)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, currentTime: Double)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, rate: Float)
    func mhVideoPlayerCallback(playerView: MHVideoPlayerWithDelegateView, isLikelyKeepUp: Bool)
    func mhVideoPlayerCallback(playerFinished playerView: MHVideoPlayerWithDelegateView)
}

public class MHVideoPlayerWithDelegateView: UIView{
    
    deinit{
        print("deinit \(self)")
        self.removePlayer()
        self.removeNotification()
    }

    let notificationCenter = NotificationCenter.default
    private var statusContext = true
    private var statusItemContext = true
    private var statusKeepUpContext = true
    private var loadedContext = true
    private var durationContext = true
    private var currentTimeContext = true
    private var rateContext = true
    private var playerItemContext = true
    
    private let tPlayerTracksKey = "tracks"
    private let tPlyerPlayableKey = "playable"
    private let tPlayerDurationKey = "duration"
    private let tPlayerRateKey = "rate"
    private let tCurrentItemKey = "currentItem"
    
    private let tPlayerStatusKey = "status"
    private let tPlayerEmptyBufferKey = "playbackBufferEmpty"
    private let tPlaybackBufferFullKey = "playbackBufferFull"
    private let tPlayerKeepUpKey = "playbackLikelyToKeepUp"
    private let tLoadedTimeRangesKey = "loadedTimeRanges"
    
    public override class var layerClass: AnyClass{
        AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer{
        self.layer as! AVPlayerLayer
    }
    
    private var player: AVPlayer?{
        set{
            playerLayer.player = newValue
        }
        get{
            return playerLayer.player
        }
    }
    
    weak public var delegate: MHVideoPlayerViewDelegate?
    
    public var keepingPlayer: AVPlayer = AVPlayer()
    
    private var isCalcurateCurrentTime: Bool = true
    private var timeObserverToken: AnyObject?
    private weak var lastPlayerTimeObserve: AVPlayer?
    
    public var isCanBackgroundPlay: Bool = true
    
    
    public var isReleasePlayer: Bool{
        set{
            if newValue, self.isCanBackgroundPlay{  //백그라운드 재생 가능하고, 현재 백그라운드인 경우
                self.player = nil
            }else{
                self.player = self.keepingPlayer
                self.play()
            }
        }
        get{
            if let _ = self.playerLayer.player{
                return false
            }else{ //백그라운드
                return true
            }
        }
    }
    
    public var isHaveURL: Bool = false
    
    public var url: URL?{
        didSet{
            
            guard !self.isHaveURL else{
                return
            }
            guard let url = url else {
                return
            }
            
            print("video url ::: \(url)")
            self.isHaveURL = true
            self.preparePlayer(url: url)
        }
    }
    
    public var isPlaying: Bool = false
//    {
//        didSet{
//            if self.isPlaying{
//                self.play(rate: self.rate)
//            }else{
//                self.pause()
//            }
//        }
//    }
    
    public var rate: Float{
        set{
            guard self.rate != newValue else {
                return
            }
            
            if newValue == 0{
                self.removeCurrentTimeObserver()
            }else if self.rate == 0 && newValue != 0{
                self.addCurrentTimeObserver()
                self.isCalcurateCurrentTime = true
            }
            self.player?.rate = newValue
        }
        get{
            guard let player = self.player else {
                return 0
            }
            return player.rate
        }
    }
    
    public var currentTime: Double {
        get{
            guard let player = self.player else {
                return 0
            }
            return CMTimeGetSeconds(player.currentTime())
        }
        set{
            guard let timeScale = self.player?.currentItem?.duration.timescale else{
                return
            }
            let newTime = CMTimeMakeWithSeconds(newValue, preferredTimescale: timeScale)
            self.player?.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    public var interval = CMTimeMake(value: 1, timescale: 60){
        didSet{
            if self.rate != 0{
                self.addCurrentTimeObserver()
            }
        }
    }
    
    public var fillMode: MHVideoPlayerViewFillModeType?{
        didSet{
            guard let gravity = self.fillMode?.AVLayerVideoGravity else{
                return
            }
            self.playerLayer.videoGravity = gravity
        }
    }
    
    public var playingInfo: PlayingInfo?{
        didSet{
            guard let info = self.playingInfo else{
                return
            }
            self.setupNowPlaying(playingInfo: info)
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.notificationCenter.addObserver(self, selector: #selector(playerItemDidPlayToEndTime(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.soundEnableAtBibrationOff()
        
        /** 백그라운드로 들어갔을 때 **/
        self.notificationCenter.addObserver(self, selector: #selector(goBackground(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        /** 앱으로 돌아왔을 때 **/
        self.notificationCenter.addObserver(self, selector: #selector(comeBackApp(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.setupRemoteTransportControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    /** 플레이어 준비 **/
    private func preparePlayer(url: URL){
    
        self.delegate?.mhVideoPlayerCallback(loadStart: self)
        
        let asset = AVURLAsset(url: url)
        let requestKeys: [String] = [tPlayerTracksKey, tPlyerPlayableKey, tPlayerDurationKey]
        
        asset.loadValuesAsynchronously(forKeys: requestKeys) {
            DispatchQueue.main.async {
                for key in requestKeys{
                    var error: NSError?
                    let status = asset.statusOfValue(forKey: key, error: &error)
                    if status == .failed{
                        self.delegate?.mhVideoPlayerCallback(loadFinish: self, isLoadSuccess: false, error: error)
                        return
                    }
                    if asset.isPlayable == false{
                        self.delegate?.mhVideoPlayerCallback(loadFinish: self, isLoadSuccess: false, error: error)
                        return
                    }
                }
                
                if self.player == nil {
                    self.player = self.keepingPlayer
                }
                
                self.keepingPlayer.replaceCurrentItem(with: AVPlayerItem(asset: asset))
                
               self.player?.currentItem?.audioTimePitchAlgorithm = .timeDomain

                self.addObserversPlayer(avPlayer: self.player!)
                self.addObserversVideoItem(playerItem: self.player!.currentItem!)
                
                self.delegate?.mhVideoPlayerCallback(loadFinish: self, isLoadSuccess: true, error: nil)
            }
        }
    }

    /** 백그라운드 재생 컨트롤러 터치이벤트 셋업 **/
    private func setupRemoteTransportControls(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

//        commandCenter.playCommand.addTarget { [unowned self] event in
        commandCenter.playCommand.addTarget { [weak self] event in
            self?.keepingPlayer.play()
            return .success
        }

//        commandCenter.pauseCommand.addTarget { [unowned self] event in
        commandCenter.pauseCommand.addTarget { [weak self] event in
            self?.keepingPlayer.pause()
            return .success
        }
    }
    
    /** 백그라운드 재생 컨트롤러에 뜰 정보 셋업 **/
    func setupNowPlaying(playingInfo: PlayingInfo){
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = playingInfo.titleStr
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        guard let urlStr = playingInfo.imgUrlStr else{
            return
        }
        
        let url = URL(string: urlStr)!
        
        guard let data = try? Data(contentsOf: url) else{
            return
        }
        
        if let image = UIImage(data: data){
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size in
                return image
            })
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func soundEnableAtBibrationOff(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{}
    }
    
    private func addObserversPlayer(avPlayer: AVPlayer){
        avPlayer.addObserver(self, forKeyPath: tPlayerStatusKey, options: [.new], context: &statusContext)
        avPlayer.addObserver(self, forKeyPath: tPlayerRateKey, options: [.new], context: &rateContext)
        avPlayer.addObserver(self, forKeyPath: tCurrentItemKey, options: [.old, .new], context: &playerItemContext)
    }
    
    private func removeObserversPlayer(avPlayer: AVPlayer){
        avPlayer.removeObserver(self, forKeyPath: tPlayerStatusKey, context: &statusContext)
        avPlayer.removeObserver(self, forKeyPath: tPlayerRateKey, context: &rateContext)
        avPlayer.removeObserver(self, forKeyPath: tCurrentItemKey, context: &playerItemContext)
        
        if let timeObserverToken = self.timeObserverToken {
            avPlayer.removeTimeObserver(timeObserverToken)
        }
    }
    
    private func addObserversVideoItem(playerItem: AVPlayerItem){
        playerItem.addObserver(self, forKeyPath: tLoadedTimeRangesKey, options: [], context: &loadedContext)
        playerItem.addObserver(self, forKeyPath: tPlayerDurationKey, options: [], context: &durationContext)
        playerItem.addObserver(self, forKeyPath: tPlayerStatusKey, options: [], context: &statusItemContext)
        playerItem.addObserver(self, forKeyPath: tPlayerKeepUpKey, options: [.new, .old], context: &statusKeepUpContext)
    }
    
    private func removeObserversVideoItem(playerItem: AVPlayerItem){
        playerItem.removeObserver(self, forKeyPath: tLoadedTimeRangesKey, context: &loadedContext)
        playerItem.removeObserver(self, forKeyPath: tPlayerDurationKey, context: &durationContext)
        playerItem.removeObserver(self, forKeyPath: tPlayerStatusKey, context: &statusItemContext)
        playerItem.removeObserver(self, forKeyPath: tPlayerKeepUpKey, context: &statusKeepUpContext)
    }
    
    private func removeNotification(){
        //등록된 노티피케이션 옵저버 전체 제거
        self.notificationCenter.removeObserver(self)
    }

    private func removeCurrentTimeObserver(){
        if let timeObserverToken = self.timeObserverToken {
            lastPlayerTimeObserve?.removeTimeObserver(timeObserverToken)
        }
        self.timeObserverToken = nil
    }
    
    private func addCurrentTimeObserver(){
        self.removeCurrentTimeObserver()
        
        self.lastPlayerTimeObserve = self.player
        self.timeObserverToken = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time-> Void in
            if let mySelf = self{
                if mySelf.isCalcurateCurrentTime{
                    self?.delegate?.mhVideoPlayerCallback(playerView: mySelf, currentTime: mySelf.currentTime)
                }
            }
        }) as AnyObject?
    }
    
    private func removePlayer(){
        guard let player = player else {
            return
        }
        player.pause()
        
        self.removeObserversPlayer(avPlayer: player)
        
        if let playerItem = player.currentItem{
            self.removeObserversVideoItem(playerItem: playerItem)
        }
        
        self.player = nil
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &statusContext {
            guard let player = self.player else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
            self.delegate?.mhVideoPlayerCallback(playerView: self, statusPlayer: player.status, error: player.error)
            
        }else if context == &loadedContext{
            let playerItem = self.player?.currentItem
            
            guard let times = playerItem?.loadedTimeRanges else{
                return
            }
            let values = times.map{$0.timeRangeValue}
            self.delegate?.mhVideoPlayerCallback(playerView: self, loadedTimeRanges: values)
            
        }else if context == &durationContext{
            if let currentItem = self.player?.currentItem{
                self.delegate?.mhVideoPlayerCallback(playerView: self, duration: currentItem.duration.seconds)
            }
        }else if context == &statusItemContext{
            if let currentItem = self.player?.currentItem{
                self.delegate?.mhVideoPlayerCallback(playerView: self, statusItemPlayer: currentItem.status, error: currentItem.error)
            }
        }else if context == &rateContext{
            guard let newRateNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber else{
                return
            }
            let newRate = newRateNumber.floatValue
            if newRate == 0{
                self.removeCurrentTimeObserver()
            }else{
                self.addCurrentTimeObserver()
            }
            self.delegate?.mhVideoPlayerCallback(playerView: self, rate: newRate)
            
        }else if context == &statusKeepUpContext{
            guard let newIsKeepupValue = (change?[NSKeyValueChangeKey.newKey] as? Bool) else{
                return
            }
            self.delegate?.mhVideoPlayerCallback(playerView: self, isLikelyKeepUp: newIsKeepupValue)
            
        }else if context == &playerItemContext{
            guard let oldItem = (change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem) else{
                return
            }
            self.removeObserversVideoItem(playerItem: oldItem)
            guard let newItem = (change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem) else{
                return
            }
            self.addObserversVideoItem(playerItem: newItem)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension MHVideoPlayerWithDelegateView{
    @objc private func playerItemDidPlayToEndTime(notification: NSNotification){
        self.delegate?.mhVideoPlayerCallback(playerFinished: self)
    }
    @objc private func goBackground(notification: NSNotification){
        print("go background")
        self.player = nil
    }
    @objc private func comeBackApp(notification: NSNotification){
        print("comeback app")
        self.player = self.keepingPlayer
    }
}

extension MHVideoPlayerWithDelegateView{
    
    public func play(rate: Float = 1){
        self.rate = rate
    }
    
    public func pause(){
        self.isCalcurateCurrentTime = false
        self.rate = 0
    }
    
    public func stop(){
        self.currentTime = 0
        self.pause()
    }
    
    public func playFromBeginning(){
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    public func seekOperation(targetTime: Double, completion: @escaping ()->()){
        
        guard let timeScale = self.player?.currentItem?.duration.timescale else{
            return
        }
        
        let isBeforePlaying = self.isPlaying
        self.isPlaying = false
        
        self.currentTime = targetTime
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isPlaying = isBeforePlaying
            completion()
        }
    }
    
    func setPlayerStatus(isPlaying: Bool, velocity: Float){
        
//        guard isPlaying != self.isPlaying else{
//            self.setVelocity(velocity: velocity)
//            return
//        }
        
//        self.isPlaying = isPlaying
        
        if isPlaying{
//            print("playing \(velocity)")
            self.play(rate: velocity)
        }else{
            self.pause()
        }
    }
    
    func setVelocity(velocity: Float){
        self.rate = velocity
    }
}

