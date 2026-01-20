import SwiftUI
@preconcurrency import WebKit

struct SweetDisplayView: View {
    @StateObject private var sweetFlowController = SweetFlowController.shared
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SweetWebView(
                    sweetUrl: sweetFlowController.sweetCachedEndpoint ?? "",
                    sweetOnURLUpdate: { sweetNewURL in
                        sweetFlowController.sweetUpdateURL(sweetNewURL)
                    }
                )
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

struct SweetWebView: UIViewRepresentable {
    let sweetUrl: String
    let sweetOnURLUpdate: (String) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let sweetConfig = WKWebViewConfiguration()
        let sweetPreferences = WKWebpagePreferences()
        sweetPreferences.allowsContentJavaScript = true
        sweetConfig.defaultWebpagePreferences = sweetPreferences
        
        sweetConfig.allowsInlineMediaPlayback = true
        sweetConfig.mediaTypesRequiringUserActionForPlayback = []
        sweetConfig.allowsAirPlayForMediaPlayback = true
        sweetConfig.allowsPictureInPictureMediaPlayback = true
        
        sweetConfig.websiteDataStore = WKWebsiteDataStore.default()
        
        let sweetWebView = WKWebView(frame: .zero, configuration: sweetConfig)
        sweetWebView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
        sweetWebView.scrollView.backgroundColor = .black
        sweetWebView.backgroundColor = .black
        sweetWebView.navigationDelegate = context.coordinator
        sweetWebView.uiDelegate = context.coordinator
        
        sweetWebView.allowsBackForwardNavigationGestures = true
        sweetWebView.scrollView.keyboardDismissMode = .interactive
        sweetWebView.allowsLinkPreview = false
        
        let sweetRefreshControl = UIRefreshControl()
        sweetRefreshControl.tintColor = UIColor.white
        sweetRefreshControl.addTarget(
            context.coordinator,
            action: #selector(SweetCoordinator.sweetHandleRefresh(_:)),
            for: .valueChanged
        )
        sweetWebView.scrollView.refreshControl = sweetRefreshControl
        sweetWebView.scrollView.bounces = true
        
        context.coordinator.sweetRefreshControl = sweetRefreshControl
        
        if let sweetCookieData = UserDefaults.standard.array(forKey: "sweet_saved_cookies_v1") as? [Data] {
            for sweetCookieDataItem in sweetCookieData {
                if let sweetCookie = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(sweetCookieDataItem) as? HTTPCookie {
                    WKWebsiteDataStore.default().httpCookieStore.setCookie(sweetCookie)
                }
            }
        }
        
        if !sweetUrl.isEmpty, let sweetWebURL = URL(string: sweetUrl) {
            let sweetRequest = URLRequest(url: sweetWebURL)
            sweetWebView.load(sweetRequest)
        }
        
        return sweetWebView
    }
    
    func updateUIView(_ sweetUiView: WKWebView, context: Context) {
        if !sweetUrl.isEmpty {
            let sweetCurrentURLString = sweetUiView.url?.absoluteString ?? ""
            if sweetCurrentURLString != sweetUrl {
                print("🔄 [SweetWebView] URL changed from '\(sweetCurrentURLString)' to '\(sweetUrl)' - reloading")
                if let sweetWebURL = URL(string: sweetUrl) {
                    let sweetRequest = URLRequest(url: sweetWebURL)
                    sweetUiView.load(sweetRequest)
                }
            }
        }
    }
    
    func makeCoordinator() -> SweetCoordinator {
        SweetCoordinator(self)
    }
    
    class SweetCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let sweetParent: SweetWebView
        private weak var sweetWebView: WKWebView?
        weak var sweetRefreshControl: UIRefreshControl?
        
        init(_ sweetParent: SweetWebView) {
            self.sweetParent = sweetParent
            super.init()
        }
        
        @objc func sweetHandleRefresh(_ sweetRefreshControl: UIRefreshControl) {
            sweetWebView?.reload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sweetRefreshControl.endRefreshing()
            }
        }
        
        func webView(_ sweetWebView: WKWebView, didStartProvisionalNavigation sweetNavigation: WKNavigation!) {
            self.sweetWebView = sweetWebView
        }
        
        func webView(_ sweetWebView: WKWebView, didFinish sweetNavigation: WKNavigation!) {
            sweetRefreshControl?.endRefreshing()
            
            if let sweetCurrentURL = sweetWebView.url?.absoluteString {
                sweetParent.sweetOnURLUpdate(sweetCurrentURL)
            }
            
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { sweetCookies in
                let sweetCookieData = sweetCookies.compactMap {
                    try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: false)
                }
                UserDefaults.standard.set(sweetCookieData, forKey: "sweet_saved_cookies_v1")
            }
        }
        
        func webView(_ sweetWebView: WKWebView, didFail sweetNavigation: WKNavigation!, withError sweetError: Error) {
            sweetRefreshControl?.endRefreshing()
        }
        
        func webView(_ sweetWebView: WKWebView, decidePolicyFor sweetNavigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let sweetUrl = sweetNavigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            let sweetScheme = sweetUrl.scheme?.lowercased() ?? ""
            
            if sweetScheme != "http" && sweetScheme != "https" {
                print("🔗 [SweetWebView] Opening external URL: \(sweetUrl)")
                UIApplication.shared.open(sweetUrl)
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ sweetWebView: WKWebView, createWebViewWith sweetConfiguration: WKWebViewConfiguration, for sweetNavigationAction: WKNavigationAction, windowFeatures sweetWindowFeatures: WKWindowFeatures) -> WKWebView? {
            if let sweetUrl = sweetNavigationAction.request.url {
                sweetWebView.load(URLRequest(url: sweetUrl))
            }
            return nil
        }
        
        func webView(_ sweetWebView: WKWebView, runJavaScriptAlertPanelWithMessage sweetMessage: String, initiatedByFrame sweetFrame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            let sweetAlert = UIAlertController(title: nil, message: sweetMessage, preferredStyle: .alert)
            sweetAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler()
            })
            
            if let sweetWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sweetWindow = sweetWindowScene.windows.first {
                sweetWindow.rootViewController?.present(sweetAlert, animated: true)
            }
        }
        
        func webView(_ sweetWebView: WKWebView, runJavaScriptConfirmPanelWithMessage sweetMessage: String, initiatedByFrame sweetFrame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            let sweetAlert = UIAlertController(title: nil, message: sweetMessage, preferredStyle: .alert)
            sweetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            sweetAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler(true)
            })
            
            if let sweetWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sweetWindow = sweetWindowScene.windows.first {
                sweetWindow.rootViewController?.present(sweetAlert, animated: true)
            }
        }
    }
}
