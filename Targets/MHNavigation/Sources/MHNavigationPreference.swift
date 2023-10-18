//
//  MHNavigationPreference.swift
//
//
//  Created by LittleFoxiOSDeveloper on 2023/10/17.
//

import SwiftUI

public struct StatusBarColorPreferenceKey: PreferenceKey{
    public static var defaultValue: Color = .clear
    public static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}
public struct TitlePreferenceKey: PreferenceKey{
    
    public struct TitleTexts: Equatable{
        var title: String?
        var subTitle: String?
    }
    
    public static var defaultValue: TitleTexts = TitleTexts()
    public static func reduce(value: inout TitleTexts, nextValue: () -> TitleTexts) {
        value = nextValue()
    }
}
public struct BackgroundTypePreferenceKey: PreferenceKey{
    public static var defaultValue: MHNavigationController.BackgroundType?
    public static func reduce(value: inout MHNavigationController.BackgroundType?, nextValue: () -> MHNavigationController.BackgroundType?) {
        value = nextValue()
    }
}
public struct BackButtonImagePreferenceKey: PreferenceKey{
    public static var defaultValue: UIImage? = nil
    public static func reduce(value: inout UIImage?, nextValue: () -> UIImage?) {
        value = nextValue()
    }
}
public struct CloseButtonImagePreferenceKey: PreferenceKey{
    public static var defaultValue: UIImage? = nil
    public static func reduce(value: inout UIImage?, nextValue: () -> UIImage?) {
        value = nextValue()
    }
}
public struct NavigationBarHiddenPreferenceKey: PreferenceKey{
    public static var defaultValue: Bool = false
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
public struct BackButtonHiddenPreferenceKey: PreferenceKey{
    public static var defaultValue: Bool = false
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
public struct CloseButtonHiddenPreferenceKey: PreferenceKey{
    public static var defaultValue: Bool = false
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

public extension View{
    func naviViewStatusBarColor(_ color: Color) -> some View{
        preference(key: StatusBarColorPreferenceKey.self, value: color)
    }
    func naviViewTitle(_ title: String?, _ subTitle: String? = nil) -> some View{
        preference(key: TitlePreferenceKey.self, value: TitlePreferenceKey.TitleTexts(title: title, subTitle: subTitle))
    }
    func naviViewBackgroundType(_ type: MHNavigationController.BackgroundType?) -> some View{
        preference(key: BackgroundTypePreferenceKey.self, value: type)
    }
    func naviViewBackButtonImage(_ image: UIImage?) -> some View{
        preference(key: BackButtonImagePreferenceKey.self, value: image)
    }
    func naviViewCloseButtonImage(_ image: UIImage?) -> some View{
        preference(key: CloseButtonImagePreferenceKey.self, value: image)
    }
    func naviViewHidden(_ isHidden: Bool = false) -> some View{
        preference(key: NavigationBarHiddenPreferenceKey.self, value: isHidden)
    }
    func naviViewBackButtonHidden(_ isHidden: Bool = false) -> some View{
        preference(key: BackButtonHiddenPreferenceKey.self, value: isHidden)
    }
    func naviViewCloseButtonHidden(_ isHidden: Bool = false) -> some View{
        preference(key: CloseButtonHiddenPreferenceKey.self, value: isHidden)
    }
}