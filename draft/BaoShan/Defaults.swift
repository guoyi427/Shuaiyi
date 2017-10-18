//
//  Defaults.swift
//  CIASMovie
//
//  Created by Albert on 24/05/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import Foundation

extension String {
    static func defaultValue(_ defaultValue:String?, key:String) -> String? {
        
        guard let def = UserDefaults.standard.object(forKey: key) else {
            // default value
            return defaultValue
        }
        return  def as? String
    }
}


class Defaults:NSObject {
    
    static private func get(_ key: String) -> Any? {
        
        return UserDefaults.standard.object(forKey:key)
    }
    
    static private func set(_ key: String, _ value: Any?) {
        
        guard let value = value else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        
        switch value {
        case let bool as Bool:
            UserDefaults.standard.set(bool, forKey: key)
        case let url as URL:
            UserDefaults.standard.set(url, forKey: key)
        case let int as Int:
            UserDefaults.standard.set(int, forKey: key)
        case let float as Float:
            UserDefaults.standard.set(float, forKey: key)
        case let double as Double:
            UserDefaults.standard.set(double, forKey: key)
        default:
            UserDefaults.standard.set(value, forKey: key)
        }
        
    }
    
    
    /// 首次登录
    static var isFirstLaunch: Bool {
        get{
            guard let value = get("user_haslaunched") else {
                // default is true
                return true
            }
            return  value as! Bool
        }
        set{
            
            set("user_haslaunched", newValue)
        }
    }
    
    
    /// 弹框时间
    static var alertTime: Double {
        get{
            guard let value = get("user_alert_time") else {
                // default value
                return -1.0
            }
            return  value as! Double
        }
        set{
            set("user_alert_time", newValue)
        }
    }
    
    /// 用于防止警告连弹
    static var expireAlert: Date? {
        get{
            guard let value = get("expire_alert") else {
                // default value
                return nil
            }
            return  value as? Date
        }
        set{
            set("expire_alert", newValue)
        }
    }
    
    /// 用户注册phoneNum
    static var registerPhone: String? {
        get{
            return String.defaultValue(nil, key: "register_phone")
        }
        set{
            set("register_phone", newValue)
        }
    }
    
    
    /// 用户绑卡phoneNum
    static var bindPhone: String? {
        get{
            return String.defaultValue(nil, key: "bind_phone")
        }
        set{
            set("bind_phone", newValue)
        }
    }
    
    /// 用户注册code
    static var registerCode: String? {
        get{
            return String.defaultValue(nil, key: "register_code")
        }
        set{
            set("register_code", newValue)
        }
    }
    
    
    /// 用户忘记密码code
    static var forgetCode: String? {
        get{
            return String.defaultValue(nil, key: "forget_code")
        }
        set{
            set("forget_code", newValue)
        }
    }
    
    /// 用户忘记密码phoneNum
    static var forgetPhone: String? {
        get{
            return String.defaultValue(nil, key: "forget_phone")
        }
        set{
            set("forget_phone", newValue)
        }
    }
    
    
    /// 用户重置密码code
    static var resetCode: String? {
        get{
            return String.defaultValue(nil, key: "reset_code")
        }
        set{
            set("reset_code", newValue)
        }
    }
    
    /// 用户重置密码phoneNum
    static var resetPhone: String? {
        get{
            return String.defaultValue(nil, key: "reset_phone")
        }
        set{
            set("reset_phone", newValue)
        }
    }
    
    static var name: String? {
        get{
            return String.defaultValue(nil, key: "user_name")
        }
        set{
            set("user_name", newValue)
        }
    }
    
    /// 用户默认城市
    static var userCity: String? {
        get{
            return String.defaultValue(nil, key: "user_city")
        }
        set{
            set("user_city", newValue)
        }
    }
    
    /// 用户默认城市名称
    static var userCityName: String? {
        get{
            return String.defaultValue(nil, key: "user_city_name")
        }
        set{
            set("user_city_name", newValue)
        }
    }
    
    /// 用户绑定会员卡选择城市，单独使用
    static var userBindCity: String? {
        get{
            return String.defaultValue(nil, key: "user_bind_city")
        }
        set{
            set("user_bind_city", newValue)
        }
    }
    
    /// 用户绑定会员卡选择城市名称，单独使用
    static var userBindCityName: String? {
        get{
            return String.defaultValue(nil, key: "user_bind_city_name")
        }
        set{
            set("user_bind_city_name", newValue)
        }
    }
    
    /// 用户的GPS纬度
    static var latitude: Double {
        get{
            guard let value = get("user_latitude") else {
                return -1.0
            }
            return value as! Double
        }
        set{
            set("user_latitude", newValue)
        }
    }
    
    /// 用户的GPS经度
    static var longitude: Double {
        get{
            guard let value = get("user_longitude") else {
                return -1.0
            }
            return value as! Double
        }
        set{
            set("user_longitude", newValue)
        }
    }
    
    
    /// 用户GPS城市
    static var gpsCity: String? {
        get{
            return String.defaultValue(nil, key: "user_gps_city")
        }
        set{
            set("user_gps_city", newValue)
        }
    }
    
    /// 百度地图定位用户的GPS纬度
    static var baiduLatitude: Double {
        get{
            guard let value = get("baidu_user_latitude") else {
                return -1.0
            }
            return value as! Double
        }
        set{
            set("baidu_user_latitude", newValue)
        }
    }
    
    /// 百度地图定位用户的GPS经度
    static var baiduLongitude: Double {
        get{
            guard let value = get("baidu_user_longitude") else {
                return -1.0
            }
            
            return value as! Double
        }
        set{
            set("baidu_user_longitude", newValue)
        }
    }
    
    /// 用户当前位置
    static var currenAddress: String? {
        get{
            return String.defaultValue(nil, key: "user_current_address")
        }
        set{
            set("user_current_address", newValue)
        }
    }
    
    /// 用户默认影院ID
    static var cinemaID: String? {
        get{
            return String.defaultValue(nil, key: "user_cinemaId")
        }
        set{
            set("user_cinemaId", newValue)
        }
    }
    
    /// 宝山用户默认城市
    static var userCity_bs: String? {
        get{
            return String.defaultValue(nil, key: "user_city_bs")
        }
        set{
            set("user_city_bs", newValue)
        }
    }
    
    /// 宝山用户默认影院ID
    static var cinemaID_bs: String? {
        get{
            return String.defaultValue(nil, key: "user_cinemaId_bs")
        }
        set{
            set("user_cinemaId_bs", newValue)
        }
    }
    
    /// 用户绑卡影院ID
    static var bindCinemaID: String? {
        get{
            return String.defaultValue(nil, key: "user_bind_cinemaId")
        }
        
        set{
            set("user_bind_cinemaId", newValue)
        }
    }
    
    /// 用户开卡影院ID
    static var openCinemaID: String? {
        get{
            return String.defaultValue(nil, key: "user_bind_cinemaId")
        }
        set{
            set("user_bind_cinemaId", newValue)
        }
    }
    
    /// 用户默认影院名称
    static var cinemaName: String? {
        get{
            return String.defaultValue(nil, key: "user_cinema_name")
        }
        set{
            set("user_cinema_name", newValue)
        }
    }
    
    /// 用户默认影院地址
    static var cinemaAddress: String? {
        get{
            return String.defaultValue(nil, key: "user_cinema_address")
        }
        set{
            set("user_cinema_address", newValue)
        }
    }
    /// 选择影院的经纬度
    static var cinemaLatitude: Double {
        get{
            guard let value = get("cinema_latitude") else {
                return -1.0
            }
            return value as! Double
        }
        set{
            set("cinema_latitude", newValue)
        }
    }
    static var cinemaLongitude: Double {
        get{
            guard let value = get("cinema_longitude") else {
                return -1.0
            }
            return value as! Double
        }
        set{
            set("cinema_longitude", newValue)
        }
    }
    
    /// 记录设备的唯一标识
    static var tabberLoc: String? {
        get{
            return String.defaultValue(nil, key: "app_tabber_loc")
        }
        set{
            set("app_tabber_loc", newValue)
        }
    }
}
