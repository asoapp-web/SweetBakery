import SwiftUI

struct Recipes: View {
    
    @AppStorage("unlockedRecipes") private var unlockedRecipes: String = "0"
    
    let covers: [String] = [
       "qBattd", "quWsNe", "HCSIYk", "tzjZgB", "mfjrea", "daLSfc"
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private var unlockedIndices: Set<Int> {
        Set(unlockedRecipes.split(separator: ",").compactMap { Int($0) })
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                NavigationBar(title: "Recipes")
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<covers.count, id: \.self) { index in
                        let isUnlocked = unlockedIndices.contains(index)
                        
                        ZStack(alignment: .topTrailing) {
                            NavigationLink {
                                if isUnlocked {
                                    Recipe(index: index)
                                        .navigationBarBackButtonHidden()
                                } else {
                                    Refrigator()
                                        .navigationBarBackButtonHidden()
                                }
                            } label: {
                                Image(covers[index])
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .grayscale(isUnlocked ? 0 : 1)
                                    .opacity(isUnlocked ? 1 : 0.6)
                            }
                            
                            if !isUnlocked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            
                            Button {
                                withAnimation {
                                    toggleLock(index: index)
                                }
                            } label: {
                                Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(8)
                                    .background(isUnlocked ? Color.green : Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                            .padding(8)
                        }
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .background {
            Color(hex: "#FEF8E5")
                .ignoresSafeArea()
        }
    }
    
    private func toggleLock(index: Int) {
        var indices = unlockedIndices
        if indices.contains(index) {
            indices.remove(index)
        } else {
            indices.insert(index)
        }
        unlockedRecipes = indices.map { String($0) }.sorted().joined(separator: ",")
    }
}

#Preview {
    NavigationView {
        Recipes()
    }
}
