import SwiftUI

struct SweetLoadingView: View {
    @State private var sweetRotationAngle: Double = 0
    @State private var sweetCurrentImageIndex: Int = 0
    @State private var sweetIsRotatingLeft: Bool = true
    @State private var sweetImageOpacity: Double = 1.0
    
    private let sweetImageNames = ["DjcCyc", "FZMFim", "vVEUQd", "ZXoapZ"]
    
    var body: some View {
        ZStack {
            Image("kIQdUC")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Image(sweetImageNames[sweetCurrentImageIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(sweetRotationAngle))
                        .opacity(sweetImageOpacity)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        }
        .onAppear {
            sweetStartRotation()
        }
    }
    
    private func sweetStartRotation() {
        sweetRotateCurrentImage()
    }
    
    private func sweetRotateCurrentImage() {
        let sweetDuration: Double = 2.0
        let sweetTargetAngle = sweetIsRotatingLeft ? -360 : 360
        
        withAnimation(.linear(duration: sweetDuration)) {
            sweetRotationAngle = Double(sweetTargetAngle)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + sweetDuration * 0.7) {
            withAnimation(.easeOut(duration: 0.3)) {
                sweetImageOpacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + sweetDuration) {
            sweetCurrentImageIndex = (sweetCurrentImageIndex + 1) % sweetImageNames.count
            sweetIsRotatingLeft.toggle()
            sweetRotationAngle = 0
            
            withAnimation(.easeIn(duration: 0.3)) {
                sweetImageOpacity = 1.0
            }
            
            sweetRotateCurrentImage()
        }
    }
}
