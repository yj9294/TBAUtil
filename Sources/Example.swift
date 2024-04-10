class EventRequest: TBARequest {
    static func preloadPool() {
        ReachabilityUtil.shared.startMonitoring()
        TBACacheUtil.isDebug = AppUtil.isDebug
        Request.url = AppUtil.isDebug ? "https://test-scala.perfectbrowsers.com/robbery/vinegar/margery" : "https://scala.perfectbrowsers.com/iodine/proximal"
        // 国家枚举映射字段名称
        Request.osString = "populism"
        // 是否限制追踪 枚举映射字段名称
        Request.att = [true: "lagging", false: "capstan"]
        // sex key name
        Request.secKeyNames = ["special", "carpet", "sham", "eutectic", "crockett", "per"]
        // min sec key name
        Request.milKeyNames = ["charon"]
        // id key name
        Request.idKeyNames = ["anabel"]
        // cloak.url
        Request.cloakUrl = "https://ye.perfectbrowsers.com/aural/arboreal"
        // cloak go key name
        Request.cloakGoName = "raster"
        // cloak param
        var cloakParams: [String: Any] = [:]
        cloakParams["innate"] = Request.parametersPool()["distinct_id"]
        cloakParams["charon"] = Request.parametersPool()["client_ts"]
        cloakParams["witt"] = Request.parametersPool()["device_model"]
        cloakParams["kabuki"] = Request.parametersPool()["bundle_id"]
        cloakParams["dynast"] = Request.parametersPool()["os_version"]
        cloakParams["fraser"] = Request.parametersPool()["idfv"]
        cloakParams["schiller"] = ""
        cloakParams["nugatory"] = ""
        cloakParams["sus"] = Request.parametersPool()["os"]
        cloakParams["winkle"] =  Request.parametersPool()["idfa"]
        cloakParams["nutshell"] = Request.parametersPool()["app_version"]
        Request.cloakParam = cloakParams
        
        
        // 公共参数
        var parameters: [String: Any] = [:]
        
        var gaseous: [String: Any] = [:]
        gaseous["innate"] = Request.parametersPool()["distinct_id"]
        gaseous["kabuki"] = Request.parametersPool()["bundle_id"]
        gaseous["saran"] = Request.parametersPool()["brand"]
        gaseous["dynast"] = Request.parametersPool()["os_version"]
        parameters["gaseous"] = gaseous
        
        var swelter:  [String: Any] = [:]
        swelter["sus"] = Request.parametersPool()["os"]
        swelter["assault"] = Request.parametersPool()["manufacturer"]
        swelter["airborne"] = Request.parametersPool()["zone_offset"]
        swelter["anabel"] = Request.parametersPool()["log_id"]
        swelter["witt"] = Request.parametersPool()["device_model"]
        swelter["winkle"] = Request.parametersPool()["idfa"]
        swelter["nutshell"] = Request.parametersPool()["app_version"]
        swelter["charon"] = Request.parametersPool()["client_ts"]
        swelter["osborn"] = ""
        swelter["fantasia"] = Request.parametersPool()["os_country"]
        parameters["swelter"] = swelter
        
        var colonel: [String: Any] = [:]
        colonel["blacken"] = Request.parametersPool()["system_language"]
        colonel["pomology"] = Request.parametersPool()["network_type"]
        colonel["fraser"] = Request.parametersPool()["idfv"]
        colonel["julia"] = Request.parametersPool()["channel"]
        colonel["motet"] = Request.parametersPool()["ip"]
        parameters["colonel"] = colonel
        
// MARK: 全局属性
        parameters["sole"] = ["ay_per": Locale.current.regionCode ?? ""]
        Request.commonParam = parameters
        
        var commonHeader: [String: String] = [:]
        commonHeader["winkle"] = "\(Request.parametersPool()["idfa"] ?? "")"
        commonHeader["schiller"] = ""
        commonHeader["charon"] = "\(Request.parametersPool()["client_ts"] ?? "")"
        Request.commonHeader = commonHeader
        
        var commonQuery: [String: String] = [:]
        commonQuery["fantasia"] = "\(Request.parametersPool()["os_country"] ?? "")"
        commonQuery["osborn"] = "\(Request.parametersPool()["operator"] ?? "")"
        commonQuery["schiller"] = "\(Request.parametersPool()["gaid"] ?? "")"
        commonQuery["innate"] = "\(Request.parametersPool()["distinct_id"] ?? "")"
        commonQuery["sus"] = "\(Request.parametersPool()["os"] ?? "")"
        Request.commonQuery = commonQuery
        
        var installParam: [String: Any] = [:]
        installParam["weekend"] = Request.parametersPool()["build"]
        installParam["bequeath"] = Request.parametersPool()["user_agent"]
        installParam["swindle"] = Request.parametersPool()["lat"]
        installParam["special"] = Request.parametersPool()["referrer_click_timestamp_seconds"]
        installParam["carpet"] = Request.parametersPool()["install_begin_timestamp_seconds"]
        installParam["sham"] = Request.parametersPool()["referrer_click_timestamp_server_seconds"]
        installParam["eutectic"] = Request.parametersPool()["install_begin_timestamp_server_seconds"]
        installParam["crockett"] = Request.parametersPool()["install_first_seconds"]
        installParam["per"] = Request.parametersPool()["last_update_seconds"]
        
        installParam["cede"] = "aspect"
        Request.installParam = installParam
        
        var sessionParam: [String: Any] = [:]
        sessionParam["cede"] = "nameable"
        Request.sessionParam = sessionParam
        
        var firstOpenParam: [String: Any] = [:]
        firstOpenParam["cede"] = "first_open"
        Request.firstOpenParam = firstOpenParam
        
    
    }
    
    static func tbaADRequest(ad: GADBaseModel?) {
        var adParam: [String: Any] = [:]
        adParam["etruria"] = Request.parametersPool(ad)["ad_pre_ecpm"]
        adParam["swiss"] = Request.parametersPool(ad)["currency"]
        adParam["virginia"] = Request.parametersPool(ad)["ad_network"]
        adParam["culture"] = Request.parametersPool(ad)["ad_source"]
        adParam["gunsling"] = Request.parametersPool(ad)["ad_code_id"]
        adParam["wipe"] = Request.parametersPool(ad)["ad_pos_id"]
        adParam["turban"] = Request.parametersPool(ad)["ad_sense"]
        adParam["saturate"] = Request.parametersPool(ad)["ad_format"]
        adParam["bawl"] = Request.parametersPool(ad)["ad_load_ip"]
        adParam["ladyfern"] = Request.parametersPool(ad)["ad_impression_ip"]
        adParam["cede"] = "kant"
        Request.adParam = adParam
        Request.tbaRequest(key: .ad, ad: nil)
    }
    
    static func tbaEventReequest(eventKey: String = "", value: [String: Any]? = nil) {
        var eventParam: [String: Any] = [:]
        eventParam["cede"] = eventKey
//MARK: 私有属性
        eventParam[eventKey] = value
        Request.eventParam = eventParam
        Request.tbaRequest(key: .normalEvent, eventKey: eventKey, value: value)
    }
    static func installRequest() {
        Request.tbaRequest(key: .install)
    }
    
    static func sessionRequest() {
        Request.tbaRequest(key: .session)
    }
    
    static func firstOpenRequest() {
        Request.tbaRequest(key: .firstOpen)
    }
    
    static func cloakRequest() {
        Request.requestCloak()
    }
    
    static func eventRequest(_ event: Event, value: [String: Any] = [:]) {
        self.tbaEventReequest(eventKey: event.rawValue, value: value)
    }
 
    enum Event: String {
        case vpnHome = "pobr_1"
        case vpnBack = "pobr_homeback"
        case vpnConnect = "pobr_link"
        case vpnConnectError = "pobr_link1"
        // rot （服务器的 ip）：ip 地址
        case vpnConnectSuccess = "pobr_link2"
        // rot （服务器的 ip）：ip 地址
        case vpnDidConnect = "pobr_link0"
        
        case vpnPermission = "pobr_pm"
        case vpnPermission1 = "pobr_pm2"
        
        case vpnResultConnect = "pobr_re1"
        case vpnResultDisconnect = "pobr_re2"
        
        case vpnResultConnceBack = "pobr_re1_back"
        case vpnResultDisconnectBack = "pobr_re2_back"
        
        // duration
        case vpnDisconnectManual = "pobr_disLink"
        
        case vpnGuide = "pobr_pop"
        case vpnGuideSkip = "pobr_pop0"
        case vpnGuideOk = "pobr_pop1"
    }
}
