//
//  Constants.swift
//  CIASMovie
//
//  Created by Albert on 23/05/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import Foundation

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let K_ONE_PIXEL = 1/UIScreen.main.scale

class Constants:NSObject {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let isIphone5: Bool = {
        return UIScreen.main.bounds.width == 320
    }()
    static let launch3rdSDK: Bool = {
        var tem = true
        #if DEBUG
            tem = false
        #endif
        return tem
    }()
    static var isConnected: Bool = true
    
    static var isShowBackBtn: Bool = false
    
    static let screenWidthRate = {
        return UIScreen.main.bounds.width/375.0 > 1.0 ? 1.0 : UIScreen.main.bounds.width/375.0
    }()
    static let screenHeightRate = {
        return UIScreen.main.bounds.height/667.0 > 1.0 ? 1.0 : UIScreen.main.bounds.height/667.0
    }()
    
    static var isAuthorized: Bool {
        get {
            return !DataEngine.shared().isAuthorizeExpired()
        }
        
        set{
            
        }
    }
    static var isHidAnimation = false
    static var segmentIndex = 1
    static var rootNav:UINavigationController?
    static var idfaUrl:NSString = ""
    static var tmpView:UIView = {
        let vi = UIView(frame: UIScreen.main.bounds)
        vi.backgroundColor = UIColor.white
        return vi
    }()
    
    static var payOrderType: PayOrderType = .none
}


@objc public enum  PayOrderType: Int, RawRepresentable {
    case alipay
    case openCard
    case chargeCard
    case none
    
    
    public var rawValue: Int {
        switch self {
        case .alipay:
            return 1
        case .openCard:
            return 2
        case .chargeCard:
            return 3
        case .none:
            return 0
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case 1:
            self = .alipay
        case 2:
            self = .openCard
        case 3:
            self = .chargeCard
        case 0:
            self = .none
        default:
            self = .none
        }
    }
    
}
