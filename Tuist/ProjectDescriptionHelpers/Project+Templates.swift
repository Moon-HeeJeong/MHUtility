import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    public static func app(name: String, frameworkTargetsName: [String]) -> Project{
        var targets = [Target]()
        
        let frameWorkTarget = makeFrameworkTargets(targetsNames: frameworkTargetsName)
        
        let appTarget = makeAppTargets(name: "\(name)TestAppSwiftUI", dependencies: frameworkTargetsName.map({TargetDependency.target(name: $0)}))
        
        targets += frameWorkTarget
        targets += appTarget
        
        return Project(name: name, targets: targets)
    }
    
    private static func makeFrameworkTargets(targetsNames:[String]) -> [Target]{
        let minIOSVersion: String = "14.0"
        
        var targets = [Target]()
        for name in targetsNames{
            let sources = Target(name: name,
                                platform: .iOS,
                                product: .framework,
                                bundleId: "com.mh.\(name)",
                                 deploymentTarget: .iOS(targetVersion: minIOSVersion, devices: [.ipad, .iphone,.mac]),
                                infoPlist: .default,
                                sources: ["Targets/\(name)/Sources/**"],
//                                resources: [],
                                resources: ["Targets/\(name)/Resources/**"],
                                dependencies: [])
            let tests = Target(name: "\(name)Tests",
                               platform: .iOS,
                               product: .unitTests,
                               bundleId: "com.mh.\(name)Tests",
                               deploymentTarget: .iOS(targetVersion: minIOSVersion, devices: [.ipad, .iphone, .mac]),
                               infoPlist: .default,
                               sources: ["Targets/\(name)/Tests/**"],
//                               resources: [],
                               resources: ["Targets/\(name)/Resources/**"],
                               dependencies: [.target(name: name)])
            
            targets.append(sources)
            targets.append(tests)
        }
        return targets
    }
    
    private static func makeAppTargets(name: String, dependencies: [TargetDependency]) -> [Target]{
        
        let platform: Platform = .iOS
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        let minIOSVersion: String = "14.0"
        
        let mainTarget = Target(name: name,
                            platform: platform,
                            product: .app,
                            bundleId: "com.mh.\(name)",
                            deploymentTarget: .iOS(targetVersion: minIOSVersion, devices: [.ipad, .iphone,.mac]),
                             infoPlist: .extendingDefault(with: infoPlist),
                            sources: ["Targets/\(name)/Sources/**"],
                            resources: ["Targets/\(name)/Resources/**"],
                            dependencies: dependencies)
        
        let testTarget = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "com.mh.\(name)Tests",
                           deploymentTarget: .iOS(targetVersion: minIOSVersion, devices: [.ipad, .iphone, .mac]),
                           infoPlist: .default,
                           sources: ["Targets/\(name)/Tests/**"],
                           dependencies: [.target(name: name)])
        
        return [mainTarget, testTarget]
    }
}
