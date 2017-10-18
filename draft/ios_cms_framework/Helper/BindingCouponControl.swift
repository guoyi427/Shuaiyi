//
//  BindingCouponControl.swift
//  CIASMovie
//
//  Created by kokozu on 18/08/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import Foundation

class BindingCouponControl: NSObject {
    static let instance: BindingCouponControl = BindingCouponControl()
    
    fileprivate var _backgroundView: UIView?
    fileprivate var _textField: UITextField?
    fileprivate var _errorLabel: UILabel?
    fileprivate var _whiteView: UIView?
    
    fileprivate var _completeClosure: (() -> Void)?
    fileprivate var _orderNo: NSString?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notifi:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func show(orderNo: NSString, complete: @escaping ()->Void) {
        if _backgroundView != nil {
            _backgroundView?.removeFromSuperview()
            _backgroundView = nil
        }
        _completeClosure = complete
        _orderNo = orderNo
        
        _prepareUI()
    }
}

// MARK: - Private - Methods
extension BindingCouponControl {
    fileprivate func _prepareUI() {
        _backgroundView = UIView(frame: UIScreen.main.bounds)
        _backgroundView?.backgroundColor = UIColor.init(white: 0.3, alpha: 0.3)
        UIApplication.shared.keyWindow?.addSubview(_backgroundView!)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundViewAction))
        _backgroundView?.addGestureRecognizer(tapGR)
        
        _whiteView = UIView()
        _whiteView?.backgroundColor = UIColor.white
        _backgroundView?.addSubview(_whiteView!)
        _whiteView?.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(150)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "添加券"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        _whiteView?.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(15)
        }
        
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(#imageLiteral(resourceName: "titlebar_close"), for: .normal)
//        closeButton.setImage(UIImage(named:"titlebar_close"), for:.normal)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        _whiteView?.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        _textField = UITextField()
        _textField?.placeholder = "请输入需要添加的券号"
        _textField?.font = UIFont.systemFont(ofSize: 15)
        _textField?.layer.borderColor = UIColor.colorWithHexString(hex:"#b2b2b2").cgColor
        _textField?.layer.cornerRadius = 4
        _textField?.layer.borderWidth = 1
        _textField?.keyboardType = UIKeyboardType.namePhonePad
        _whiteView?.addSubview(_textField!)
        _textField?.snp.makeConstraints({ (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(33)
        })
        _textField?.becomeFirstResponder()
        
        _errorLabel = UILabel()
        _errorLabel?.textColor = UIColor.red
        _errorLabel?.font = UIFont.systemFont(ofSize: 10)
        _whiteView?.addSubview(_errorLabel!)
        _errorLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(_textField!.snp.bottom).offset(7)
            make.centerX.equalTo(_whiteView!)
        })
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("确定", for: .normal)
        doneButton.setTitleColor(UIColor(hex:UIConstants.sharedDataEngine().btnCharacterColor), for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneButton.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().btnColor)
        _whiteView?.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(44)
        }
    }
}

// MARK: - UIButton - Action
extension BindingCouponControl {
    @objc
    fileprivate func closeButtonAction() {
        guard let textField = _textField else { return }
        textField.resignFirstResponder()
        _backgroundView?.removeFromSuperview()
        _backgroundView = nil
    }
    
    @objc
    fileprivate func doneButtonAction() {
        guard let textField = _textField else { return }
        textField.resignFirstResponder()

//        let length = textField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let length = textField.text?.characters.count

        if length!<=0 {
            CIASAlertCancleView().show("温馨提示", message: "请输入卡券", cancleTitle: "知道了", callback: nil)
            return
        }
        _errorLabel?.text = ""
        
        guard let couponNumber = textField.text else { return }
        
        UIConstants.sharedDataEngine().loadingAnimation()
        CouponRequest().bindCoupon(withOrderCode: _orderNo as String?, cardCouponsRawCode: couponNumber, success: { (coupon) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            if self._completeClosure != nil {
                self._completeClosure!()
            }
            self.closeButtonAction()
        }) { (err) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            guard let error = err as NSError? else { return }
            if let errorText = error.userInfo["kkz.error.message"] as? String {
                self._errorLabel?.text = errorText
                self._textField?.text = ""
            }
        }
    }

    @objc
    fileprivate func tapBackgroundViewAction() {
        guard let textField = _textField else { return }
        textField.resignFirstResponder()
        self.closeButtonAction()
    }
}

// MARK: - NotificationCenter - Action
extension BindingCouponControl {
    
    @objc fileprivate func keyboardDidChangeFrame(notifi: Notification) {
        let keyboardFrame = notifi.userInfo?[UIKeyboardFrameEndUserInfoKey]
        guard let endFrame = keyboardFrame as? CGRect, let whiteView = _whiteView  else { return }
        if whiteView.superview == nil {
            return
        }
        whiteView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(endFrame.minY-ScreenHeight)
        })
        
    }
}
