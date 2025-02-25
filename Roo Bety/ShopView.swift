import SwiftUI

struct CardOption: Identifiable {
    let id: String
    let buyImage: String
    let selectImage: String
    let closeImage: String
    let selectedImage: String
}

struct ShopView: View {
    @AppStorage("coinscore") var playerBalance: Int = 10
    @AppStorage("ownedCards") private var ownedCards: String = "background1" // Используем строку для хранения карт
    @AppStorage("selectedCard") private var selectedCard: String = "firstCardSelected" // Выбранная карта
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1" // Новая переменная для хранения closeImage выбранной карты

    @State private var alertMessage: String? // Для хранения текста алерта
    @State private var showAlert: Bool = false // Отображение алерта

    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard", buyImage: "firstCardBuy", selectImage: "firstCardSelect", closeImage: "background1", selectedImage: "firstCardSelected"),
        CardOption(id: "secondCard", buyImage: "secondCardBuy", selectImage: "secondCardSelect", closeImage: "background2", selectedImage: "secondCardSelected"),
        CardOption(id: "thirdCard", buyImage: "thirdCardBuy", selectImage: "thirdCardSelect", closeImage: "background3", selectedImage: "thirdCardSelected"),
        CardOption(id: "fourCard", buyImage: "fourCardBuy", selectImage: "fourCardSelect", closeImage: "background4", selectedImage: "fourCardSelected"),
        CardOption(id: "fiveCard", buyImage: "fiveCardBuy", selectImage: "fiveCardSelect", closeImage: "background5", selectedImage: "fiveCardSelected"),
        CardOption(id: "sixCard", buyImage: "sixCardBuy", selectImage: "sixCardSelect", closeImage: "background6", selectedImage: "sixCardSelected"),
        CardOption(id: "sevenCard", buyImage: "sevenCardBuy", selectImage: "sevenCardSelect", closeImage: "background7", selectedImage: "sevenCardSelected"),
        CardOption(id: "eightCard", buyImage: "eightCardBuy", selectImage: "eightCardSelect", closeImage: "background8", selectedImage: "eightCardSelected"),

    ]
    
    private let cardPrice: Int = 10
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                                BalanceTemplate()
                            }
                            Spacer()
                        }
                        .padding(.top, 30)
                        
                        
                        HStack(spacing: 40) {
                            
                            ZStack {
                                Image(.custumerPlate)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 350)
                                    .padding(.top, 90)
                                
                                
                                Image("\(currentSelectedCloseCard)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 250)
                                    .padding(.top, 50)
                                    .padding(.leading, 55)
                            }
                            
                            ZStack {
                                Image(.shopPlate)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 450, height: 350)
                                    .padding(.top, 90)
                                
                                VStack(spacing: 20) { // Оборачиваем все карточки в VStack
                                    HStack(spacing: -60) { // Первый ряд с четырьмя карточками
                                        ForEach(cardOptions.prefix(4)) { card in
                                            Button(action: {
                                                handleCardAction(for: card)
                                            }) {
                                                Image(currentImage(for: card))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 150, height: 100)
                                            }
                                        }
                                    }
                                    
                                    HStack(spacing: -60) { // Второй ряд с четырьмя карточками
                                        ForEach(cardOptions.suffix(4)) { card in
                                            Button(action: {
                                                handleCardAction(for: card)
                                            }) {
                                                Image(currentImage(for: card))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 150, height: 100)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 50)
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
                                }
                            }
                        }
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
                Image(.backgroundShop)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
    
    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage // Отображаем "выбранный" статус
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage // Карта куплена, но не выбрана
        } else {
            return card.buyImage // Карта не куплена
        }
    }
    
    private func handleCardAction(for card: CardOption) {
        if ownedCards.contains(card.closeImage) {
            // Если карта уже куплена, просто выбираем её
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage) // Сохраняем closeImage выбранной карты
            alertMessage = "Card selected successfully!" // Сообщение об успешном выборе карты
        } else if playerBalance >= cardPrice {
            // Покупаем карту
            playerBalance -= cardPrice
            ownedCards += "," + card.closeImage // Добавляем карту в список
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage) // Сохраняем closeImage выбранной карты
            alertMessage = "Card purchased successfully!" // Сообщение об успешной покупке карты
        } else {
            alertMessage = "Not enough coins to buy this card!" // Сообщение о недостатке монет
        }
        showAlert = true
    }
    
    private func saveCurrentSelectedCloseCard(_ closeCard: String) {
        currentSelectedCloseCard = closeCard // Сохраняем в @AppStorage значение closeImage
    }
}


#Preview {
    ShopView()
}

