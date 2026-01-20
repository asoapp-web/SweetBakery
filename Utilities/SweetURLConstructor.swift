import Foundation

struct SweetURLConstructor {
    
    private static let sweetBaseURL = "https://spaceorb-active.com/t5SGvRsb"
    
    static func sweetBuildURL(
        sweetAppsFlyerUID: String,
        sweetConversionData: [AnyHashable: Any] = [:]
    ) -> String {
        guard var sweetComponents = URLComponents(string: sweetBaseURL) else {
            return sweetBaseURL
        }
        
        var sweetQueryItems: [URLQueryItem] = []
        
        let sweetGadid = sweetExtractValue(from: sweetConversionData, sweetKeys: ["gadid", "af_gadid", "adgroup_id"])
        
        sweetQueryItems.append(URLQueryItem(name: "gadid", value: sweetGadid))
        
        sweetQueryItems.append(URLQueryItem(name: "appsflyerId", value: sweetAppsFlyerUID))
        
        let sweetAfAdId = sweetExtractValue(from: sweetConversionData, sweetKeys: ["af_ad_id", "ad_id", "af_ad"])
        let sweetCampaignId = sweetExtractValue(from: sweetConversionData, sweetKeys: ["campaign_id", "af_campaign_id"])
        let sweetSourceAppId = sweetExtractValue(from: sweetConversionData, sweetKeys: ["source_app_id", "af_source_app_id"])
        let sweetCampaign = sweetExtractValue(from: sweetConversionData, sweetKeys: ["campaign", "c", "af_c"])
        let sweetAfAd = sweetExtractValue(from: sweetConversionData, sweetKeys: ["af_ad", "ad"])
        let sweetAfAdset = sweetExtractValue(from: sweetConversionData, sweetKeys: ["af_adset", "adset"])
        let sweetAfAdsetId = sweetExtractValue(from: sweetConversionData, sweetKeys: ["af_adset_id", "adset_id"])
        let sweetNetwork = sweetExtractValue(from: sweetConversionData, sweetKeys: ["network", "af_network", "media_source", "pid"])
        
        sweetQueryItems.append(URLQueryItem(name: "af_ad_id", value: sweetAfAdId))
        sweetQueryItems.append(URLQueryItem(name: "campaign_id", value: sweetCampaignId))
        sweetQueryItems.append(URLQueryItem(name: "source_app_id", value: sweetSourceAppId))
        sweetQueryItems.append(URLQueryItem(name: "campaign", value: sweetCampaign))
        sweetQueryItems.append(URLQueryItem(name: "af_ad", value: sweetAfAd))
        sweetQueryItems.append(URLQueryItem(name: "af_adset", value: sweetAfAdset))
        sweetQueryItems.append(URLQueryItem(name: "af_adset_id", value: sweetAfAdsetId))
        sweetQueryItems.append(URLQueryItem(name: "network", value: sweetNetwork))
        
        sweetComponents.queryItems = sweetQueryItems
        
        guard let sweetFinalURL = sweetComponents.url?.absoluteString else {
            return sweetBaseURL
        }
        
        print("🔗 [SweetURLConstructor] Built URL with \(sweetQueryItems.count) parameters")
        return sweetFinalURL
    }
    
    private static func sweetExtractValue(from sweetData: [AnyHashable: Any], sweetKeys: [String]) -> String {
        for sweetKey in sweetKeys {
            if let sweetValue = sweetData[sweetKey] {
                let sweetStringValue = String(describing: sweetValue)
                if !sweetStringValue.isEmpty && sweetStringValue != "null" && sweetStringValue != "<null>" {
                    return sweetStringValue
                }
            }
        }
        return ""
    }
}
