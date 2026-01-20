import SwiftUI
import UIKit

struct SweetImagePicker: UIViewControllerRepresentable {
    @Binding var sweetSelectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    var sweetSourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let sweetPicker = UIImagePickerController()
        sweetPicker.sourceType = sweetSourceType
        sweetPicker.delegate = context.coordinator
        sweetPicker.allowsEditing = true
        return sweetPicker
    }
    
    func updateUIViewController(_ sweetUiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let sweetParent: SweetImagePicker
        
        init(_ sweetParent: SweetImagePicker) {
            self.sweetParent = sweetParent
        }
        
        func imagePickerController(_ sweetPicker: UIImagePickerController, didFinishPickingMediaWithInfo sweetInfo: [UIImagePickerController.InfoKey : Any]) {
            if let sweetEditedImage = sweetInfo[.editedImage] as? UIImage {
                sweetParent.sweetSelectedImage = sweetEditedImage
            } else if let sweetOriginalImage = sweetInfo[.originalImage] as? UIImage {
                sweetParent.sweetSelectedImage = sweetOriginalImage
            }
            
            sweetParent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ sweetPicker: UIImagePickerController) {
            sweetParent.dismiss()
        }
    }
}
