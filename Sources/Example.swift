//
//  File.swift
//  
//
//  Created by Super on 2024/3/26.
//

import Foundation
import TBAUtil

extension Request: TBARequest {
    static func preloadPool() {
        ReachabilityUtil.shared.startMonitoring()
        Request.url = "https://xxxxxx"
        // 国家枚举映射字段名称
        Request.osString = "talcum"
        // 是否限制追踪 枚举映射字段名称
        Request.att = [true: "jeopard", false: "ferguson"]
        // mil sec key name
        Request.milKeyNames = ["foist"]
        // sec key name
        Request.secKeyNames = ["foist"]
        // id key name
        Request.idKeyNames = ["extremum"]
        // cloak.url
        Request.cloakUrl = "https://www.ddxx.com"
        // cloak go key name
        Request.cloakGoName = "roundoff"
        // cloak param
        var cloakParams: [String: Any] = [:]
        params["thai"] = Request.parametersPool()["distinct_id"]
        params["foist"] = Request.parametersPool()["client_ts"]
        params["bun"] = Request.parametersPool()["device_model"]
        params["psych"] = Request.parametersPool()["bundle_id"]
        params["deceive"] = Request.parametersPool()["os_version"]
        params["waveform"] = Request.parametersPool()["idfv"]
        params["govern"] = ""
        params["cackle"] = ""
        params["hide"] = Request.parametersPool()["os"]
        params["quaver"] =  Request.parametersPool()["idfa"]
        params["madonna"] = Request.parametersPool()["app_version"]
        Request.cloakParam = cloakParams
        
        
        // 公共参数
        var parameters: [String: Any] = [:]
        var wylie: [String: Any] = [:]
        var inhale:  [String: Any] = [:]
        var  winnetka: [String: Any] = [:]
        winnetka["scripps"] = Request.parametersPool()["manufacturer"]
        winnetka["extremum"] = Request.parametersPool()["log_id"]
        winnetka["censure"] = Request.parametersPool()["brand"]
        winnetka["waveform"] = Request.parametersPool()["idfv"]

        wylie["goggle"] = Request.parametersPool()["operator"]
        wylie["canna"] = Request.parametersPool()["channel"]
        wylie["madonna"] = Request.parametersPool()["app_version"]
        wylie["hide"] = Request.parametersPool()["os"]
        wylie["timex"] = Request.parametersPool()["ip"]
        wylie["bun"] = Request.parametersPool()["device_model"]
        wylie["psych"] = Request.parametersPool()["bundle_id"]
        wylie["buttery"] = Request.parametersPool()["os_country"]
        wylie["clarinet"] = Request.parametersPool()["system_language"]

        inhale["sledge"] = Request.parametersPool()["zone_offset"]
        inhale["deceive"] = Request.parametersPool()["os_version"]
        inhale["foist"] = Request.parametersPool()["client_ts"]
        inhale["govern"] = Request.parametersPool()["gaid"]
        inhale["quaver"] = Request.parametersPool()["idfa"]
        inhale["jazz"] = Request.parametersPool()["network_type"]
        inhale["thai"] = Request.parametersPool()["distinct_id"]

        parameters["wylie"] = wylie
        parameters["inhale"] = inhale
        parameters["winnetka"] = winnetka
// MARK: 全局属性
        parameters["millet"] = ["region": Locale.current.regionCode ?? ""]
        Request.commonParam = parameters
        
        var commonHeader: [String: String] = [:]
        commonHeader["madonna"] = "\(Request.parametersPool()["app_version"] ?? "")"
        commonHeader["canna"] = "\(Request.parametersPool()["channel"] ?? "")"
        commonHeader["waveform"] = "\(Request.parametersPool()["idfv"] ?? "")"
        Request.commonHeader = commonHeader
        
        var commonQuery: [String: String] = [:]
        commonQuery["scripps"] = "\(Request.parametersPool()["manufacturer"] ?? "")"
        commonQuery["madonna"] = "\(Request.parametersPool()["app_version"] ?? "")"
        Request.commonQuery = commonQuery
        
        var installParam: [String: Any] = [:]
        installParam["dynamic"] = Request.parametersPool()["build"]
        installParam["randall"] = Request.parametersPool()["user_agent"]
        installParam["recline"] = Request.parametersPool()["lat"]
        installParam["airmass"] = Request.parametersPool()["referrer_click_timestamp_seconds"]
        installParam["gossip"] = Request.parametersPool()["install_begin_timestamp_seconds"]
        installParam["coliform"] = Request.parametersPool()["referrer_click_timestamp_server_seconds"]
        installParam["fanny"] = Request.parametersPool()["install_begin_timestamp_server_seconds"]
        installParam["gradual"] = Request.parametersPool()["install_first_seconds"]
        installParam["uptake"] = Request.parametersPool()["last_update_seconds"]
        Request.installParam = ["jacobson": installParam]
        
        let sessionParam: [String: Any] = [:]
        Request.sessionParam = ["disperse": sessionParam]
        
        Request.eventParam = ["bessel" : "first_open"]
        
    
    }
    
    static func tbaADRequest(ad: ADBaseModel?) {
        var adParam: [String: Any] = [:]
        adParam["kane"] = Request.parametersPool(ad)["ad_pre_ecpm"]
        adParam["gluten"] = Request.parametersPool(ad)["currency"]
        adParam["mchugh"] = Request.parametersPool(ad)["ad_network"]
        adParam["bay"] = Request.parametersPool(ad)["ad_source"]
        adParam["bode"] = Request.parametersPool(ad)["ad_code_id"]
        adParam["monitor"] = Request.parametersPool(ad)["ad_pos_id"]
        adParam["develop"] = Request.parametersPool(ad)["ad_sense"]
        adParam["hymn"] = Request.parametersPool(ad)["ad_format"]
        adParam["imperil"] = Request.parametersPool(ad)["ad_load_ip"]
        adParam["dortmund"] = Request.parametersPool(ad)["ad_impression_ip"]
        adParam["bessel"] = "budge"
        Request.adParam = adParam
        Request.tbaRequest(key: .ad, ad: nil)
    }
    
    static func tbaEventReequest(eventKey: String = "", value: [String: Any]? = nil) {
        var eventParam: [String: Any] = [:]
        eventParam["bessel"] = eventKey
//MARK: 私有属性
        value?.keys.forEach({ key in
            eventParam["lisa/\(key)"] = value?[key]
        })
        Request.eventParam = eventParam
        Request.tbaRequest(key: .normalEvent, eventKey: eventKey, value: value)
    }
}
