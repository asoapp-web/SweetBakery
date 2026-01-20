import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let image: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct Game: View {
    
    let level: Int
    @State private var cards: [Card] = []
    @State private var firstSelectedIndex: Int?
    @State private var secondSelectedIndex: Int?
    @State private var showWon = false
    @State private var levelToLoad: Int = 0
    @Environment(\.dismiss) var dismiss
    
    private let cardImages = ["ejDmhi", "GvkmcD", "rVPDhd", "IKUJmc", "pMzPFy"]
    private let closedCardImage = "FhkEWz"
    
    var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false){
                VStack {
                    NavigationBar(title: "GAME")
                    
                    // GRID
                    VStack {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<cards.count, id: \.self) { index in
                                CardView(card: cards[index])
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            cardTapped(at: index)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.all, 24)
                    .padding(.vertical, 25)
                    .background {
                        Image("MkJAcR")
                            .resizable()
                    }
                    .overlay {
                        VStack {
                            Image("DBmbOK")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .overlay {
                                    Text("LEVEL \(levelToLoad)")
                                        .font(.londrina(.regular, size: 24))
                                        .foregroundStyle(.white)
                                }
                                .offset(y: -25)
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    
                    Spacer()
                }
                .padding()
            }
            .background {
                Image("rETAWd")
                    .resizable()
                    .ignoresSafeArea()
            }
            .onAppear {
                levelToLoad = level
                setupGame()
            }
            
            if showWon {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    Won {
                        withAnimation {
                            levelToLoad += 1
                            setupGame()
                            showWon = false
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(2)
            }
        }
    }
    
    private func setupGame() {
        let pairCount: Int
        if levelToLoad < 4 {
            pairCount = 2 // 2x2
        } else if levelToLoad < 7 {
            pairCount = 3 // 2x3
        } else {
            pairCount = 4 // 2x4
        }
        
        var selectedImages: [String] = []
        let availableImages = cardImages.shuffled()
        for i in 0..<pairCount {
            selectedImages.append(availableImages[i % availableImages.count])
        }
        
        let gameImages = (selectedImages + selectedImages).shuffled()
        cards = gameImages.map { Card(image: $0) }
        firstSelectedIndex = nil
        secondSelectedIndex = nil
    }
    
    private func cardTapped(at index: Int) {
        // Ignore if card is already face up or matched, or if two cards are already being shown
        guard !cards[index].isFaceUp, !cards[index].isMatched, secondSelectedIndex == nil else { return }
        
        cards[index].isFaceUp = true
        
        if let first = firstSelectedIndex {
            secondSelectedIndex = index
            checkForMatch(first: first, second: index)
        } else {
            firstSelectedIndex = index
        }
    }
    
    private func checkForMatch(first: Int, second: Int) {
        if cards[first].image == cards[second].image {
            cards[first].isMatched = true
            cards[second].isMatched = true
            resetSelection()
            checkWinCondition()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    cards[first].isFaceUp = false
                    cards[second].isFaceUp = false
                }
                resetSelection()
            }
        }
    }
    
    private func resetSelection() {
        firstSelectedIndex = nil
        secondSelectedIndex = nil
    }
    
    private func checkWinCondition() {
        if cards.allSatisfy({ $0.isMatched }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showWon = true
                }
            }
        }
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            Image(card.image)
                .resizable()
                .scaledToFit()
                .opacity(card.isFaceUp || card.isMatched ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(card.isFaceUp || card.isMatched ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            
            Image("FhkEWz")
                .resizable()
                .scaledToFit()
                .opacity(card.isFaceUp || card.isMatched ? 0.0 : 1.0)
                .rotation3DEffect(.degrees(card.isFaceUp || card.isMatched ? -180 : 0), axis: (x: 0, y: 1, z: 0))
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: card.isFaceUp)
    }
}

#Preview {
    Game(level: 1)
}
