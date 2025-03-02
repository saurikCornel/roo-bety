import SwiftUI

struct MenuView: View {
    @AppStorage("firstOpen") var firstOpen = false
    @StateObject private var soundManager = CheckingSound() // Подключаем CheckingSound
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true // Флаг первого запуска

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                    ZStack {
                        VStack {
                            HStack {
                                StarTemplate()
                                BalanceTemplate()
                                Spacer()
                                ButtonTemplateSmall(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                            }
                            Spacer()
                            
                            HStack {
                                ButtonTemplateSmall(image: "shopBtn", action: {NavGuard.shared.currentScreen = .SHOP})
                                Spacer()
                                ButtonTemplateSmall(image: "rulesBtn", action: {NavGuard.shared.currentScreen = .ABOUT})

                            }
                        }
                        
                        HStack {
                            ButtonTemplateSmall(image: "dailyBtn", action: {NavGuard.shared.currentScreen = .DAILY})
                            Spacer()
                        }
                        
                        if firstOpen {
                            ButtonTemplateBig(image: "startBtn", action: {NavGuard.shared.currentScreen = .GAMESCREEN1})
                        } else {
                            ButtonTemplateBig(image: "startBtn", action: {clickRight()})
                        }
//                        ButtonTemplateBig(image: "startBtn", action: {NavGuard.shared.currentScreen = .GAMESCREEN1})
                        
                            
                        }
                    .onAppear {
                        // Включаем музыку только при первом запуске
                        if isFirstLaunch {
                            soundManager.musicEnabled = true
                            isFirstLaunch = false // Отмечаем, что первый запуск прошёл
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )


        }
    }
    func clickRight() {
        firstOpen = true
        NavGuard.shared.currentScreen = .GAME1RULES
    }
}




struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    var body: some View {
            ZStack {
                Image(.coinTemplate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 70)
                    .overlay(
                        ZStack {
                            Text("\(coinscore)")
                                .foregroundColor(.black)
                                .fontWeight(.heavy)
                                .font(.title3)
                                .position(x: 80, y: 35)
                            
                        }
                    )
            }
    }
}

struct StarTemplate: View {
    @AppStorage("starscore") var starscore: Int = 10
    var body: some View {
        ZStack {
            Image(.starTemplate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(starscore)")
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 80, y: 35)
                        
                    }
                )
        }
    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 140)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}

