import Foundation

final class SweetDataProcessor {
    
    private static let sweetTransformKey = "SweetBakery_DataTransform_2024_Key!"
    
    static func sweetTransform(_ sweetInput: String) -> String? {
        guard !sweetInput.isEmpty else {
            print("📝 [SweetDataProcessor] Empty input received")
            return nil
        }
        
        let sweetKeyBytes = Array(sweetTransformKey.utf8)
        let sweetInputBytes = Array(sweetInput.utf8)
        var sweetOutputBytes = [UInt8]()
        
        for (sweetIndex, sweetByte) in sweetInputBytes.enumerated() {
            let sweetKeyByte = sweetKeyBytes[sweetIndex % sweetKeyBytes.count]
            sweetOutputBytes.append(sweetByte ^ sweetKeyByte)
        }
        
        let sweetResult = Data(sweetOutputBytes).base64EncodedString()
        print("📝 [SweetDataProcessor] Data transformed, length: \(sweetResult.count)")
        return sweetResult
    }
    
    static func sweetRestore(_ sweetInput: String) -> String? {
        guard let sweetData = Data(base64Encoded: sweetInput) else {
            print("📝 [SweetDataProcessor] Failed to decode input")
            return nil
        }
        
        let sweetKeyBytes = Array(sweetTransformKey.utf8)
        let sweetInputBytes = Array(sweetData)
        var sweetOutputBytes = [UInt8]()
        
        for (sweetIndex, sweetByte) in sweetInputBytes.enumerated() {
            let sweetKeyByte = sweetKeyBytes[sweetIndex % sweetKeyBytes.count]
            sweetOutputBytes.append(sweetByte ^ sweetKeyByte)
        }
        
        guard let sweetResult = String(bytes: sweetOutputBytes, encoding: .utf8) else {
            print("📝 [SweetDataProcessor] Failed to convert bytes to string")
            return nil
        }
        
        print("📝 [SweetDataProcessor] Data restored successfully")
        return sweetResult
    }
}
