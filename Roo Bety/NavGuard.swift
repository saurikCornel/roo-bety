import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case SETTINGS
    case ABOUT
    case SHOP
    case GAME1
    case GAME1RULES
    case GAME2RULES
    case GAME2
    case GAME3
    case GAME4
    case GAME3RULES
    case GAME4RULES
    case DAILY
    case GAMESCREEN1
    case GAMESCREEN2
    case GAMESCREEN3
    case GAMESCREEN4
    case PLEASURE
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: NavGuard = .init()
}
