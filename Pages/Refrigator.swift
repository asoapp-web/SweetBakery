import SwiftUI
internal import Combine

struct Refrigator: View {
    
    @State var refrigatorIsOpen: Bool = false
    @State private var timeRemaining: TimeInterval = 0
    @State private var canUnlock: Bool = false
    @State private var showBonus: Bool = false
    
    @AppStorage("lastUnlockDate") private var lastUnlockDate: Double = 0
    @AppStorage("unlockedRecipes") private var unlockedRecipes: String = "0"
    @State private var newlyUnlockedIndex: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let unlockInterval: TimeInterval = 12 * 60 * 60
    
    var body: some View {
        ZStack {
            VStack(spacing: 24){
                NavigationBar(title: "daily bonus")
                ZStack {
                    Image("qjalOa")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            VStack {
                                if canUnlock {
                                    Button {
                                        unlockRecipe()
                                    } label: {
                                        Text("UNLOCK")
                                            .font(.londrina(.black, size: 30))
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 24)
                                            .background(Color(hex: "#653B3E"))
                                            .foregroundStyle(.white)
                                            .cornerRadius(18)
                                    }
                                } else {
                                    Text(formatTime(timeRemaining))
                                        .font(.londrina(.black, size: 30))
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 24)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color(hex: "#653B3E"), lineWidth: 4)
                                        }
                                        .foregroundStyle(Color(hex: "#653B3E"))
                                }
                                Spacer()
                            }
                            .padding(.top, 64)
                        }
                    
                    Image("kiTZcd")
                        .resizable()
                        .scaledToFit()
                        .rotation3DEffect(
                            .degrees(refrigatorIsOpen ? 100 : 0),
                            axis: (x: 0, y: 1, z: 0),
                            anchor: .trailing,
                            perspective: 0.3
                        )
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: refrigatorIsOpen)

                Button {
                    refrigatorIsOpen.toggle()
                } label: {
                    CustomButton(text: refrigatorIsOpen ? "CLOSE" : "OPEN")
                }
            }
            .padding()
            .background {
                Color(hex: "#FEF8E5")
                    .ignoresSafeArea()
            }
            
            if showBonus {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showBonus = false
                            }
                        }
                    
                    Bonus(recipeIndex: newlyUnlockedIndex)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            if lastUnlockDate == 0 {
                lastUnlockDate = Date().timeIntervalSince1970
            }
            updateTimer()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }
    
    private func updateTimer() {
        let lastDate = Date(timeIntervalSince1970: lastUnlockDate)
        let elapsed = Date().timeIntervalSince(lastDate)
        
        if elapsed >= unlockInterval {
            canUnlock = true
            timeRemaining = 0
        } else {
            canUnlock = false
            timeRemaining = unlockInterval - elapsed
        }
    }
    
    private func unlockRecipe() {
        let unlockedSet = Set(unlockedRecipes.split(separator: ",").compactMap { Int($0) })
        let allIndices = Set(0...5)
        let lockedIndices = allIndices.subtracting(unlockedSet)
        
        if let newIndex = lockedIndices.randomElement() {
            newlyUnlockedIndex = newIndex
            var newUnlockedSet = unlockedSet
            newUnlockedSet.insert(newIndex)
            unlockedRecipes = newUnlockedSet.map { String($0) }.joined(separator: ",")
            
            lastUnlockDate = Date().timeIntervalSince1970
            updateTimer()
            withAnimation {
                showBonus = true
            }
        } else {
            newlyUnlockedIndex = Int.random(in: 0...5)
            lastUnlockDate = Date().timeIntervalSince1970
            updateTimer()
            withAnimation {
                showBonus = true
            }
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    NavigationView {
        Refrigator()
    }
}
