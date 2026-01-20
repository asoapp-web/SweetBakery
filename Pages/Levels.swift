import SwiftUI

struct Levels: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            NavigationBar(title: "levels")
            
            Spacer()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(1...9, id: \.self) { index in
                    NavigationLink {
                        Game(level: index)
                            .navigationBarBackButtonHidden()
                    } label: {
                        VStack(spacing: 0){
                            Text("\(index)")
                                .font(.londrina(.black, size: 48))
                                .foregroundStyle(.white)
                                .padding(.top, 12)
                            Image("dLszWv")
                                .resizable()
                                .scaledToFit()
                        }
                        .background {
                            Image("gQwBcU")
                                .resizable()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background {
            Image("csscWV")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Levels()
}
