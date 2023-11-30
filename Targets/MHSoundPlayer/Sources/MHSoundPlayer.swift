import Foundation
import Combine
import AVFoundation
import AVKit

public class MHSoundPlayer: NSObject{
    
    deinit {
        print("deinit sound")
        self.stop()
    }
    
    public enum SoundStatus{
        case playStart
        case playEnd
        case playStop
        case fail(errorKind: SoundError)
    }
    
    public enum SoundError: Error{
        case urlError
        case loadFail
        case notPlayable
    }
    
    private var player: AVQueuePlayer?
    public var statusSubject = PassthroughSubject<SoundStatus, Never>()
    
    private let tPlayerTracksKey = "tracks"
    private let tPlayerPlayableKey = "playable"
    private let tPlayerDurationKey = "duration"
    
    private var urls: [URL]?{
        didSet{
            guard let urls = urls else {
                self.statusSubject.send(.fail(errorKind: .urlError))
                self.assets = []
                return
            }
            self.assets = urls.map({AVURLAsset(url: $0)})
        }
    }
    private var assets: [AVAsset] = []{
        didSet{
            for asset in oldValue{
                asset.cancelLoading()
            }
            self.setPlayer(assets: self.assets)
        }
    }
    
    override init(){
        super.init()
    }
    
    @objc private func endPlaying(_ notification: Notification){
        self.statusSubject.send(.playEnd)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    public func stop(){
        self.player?.pause()
        self.release()
        self.statusSubject.send(.playStop)
    }
    
    public func release(){
        self.player?.removeAllItems()
        self.player = nil
    }
}
extension MHSoundPlayer{
    
    public func subscribeStatusPublisher() -> AnyPublisher<SoundStatus, Never>{
        return statusSubject.eraseToAnyPublisher()
    }
    
    public func playSound(soundUrlStrs: [String]){
        self.urls = soundUrlStrs.map({URL(string: $0)!})
        NotificationCenter.default.addObserver(self, selector: #selector(endPlaying), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    private func setPlayer(assets: [AVAsset]){
        self.stop()
        
        var items: [AVPlayerItem] = []
        
        var currentIdx: Int = 0
        
        func load(){
            let requestKeys : [String] = [tPlayerTracksKey,tPlayerPlayableKey,tPlayerDurationKey]
            assets[currentIdx].loadValuesAsynchronously(forKeys: requestKeys) {
                DispatchQueue.main.async {
                    for key in requestKeys {
                        var error: NSError?
                        let status = assets[currentIdx].statusOfValue(forKey: key, error: &error)
                        
                        if status == .failed{
                            self.statusSubject.send(.fail(errorKind: .loadFail))
                            return
                        }
                        
                        if assets[currentIdx].isPlayable == false{
                            self.statusSubject.send(.fail(errorKind: .notPlayable))
                            return
                        }
                    }
                    
                    let item = AVPlayerItem(asset: assets[currentIdx])
                    items.append(item)
                    
                    if currentIdx == assets.count-1{
                        self.player = AVQueuePlayer(items: items)
                        
                        self.statusSubject.send(.playStart)
                        self.player?.play()
                    }else{
                        currentIdx += 1
                        load()
                    }
                }
            }
        }
        
        load()
    }
}
