import SwiftUI

struct Game2: View {
    @State private var board = Array(repeating: "", count: 9) // Игровое поле
    @State private var isPlayerTurn = true // Флаг, чей ход (true - игрок, false - робот)
    @State private var winnerMessage = "" // Сообщение о победителе
    @State private var isGameOver = false // Флаг окончания игры

    let playerSymbol = "krest" // Ваш символ (крестик)
    let robotSymbol = "nol" // Символ робота (нолик)

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    HStack {
                        Image(isPlayerTurn ? .player1Go : .player1Wait)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 300)
                            .padding()

                        Spacer()

                        VStack(spacing: 0) {
                            if isGameOver {
                                if winnerMessage == "You Win!" {
                                    WinViewLevel2()
                                } else {
                                    LoseViewLevel2()
                                }
                            } else {
                                VStack(spacing: 0) { // Игровое поле
                                    ForEach(0..<3) { row in
                                        HStack(spacing: 0) {
                                            ForEach(0..<3) { col in
                                                let index = row * 3 + col
                                                Button(action: {
                                                    if board[index] == "" && isPlayerTurn && !isGameOver {
                                                        handlePlayerMove(at: index)
                                                        checkForWinner()
                                                        
                                                        if !isGameOver {
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                handleRobotMove()
                                                                checkForWinner()
                                                            }
                                                        }
                                                    }
                                                }) {
                                                    Image(board[index].isEmpty ? "empty" : board[index])
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 100)
                                                        .background(
                                                            Image(.slice)
                                                                .resizable()
                                                                .scaledToFill()
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Spacer()

                        Image(isPlayerTurn ? .player2Wait : .player2Go)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 300)
                            .padding()
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
                Image(.backgroundGame2)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }

    func handlePlayerMove(at index: Int) {
        board[index] = playerSymbol
        isPlayerTurn = false
    }

    func handleRobotMove() {
        var availableMoves = board.enumerated().filter { $0.element == "" }.map { $0.offset }
        
        if !availableMoves.isEmpty {
            let randomIndex = Int.random(in: 0..<availableMoves.count)
            let moveIndex = availableMoves[randomIndex]
            board[moveIndex] = robotSymbol
            isPlayerTurn = true
        }
    }

    func checkForWinner() {
        let winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Горизонтальные линии
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Вертикальные линии
            [0, 4, 8], [2, 4, 6]             // Диагональные линии
        ]
        
        for pattern in winPatterns {
            if board[pattern[0]] != "" && board[pattern[0]] == board[pattern[1]] && board[pattern[1]] == board[pattern[2]] {
                winnerMessage = board[pattern[0]] == playerSymbol ? "You Win!" : "Robot Wins!"
                isGameOver = true
                return
            }
        }
        
        if !board.contains("") {
            winnerMessage = "It's a Draw!"
            isGameOver = true
        }
    }

    func resetGame() {
        board = Array(repeating: "", count: 9)
        isPlayerTurn = true
        winnerMessage = ""
        isGameOver = false
    }
}

struct WinViewLevel2: View {
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
                    NavGuard.shared.currentScreen = .GAME3RULES
                }
        }
    }
}


struct LoseViewLevel2: View {
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
    Game2()
}
