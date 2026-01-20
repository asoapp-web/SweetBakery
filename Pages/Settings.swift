import SwiftUI
import StoreKit
import Photos
import AVFoundation

struct Settings: View {
    
    @StateObject private var musicManager = MusicManager.shared
    @StateObject private var sweetPhotoManager = SweetProfilePhotoManager.shared
    @State private var showPrivacy = false
    @State private var showSweetImagePicker = false
    @State private var showSweetImageSourceAlert = false
    @State private var sweetImageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var sweetSelectedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            NavigationBar(title: "Settings")
            
            VStack(alignment: .leading, spacing: 15) {
                Text("PROFILE PHOTO")
                    .font(.londrina(.regular, size: 32))
                    .foregroundStyle(Color(hex: "#4A0D00"))
                
                HStack(spacing: 20) {
                    if let sweetPhoto = sweetPhotoManager.sweetProfilePhoto {
                        Image(uiImage: sweetPhoto)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hex: "#50071C"), lineWidth: 3))
                    } else {
                        Circle()
                            .fill(Color(hex: "#E8DCC4"))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color(hex: "#4A0D00"))
                            )
                            .overlay(Circle().stroke(Color(hex: "#50071C"), lineWidth: 3))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            showSweetImageSourceAlert = true
                        } label: {
                            CustomButton(text: sweetPhotoManager.sweetProfilePhoto != nil ? "CHANGE PHOTO" : "ADD PHOTO", maxWidth: false)
                        }
                        
                        if sweetPhotoManager.sweetProfilePhoto != nil {
                            Button {
                                sweetPhotoManager.sweetDeletePhoto()
                            } label: {
                                Text("DELETE")
                                    .font(.londrina(.regular, size: 18))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("MUSIC")
                    .font(.londrina(.regular, size: 32))
                    .foregroundStyle(Color(hex: "#4A0D00"))
                
                CustomSlider(value: $musicManager.volume)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("INFORMATION")
                    .font(.londrina(.regular, size: 32))
                    .foregroundStyle(Color(hex: "#4A0D00"))
                
                VStack(spacing: 12) {
                    Button {
                        showPrivacy = true
                    } label: {
                        CustomButton(text: "PRIVACY POLICY", maxWidth: true)
                    }
                    
                    Button {
                        requestReview()
                    } label: {
                        CustomButton(text: "RATE US", maxWidth: true)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background {
            Color(hex: "#FEF8E5")
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showPrivacy) {
            SafariView(url: URL(string: "https://www.google.com")!)
        }
        .confirmationDialog("Select Photo Source", isPresented: $showSweetImageSourceAlert, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    sweetRequestCameraPermission()
                }
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                Button("Photo Library") {
                    sweetRequestPhotoLibraryPermission()
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showSweetImagePicker) {
            SweetImagePicker(sweetSelectedImage: $sweetSelectedImage, sweetSourceType: sweetImageSourceType)
        }
        .onChange(of: sweetSelectedImage) { sweetNewImage in
            if let sweetImage = sweetNewImage {
                sweetPhotoManager.sweetSavePhoto(sweetImage)
            }
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func sweetRequestCameraPermission() {
        let sweetAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch sweetAuthStatus {
        case .authorized:
            sweetImageSourceType = .camera
            showSweetImagePicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { sweetGranted in
                DispatchQueue.main.async {
                    if sweetGranted {
                        self.sweetImageSourceType = .camera
                        self.showSweetImagePicker = true
                    }
                }
            }
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func sweetRequestPhotoLibraryPermission() {
        let sweetAuthStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch sweetAuthStatus {
        case .authorized, .limited:
            sweetImageSourceType = .photoLibrary
            showSweetImagePicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { sweetStatus in
                DispatchQueue.main.async {
                    if sweetStatus == .authorized || sweetStatus == .limited {
                        self.sweetImageSourceType = .photoLibrary
                        self.showSweetImagePicker = true
                    }
                }
            }
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background Track
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#E8DCC4"))
                    .frame(height: 30)
                
                // Progress Track
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#50071C"))
                    .frame(width: CGFloat(value) * geometry.size.width, height: 30)
                
                // Thumb
                Circle()
                    .fill(Color(hex: "#50071C"))
                    .frame(width: 45, height: 45)
                    .offset(x: CGFloat(value) * (geometry.size.width - 45))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newValue = Double(gesture.location.x / geometry.size.width)
                                self.value = min(max(0, newValue), 1)
                            }
                    )
            }
        }
        .frame(height: 45)
    }
}

#Preview {
    Settings()
}
