import SwiftUI

@main
struct Roo_BetyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let currentScreen = NavGuard.shared.currentScreen
        print("AppDelegate: Current Screen = \(currentScreen)") // Отладка
        if currentScreen == .PLEASURE {
            print("AppDelegate: Returning .allButUpsideDown")
            return .allButUpsideDown
        } else {
            print("AppDelegate: Returning .landscape")
            return .landscape
        }
    }
}
