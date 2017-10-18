//
//  SettingViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/6/8.
//  Copyright © 2017年 cias. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import NSURL_QueryDictionary

class SettingViewController: UIViewController {
    
    var      cacheView     = UIView()
    var    suggestView     = UIView()
    var    commentView     = UIView()
    var     customView     = UIView()
    var notificateView     = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.topItem?.title = "设置"
        
        #if K_HENGDIAN
            UIApplication.shared.setStatusBarStyle(.default, animated: false)
        #endif
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "设置"
        addSettingView()
    }
    
    
    func addSettingView() {
        var positionY : CGFloat = 0.0
//        if (cacheView.superview != nil) {
//            cacheView.removeFromSuperview()
//        }
        cacheView = viewForSetting(titleLabelStr: "清空缓存", labelStr: String(format: "%.1fM", fileSizeOfCache()), positionY: positionY)
        let cacheViewSingleTap = UITapGestureRecognizer.init(target: self, action:#selector(cacheViewBtnClick))
        cacheView.addGestureRecognizer(cacheViewSingleTap)
        
        positionY += 44
        
//        if suggestView.superview != nil {
//            suggestView.removeFromSuperview()
//        }
        suggestView = viewForSetting(titleLabelStr: "意见反馈", labelStr: "", positionY: positionY)
        let suggestViewSingleTap = UITapGestureRecognizer.init(target: self, action: #selector(suggestViewBtnClick))
        suggestView.addGestureRecognizer(suggestViewSingleTap)
        
        positionY += 44
//        if commentView.superview != nil {
//            commentView.removeFromSuperview()
//        }
        commentView = viewForSetting(titleLabelStr: "给个好评", labelStr: "", positionY: positionY)
        let commentViewSingleTap = UITapGestureRecognizer.init(target: self, action: #selector(commentViewBtnClick))
        commentView.addGestureRecognizer(commentViewSingleTap)
        
        positionY += 44
//        if customView.superview != nil {
//            customView.removeFromSuperview()
//        }
        customView = viewForSetting(titleLabelStr: "拨打客服热线", labelStr: "", positionY: positionY)
        let customViewSingleTap = UITapGestureRecognizer.init(target: self, action: #selector(customViewBtnClick))
        customView.addGestureRecognizer(customViewSingleTap)
        
        positionY += 44
//        if notificateView.superview != nil {
//            notificateView.removeFromSuperview()
//        }
        notificateView = viewForSetting(titleLabelStr: "系统设置", labelStr: "", positionY: positionY)
        let notificateViewSingleTap = UITapGestureRecognizer.init(target: self, action: #selector(notificateViewBtnClick))
        notificateView.addGestureRecognizer(notificateViewSingleTap)
        
        
        let versionLabel = UILabel()
        view.addSubview(versionLabel)
        versionLabel.textAlignment = .center
        if let infoDic = Bundle.main.infoDictionary {
            let version = infoDic["CFBundleShortVersionString"]
            if let _version = version {
                versionLabel.text = "版本号:v\(_version)Beta"
            }
        }
        
        versionLabel.font = UIFont.systemFont(ofSize: 13)
        versionLabel.textColor = UIColor(hex: "0x333333")
        versionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-70)
            make.height.equalTo(20)
        }
        
        let signOutBtn = UIButton.init(type: .custom)
        signOutBtn.setTitle("退出登录", for: .normal)
        signOutBtn.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().btnColor)
        signOutBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnCharacterColor), for: .normal)
        signOutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        if Constants.isAuthorized {
            signOutBtn.isHidden = false
        } else {
            signOutBtn.isHidden = true
        }
        view.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.height.equalTo(50)
        }
        
        signOutBtn.addTarget(self, action: #selector(signOutOfSetting), for: .touchUpInside)
        
    }
    
    @objc func signOutOfSetting() {
        var block : ((Bool)->Void)? = nil
        block = { confirm in
            if confirm {
                Constants.appDelegate.signout()
                self.navigationController?.popViewController(animated: true)
            }
        }
        CIASAlertVIew().show("温馨提示", message: "是否注销账号？", image: nil, cancleTitle: "容朕想想", otherTitle: "果断注销", callback: block)
    }
    
    //MARK: 清理缓存按钮事件
    @objc func cacheViewBtnClick() {
        CIASAlertVIew().show("提示", message: "是否清空缓存？", image: nil, cancleTitle: "取消", otherTitle: "确定") { (confirm) in
            if confirm == true {
                if self.fileSizeOfCache() > 0 {
                    self.clearCache()
                    if (self.cacheView.superview != nil) {
                        self.cacheView.removeFromSuperview()
                    }
                    self.cacheView = self.viewForSetting(titleLabelStr: "清空缓存", labelStr: String(format: "%.1fM", self.fileSizeOfCache()), positionY: 0)
                    let cacheViewSingleTap = UITapGestureRecognizer.init(target: self, action:#selector(self.cacheViewBtnClick))
                    self.cacheView.addGestureRecognizer(cacheViewSingleTap)
                }
            }
        }
    }
    
    //MARK:  意见反馈按钮事件
    @objc func suggestViewBtnClick() {
        let commentVC = CommentViewController()
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    //MARK: 给个好评按钮事件
    @objc func commentViewBtnClick() {
        
        guard kIsHaveJudgement == "1" else {
            CIASAlertCancleView().show("温馨提示", message: "该功能尚未开放", cancleTitle: "知道了", callback: { (confirm) in
            })
            return
        }
        
        var block: ((Bool) -> Void)? = nil
        
        if #available(iOS 10.0, *) {
            block = { confirm in
                if let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=1&sortOrdering=1&id=\(kStoreAppId)"), confirm {
                    
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
                    if let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=1&sortOrdering=1&id=\(kStoreAppId)"), confirm, app.canOpenURL(url) {
                        app.openURL(url)
                        
                    }
                }
            }
        }

        CIASAlertImageView().show("五星鼓励", message: "欢迎给我们评分留言\n告诉我们你用的多爽", image: #imageLiteral(resourceName: "toscore"), cancleTitle: "残忍拒绝", otherTitle: "写个好评", callback: block)
    }
    
    
    //MARK: 拨打客服电话按钮事件
    @objc func customViewBtnClick() {
        CIASAlertVIew().show("提示", message: "确定拨打客服电话吗？", image: nil, cancleTitle: "取消", otherTitle: "确定") { (confirm) in
            if confirm == true {
                self.makePhoneCallWithTel(telNumber: kHotLine)
            }
        }
    }
    
    func makePhoneCallWithTel(telNumber:String) {
        let app = UIApplication.shared
        let url = URL(string: "tel://\(telNumber)")

        if #available(iOS 10.0, *) {
            if app.canOpenURL(url!) {
                app.open(url!, options: [:], completionHandler: nil)
            }
        } else {
            if app.canOpenURL(url!) {
                app.openURL(url!)
            }
        }
    }
    
    //MARK: 系统设置按钮事件
    @objc func notificateViewBtnClick() {
        guard kIsHaveSystemSet == "1" else {
            CIASAlertCancleView().show("温馨提示", message: "该功能尚未开放", cancleTitle: "知道了", callback: { (confirm) in
            })
            return
        }
        
        let app = UIApplication.shared
        let url = URL(string: UIApplicationOpenSettingsURLString)
        
        if #available(iOS 10.0, *) {
            
            if app.canOpenURL(url!) {
                app.open(url!, options: [:], completionHandler: nil)
            }
            
        } else {
            if app.canOpenURL(url!) {
                app.openURL(url!)
            }
        }
    
    }
    
    //MARK: 读取缓存
    func fileSizeOfCache()-> Double {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0.00
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += Double((bcd as AnyObject) as! NSNumber)
                }
            }
        }
        let mm = size / 1024.0 / 1024.0
        return mm
    }
    
    //MARK: 清理缓存
    func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                }
            }
        }
    }
    
    
    func viewForSetting(titleLabelStr:String, labelStr:String, positionY:CGFloat) -> UIView {
        let viewForSet = UIView()
        viewForSet.backgroundColor = UIColor(hex: "0xffffff")
        viewForSet.isUserInteractionEnabled = true
        view.addSubview(viewForSet)
        viewForSet.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view.snp.top).offset(positionY)
            make.height.equalTo(44)
        }
        
        let titleLabelOfSet = UILabel.init()
        viewForSet.addSubview(titleLabelOfSet)
        titleLabelOfSet.font = UIFont.systemFont(ofSize: 13)
        titleLabelOfSet.textColor = UIColor(hex: "0x333333")
        let titleLabelStrSize : CGSize = KKZTextUtility.measureText(titleLabelStr, size: CGSize(width: 500, height: 500), font: UIFont.systemFont(ofSize: 13))
        titleLabelOfSet.text = titleLabelStr
        titleLabelOfSet.snp.makeConstraints { (make) in
            make.left.equalTo(viewForSet.snp.left).offset(15)
            make.top.equalTo(viewForSet.snp.top).offset((44 - titleLabelStrSize.height)/2)
            make.size.equalTo(CGSize(width:  titleLabelStrSize.width + 5, height: titleLabelStrSize.height))
        }
        
        let imageOfSet : UIImage = #imageLiteral(resourceName: "home_more")
        if !labelStr.isEmpty {
            let labelOfSet = UILabel.init()
            viewForSet.addSubview(labelOfSet)
            labelOfSet.font = UIFont.systemFont(ofSize: 13)
            labelOfSet.textColor = UIColor(hex: "0x333333")
            let labelStrSize = KKZTextUtility.measureText(labelStr, size: CGSize(width:500, height:500), font: UIFont.systemFont(ofSize: 13))
            labelOfSet.text = labelStr
            labelOfSet.snp.makeConstraints({ (make) in
                make.top.equalTo(viewForSet.snp.top).offset((44 - titleLabelStrSize.height)/2)
                make.right.equalTo(viewForSet.snp.right).offset(-(9 + imageOfSet.size.width + 15))
                make.size.equalTo(CGSize(width: labelStrSize.width + 6, height: labelStrSize.height))
            })
        }
        
        let imageViewOfSet = UIImageView(image: imageOfSet)
        viewForSet.addSubview(imageViewOfSet)
        imageViewOfSet.contentMode = .scaleAspectFill
        imageViewOfSet.snp.makeConstraints { (make) in
            make.top.equalTo(viewForSet.snp.top).offset((44 - imageOfSet.size.width)/2)
            make.right.equalTo(viewForSet.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: imageOfSet.size.width, height: imageOfSet.size.height))
        }
        
        let lineView = UIView()
        viewForSet.addSubview(lineView)
        lineView.backgroundColor = UIColor(hex: "0xe0e0e0")
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewForSet)
            make.top.equalTo(viewForSet.snp.top).offset(43)
            make.height.equalTo(1)
        }
        
        return viewForSet
    }
    
    
    
}
