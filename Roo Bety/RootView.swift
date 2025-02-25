import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: NavGuard = NavGuard.shared
    var body: some View {
        switch nav.currentScreen {
                                        
        case .MENU:
            MenuView()
            
        case .LOADING:
            LoadingScreen()
            
        case .SETTINGS:
            SettingsView()
            
        case .ABOUT:
            RulesView()
            
        case .SHOP:
            ShopView()
            
        case .GAME1:
            Game1()
            
        case .GAME1RULES:
            Game1Rules()
            
        case .GAME2RULES:
            Game2Rules()
            
        case .GAME2:
            Game2()
            
        case .GAME3RULES:
            Game3Rules()
            
        case .GAME3:
            Game3()
            
        case .GAME4RULES:
            Game4Rules()
            
        case .GAME4:
            Game4()
            
        case .DAILY:
            DailyBonus()

        }

    }
}
