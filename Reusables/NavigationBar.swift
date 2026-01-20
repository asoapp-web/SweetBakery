import SwiftUI

struct NavigationBar: View {
    
    @Environment(\.dismiss) var dismiss
    
    let title: String
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image("ZZoqaO")
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Text(title.uppercased())
                .font(.londrina(.regular, size: 36))
                .foregroundStyle(Color(hex: "#4A0D00"))
        }
        .frame(height: 50)
    }
}

#Preview {
    NavigationBar(title: "Stories")
}
