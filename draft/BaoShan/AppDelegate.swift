//
//  AppDelegate.swift
//  CIASMovie
//
//  Created by Albert on 23/05/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit
import Bugly
import AFNetworking
import UserNotifications
import SDWebImage
import NetCore_KKZ.KKZBaseRequestParams

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootNav: NavigationController!
    var homeTabView: HomeTabViewController?
    var loginView: LoginCenterView?
    var countNum = 0
    
    let publicObject = CIASPublicUtility.sharedEngine()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        K_REQUEST_ENC_SALT = NSMutableString(string: kKsspKey)
        Bugly.start(withAppId: BuglyAppId)
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        UIConstants.sharedDataEngine()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        var rootCtr:UIViewController?
        
//        #if K_HENGDIAN
//            let ctr = SplashViewController()
//            ctr.dismissCallback({
//                // start home VC
//                self.startHomeViewController()
//            })
//            
//            rootCtr = ctr
//        #else
            let userDefaults = UserDefaults.standard
            if (userDefaults.object(forKey: kIsFirstLaunch) == nil) {
                
                let dic = userDefaults.dictionaryRepresentation()
                dic.keys.forEach{
                    userDefaults.removeObject(forKey: $0)
                }
                
                userDefaults.synchronize()
                
                signout()
                
                userDefaults.set("1", forKey: kIsFirstLaunch)
                
                userDefaults.synchronize()
                
                let ctr = GuideViewController()
                ctr.dismissCallback({
                    // start home VC
                    self.startHomeViewController()
                })
                
                rootCtr = ctr
            } else {
                let ctr = SplashViewController()
                ctr.dismissCallback({
                    // start home VC
                    self.startHomeViewController()
                })
                
                rootCtr = ctr
            }
//        #endif
        
        
        rootNav = NavigationController(rootViewController: rootCtr!)
        window?.rootViewController = rootNav
        Constants.rootNav = rootNav
        
        window?.makeKeyAndVisible()
        
        publicObject?.applyThirdPartySDK()
        
        initBaiduMapManger()
        
        initWXApi()
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        parse(url: url)
     
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        parse(url: url)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        parse(url: url)
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        publicObject?.checkAppUpdate()
        LocationEngine.shared().start()
    }
    
    func startHomeViewController() {
        let homeVC = HomeTabViewController()
        rootNav = NavigationController(rootViewController: homeVC)
        homeTabView = homeVC
        window?.rootViewController = rootNav
        window?.makeKeyAndVisible()
        
        publicObject?.checkAppUpdate()
        LocationEngine.shared().start()
        
//        //设置宝山单影院信息
//        defaultSetup()
        
        //每次启动后请求广告，避免覆盖上一次广告
        requestAD()
        
        //MARK: 获取 iOS webview默认的UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
        let userAgent : String = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")!
        let customUserAgent : String = userAgent.appending(" zdwx_ios_xingyi")
        UserDefaults.standard.register(defaults: ["UserAgent": customUserAgent])
        
        if isAllowedNotification() == false {
            
            var block: ((Bool) -> Void)? = nil
            
            if #available(iOS 10.0, *) {
                block = { confirm in
                    if let url = URL(string: UIApplicationOpenSettingsURLString), confirm {
                        
                        let app = UIApplication.shared
                        if app.canOpenURL(url) {
                            app.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            } else {
                block = { confirm in
                    if confirm {
                        let app = UIApplication.shared
                        if let url = URL(string: "prefs:root=NOTIFICATIONS_ID&path=\(String(describing: Bundle.main.bundleIdentifier))"), confirm, app.canOpenURL(url) {
                            app.openURL(url)
                            
                        }
                    }
                }
            }
            
            CIASAlertImageView().show("开启消息推送通知", message: "放映前，及时给你观影提醒\n有活动，优先给你推送消息", image: #imageLiteral(resourceName: "openpush"), cancleTitle: "以后再说", otherTitle: "马上开启", callback: block)
        }
    }
    
    func isAllowedNotification() -> Bool{
        let setting = UIApplication.shared.currentUserNotificationSettings
        return setting?.types == .none ? false : true
    }
    
    
    func setHomeSelectedTab(atIndex:Int)  {
        homeTabView?.setSelectedTabAt(atIndex)
    }
    
    
    func loginIn()  {
        
        guard Constants.isAuthorized == false else {
            return
        }
        /*
        if (self.loginView != nil), ((self.loginView?.superview) != nil)  {
            self.loginView?.removeFromSuperview()
        }else {
            self.loginView = LoginCenterView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), withIsCancelView: true, delegate: nil)
        }
        UIApplication.shared.keyWindow?.addSubview(self.loginView!)
         */
        
        let vc = LoginViewController()
        let naviC = NavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController?.present(naviC, animated: true, completion: nil)
    }
    
    func signout() {
        DataEngine.shared().signout()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "handleUserSignOut"), object: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "handleUserSignOutForVipCard"), object: nil)
        
        if let userName = Defaults.name {
            do {
                try SFHFKeychainUtils.deleteItem(forUsername: userName, andServiceName: kKeyChainServiceName)
            } catch {
                
            }
            
        }
    }
    
}


// MARK: - BaiDuMap
extension AppDelegate : BMKGeneralDelegate{
    func initBaiduMapManger() {
        let mapManager = BMKMapManager()
        let ret = mapManager.start(BaiduMapKey, generalDelegate: self)
        if ret == false {
            debugPrint("manager start failed!")
        }
    }
    
    func onGetNetworkState(_ iError: Int32) {
        if iError == 0 {
            debugPrint("联网成功")
        }else {
            debugPrint("onGetNetworkState \(iError)")
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if iError == 0 {
            debugPrint("授权成功")
        }else {
            debugPrint("onGetPermissionState \(iError)")
        }
    }
}

//MARK: - WXApi
extension AppDelegate : WXApiDelegate {
    func initWXApi() {
        let ret = WXApi.registerApp(kWeixinKey, enableMTA: false)
        if ret == false {
            debugPrint("WXApi start failed!")
        }
    }
}


// MARK: - Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func handleUmengMessage(launchOption: [UIApplicationLaunchOptionsKey : Any]? = nil) {
        UMessage.start(withAppkey: kUMengKey, launchOptions: launchOption)
        
        UMessage.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            let notiCenter = UNUserNotificationCenter.current()
            
            notiCenter.delegate = self
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            notiCenter.requestAuthorization(options: options, completionHandler: { (granted, err) in
                
            })
            
        }
        
        #if DEBUG
            UMessage.setLogEnabled(true)
        #endif
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.trigger != nil {
            UMessage.didReceiveRemoteNotification(response.notification.request.content.userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.trigger != nil {
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(notification.request.content.userInfo)
        }
        completionHandler([.alert, .badge, .sound])
    }
    
}


// MARK: - parse URL
extension AppDelegate {
    func parse(url: URL) {
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dic) in
            let resultStatus = dic?["resultStatus"] as? String
            let tipMsg = dic?["memo"] as? String
            if let status = Int(resultStatus!) {
                if status == 9000 {
                    
                    switch Constants.payOrderType {
                    case .alipay:
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TaskTypeAliPaySucceedNotification), object: nil)
                    case .chargeCard:
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AliPayChargeSucceedNotification), object: nil)
                    case .openCard:
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AliPayOpencardSucceedNotification), object: nil)
                    default: break
                    }
                    
                } else if let msg = tipMsg {
                    CIASPublicUtility.showAlertView(forTitle: "", message: msg, cancelButton: "知道了")
                }
                
            }
        }
        if kIsHaveWeixinPay == "1" {
            WXApi.handleOpen(url, delegate: self)
        }
    }
    
    // MARK: - WeiXin
    func onResp(_ resp: BaseResp!) {
        var strMsg = ""
        
        switch resp {
        case is SendMessageToWXResp:
            break
        case is SendAuthResp:   //  登录
            switch resp.errCode {
            case WXSuccess.rawValue:
                //  登录成功
                guard let authResp = resp as? SendAuthResp else { return }
                debugPrint("\(authResp)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserAuthSuccess"), object: nil, userInfo: ["code": authResp.code!])
                break
            case WXErrCodeUserCancel.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserAuthCancel"), object: nil)
            case WXErrCodeAuthDeny.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserAuthFail"), object: nil)
            default:
                break
            }
        case is PayResp:    //  支付
            switch resp.errCode {
            case WXSuccess.rawValue:
                switch Constants.payOrderType {
                case .alipay:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: wxpaySucceedNotification), object: nil)
                case .chargeCard:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: wxChargeSucceedNotification), object: nil)
                case .openCard:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: wxpayOpencardSucceedNotification), object: nil)
                default:
                    break
                }
            case WXErrCodeUserCancel.rawValue:
                strMsg = "用户中途取消"
            default:
                strMsg = "支付异常,请稍后再试！"
            }
        default:
            break
        }
        
        if !strMsg.isEmpty {
            CIASPublicUtility.showAlertView(forTitle: "", message: strMsg, cancelButton: "确定")
        }
    }
    
}

// MARK: - 配置
extension AppDelegate {
    func defaultSetup() {
        #if K_BAOSHAN
            Defaults.cinemaID = "2071"
            Defaults.userCity = "321200"
        #endif
    }
}

let K_AD_IMAGE_STAORE_KEY = "K_AD_IMAGE_STAORE_KEY"
// MARK: - 广告
extension AppDelegate {
    
    /// for OC
    ///
    /// - Returns: key for store ad image on disk
    static func keyForAD() -> String {
        return K_AD_IMAGE_STAORE_KEY
    }
    
    /// 本地是否存在广告图片
    ///
    /// - Returns: true：有广告缓存 false：没有
    static func hasADInCache() -> Bool {
//        let image = SDImageCache.shared().imageFromDiskCache(forKey: K_AD_IMAGE_STAORE_KEY)
//        return image != nil
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let videoPath = (cachePath! as NSString).appending("flash.mp4")
        if FileManager.default.fileExists(atPath: videoPath) {
            return true
        }
        
        let picturePath = (cachePath! as NSString).appending("flash.png")
        if FileManager.default.fileExists(atPath: picturePath) {
            return true
        }
        return false
    }
    
    func requestAD() {
        AppConfigureRequest().requestQueryConfigParams(nil, success: { (conf) in
            guard let dic:[String:Any] = conf?.iosLaunchImage as? [String : Any], let url = dic["file0"] as? String else {return}
            
//            self.downloadADImage(url)
            self.downLoadAdData(url)
//            let urlStr = "http://media.komovie.cn/trailer/14866281809125.mp4"
//            self.downLoadAdData(urlStr)
        }, failure: nil)
    }
    
    
    /// 下载广告图片
    ///
    /// - Parameter url: 广告图片url
    func downloadADImage(_ url:String?) {
        guard let url = url, let adURL = URL(string:url) else {
            return
        }
        SDWebImageManager.shared().loadImage(with: adURL, options: .continueInBackground, progress: nil) { (image, data, err, cacheType, finish, url) in
            
            SDImageCache.shared().store(image, forKey: K_AD_IMAGE_STAORE_KEY, toDisk: true, completion: nil)
        }
    }
    
    
    //下载广告，包括视频和图片，缓存在Caches路径下
    func downLoadAdData(_ url:String?) {
        guard let urlStr = url else {
            return
        }
        
        AppConfigureRequest().requestADdata(withUrlStr: urlStr)
        
        
    }
}
