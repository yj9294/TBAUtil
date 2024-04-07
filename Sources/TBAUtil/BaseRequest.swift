//
//  BaseRequest.swift
//  TraslateNow
//
//  Created by Super on 2024/3/22.
//

import Foundation
import Alamofire
import AdSupport
import UIKit
import GADUtil
import CoreTelephony


let sessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return Session(configuration: configuration)
}()


enum RequestCode : Int {
    case success = 200 //请求成功
    case networkFail = -9999 //网络错误
    case tokenMiss = 401 // token过期
    case tokenExpired = 403 // token过期
    case serverError = 500 // 服务器错误
    case jsonError = 501 // 解析错误
    case unknown = -8888 //未定义
}

/// 请求成功
typealias NetWorkSuccess = (_ obj:Any?) -> Void
/// 网络错误回调
typealias NetWorkError = (_ obj:Any?, _ code:RequestCode) -> Void
/// 主要用于网络请求完成过后停止列表刷新/加载
typealias NetWorkEnd = () -> Void

public class Request {
    public static var cloakUrl: String = ""
    public static var url: String = ""
    public static var osString: String = ""
    public static var att:[Bool:String] = [:]
    public static var idKeyNames: [String] = []
    public static var secKeyNames: [String] = []
    public static var milKeyNames: [String] = []
    public static var cloakGoName: String = ""
    // 公共参数
    public static var commonParam:[String: Any] = [:]
    // 公共头部
    public static var commonHeader: [String: String] = [:]
    // 公共query
    public static var commonQuery: [String: String] = [:]
    // install 参数
    public static var installParam: [String: Any] = [:]
    // ad 参数
    public static var adParam: [String: Any] = [:]
    // session 参数
    public static var sessionParam: [String: Any] = [:]
    // firstOpen 参数
    public static var firstOpenParam: [String: Any] = [:]
    // event 参数
    public static var eventParam: [String: Any] = [:]
    // cloak 参数
    public static var cloakParam: [String: Any] = [:]
    public static func parametersPool(_ ad: GADBaseModel? = nil) -> [String: Any] {
        if osString.isEmpty {
            TBALog("[tba] 请先设置 osString ")
            return [:]
        }
        if att.isEmpty {
            TBALog("[tba] 请先设置 att 枚举")
            return [:]
        }
        return ["manufacturer": "apple",
                "log_id": UUID().uuidString,
                "brand": "apple",
                "idfv": UIDevice.current.identifierForVendor?.uuidString ?? "",
                "operator": "",
                "channel": "AppStore",
                "app_version": (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "",
                "os": Request.osString,
                "ip": TBACacheUtil.shared.getIP(),
                "device_model": UIDevice.current.systemName + UIDevice.current.systemVersion,
                "bundle_id": Bundle.main.bundleIdentifier ?? "",
                "os_country": Locale.current.languageCode ?? "US",
                "system_language": Locale.current.identifier,
                "zone_offset": TimeZone.current.secondsFromGMT() / 3600,
                "os_version": UIDevice.current.systemVersion,
                "client_ts": Int(Date().timeIntervalSince1970 * 1000),
                "gaid": "",
                "idfa":  UIDevice.current.identifierForVendor?.uuidString ?? "",
                "network_type": "wifi",
                "android_id": "",
                "distinct_id": TBACacheUtil.shared.getUUID(),
                "build": "Build/\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "1")",
                "referrer_url": "",
                "install_version": "",
                "user_agent":  TBACacheUtil.shared.getUserAgent(),
                "lat": (ASIdentifierManager.shared().advertisingIdentifier.uuidString == "00000000-0000-0000-0000-000000000000" ? Request.att[true] : Request.att[false]) ?? "",
                "referrer_click_timestamp_seconds": Int(Date().timeIntervalSince1970 * 1000),
                "install_begin_timestamp_seconds": Int(Date().timeIntervalSince1970 * 1000),
                "referrer_click_timestamp_server_seconds": Int(Date().timeIntervalSince1970 * 1000),
                "install_begin_timestamp_server_seconds": Int(Date().timeIntervalSince1970 * 1000),
                "install_first_seconds": Int(Date().timeIntervalSince1970 * 1000),
                "last_update_seconds": Int(Date().timeIntervalSince1970 * 1000),
                
                "ad_pre_ecpm":(ad?.price ?? 0) * 1000000,
                "currency": ad?.currency ?? "USD",
                "ad_network": ad?.network ?? "",
                "ad_source": "admob",
                "ad_code_id": ad?.model?.theAdID ?? "",
                "ad_pos_id": ad?.position.rawValue ?? "",
                "ad_sense": "",
                "ad_format": ad?.position.name ?? "",
                "ad_load_ip": ad?.loadIP ?? "",
                "ad_impression_ip": ad?.impressIP ?? "",
                "ad_sdk_ver": ""
        ]
    }
    
    var method : HTTPMethod = .get
    var timeOut : TimeInterval = 65
    var decoding: Bool = true
    var key: APIKey = .normalEvent // 用于业务上进行区别， 好进行缓存重试
    var eventKey: String = ""
    
    private var parameters : [String:Any]? = nil
    private var success : NetWorkSuccess?
    private var error : NetWorkError?
    private var end : NetWorkEnd?
    private var config : ((_ req:Request) -> Void)?
    private var query: [String: String]?
    private var id: String

    required init(id: String = UUID().uuidString,query: [String: String]? = nil, parameters: [String:Any]? = nil) {
        self.id = id
        self.parameters = parameters
        self.query = query
    }
    
    func netWorkConfig(config:((_ req:Request) -> Void)) -> Self {
        config(self)
        return self
    }
    
    @discardableResult
    func startRequestSuccess(success: NetWorkSuccess?) -> Self {
        self.success = success
        self.startRequest()
        return self
    }
    
    
    @discardableResult
    func end(end:@escaping NetWorkEnd) -> Self {
        self.end = end
        return self
    }

    @discardableResult
    func error(error:@escaping NetWorkError) -> Self {
        self.error = error
        return self
    }
    
    deinit {
        TBALog("[API] request===============deinit")
    }
    
}

// MARK: 请求实现
extension Request {
    private func startRequest() -> Void {
        
        var url = Request.url
        
        var queryDic: [String: String] =  self.query ?? [:]
        if Request.commonQuery.isEmpty {
            TBALog("[tba] 请先配置 公共 query 参数")
            return
        }
        
        var dic: [String: String] = [:]
        deepModifyLogID(in: Request.commonQuery, idKeyNames: Request.idKeyNames, secKeyNames: Request.secKeyNames, milKeyNames: Request.milKeyNames).forEach { k,v in
            dic[k] = v as? String
        }
        queryDic = dic
        query?.forEach({ key, value in
            queryDic[key] = value
        })
        
        if queryDic.count != 0  {
            if let cache = TBACacheUtil.shared.cache(id) {
                url = url + "?" + cache.query
            } else {
                let strings = queryDic.compactMap({ "\($0.key)=\($0.value)" })
                let string = strings.joined(separator: "&")
                url = url + "?" + string
            }
        }
        
        
        var headerDic:[String: String] = [:]
        if Request.commonHeader.isEmpty {
            TBALog("[tba] 请先配置 公共 header 参数")
            return
        }
        if let cache = TBACacheUtil.shared.cache(id) {
            headerDic = cache.header
        } else {
            var dic: [String: String] = [:]
            deepModifyLogID(in: Request.commonHeader, idKeyNames: Request.idKeyNames, secKeyNames: Request.secKeyNames, milKeyNames: Request.milKeyNames).forEach { k,v in
                dic[k] = v as? String
            }
            headerDic = dic
        }
        
        var parameters: [String: Any] = [:]
        // 公共参数
        if Request.commonParam.isEmpty {
            TBALog("[tba] 请先配置 公共 param 参数")
            return
        }
        parameters = deepModifyLogID(in: Request.commonParam, idKeyNames: Request.idKeyNames, secKeyNames: Request.secKeyNames, milKeyNames: Request.milKeyNames)

        if let cache = TBACacheUtil.shared.cache(id) {
            parameters = cache.parameter.json ?? [:]
        } else {
            self.parameters?.forEach({ (key, value) in
                parameters[key] = value
            })
        }
        
        var dataRequest : DataRequest!
        typealias RequestModifier = (inout URLRequest) throws -> Void
        let requestModifier : RequestModifier = { (rq) in
            rq.timeoutInterval = self.timeOut
            if self.method != .get {
                rq.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                rq.httpBody = parameters.data
            }
            TBALog("[API] -----------------------")
            TBALog("[API] 请求地址:\(url)")
            TBALog("[API] 请求参数:\(parameters.jsonString ?? "")")
            TBALog("[API] 请求header:\(headerDic.jsonString ?? "")")
            TBALog("[API] -----------------------")
        }
        
        dataRequest = sessionManager.request(url, method: method, parameters: nil , encoding: JSONEncoding(), headers: HTTPHeaders.init(headerDic), requestModifier: requestModifier)
        TBACacheUtil.shared.removeCache(id)
        dataRequest.responseData { (result: AFDataResponse) in
            guard let code = result.response?.statusCode, code == RequestCode.success.rawValue else {
                
                let retStr = String(data: result.data ?? Data(), encoding: .utf8)
                let code = result.response?.statusCode ?? -9999
                TBALog("[API] ❌❌❌ key:\(self.key) code: \(code) error:\(retStr ?? "")")
                self.handleError(code: code, error: retStr, request: result.request)
                return
            }
            if let data = result.data {
                let retStr = String(data: data, encoding: .utf8) ?? ""
                TBALog("[API] ✅✅✅ key: \(self.key) response \(retStr)")
                self.requestSuccess(retStr)
            } else {
                TBALog("[API] ❌❌❌ event: \(self.key) response data is nil")
                self.handleError(code: RequestCode.serverError.rawValue, error: nil, request: result.request)
            }
        }
        
    }
    
    func deepModifyLogID(in dictionary: [String: Any], idKeyNames: [String], secKeyNames: [String], milKeyNames: [String]) -> [String: Any] {
        var modifiedDict = dictionary
        
        for (key, value) in dictionary {
            if let nestedDict = value as? [String: Any] {
                modifiedDict[key] = deepModifyLogID(in: nestedDict, idKeyNames: idKeyNames, secKeyNames: secKeyNames, milKeyNames: milKeyNames)
            } else if idKeyNames.contains(key) {
                modifiedDict[key] = UUID().uuidString
            } else if milKeyNames.contains(key) {
                modifiedDict[key] = Int(Date().timeIntervalSince1970 * 1000)
            } else if secKeyNames.contains(key) {
                modifiedDict[key] = Int(Date().timeIntervalSince1970)
            }
        }
        
        return modifiedDict
    }
    
    private func requestSuccess(_ str: String) -> Void {
        TBACacheUtil.shared.removeCache(id)
        self.success?(str)
        self.success = nil
        self.end?()
        self.end = nil
    }
    
    
    // MARK: 错误处理
    func handleError(code:Int, error: Any?, request: URLRequest?) -> Void {
        // 通过id进行缓存
        if key.isFirstOpen {
            if TBACacheUtil.shared.needCacheFirstOpenFail() {
                if TBACacheUtil.shared.cache(id) == nil {
                    TBACacheUtil.shared.appendCache(RequestCache(id, key: key, eventKey: eventKey, req: request))
                    TBACacheUtil.shared.cacheFirstOpen(isSuccess: false)
                }
            }
        } else {
            TBACacheUtil.shared.appendCache(RequestCache(id, key: key, eventKey: eventKey, req: request))
        }
        self.error?(error, RequestCode(rawValue: code) ?? .unknown)
        self.end?()
        self.end = nil
    }
    
}

extension Dictionary {
    var jsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
    
    var data: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
    
}

extension Data {
    var json: [String: Any]? {
        guard let json = try? JSONSerialization.jsonObject(with: self) else {
            return nil
        }
        return json as? [String : Any]
    }
}
