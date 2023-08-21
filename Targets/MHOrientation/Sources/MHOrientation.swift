import Foundation
import UIKit

public class MHOrientation: NSObject{
    public typealias Listener = (_ orientation: UIInterfaceOrientation) -> ()
    
    public enum DeviceType{
        case phone
        case pad
        
        init(){
            switch UIDevice.current.userInterfaceIdiom{
            case .phone:
                self = .phone
                break
            case .pad:
                self = .pad
                break
            default:
                self = .pad
                break
            }
        }
    }

    weak var vc: UIViewController?

    override init(){}
    public init(vc: UIViewController?) {
        self.vc = vc
    }

    private var supportedOrientation: UIInterfaceOrientationMask?{
        self.supportedListener?()
    }
     
    public var currentDevice: DeviceType = DeviceType()
    
    public var isSetNeedsUpdate: Bool = false{
        didSet{
            guard isSetNeedsUpdate == true else {
                return
            }
            if #available(iOS 16.0, *) {
                self.vc?.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                // Fallback on earlier versions
            }
            self.isSetNeedsUpdate = false
        }
    }

    private var supportedListener: (() -> (UIInterfaceOrientationMask))?
    public func setSupportedOrientation(supportedListener: @escaping (() -> (UIInterfaceOrientationMask))){
        self.supportedListener = supportedListener
    }

    //orientation 설정
    public func set(orientation: UIInterfaceOrientation, _ to: Listener?){
        self.rotateDevice(orientation: orientation) {
            to?(orientation)
        }
    }

    //현재 orientation에서 반대로 돌려줌
    public func setForce(_ to: Listener?){
        self.rotateDeviceByForce { orientaton in //orientation : 변하게 되는 방향
            to?(orientaton)
        }
    }

    //현재 Orientation
    public var currentOrientation: UIInterfaceOrientation{
        if #available(iOS 13.0, *){
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? (self.currentDevice == .phone ? .portrait : .landscapeLeft)
//            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? (AngDevice.current.deviceType.deviceFamily.isPhone ? .portrait : .landscapeLeft)
        }else{
            return UIDevice.current.orientation.interfaceOrient
        }
    }

    //Portrait/Landscape 로 돌려줌
    private func rotateDevice(addTime: Double = 0.1, orientation: UIInterfaceOrientation = .portrait, closure: @escaping ()->()){
//        if AngDevice.current.deviceType.deviceFamily.isPhone{
        if self.currentDevice == .phone{
            if #available(iOS 16, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation.mask))

                DispatchQueue.main.asyncAfter(deadline: .now()+addTime) {
                    closure()
                }
            } else {
                UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
                closure()
            }
        }
    }

    //현재방향에서 반대로 돌려줌
    private func rotateDeviceByForce(closure: @escaping (_ orientation: UIInterfaceOrientation)->()){
        let orientationValue: UIInterfaceOrientation = {
            return self.currentOrientation.isLandscape ? .portrait : .landscapeRight
        }()

        if #available(iOS 16, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientationValue.mask))
        } else {
            UIDevice.current.setValue(orientationValue.deviceOrient.rawValue, forKey: "orientation")
        }

        closure(orientationValue)
    }
}

extension UIInterfaceOrientation{
    var mask: UIInterfaceOrientationMask{
        switch self {
        case .unknown:
            return .all
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        }
    }
    
    var deviceOrient: UIDeviceOrientation{
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
        }
    }
}

extension UIDeviceOrientation{
    var interfaceOrient: UIInterfaceOrientation{
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
