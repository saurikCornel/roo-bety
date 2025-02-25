import SwiftUI

struct Tile: Identifiable {
    let id = UUID()
    let image: Image
    var position: Int
}

struct Game4: View {
    @State private var tiles: [Tile] = []
    @State private var emptyIndex: Int = 15
    @State private var isWin: Bool = false  // Флаг победы
    
    init() {
        let originalImage = UIImage(named: "gamePic")
        let tileImages = sliceImage(originalImage: originalImage, rows: 4, cols: 4)
        
        var initialTiles = tileImages.enumerated().map { Tile(image: Image(uiImage: $0.element), position: $0.offset) }
        initialTiles.append(Tile(image: Image("empty"), position: 15))
        _tiles = State(initialValue: initialTiles.shuffled())
        _emptyIndex = State(initialValue: tiles.firstIndex(where: { $0.position == 15 }) ?? 15)
    }
    
    func shuffleTiles() {
        tiles.shuffle()
        emptyIndex = tiles.firstIndex(where: { $0.position == 15 }) ?? 15
        isWin = false  // При перемешивании сбрасываем победу
    }
    
    func moveTile(at index: Int) {
        let row = index / 4
        let col = index % 4
        let emptyRow = emptyIndex / 4
        let emptyCol = emptyIndex % 4
        
        let isAdjacent = (row == emptyRow && abs(col - emptyCol) == 1) || (col == emptyCol && abs(row - emptyRow) == 1)
        
        if isAdjacent {
            tiles.swapAt(index, emptyIndex)
            emptyIndex = index
            checkForWin()  // Проверяем на победу после каждого хода
        }
    }
    
    func checkForWin() {
        // Проверка на победу: если все плитки на своих местах
        isWin = tiles.allSatisfy { $0.position == tiles.firstIndex(where: { $0.id == $0.id }) }
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            ZStack {
                if isLandscape {
                    ZStack {
                        HStack {
                            VStack {
                                Image("restartBtn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .padding()
                                    .onTapGesture {
                                        shuffleTiles()
                                    }
                                
                                Image("homeBtn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .padding()
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                            }
                            Spacer()
                        }
                                                
                        // Если победа, показываем WinView
                        if isWin {
                            WinViewLevel4()
                        }
                        
                        
                        if isPad {
                            Image("game4Plate")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 400)
                        } else {
                            Image("game4Plate")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: isPad ? -830 : -400), count: 4), spacing: -15) {
                                ForEach(tiles.indices, id: \.self) { index in
                                    tiles[index].image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .onTapGesture {
                                            moveTile(at: index)
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                    RotateDeviceScreen()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundGame4")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

func sliceImage(originalImage: UIImage?, rows: Int, cols: Int) -> [UIImage] {
    guard let image = originalImage?.cgImage else { return [] }
    let tileWidth = image.width / cols
    let tileHeight = image.height / rows
    var images: [UIImage] = []
    
    for row in 0..<rows {
        for col in 0..<cols {
            if row == rows - 1 && col == cols - 1 { continue } // Пропускаем последнюю ячейку
            if let cropped = image.cropping(to: CGRect(x: col * tileWidth, y: row * tileHeight, width: tileWidth, height: tileHeight)) {
                images.append(UIImage(cgImage: cropped))
            }
        }
    }
    return images
}


struct WinViewLevel4: View {
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
                    currentLevel = 1
                    starscore += 3
                    coinscore += 10
                    NavGuard.shared.currentScreen = .MENU
                }
            
        }
    }
}

struct LoseViewLevel4: View {
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
    Game4()
}
