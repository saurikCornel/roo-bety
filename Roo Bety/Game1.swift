import SwiftUI

struct Game1: View {
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1"
    @AppStorage("coinscore") var coinscore: Int = 10
    @State private var items: [GameItem] = []
    @State private var gameOver: Bool = false
    @State private var characterY: CGFloat = 200
    @State private var characterOnBlockIndex: Int? = nil
    @State private var successfulJumps: Int = 0
    
    let itemSize: CGFloat = 130
    let characterSize: CGFloat = 50
    let itemSpeed: CGFloat = 10
    let levels: [CGFloat] = [100, 200, 300]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                    // Игра работает только в ландшафтной ориентации
                    ZStack {
                        // Добавляем персонажа
                        Image(currentSelectedCloseCard)
                            .resizable()
                            .frame(width: characterSize, height: characterSize + 30)
                            .position(x: ((screenWidth / 9)), y: characterY - 80) // Персонаж по центру п
                            .zIndex(1)
                        
                        
                        // Добавляем блоки (картинки)
                        ForEach(items.indices, id: \.self) { index in
                            if !items[index].isOutOfScreen {  // Проверяем, не ушел ли блок за экран
                                Image(items[index].image)
                                    .resizable()
                                    .frame(width: itemSize, height: itemSize)
                                    .position(x: items[index].x, y: items[index].y)
                                    .zIndex(0)
                            }
                        }
                        
                        
                        if gameOver {
                            if successfulJumps >= 4 {
                                WinViewLevel1()
                            } else {
                                LoseViewLevel1()
                            }
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight)
                    .onAppear {
                        startGame(screenWidth: screenWidth)
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < 0 {
                                    // Свайп вверх
                                    moveCharacter(direction: .up)
                                } else {
                                    // Свайп вниз
                                    moveCharacter(direction: .down)
                                }
                                checkCollision(screenWidth: screenWidth)
                            }
                    )
            }
            .frame(width: screenWidth, height: screenHeight)
            .background(
                Image("backgroundGame1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
    
    // Направление движения персонаж
    enum MoveDirection {
        case up
        case down
    }

    // Структура для блока
    struct GameItem: Identifiable, Equatable {
        var id = UUID()
        var x: CGFloat
        var y: CGFloat
        var image: String
        var isStopped: Bool
        var isOutOfScreen: Bool = false  // Добавляем флаг для проверки, ушел ли блок за экран
    }
    
    // Запуск игры
    func startGame(screenWidth: CGFloat) {
        items.removeAll()
        successfulJumps = 0 // Убеждаемся, что начинается с 0
        gameOver = false
        characterOnBlockIndex = nil
        
        let startBlock = GameItem(x: screenWidth / 9, y: characterY, image: "item1", isStopped: true)
        items.append(startBlock)
        characterOnBlockIndex = 0

        // Таймер добавления блоков
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            withAnimation {
                let randomLevel = levels.randomElement()!
                let randomImage = "item\(Int.random(in: 3...5))"

                let newItem = GameItem(x: screenWidth + itemSize, y: randomLevel, image: randomImage, isStopped: false)
                items.append(newItem)
            }
        }

        // Таймер движения блоков
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation {
                for index in items.indices {
                    if !items[index].isStopped {
                        items[index].x -= itemSpeed
                    }
                    if items[index].x < -itemSize {
                        items[index].isOutOfScreen = true
                    }
                }
                checkCollision(screenWidth: screenWidth)
            }
        }
    }

    // Проверка прыжка персонажа
    func checkCollision(screenWidth: CGFloat) {
        var nearestBlockIndex: Int? = nil

        for index in items.indices {
            let item = items[index]

            if item.y == characterY, abs(item.x - (screenWidth / 9)) < itemSize - 100 {
                nearestBlockIndex = index
            }

            if item.x < -itemSize {
                items[index].isOutOfScreen = true
            }
        }

        // Если персонаж только начал игру, не засчитываем стартовый блок
        if characterOnBlockIndex == nil {
            characterOnBlockIndex = nearestBlockIndex
            return
        }

        if let nearestBlockIndex {
            // Проверяем, перешел ли персонаж на новый блок
            if nearestBlockIndex != characterOnBlockIndex {
                if let currentCharacterIndex = characterOnBlockIndex {
                    items[currentCharacterIndex].isStopped = false
                }
                
                items[nearestBlockIndex].isStopped = true
                characterOnBlockIndex = nearestBlockIndex

                // Увеличиваем успешные прыжки только при смене блока
                successfulJumps += 1

                if successfulJumps >= 4 {
                    gameOver = true
                }
            }
        } else {
            gameOver = true
        }
    }

    // Перемещение персонажа с проверкой
    func moveCharacter(direction: MoveDirection) {
        withAnimation {
            if let currentLevelIndex = levels.firstIndex(of: characterY) {
                let newLevelIndex = direction == .up ? currentLevelIndex - 1 : currentLevelIndex + 1
                if newLevelIndex >= 0, newLevelIndex < levels.count {
                    let newCharacterY = levels[newLevelIndex]

                    // Проверяем, есть ли блок рядом, прежде чем менять уровень
                    let isSafeJump = items.contains { $0.y == newCharacterY && abs($0.x - (UIScreen.main.bounds.width / 9)) < itemSize }

                    if isSafeJump {
                        // Перемещаем персонажа на верхнюю часть блока
                        if let blockIndex = items.firstIndex(where: { $0.y == newCharacterY && abs($0.x - (UIScreen.main.bounds.width / 9)) < itemSize }) {
                            characterY = items[blockIndex].y
                        }
                    } else {
                        gameOver = true // Прыжок в пустоту
                    }
                }
            }
        }
    }
}


struct WinViewLevel1: View {
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
                    NavGuard.shared.currentScreen = .GAMESCREEN2
                }
            
        }
    }
}

struct LoseViewLevel1: View {
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
    Game1()
}
