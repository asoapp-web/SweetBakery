import SwiftUI

struct Bonus: View {
    
    let recipeIndex: Int
    
    let cakes: [String] = [
        "ZXoapZ", "vVEUQd", "DjcCyc", "FZMFim", "ZXoapZ", "vVEUQd" // Added more to match 6 recipes
    ]
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 24){
                HStack {
                    Text("your daily\nbonus".uppercased())
                        .font(.londrina(.black, size: 28))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 24)
                
                Text("+1 recipe".uppercased())
                    .font(.londrina(.black, size: 48))
                    .foregroundStyle(.white)
                
                NavigationLink {
                    Recipes()
                        .navigationBarBackButtonHidden()
                } label: {
                    CustomButton(text: "go to recipes", maxWidth: true)
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 48)
            .background {
                Image("TGyHpw")
                    .resizable()
            }
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Image(cakes[recipeIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    Spacer()
                }
                .offset(x: 25, y: -75)
            }
            .padding(24)
            Spacer()
        }
    }
}

#Preview {
    Bonus(recipeIndex: 0)
}
