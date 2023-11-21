import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains MHUtility App target and MHUtility unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "MHUtility",
                          frameworkTargetsName: ["MHAPI",
                                                 "MHOrientation",
                                                 "MHExtension",
                                                 "MHDownloader",
                                                 "MHImageCache",
                                                 "MHDevice",
                                                 "MHLog",
                                                 "MHUserDefaults",
                                                 "MHUIUtility",
                                                 "MHTextFieldListView",
                                                "MHNavigation"])


//roject.app(name: "MHUtility",
//                          platform: .iOS,
//                          additionalTargets: ["MHUtilityKit", "MHUtilityUI"])
