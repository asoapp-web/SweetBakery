import Foundation
import SwiftUI
import UIKit

class SweetProfilePhotoManager: ObservableObject {
    static let shared = SweetProfilePhotoManager()
    
    @Published var sweetProfilePhoto: UIImage? = nil
    
    private let sweetPhotoKey = "sweet_profile_photo_v1"
    
    private init() {
        sweetLoadPhoto()
    }
    
    func sweetSavePhoto(_ image: UIImage) {
        guard let sweetImageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        UserDefaults.standard.set(sweetImageData, forKey: sweetPhotoKey)
        sweetProfilePhoto = image
    }
    
    func sweetLoadPhoto() {
        guard let sweetImageData = UserDefaults.standard.data(forKey: sweetPhotoKey),
              let sweetImage = UIImage(data: sweetImageData) else {
            sweetProfilePhoto = nil
            return
        }
        
        sweetProfilePhoto = sweetImage
    }
    
    func sweetDeletePhoto() {
        UserDefaults.standard.removeObject(forKey: sweetPhotoKey)
        sweetProfilePhoto = nil
    }
}
