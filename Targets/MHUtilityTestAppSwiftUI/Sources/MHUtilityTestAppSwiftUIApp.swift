//
//  MHUtilityTestAppSwiftUIApp.swift
//  MHUtilityTestAppSwiftUI
//
//  Created by LittleFoxiOSDeveloper on 2023/08/18.
//

import SwiftUI

@main
struct MHUtilityTestAppSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
      }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        return UIInterfaceOrientationMask.all
    }
}
