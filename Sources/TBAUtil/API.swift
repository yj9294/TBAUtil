//
//  API.swift
//  TraslateNow
//
//  Created by Super on 2024/3/22.
//

import Foundation
import WebKit
import GADUtil
import AdSupport

extension Request {
    
    public class func tbaRequest(_ id: String = UUID().uuidString, key: APIKey, eventKey: String = APIKey.normalEvent.rawValue, value: [String: Any]? = [:], ad: GADBaseModel? = nil, retry: Bool = true) {
        if key.isInstall {
            if !TBACacheUtil.shared.getInstall(), retry {
                return
            }
            Request.installRequest(id: id) { ret in
                if !ret, retry {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if TBACacheUtil.shared.cache(id) != nil {
                            debugPrint("[tba] 开始重试上报 install 事件")
                            self.tbaRequest(id, key: key, retry: false)
                        }
                    }
                }
            }
        }
        if key.isSession {
            Request.sessionRequest(id: id) { ret in
                if !ret, retry {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if TBACacheUtil.shared.cache(id) != nil {
                            debugPrint("[tba] 开始重试上报 session 事件")
                            self.tbaRequest(id, key: key, retry: false)
                        }
                    }
                }
            }
        }
        if key.isEvent {
            Request.eventequest(id: id, eventKey: eventKey, value: value) { ret in
                if !ret, retry {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if TBACacheUtil.shared.cache(id) != nil {
                            debugPrint("[tba] 开始重试上报 \(eventKey) 事件")
                            self.tbaRequest(id, key: .normalEvent, eventKey: eventKey, value: value, retry: false)
                        }
                    }
                }
            }
        }
        if key.isFirstOpen {
            if TBACacheUtil.shared.cacheOfFirstOpenCount() >= 6 {
                return
            }
            Request.eventequest(id: id, key: .firstOpen) { ret in
                if !ret, retry {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if TBACacheUtil.shared.cache(id) != nil {
                            debugPrint("[tba] 开始重试上报 firstOpen 事件")
                            self.tbaRequest(id, key: key, retry: false)
                        }
                    }
                } else if ret {
                    TBACacheUtil.shared.cacheFirstOpenCount()
                }
            }
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                if TBACacheUtil.shared.cacheOfFirstOpenCount() >= 6 {
                    timer.invalidate()
                    return
                }
                let id = UUID().uuidString
                Request.eventequest(id: id, key: .firstOpen) { ret in
                    if !ret, retry {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            if TBACacheUtil.shared.cache(id) != nil {
                                debugPrint("[tba] 开始重试上报 firstOpen 事件")
                                self.tbaRequest(id, key: key, retry: false)
                            }
                        }
                    } else if ret {
                        TBACacheUtil.shared.cacheFirstOpenCount()
                    }
                }
            }
        }
        if let ad = ad, key.isAD {
            Request.adRequest(id: id, ad: ad) { ret in
                if !ret, retry {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if TBACacheUtil.shared.cache(id) != nil {
                            debugPrint("[tba] 开始重试上报 ad 事件")
                            self.tbaRequest(id, key: key, ad: ad, retry: false)
                        }
                    }
                }
            }
        }
    }

    private class func installRequest(id: String, completion: ((Bool)->Void)? = nil) {
        debugPrint("[tba] 开始上报 install ")
        Request(id: id, parameters: Request.installParam).netWorkConfig { req in
            req.method = .post
            req.key = .install
        }.startRequestSuccess { _ in
            debugPrint("[tba] 上报 install 成功 ✅✅✅")
            completion?(true)
        }.error { obj, code in
            debugPrint("[tba] 上报 install 失败 ❌❌❌")
            completion?(false)
        }
    }
    
    private class func sessionRequest(id: String, completion: ((Bool)->Void)? = nil) {
        debugPrint("[tba] 开始上报 session ")
        Request(id: id, parameters: Request.sessionParam).netWorkConfig { req in
            req.method = .post
            req.key = .session
        }.startRequestSuccess { _ in
            debugPrint("[tba] 上报 session 成功 ✅✅✅")
            completion?(true)
        }.error { obj, code in
            debugPrint("[tba] 上报 session 失败 ❌❌❌")
            completion?(false)
        }
    }
    
    private class func adRequest(id: String, ad: GADBaseModel, completion: ((Bool)->Void)? = nil) {
        debugPrint("[tba] 开始上报 ad ")
        Request(id: id, parameters: Request.adParam).netWorkConfig { req in
            req.method = .post
            req.key = .ad
        }.startRequestSuccess { _ in
            debugPrint("[tba] 上报 ad 成功 ✅✅✅")
            completion?(true)
        }.error { obj, code in
            debugPrint("[tba] 上报 ad 失败 ❌❌❌")
            completion?(false)
        }
    }
    
    private class func eventequest(id: String, key: APIKey = .normalEvent, eventKey: String = APIKey.normalEvent.rawValue, value: [String: Any]? = nil, completion: ((Bool)->Void)? = nil) {
        if key == .normalEvent {
            if value?.isEmpty != false {
                debugPrint("[tba] 开始上报 \(eventKey) param:\(value ?? [:])")
            } else {
                debugPrint("[tba] 开始上报 \(eventKey)")
            }
        } else {
            debugPrint("[tba] 开始上报 \(key) param:\(value ?? [:])")
        }
        Request(id: id, parameters: Request.eventParam).netWorkConfig { req in
            req.method = .post
            req.key = key
            req.eventKey = eventKey
        }.startRequestSuccess { _ in
            if key == .normalEvent {
                debugPrint("[tba] 上报 \(eventKey) 成功 ✅✅✅")
            } else {
                debugPrint("[tba] 上报 \(key) 成功 ✅✅✅")
            }
            completion?(true)
        }.error { obj, code in
            if key == .normalEvent {
                debugPrint("[tba] 上报 \(eventKey) 失败 ❌❌❌")
            } else {
                debugPrint("[tba] 上报 \(key) 失败 ❌❌❌")
            }
            completion?(false)
        }
    }
}

public enum APIKey: String, Codable, Equatable {
    // 安装事件
    case install
    case session
    case ad
    case firstOpen = "first_open"
    case normalEvent
    var isInstall: Bool {
        return self == .install
    }
    var isSession: Bool {
        return self == .session
    }
    var isAD: Bool {
        return self == .ad
    }
    var isFirstOpen: Bool {
        return self == .firstOpen
    }
    var isEvent: Bool {
        return self == .normalEvent
    }
}

