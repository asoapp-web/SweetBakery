import SwiftUI

struct Onboarding: View {
    
    @AppStorage("seenOnboarding") var seenOnboarding: Bool = false
    
    @State var index: Int = 0
    
    let bg: [String] = [
        "csscWV", "rETAWd", "HoOrDC"
    ]
    
    let character: [String] = [
        "NmlUZy", "TXmfon", "dyBBuw"
    ]
    
    let titles: [String] = [
        "Cook, Learn & Have Fun!",
        "Discover Tasty Adventures!",
        "Bake Something Magical!"
    ]
    
    let descriptions: [String] = [
        "Simple recipes you can make step by step.",
        "Easy recipes your little chef will love.",
        "Colorful, fun, kid-friendly recipes."
    ]
    
    var body: some View {
        VStack(spacing: 24){
            Spacer()
            VStack(spacing: 0){
                Image(character[index])
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                Image("XZSLOn")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Text(titles[index].uppercased())
                                .font(.londrina(.regular, size: 34))
                                .foregroundStyle(Color(hex: "#A00056"))
                            Text(descriptions[index].uppercased())
                                .font(.londrina(.regular, size: 28))
                                .foregroundStyle(.white)
                        }
                        .padding(.all, 18)
                        .multilineTextAlignment(.center)
                    }
            }
            .padding(.horizontal, 24)
            Button {
                if index < 2 {
                    index += 1
                }else{
                    seenOnboarding = true
                }
            } label: {
                CustomButton(text: "NEXT")
            }
            Spacer()
        }
        .background {
            Image(bg[index])
                .resizable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Onboarding()
}
