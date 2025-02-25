import SwiftUI

struct DailyBonus: View {
    @AppStorage("lastSpinTime") private var lastSpinTime: Double = 0
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    @State private var showPrize = false
    @State private var showAlert = false
    @State private var remainingTime: String = ""
    
    private var canSpin: Bool {
        let currentTime = Date().timeIntervalSince1970
        return currentTime - lastSpinTime > 86400
    }
    
    private func updateRemainingTime() {
        let currentTime = Date().timeIntervalSince1970
        let timeLeft = 86400 - (currentTime - lastSpinTime)
        if timeLeft > 0 {
            let hours = Int(timeLeft) / 3600
            let minutes = (Int(timeLeft) % 3600) / 60
            remainingTime = String(format: "%02d:%02d", hours, minutes)
        } else {
            remainingTime = "00:00"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Image("close")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(.top, 60)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 90) {
                            Image(.wheel)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .rotationEffect(.degrees(rotationAngle))
                                .animation(.easeOut(duration: 12), value: rotationAngle)
                            
                            Image(.spinBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .onTapGesture {
                                    if canSpin {
                                        isSpinning = true
                                        rotationAngle += 3600
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                                            isSpinning = false
                                            showPrize = true
                                            lastSpinTime = Date().timeIntervalSince1970
                                        }
                                    } else {
                                        updateRemainingTime()
                                        showAlert = true
                                    }
                                }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("You can open it in"), message: Text(remainingTime), dismissButton: .default(Text("OK")))
                    }
                    .fullScreenCover(isPresented: $showPrize) {
                        PriseView()
                    }
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
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct PriseView: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.priseView)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .onTapGesture {
                        coinscore += 100
                        NavGuard.shared.currentScreen = .MENU
                    }
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
}

#Preview {
    DailyBonus()
}
