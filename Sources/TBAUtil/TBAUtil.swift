// The Swift Programming Language
// https://docs.swift.org/swift-book

import GADUtil
public protocol TBARequest {
    // 预备工作
    // 1. 设置 请求url
    // 2. 设置部分枚举参数映射
    // 3. 设置公共参数
    // 4. 设置公共头部
    // 5. 设置公共Query
    // 6. 设置全局属性（放到公共参数里面）
    // 7. 设置 session 参数
    // 8. 设置 install 参数
    // 9. 设置 first_open 参数
    static func preloadPool()
    
    // 1. 设置广告事件参数映射
    // 2. 设置广告事件参数格式
    static func tbaADRequest(ad: GADBaseModel?)
    
    // 1. 设置基础打点事件参数映射
    // 2. 甚至基础打点事件格式
    // event key 是确定的事件名称
    // value 是事件参数键值
    // ⚠️ 记得判定 first_open 事件 将api key设置为 first open
    static func tbaEventReequest(eventKey: String , value: [String: Any]?)
}
