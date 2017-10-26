//
//  KKZRemoteNotificationCenter.swift
//  KoMovie
//
//  Created by Albert on 10/01/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit
import KKZExtension

@objc class KKZRemoteNotificationCenter: NSObject {
    static let sharedInstance = KKZRemoteNotificationCenter()
    
    private var payload:[String:Any]?
    
    /// 收集下通知，当app通过通知打开时
    ///
    /// - Parameter remoteNotification: remote通知
    func collect(_ payload: [String:Any]?){
        self.payload = payload;
    }
    
    private func getURL(_ notify:[String:Any]) -> String? {
        if let info = notify["payload"] as? String, let data = info.data(using: .utf8) {
            
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dic?["url"] as? String
            } catch {
                debugPrint(error.localizedDescription)
                return nil
            }
            
        }else { return nil }
    }
    
    /// 处理通知，当不是通过通知打开app时
    ///
    /// - Parameter remoteNotification: remote通知
    func handle(_ payload: [String:Any]?, showAlert:Bool = true){
        
        guard let notify = payload else {
            return
        }
        
        guard let message = notify["message"] as? String else {
            return
        }
        
        let refreshAlert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let url = notify["url"] as? String {
            
            if showAlert == false {
                UrlOpenUtility.handleOpenAppUrl(URL(string:url))
                self.payload = nil
                return
            }
            
            refreshAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action: UIAlertAction!) in
                //handle URL
                UrlOpenUtility.handleOpenAppUrl(URL(string:url))
            }))
        }
        
        refreshAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
            //dismiss
        }))
        
        UIApplication.shared.keyWindow?.kkz.visibleViewController?.present(refreshAlert, animated: true, completion: nil)
        
        self.payload = nil
    }
    
    /// 检查是否有需要处理的通知
    func checkNotify() {
        
        handle(payload, showAlert:false)
    }
    
    
    
}
