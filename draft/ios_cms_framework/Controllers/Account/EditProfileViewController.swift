//
//  EditProfileViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/6/22.
//  Copyright © 2017年 cias. All rights reserved.
//

import UIKit
import SnapKit
import NSURL_QueryDictionary


class EditProfileViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let _whiteView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 230))
    
    lazy var  blurEffectView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: ScreenWidth/2, y: ScreenHeight/2, width: 0, height: 0)
        blurView.backgroundColor = UIColor(hex: "0x333333")
        blurView.alpha = 0.5
        return blurView
    }()
    
    fileprivate var datePickerDate = ""
    
    lazy var datePickView: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = UIColor.white
        tmpView.frame = CGRect(x: 0, y: ScreenHeight - 216 - 44, width: ScreenWidth, height: 216 + 44)
        let btnTitles = ["取消","确定"]
        let selectorList = [#selector(cancelButtonAction), #selector(finishButtonAction)]
        let frameList = [CGRect(x: 15, y: 0, width: 44, height: 44), CGRect(x: ScreenWidth - 44 - 15, y: 0, width: 44, height: 44)]
        for i in 0 ..< 2 {
            let button = UIButton(type: .custom)
            button.frame = frameList[i]
            button.setTitle(btnTitles[i], for: .normal)
            button.setTitleColor(UIColor(hex:"#249cf8"), for: .normal)
            button.addTarget(self, action: selectorList[i], for: .touchUpInside)
            tmpView.addSubview(button)
        }
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y:44, width:ScreenWidth, height:216))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        //默认日期选择控件中的文字是英文，如果想显示中文，则需要将日期选择控件的区域做如下设置
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        datePicker.datePickerMode = .date
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: 0) as Date
        
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(ChangeDate(datePicker:)), for: .valueChanged)
        tmpView.addSubview(datePicker)
        
        return tmpView
    }()
    /// 头像
    fileprivate var _useridLabel = UILabel()
    fileprivate let _userHeadImageView = UIImageView()
    fileprivate var _nickNameLabel = UILabel()
    fileprivate var _sexLabel = UILabel()
    fileprivate var _birthLabel = UILabel()

    fileprivate let Padding: CGFloat = 15

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar = false
        view.backgroundColor = UIColor(hex: "0xeeeeee")
        self.title = "修改资料"
        /*
        let navBar = UIView()
        navBar.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().navigationBarBackgroundColor)
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(64)
        }
        let narTitleLabel = UILabel()
        narTitleLabel.textColor = UIColor(hex: UIConstants.sharedDataEngine().navigationBarTitleColor)
        narTitleLabel.textAlignment = .center
        narTitleLabel.text = "修改资料"
        narTitleLabel.font = UIFont.systemFont(ofSize: 18)
        navBar.addSubview(narTitleLabel)
        narTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(70)
            make.width.equalTo(ScreenWidth-140)
            make.height.equalTo(44)
        }
        */
        _prepareView()
        self._getUserDetailInfo()
        
    }
    
    //MARK: 创建视图
    fileprivate func _prepareView() {
        _whiteView.backgroundColor = UIColor.white
        view.addSubview(_whiteView)
        var lastMaxY: CGFloat = 0
        
        let titles = ["用户ID","头像","昵称","性别","生日"]
        
        //  手势
        let tapGR0 = UITapGestureRecognizer(target: self, action: #selector(tapUserIDGRAction))
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(tapUserHeadGRAction))
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(tapNickNameGRAction))
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(tapSexGRAction))
        let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(tapBirthGRAction))
        let tapGRList = [tapGR0, tapGR1, tapGR2, tapGR3, tapGR4]
        
        
        for index in 0...titles.count-1 {
            var bgFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 44)
            if index == 1 {
                bgFrame.origin.y = lastMaxY
                bgFrame.size.height = 54
            } else {
                bgFrame.origin.y = lastMaxY
                bgFrame.size.height = 44
            }
            
            let bgView = UIView(frame: bgFrame)
            bgView.backgroundColor = UIColor.white
            _whiteView.addSubview(bgView)
            bgView.addGestureRecognizer(tapGRList[index])
            
            let titleLabel = UILabel()
            titleLabel.textColor = UIColor(hex: "0x333333")
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabel.text = titles[index]
            bgView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(bgView).offset(Padding)
                make.centerY.equalTo(bgView)
            }
            
            let arrow = UIImageView(image: #imageLiteral(resourceName: "home_more"))
            if index > 0 {
                //  箭头
                bgView.addSubview(arrow)
                arrow.snp.makeConstraints { (make) in
                    make.centerY.equalTo(bgView)
                    make.right.equalTo(bgView.snp.right).offset(-Padding)
                    make.size.equalTo(CGSize(width: arrow.frame.size.width, height: arrow.frame.size.height))
                }
            }
            
            if index == 1 {
                //  头像视图
                _userHeadImageView.layer.cornerRadius = 18
                _userHeadImageView.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().btnColor)
                _userHeadImageView.layer.masksToBounds = true
                bgView.addSubview(_userHeadImageView)
                _userHeadImageView.snp.makeConstraints { (make) in
                    make.centerY.equalTo(bgView)
                    make.right.equalTo(arrow.snp.left).offset(-Padding)
                    make.size.equalTo(CGSize(width: 36, height: 36))
                }
            } else {
                //  右侧标签
                var rightLabel = UILabel()
                if index == 0 {
                    rightLabel = _useridLabel
                } else if index == 2 {
                    rightLabel = _nickNameLabel
                } else if index == 3 {
                    rightLabel = _sexLabel
                } else if index == 4 {
                    rightLabel = _birthLabel
                }
                rightLabel.textColor = UIColor(hex:"0x999999")
                rightLabel.font = UIFont.systemFont(ofSize: 15)
                bgView.addSubview(rightLabel)
                if index == 0 {
                    rightLabel.snp.makeConstraints({ (make) in
                        make.right.equalTo(bgView.snp.right).offset(-Padding)
                        make.centerY.equalTo(bgView)
                    })
                } else {
                    rightLabel.snp.makeConstraints({ (make) in
                        make.right.equalTo(arrow.snp.left).offset(-Padding)
                        make.centerY.equalTo(bgView)
                    })
                }
            }
            
            if index < 4 {
                //  分割线
                let grayLine = UIView(frame: CGRect(x: Padding, y: bgView.bounds.height-0.5,
                                                    width: UIScreen.main.bounds.width, height: 1))
                grayLine.backgroundColor = UIColor(hex: "0xeeeeee")
                bgView.addSubview(grayLine)
                lastMaxY = bgView.frame.maxY
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if K_HENGDIAN
            UIApplication.shared.setStatusBarStyle(.default, animated: false)
        #endif

    }
    
    //MARK: 用户ID点击事件，不响应即可
    @objc fileprivate func tapUserIDGRAction() {
        
    }
    
    //MARK: 头像点击事件
    @objc fileprivate func tapUserHeadGRAction() {
        let cameraAction = UIAlertAction(title: "相机", style: .default) { (action) in
            self.judgeCameraAuthorCallback({ (auth) in
                if auth {
                    let pickerController = UIImagePickerController()
                    pickerController.delegate = self
                    pickerController.sourceType = .camera
                    self.present(pickerController, animated: true, completion: nil)
                }
            })
        }
        let photoLibrayAction = UIAlertAction(title: "从相册中选择", style: .default) { (action) in
            self.judgeAssetLibraryAuthorCallback({ (auth) in
                if auth {
                    let pickerController = UIImagePickerController()
                    pickerController.sourceType = .photoLibrary
                    pickerController.delegate = self
                    self.present(pickerController, animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibrayAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: 昵称点击事件
    @objc fileprivate func tapNickNameGRAction() {
        let nickName = EditUserNameViewController()
        navigationController?.pushViewController(nickName, animated: true)
        nickName.didFinishCallback = {
            name in
            self._nickNameLabel.text = name
            self._updateUserOtherInfo(para: ["nickName": name])
        }
    }
    
    //MARK: 性别点击事件
    @objc fileprivate func tapSexGRAction() {
        let maleAction = UIAlertAction(title: "男", style: .default) { (action) in
            self._sexLabel.text = "男"
            //调接口，上传
            self._updateUserOtherInfo(para: ["sex": 1])
        }
        let womanAction = UIAlertAction(title: "女", style: .default) { (action) in
            self._sexLabel.text = "女"
            //调接口，上传
            self._updateUserOtherInfo(para: ["sex": 2])
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(maleAction)
        alertController.addAction(womanAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: 生日点击事件
    @objc fileprivate func tapBirthGRAction() {
        
        UIApplication.shared.keyWindow?.addSubview(self.blurEffectView)
        self.blurEffectView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelAlert
        UIApplication.shared.keyWindow?.addSubview(self.datePickView)
        
    }
    
    
    //用户取消选择生日了
    @objc fileprivate func cancelButtonAction() {
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        if ((self.blurEffectView.superview) != nil) {
            self.blurEffectView.frame = CGRect(x: ScreenWidth/2, y: ScreenHeight/2, width: 0, height: 0)
            self.blurEffectView.removeFromSuperview()
        }
        
        if (self.datePickView.superview != nil) {
            self.datePickView.removeFromSuperview()
        }
    }
    
    //用户确认选择生日了
    @objc fileprivate func finishButtonAction() {
        //更新提醒时间文本框
        if self.datePickerDate.characters.count > 0 {
            self._birthLabel.text = self.datePickerDate
            self._updateUserOtherInfo(para: ["birthday": self.datePickerDate])
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
            if ((self.blurEffectView.superview) != nil) {
                self.blurEffectView.frame = CGRect(x: ScreenWidth/2, y: ScreenHeight/2, width: 0, height: 0)
                self.blurEffectView.removeFromSuperview()
            }
            
            if (self.datePickView.superview != nil) {
                self.datePickView.removeFromSuperview()
            }
        }
    }
    
    @objc func ChangeDate(datePicker:UIDatePicker) {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: datePicker.date)
        
        self.datePickerDate = strDate
    }
    
    
    //MARK: ImagePickerController Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //  跳转到剪辑头像页面
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let clipVC = CPEditHeaderClipViewController(image: image!) { (croperImage) in
            //  剪辑完成回调
            self._userHeadImageView.contentMode = .scaleAspectFit
            self._userHeadImageView.image = croperImage
            
            
            let imageData = UIImageJPEGRepresentation(croperImage, 0.7)
            self.dismiss(animated: true, completion: {
                UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation(rawValue: 0)!)
                UIApplication.shared.setStatusBarStyle(UIStatusBarStyle(rawValue: 1)!, animated: true)
                if let dataNotEmpty = imageData {
                    self._updateUserHeadInfo(para: ["file": dataNotEmpty])
                }
            })
        }
        picker.pushViewController(clipVC, animated: true)
    }
    
    //MARK: 修改其他资料
    fileprivate func _updateUserOtherInfo(para: [String: Any]) {
        
        UIConstants.sharedDataEngine().loadingAnimation()
        UserRequest().requestUserOtherInfomationParams(para, success: {[unowned self] (respons) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            guard let resp = respons as? [String: Any], resp["status"] as? String == "0" else {
                CIASAlertCancleView().show("温馨提示", message: "设置失败，请您稍后重试", cancleTitle: "好的", callback: nil)
                return
            }
            self._getUserDetailInfo()
        }) { (error) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            CIASAlertCancleView().show("温馨提示", message: "设置失败，请您稍后重试", cancleTitle: "好的", callback: nil)
        }
        
    }
    
    //MARK: 修改头像
    fileprivate func _updateUserHeadInfo(para: [String: Any]) {
        
        UIConstants.sharedDataEngine().loadingAnimation()
        UserRequest().requestUserHeadInfomationParams(para, success: {[unowned self] (respons) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            guard let resp = respons as? [String: Any], resp["status"] as? String == "0" else {
                CIASAlertCancleView().show("温馨提示", message: "设置失败，请您稍后重试", cancleTitle: "好的", callback: nil)
                return
            }
            self._getUserDetailInfo()
            
        }) { (error) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            CIASAlertCancleView().show("温馨提示", message: "设置失败，请您稍后重试", cancleTitle: "好的", callback: nil)
        }
        
    }
    
    
    //MARK: 查看用户详细资料
    fileprivate func _getUserDetailInfo() {
        
        UIConstants.sharedDataEngine().loadingAnimation()
        UserRequest().requestUserInfomationParams(nil, success: { (respons) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            guard let resp = respons as? [String: Any], resp["status"] as? String == "0" , let data:[String:Any] = resp["data"] as? [String:Any] else {
                CIASAlertCancleView().show("温馨提示", message: "获取信息失败，请您稍后重试", cancleTitle: "好的", callback: nil)
                return
            }
            //解析，进行赋值
            print("\(data)")
            
            if let userId =  data["id"] as? CLongLong {
                self._useridLabel.text = "\(String(describing: userId))"
            }
            
            if let headUrlStr = data["headingUrl"] as? String {
                self._userHeadImageView.sd_setImage(with: URL(string: headUrlStr), placeholderImage: nil)
                self._userHeadImageView.contentMode = .scaleAspectFit
            } else {
                self._userHeadImageView.image = UIImage.getImageRedrawed(image: #imageLiteral(resourceName: "camera_icon"), scale: 0.93)
                self._userHeadImageView.contentMode = .center
            }

            if let nickName = data["nickName"] as? String {
                self._nickNameLabel.text = nickName
            }
            
            
            if let sexValue = data["sex"] as? Int {
                if sexValue == 1 {
                    self._sexLabel.text = "男"
                } else {
                    self._sexLabel.text = "女"
                }
            }

            if let birthStr = data["birthday"] as? String {
                self._birthLabel.text = birthStr
            }
            
        }) { (error) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            CIASAlertCancleView().show("温馨提示", message: "获取信息失败，请您稍后重试", cancleTitle: "好的", callback: nil)
        }
        
    }
    
}
