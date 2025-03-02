import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped = false
    var isMatched = false
}

struct Game3: View {
    @State private var cards: [Card] = []
    @State private var selectedCards: [Int] = []
    @State private var matchedPairs = 0
    @State private var mistakes = 0
    @State private var isGameOver = false
    
    init() {
        let baseCards = ["card1", "card2", "card3", "card4"]
        let shuffledCards = (baseCards + baseCards).shuffled().map { Card(imageName: $0) }
        _cards = State(initialValue: shuffledCards)
    }
    
    func flipCard(at index: Int) {
        guard !cards[index].isFlipped, selectedCards.count < 2 else { return }
        
        cards[index].isFlipped.toggle()
        selectedCards.append(index)
        
        if selectedCards.count == 2 {
            checkForMatch()
        }
    }
    
    func checkForMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if cards[selectedCards[0]].imageName == cards[selectedCards[1]].imageName {
                cards[selectedCards[0]].isMatched = true
                cards[selectedCards[1]].isMatched = true
                matchedPairs += 1
                
                if matchedPairs == cards.count / 2 {
                    isGameOver = true
                }
            } else {
                cards[selectedCards[0]].isFlipped = false
                cards[selectedCards[1]].isFlipped = false
                mistakes += 1
                
                if mistakes >= 9 {
                    isGameOver = true
                }
            }
            selectedCards.removeAll()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                    if isGameOver {
                        if matchedPairs == cards.count / 2 {
                            WinViewLevel3()
                        } else {
                            LoseViewLevel3()
                        }
                    } else {
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 0) {
                                ForEach(cards.indices, id: \..self) { index in
                                    CardView(card: cards[index])
                                        .onTapGesture {
                                            flipCard(at: index)
                                        }
                                }
                            }
                            .padding()
                        }
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundGame3)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        Image(card.isFlipped || card.isMatched ? card.imageName : "closeCard")
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 150)
            .cornerRadius(10)
    }
}

struct WinViewLevel3: View {
    @AppStorage("currentLevel") var currentLevel = 1
    @AppStorage("starscore") var starscore: Int = 10
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        ZStack {
            Image(.winPlate)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .onTapGesture {
                    currentLevel += 1
                    starscore += 3
                    coinscore += 10
                    NavGuard.shared.currentScreen = .GAMESCREEN4
                }
        }
    }
}

struct LoseViewLevel3: View {
    @AppStorage("currentLevel") var currentLevel = 1
    var body: some View {
        ZStack {
            Image(.losePlate)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .onTapGesture {
                    currentLevel = 1
                    NavGuard.shared.currentScreen = .MENU
                }
        }
    }
}

#Preview {
    Game3()
}
