import SwiftUI

struct Game4Rules: View {
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
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
                                        NavGuard.shared.currentScreen = .GAME1
                                    }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.gameScreen4)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.05)
                    
            )


        }
    }
}

#Preview {
    Game4Rules()
}

