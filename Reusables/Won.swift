import SwiftUI

struct Won: View {
    
    @Environment(\.dismiss) var dismiss
    
    let nextLevel: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 24){
                HStack {
                    Text("you have won".uppercased())
                        .font(.londrina(.black, size: 28))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 36)
                
                VStack(spacing: 6){
                    Button {
                        nextLevel()
                    } label: {
                        CustomButton(text: "NEXT LEVEL", maxWidth: true)
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
                        Image("ZXoapZ")
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
    Won {
        
    }
}
