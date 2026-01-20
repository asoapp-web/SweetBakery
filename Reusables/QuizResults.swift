import SwiftUI

struct QuizResults: View {
    
    @Environment(\.dismiss) var dismiss
    
    let correctAnswers: Int
    
    let onRestart: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 24){
                HStack {
                    Text("your \n answered".uppercased())
                        .font(.londrina(.black, size: 28))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 36)
                
                Text("\(correctAnswers) questions correctly".uppercased())
                    .multilineTextAlignment(.center)
                    .font(.londrina(.black, size: 42))
                    .foregroundStyle(.white)
                
                VStack(spacing: 6){
                    Button {
                        onRestart()
                    } label: {
                        CustomButton(text: "TRY AGAIN", maxWidth: true)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        CustomButton(text: "MAIN PAGE", maxWidth: true)
                    }
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
                        Image("FZMFim")
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
    QuizResults(correctAnswers: 5, onRestart: {
        
    })
}
