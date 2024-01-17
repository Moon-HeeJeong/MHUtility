//
//  SheetRouter.swift
//  MHUtilityTestAppSwiftUI
//
//  Created by LittleFoxiOSDeveloper on 12/6/23.
//

import SwiftUI

//@available(iOS 16.0, *)
public enum SheetAnimation: Equatable{
    
    public enum _PresentationDetent{
        case medium
        case large
    }
    
    case full(animationOn: Bool)
    case front
    case activity(_PresentationDetent)
    case push
    
    var isAnimationOn: Bool{
        switch self {
        case .full(let animationOn):
            return animationOn
        default:
            return true
        }
    }
    
    var presentationDetent: _PresentationDetent?{
        switch self {
        case .activity(let presentationDetent):
            return presentationDetent
        default:
            return nil
        }
    }

    static public func == (lhs: SheetAnimation, rhs: SheetAnimation) -> Bool {
        "\(lhs.self)" == "\(rhs.self)"
    }
}

public protocol SheetRouterProtocol: Identifiable, Equatable {
    associatedtype Sheet: View
    @ViewBuilder func buildView(isSheeted: Binding<Bool>) -> Sheet
}

public struct SheetRouterContext<R: SheetRouterProtocol>: Equatable{
    let router: R
    let animation: SheetAnimation
}

public extension SheetRouterProtocol{
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String { "\(self)" }
}



///
///

public class MovingSheetOperator<SheetRouter:SheetRouterProtocol>: ObservableObject {
    @Published public var sheets: [SheetRouterContext<SheetRouter>] = []
    
    public init(){}
    //View의 화면 이동
    public func go(_ sheet: SheetRouter?, animation: SheetAnimation){
        if let s = sheet{
            self.sheets.append(SheetRouterContext(router: s, animation: animation))
        }
    }
    
    public func pop(){
        _ = self.sheets.popLast()
    }
}

public extension View {
    func routering<SheetRouter: SheetRouterProtocol>(_ sheets: Binding<[SheetRouterContext<SheetRouter>]>, sheetDetector: ((SheetRouter?) -> Void)? = nil) -> some View {
        modifier(MovingRoute(sheets: sheets, sheetDetector: sheetDetector))
    }
}

//////
///
public struct MovingRoute<SheetRouter: SheetRouterProtocol>: ViewModifier {
@Binding var sheets: [SheetRouterContext<SheetRouter>]
var sheetDetector: ((SheetRouter?) -> Void)? = nil

private var isActiveBinding: Binding<Bool> {
    if sheets.isEmpty {
        return .constant(false)
    } else {
        return Binding(
            get: {
                sheets.isEmpty == false
            },
            set: { isShowing in
                if !isShowing, let _ = sheets.last {
                    sheets.removeLast()
                    print("sheet \(sheets)")
                }
            }
        )
    }
}

private var isPushSheeted: Binding<Bool> {
    sheets.last?.animation == .push ? isActiveBinding : .constant(false)
}

private var isFullSheeted: Binding<Bool> {
    
    switch sheets.last?.animation {
    case .full:
        return isActiveBinding
    default:
        return .constant(false)
    }
}

private var isFrontSheeted: Binding<Bool> {
    switch sheets.last?.animation {
    case .front, .activity:
        return isActiveBinding
    default:
        return .constant(false)
    }
}

public func body(content: Content) -> some View {
    content
        .fullScreenCover(isPresented: isFullSheeted) {
            sheets.last?.router.buildView(isSheeted: isFullSheeted)
        }
        .sheet(isPresented: isFrontSheeted) {
            if #available(iOS 16.0, *) {
                sheets.last?.router.buildView(isSheeted: isFrontSheeted)
                    .presentationDetents([(self.sheets.last?.animation.presentationDetent ?? .large) == .large ? PresentationDetent.large : PresentationDetent.medium])
            } else {
                sheets.last?.router.buildView(isSheeted: isFrontSheeted)
            }
        }
        .background(
            NavigationLink(
                destination: sheets.last?.router.buildView(isSheeted: isPushSheeted),
                isActive: isPushSheeted,
                label: EmptyView.init
            )
            .hidden()
        )
        .transaction({ t in
            t.disablesAnimations = sheets.last?.animation.isAnimationOn == false
        })
        .onChange(of: sheets) { newValue in
            self.sheetDetector?(newValue.last?.router)
        }
}
}

