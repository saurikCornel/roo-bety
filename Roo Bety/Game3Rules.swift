import SwiftUI

struct Game3Rules: View {
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    ZStack {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(.goBtn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .GAME4RULES
                                    }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.game3Rules)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.05)
            )


        }
    }
}

#Preview {
    Game3Rules()
}

