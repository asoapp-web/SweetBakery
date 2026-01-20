import SwiftUI

struct QuizSelection: View {
    var body: some View {
        VStack {
            NavigationBar(title: "QUIZ")
            Spacer()
            VStack(spacing: 0){
                Image("dyBBuw")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 48)
                VStack {
                    Text("Choose a quiz topic".uppercased())
                        .font(.londrina(.regular, size: 28))
                        .foregroundStyle(.white)
                    NavigationLink {
                        Quiz(topic: .ingredients)
                    } label: {
                        CustomButton(text: "INGREDIENTS", maxWidth: true)
                    }
                    NavigationLink {
                        Quiz(topic: .kitchenTools)
                    } label: {
                        CustomButton(text: "KITCHEN TOOLS", maxWidth: true)
                    }
                    NavigationLink {
                        Quiz(topic: .baking)
                    } label: {
                        CustomButton(text: "BAKING", maxWidth: true)
                    }
                }
                .padding(.top, 48)
                .padding(.bottom, 24)
                .frame(height: 400)
                .multilineTextAlignment(.center)
                .background {
                    Image("XZSLOn")
                        .resizable()
                }
            }
            
        }
        .padding()
        .background {
            Image("HoOrDC")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    QuizSelection()
}
