//
//  TBACacheUtil.swift
//  TraslateNow
//
//  Created by Super on 2024/3/15.
//

import Foundation
import WebKit

public struct FBPrice: Codable {
    public var price: Double
    public var currency: String
}

struct RequestCache: Codable, Identifiable {
    var id: String // 用于请求缓存ID, 唯一
    var key: APIKey
    var eventKey: String // 用于业务区别
    
    var parameter: Data
    var query: String
    var header: [String: String]
    var date = Date()
    
    init(_ id: String, key: APIKey, eventKey: String, req: URLRequest?) {
        self.id = id
        self.eventKey = eventKey
        self.key = key
        parameter = req?.httpBody ?? Data()
        if #available(iOS 16.0, *) {
            query =  req?.url?.query() ?? ""
        } else {
            // Fallback on earlier versions
            if let url = req?.url, let ulrComponenets = URLComponents(url: url , resolvingAgainstBaseURL: false) {
                if let items = ulrComponenets.queryItems {
                    query = items.map({"\($0.name)=\($0.value ??  "")"}).joined(separator: "&")
                } else {
                    query = ""
                }
            } else {
                query = ""
            }
        }
        header = req?.allHTTPHeaderFields ?? [:]
    }
}


public class TBACacheUtil: NSObject {
    public static let shared = TBACacheUtil()
    public static var isDebug = true
    
    var timer: Timer? = nil
    
    // 是否进入过后台 用于冷热启动判定
    var enterBackgrounded = false
    
    @UserDefault(key: "apis")
    private var caches: [RequestCache]?
    
    @UserDefault(key: "first.install")
    private var install: Bool?
    
    @UserDefault(key: "user.agent")
    private var userAgent: String?
    
    @UserDefault(key: "first.open.success.count")
    private var firstOpenSuccessCount: Int?
    @UserDefault(key: "first.open.fail.count")
    private var firstOpenFailCount: Int?
    
    @UserDefault(key: "first.notification")
    private var firstNoti: Bool?
    
    // fb广告价值回传
    @UserDefault(key: "facebook.price")
    var fbPrice: FBPrice?
    
    @UserDefault(key: "user.go")
    public var go: Bool?
    public func getUserGo() -> Bool {
        go ?? false
    }
    
    @UserDefault(key: "uuid")
    private var uuid: String?
    public func getUUID() -> String {
        if let uuid = uuid {
            return uuid
        } else {
            let uuid = UUID().uuidString
            self.uuid = uuid
            return uuid
        }
    }
    @UserDefault(key: "ip")
    private var ip: String?
    public func setIP(_ ip: String) { self.ip = ip }
    public func getIP() -> String { ip ?? "" }
    
    override init() {
        super.init()
        self.timer =  Timer.scheduledTimer(withTimeInterval: 65, repeats: true) { [weak self] timer in
            self?.uploadRequests()
        }
        ReachabilityUtil.shared.networkUpdated = {ret in
            if ret {
                // 网络变化 直接上传
                self.uploadRequests()
            }
        }
    }
    
    
    // MARK - 网络请求失败参数缓存
    func uploadRequests() {
        // 实时清除两天内的缓存
        self.caches = self.caches?.filter({
            $0.date.timeIntervalSinceNow > -2 * 24 * 3600
        })
        // 批量上传
        self.caches?.prefix(25).forEach({
            Request.tbaRequest($0.id, key: $0.key, eventKey: $0.eventKey, retry: false)
        })
    }
    func appendCache(_ cache: RequestCache) {
        if var caches = caches {
            let isContain = caches.contains {
                $0.id == cache.id
            }
            if isContain {
                return
            }
            caches.append(cache)
            self.caches = caches
        } else {
            self.caches = [cache]
        }
    }
    func removeCache(_ id: String) {
        self.caches = self.caches?.filter({
            $0.id != id
        })
    }
    func cache(_ id: String) -> RequestCache? {
        self.caches?.filter({
            $0.id == id
        }).first
    }
    
    func needRequestFirstOpen() -> Bool {
        (firstOpenSuccessCount ?? 0) < 6
    }
    
    func needCacheFirstOpenFail() -> Bool {
        (firstOpenFailCount ?? 0) < 6
    }
    
    func cacheFirstOpen(isSuccess: Bool) {
        if isSuccess {
            firstOpenSuccessCount = (firstOpenSuccessCount ?? 0) + 1
        } else {
            firstOpenFailCount = (firstOpenFailCount ?? 0) + 1
        }
    }
    
    
    
    // 首次判定 关于install first open enterbackground
    func getInstall() -> Bool {
        let ret = install ?? true
        install = false
        return ret
    }
    func getFirstNoti() -> Bool {
        let ret = firstNoti ?? true
        return ret
    }
    func updateFirstNoti() {
        firstNoti = false
    }
    
    
    func enterBackground() {
        enterBackgrounded = true
    }
    
    
    // userAgent
    func getUserAgent() -> String {
        if Thread.isMainThread, self.userAgent == nil {
            self.userAgent = UserAgentFetcher().fetch()
        } else if let userAgent = self.userAgent {
            return userAgent
        }
        return ""
    }
    
    public func needUploadFBPrice() -> (Bool, FBPrice) {
        TBALog("[FB] 当前正在积累广告价值 总价值： \(fbPrice?.price ?? 0) 单位：\(fbPrice?.currency ?? "")")
        if let fbPrice = fbPrice, fbPrice.price > 0.01 {
            TBALog("[FB] 当前广告价值达到要求进行上传 并清空本地 总价值： \(fbPrice.price) 单位：\(fbPrice.currency)")
            self.fbPrice = nil
            return (true, fbPrice)
        }
        return (false, FBPrice(price: 0.0, currency: "USD"))
    }
    
    public func getFBPrice() -> FBPrice {
        fbPrice ?? .init(price: 0, currency: "USD")
    }
    
    public func addFBPrice(price: Double, currency: String) {
        if let fbPrice = fbPrice, fbPrice.currency == currency {
            self.fbPrice = FBPrice(price: fbPrice.price + price, currency: currency)
        } else {
            fbPrice = FBPrice(price: price, currency: currency)
        }
    }
    
}

public final class UserAgentFetcher: NSObject {
    
    private let webView: WKWebView = WKWebView(frame: .zero)
    
    @objc
    public func fetch() -> String {
        dispatchPrecondition(condition: .onQueue(.main))

        var result: String?
        
        webView.evaluateJavaScript("navigator.userAgent") { response, error in
            if error != nil {
                result = ""
                return
            }
            
            result = response as? String ?? ""
        }

        while (result == nil) {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.01))
        }

        return result ?? ""
    }
    
}


@propertyWrapper
public struct UserDefault<T: Codable> {
    public var value: T?
    public let key: String
    public init(key: String) {
        self.key = key
        self.value = UserDefaults.standard.getObject(T.self, forKey: key)
    }
    
    public var wrappedValue: T? {
        set  {
            value = newValue
            UserDefaults.standard.setObject(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        get { value }
    }
}


extension UserDefaults {
    public func setObject<T: Codable>(_ object: T?, forKey key: String) {
        let encoder = JSONEncoder()
        guard let object = object else {
            TBALog("[US] object is nil.")
            if self.object(forKey: key) != nil {
                self.removeObject(forKey: key)
            }
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            TBALog("[US] encoding error.")
            return
        }
        self.setValue(encoded, forKey: key)
    }
    
    public func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            TBALog("[US] data is nil for \(key).")
            return nil
        }
        guard let object = try? JSONDecoder().decode(type, from: data) else {
            TBALog("[US] decoding error.")
            return nil
        }
        return object
    }
}
