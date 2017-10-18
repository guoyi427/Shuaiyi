//
//  EditUserNameViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/6/23.
//  Copyright © 2017年 cias. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift
import SnapKit
import NSURL_QueryDictionary


class EditUserNameViewController: UIViewController {
    
    
    var didFinishCallback: ((_ name:String)->Void)?
    
    fileprivate let _nameTextField = KKZTextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "昵称"
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        hideNavigationBar = false
        
        let rightItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(rightBarButtonAction))
        rightItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: .normal)
        #if K_HENGDIAN
            rightItem.tintColor = UIColor(hex: UIConstants.sharedDataEngine().lumpColor)
//            view.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().lumpColor)
            view.backgroundColor = UIColor(hex: "0xF2F4F5")

        #else
            rightItem.tintColor = UIColor(hex: "0xF3F3F3")
            view.backgroundColor = UIColor(hex: "0xF2F4F5")

        #endif
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        
        let whiteView = UIView(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: 50))
        whiteView.backgroundColor = UIColor.white
        view.addSubview(whiteView)
        
        let userInfo:User = KKZTextUtility.readPersonArrayData() as! User
        
        _nameTextField.font = UIFont.systemFont(ofSize: 15)
        _nameTextField.textColor = UIColor.black
        _nameTextField.contentVerticalAlignment = .center
        _nameTextField.text = userInfo.nickName//这个默认用户设置的昵称
        _nameTextField.clearImage = #imageLiteral(resourceName: "iconfont-shanchu")
        _nameTextField.fieldType = KKZTextFieldWithClear
//        _nameTextField.showKeyboardTopView = false
//        _nameTextField.rightViewHeight = 44
        
        whiteView.addSubview(_nameTextField)
        _nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(whiteView)
            make.right.equalTo(whiteView)
            make.height.equalTo(whiteView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
    }
    
    @objc func rightBarButtonAction() {
        
        _nameTextField.resignFirstResponder()
//        if !self._judgeNameTextRegular() {
//            CIASAlertCancleView().show("温馨提示", message: "只允许：汉字、英文大小写字母、数字", cancleTitle: "好的", callback: nil)
//            return
//        }
        
        let nameLen = (_nameTextField.text?.characters.count)!
        
        if nameLen == 0 {
            CIASAlertCancleView().show("温馨提示", message: "昵称不能为空！", cancleTitle: "好的", callback: nil)
            return
        }
        
        if nameLen > 15 {
            let nickStr = _nameTextField.text
            CIASAlertCancleView().show("温馨提示", message: "请确保字数在15个以内", cancleTitle: "好的", callback: nil)
            //截取字符串
            let rIndex = nickStr?.index((nickStr?.startIndex)!, offsetBy: 15)
            _nameTextField.text = nickStr?.substring(to: rIndex!)
            return
        }
        
        //发送昵称到服务器后，返回
    
        if (self.didFinishCallback != nil) {
            self.didFinishCallback!(_nameTextField.text!)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func _judgeNameTextRegular() -> Bool {
        let pattern = "^[\u{4e00}-\u{9fa5}|\\d|a-z|A-Z]{0,}$|^\\d{0,}$"
        
        var result: Bool = false
        do {
            //如果有异常error有值
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let count = regex.numberOfMatches(in: _nameTextField.text!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: (_nameTextField.text?.characters.count)!))
            
            result = count > 0 ? true:false
            
        } catch {     //通过error拿到异常结果
            print(error)
        }
        
        return result
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
