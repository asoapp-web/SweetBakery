import SwiftUI

struct Stories: View {
    
    let covers: [String] = [
       "HGtAIe", "QOxMRj", "mzLtyA", "fgrruK", "erxpPF"
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                NavigationBar(title: "Stories")
                NavigationLink {
                    Story(index: 0)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(covers[0])
                        .resizable()
                        .scaledToFit()
                }
                NavigationLink {
                    Story(index: 1)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(covers[1])
                        .resizable()
                        .scaledToFit()
                }
                NavigationLink {
                    Story(index: 2)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(covers[2])
                        .resizable()
                        .scaledToFit()
                }
                NavigationLink {
                    Story(index: 3)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(covers[3])
                        .resizable()
                        .scaledToFit()
                }
                NavigationLink {
                    Story(index: 4)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(covers[4])
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding()
        }
        .background {
            Color(hex: "#FEF8E5")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationView {
        Stories()
    }
}
