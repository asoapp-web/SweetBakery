import SwiftUI

struct CustomButton: View {
    
    let text: String
    var maxWidth: Bool = false
    
    var body: some View {
        ZStack {
            Image("fIyxuA")
                .resizable()
                .scaledToFit()
            Text(text.uppercased())
                .font(.londrina(.black, size: 30))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: maxWidth ? .infinity : 200)
    }
}

#Preview {
    CustomButton(text: "Next", maxWidth: true)
}
