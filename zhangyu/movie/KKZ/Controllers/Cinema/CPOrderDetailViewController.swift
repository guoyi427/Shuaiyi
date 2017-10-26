//
//  CPOrderDetailViewController.swift
//  Cinephile
//
//  Created by kokozu on 2017/6/12.
//  Copyright © 2017年 Kokozu. All rights reserved.
//

import UIKit
import DateEngine_KKZ
import CoreLocation
import MapKit
//import SVProgressHUD

class CPOrderDetailViewController: UIViewController {
    
    var orderModel:Order?
    var isFromChooseSeatView:Bool = false
    
    /// 白色票根背景
    fileprivate let _whiteView = UIImageView(image: #imageLiteral(resourceName: "CPTicketStub_white_bg"))
    
    fileprivate let _postImageView = UIImageView(image: #imageLiteral(resourceName: "post_black_shadow.png"))
    fileprivate let _movieNameLabel = UILabel()
    fileprivate let _movieScreenTypeLabel = UILabel()
    fileprivate let _movieDateLabel = UILabel()
    fileprivate let _movieHallLabel = UILabel()
    fileprivate let _movieSeatLabel = UILabel()
    fileprivate let _movieCinemaNameLabel = UILabel()
    fileprivate let _movieCinemaAddressLabel = UILabel()
    
    fileprivate let _grayView = UIView()
    fileprivate let _ticketNumberTitleLabel = UILabel()
    fileprivate let _ticketNumberLabel = UILabel()
    fileprivate let _ticketCodeTitleLabel = UILabel()
    fileprivate let _ticketCodeLabel = UILabel()
    fileprivate let _overdueIconView = UIImageView(image: #imageLiteral(resourceName: "overdueIcon.png"))
    
//    fileprivate let _ticketQRCodeImageView = UIImageView()
    
    fileprivate let _orderIdLabel = UILabel()
    fileprivate let _orderMobileLabel = UILabel()
    
    fileprivate let _sendMessageButton = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _prepareBackgroundView()
        _prepareNaviBar()
        _prepareMovieInfoView()
        _prepareTicketInfoView()
        _prepareQRCodeView()
        _prepareOrderInfoView()
        if isFromChooseSeatView {
            navigationController?.view.removeGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _uploadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
}

// MARK: - Private - Methods
extension CPOrderDetailViewController {
    
    fileprivate func _prepareNaviBar() {
//        self.hideNavigationBar = true
//        self.hideBackBtn = true

        let backBarButton = UIButton(type: .custom)
        backBarButton.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        backBarButton.setImage(#imageLiteral(resourceName: "CPNavibar_Close"), for: .normal)
        backBarButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(backBarButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "订单详情"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view.snp.top).offset(44)
        }
    }
    
    fileprivate func _prepareBackgroundView() {
        let bgView = UIImageView(image: #imageLiteral(resourceName: "CPTicketStub_bg"))
        bgView.frame = self.view.bounds
        bgView.isUserInteractionEnabled = true
        self.view.addSubview(bgView)
        
        var scrollView_y: CGFloat = 72
        if self.view.bounds.height == 736 {
            scrollView_y = 90
        }
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: scrollView_y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - scrollView_y))
        bgView.addSubview(scrollView)
        
        //  白色票根背景 size
        let height_whiteView = 555//_whiteView.image!.size.height / _whiteView.image!.size.width * (UIScreen.main.bounds.width - 24)
        scrollView.contentSize = CGSize(width: 0, height: height_whiteView)

        _whiteView.layer.cornerRadius = 8
        _whiteView.layer.masksToBounds = true
        _whiteView.isUserInteractionEnabled = true
        scrollView.addSubview(_whiteView)
        _whiteView.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView).offset(-24)
            make.top.equalTo(0)
            make.height.equalTo(height_whiteView)
        }
    }
    
    fileprivate func _prepareMovieInfoView() {
        _postImageView.contentMode = .scaleAspectFill
        _whiteView.addSubview(_postImageView)
        _postImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.top.equalTo(22.5)
            make.size.equalTo(CGSize(width: 75, height: 107.5))
        }
        
        _movieNameLabel.text = "电影名称"
        _movieNameLabel.textColor = UIColor.black
        _movieNameLabel.font = UIFont.systemFont(ofSize: 18)
        _movieNameLabel.adjustsFontSizeToFitWidth = true
        _movieNameLabel.minimumScaleFactor = 10/18.0
        _whiteView.addSubview(_movieNameLabel)
        _movieNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.lessThanOrEqualTo(_postImageView.snp.left).offset(-30)
            make.top.equalTo(_postImageView)
        }
        
        _movieScreenTypeLabel.text = "屏幕类型"
        _movieScreenTypeLabel.textColor = UIColor.cp_black()
        _movieScreenTypeLabel.backgroundColor = UIColor.cp_yellow()
        _movieScreenTypeLabel.font = UIFont.systemFont(ofSize: 10)
        _movieScreenTypeLabel.layer.cornerRadius = 3.0
        _movieScreenTypeLabel.layer.masksToBounds = true
        _whiteView.addSubview(_movieScreenTypeLabel)
        _movieScreenTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_movieNameLabel.snp.right).offset(5)
            make.centerY.equalTo(_movieNameLabel)
        }
        
        _movieDateLabel.text = "电影放映时间"
        _movieDateLabel.textColor = UIColor.cp_black()
        _movieDateLabel.font = UIFont.systemFont(ofSize: 13)
        _whiteView.addSubview(_movieDateLabel)
        _movieDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_movieNameLabel)
            make.top.equalTo(_movieNameLabel.snp.bottom).offset(10)
        }
        
        _movieHallLabel.text = "影厅"
        _movieHallLabel.textColor = UIColor.cp_black()
        _movieHallLabel.font = UIFont.systemFont(ofSize: 13)
        _whiteView.addSubview(_movieHallLabel)
        _movieHallLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_movieNameLabel)
            make.top.equalTo(_movieDateLabel.snp.bottom).offset(4)
        }
        
        _movieSeatLabel.text = "座椅位置"
        _movieSeatLabel.textColor = UIColor.cp_black()
        _movieSeatLabel.font = UIFont.systemFont(ofSize: 13)
        _whiteView.addSubview(_movieSeatLabel)
        _movieSeatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_movieNameLabel)
            make.top.equalTo(_movieHallLabel.snp.bottom).offset(4)
        }
        
        let mapButton = UIButton(type: .custom)
        mapButton.setImage(#imageLiteral(resourceName: "CPTicketStub_GPS"), for: .normal)
        mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        _whiteView.addSubview(mapButton)
        mapButton.snp.makeConstraints { (make) in
            make.left.equalTo(_movieNameLabel)
            make.top.equalTo(132)
        }
        
        _movieCinemaNameLabel.text = "影院名称"
        _movieCinemaNameLabel.font = UIFont.systemFont(ofSize: 13)
        _movieCinemaNameLabel.textColor = UIColor.cp_black()
        _movieCinemaNameLabel.adjustsFontSizeToFitWidth = true
        _movieCinemaNameLabel.minimumScaleFactor = 8.0/13.0
        _whiteView.addSubview(_movieCinemaNameLabel)
        _movieCinemaNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mapButton.snp.right).offset(7.5)
            make.right.lessThanOrEqualTo(_postImageView.snp.left).offset(-10)
            make.bottom.equalTo(mapButton.snp.centerY)
        }

        _movieCinemaAddressLabel.text = "影院位置"
        _movieCinemaAddressLabel.font = UIFont.systemFont(ofSize: 11)
        _movieCinemaAddressLabel.textColor = UIColor.cp_gray()
        _movieCinemaAddressLabel.adjustsFontSizeToFitWidth = true
        _movieCinemaAddressLabel.minimumScaleFactor = 8.0/11.0
        _movieCinemaAddressLabel.numberOfLines = 2
        _whiteView.addSubview(_movieCinemaAddressLabel)
        _movieCinemaAddressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_movieCinemaNameLabel)
            make.right.lessThanOrEqualTo(_whiteView).offset(-12)
            make.top.equalTo(_movieCinemaNameLabel.snp.bottom).offset(5)
        }
    }
    
    fileprivate func _prepareTicketInfoView() {
        _grayView.backgroundColor = UIColor(hex: "#f7f5f6")
        _whiteView.addSubview(_grayView)
        _grayView.snp.makeConstraints { (make) in
            make.centerX.equalTo(_whiteView)
            make.bottom.equalTo(_whiteView.snp.top).offset(310)
            make.size.equalTo(CGSize(width: 250, height: 65))
        }
        
        //  取票号
        _ticketNumberTitleLabel.text = orderModel?.finalTicketNoName
        _ticketNumberTitleLabel.textColor = UIColor(hex: "#b2b2b2")
        _ticketNumberTitleLabel.font = UIFont.systemFont(ofSize: 10)
        _grayView.addSubview(_ticketNumberTitleLabel)
        _ticketNumberTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(27)
            make.centerY.equalTo(_grayView.snp.top).offset(20)
        }
        
        _ticketNumberLabel.text = "0"
        _ticketNumberLabel.textColor = UIColor(hex: "#464646")
        _ticketNumberLabel.font = UIFont.systemFont(ofSize: 15)
        _grayView.addSubview(_ticketNumberLabel)
        _ticketNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_ticketNumberTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(_ticketNumberTitleLabel)
        }
        
        //  验证码
        _ticketCodeTitleLabel.text = orderModel?.finalVerifyCodeName
        _ticketCodeTitleLabel.textColor = _ticketNumberTitleLabel.textColor
        _ticketCodeTitleLabel.font = _ticketNumberTitleLabel.font
        _grayView.addSubview(_ticketCodeTitleLabel)
        _ticketCodeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_ticketNumberTitleLabel)
            make.centerY.equalTo(_grayView.snp.bottom).offset(-20)
        }
        
        _ticketCodeLabel.text = "0"
        _ticketCodeLabel.textColor = _ticketNumberLabel.textColor
        _ticketCodeLabel.font = _ticketNumberLabel.font
        _grayView.addSubview(_ticketCodeLabel)
        _ticketCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_ticketCodeTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(_ticketCodeTitleLabel)
        }
        
        //  放映icon
        _overdueIconView.isHidden = true
        _whiteView.addSubview(_overdueIconView)
        _overdueIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.top.equalTo(_grayView).offset(30)
        }
    }
    
    fileprivate func _prepareQRCodeView() {
//        _whiteView.addSubview(_ticketQRCodeImageView)
//        _ticketQRCodeImageView.snp.makeConstraints { (make) in
//            make.centerX.equalTo(_whiteView)
//            make.top.equalTo(269 - 12)
//            make.size.equalTo(CGSize(width: 125 + 34, height: 125 + 34))
//        }
        
        //  提示语
        let label = UILabel()
        label.text = "请至影院前台或自助取票机进行取票"
        label.textColor = UIColor.cp_black()
        label.font = UIFont.systemFont(ofSize: 12)
        _whiteView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(_whiteView)
            make.top.equalTo(270+80)
        }
        
        //  客服电话
        let mobileNumber = "400-000-9666"
        let mobileStr = NSMutableAttributedString(string: "客服电话："+mobileNumber)
        mobileStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.cp_gray(), range: NSMakeRange(0, 5))
        
        let mobileLabel = UILabel()
        mobileLabel.textColor = UIColor.cp_orange
        mobileLabel.font = UIFont.systemFont(ofSize: 11)
        mobileLabel.attributedText = mobileStr
        mobileLabel.isUserInteractionEnabled = true
        _whiteView.addSubview(mobileLabel)
        mobileLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(_whiteView)
            make.top.equalTo(label.snp.bottom).offset(4)
        }
        
        let tapCellCsGR = UITapGestureRecognizer(target: self, action: #selector(tellCs))
        mobileLabel.addGestureRecognizer(tapCellCsGR)
    }
    
    fileprivate func _prepareOrderInfoView() {
        _sendMessageButton.setTitle("发送到手机", for: .normal)
        _sendMessageButton.setTitleColor(UIColor.cp_black(), for: .normal)
        _sendMessageButton.setTitleColor(UIColor.cp_gray(), for: .disabled)
        _sendMessageButton.setBackgroundColor(UIColor.cp_yellow(), for: .normal)
        _sendMessageButton.setBackgroundColor(UIColor(hex:"#e0e0e0"), for: .disabled)
        _sendMessageButton.addTarget(self, action: #selector(sendMessageButtonAction), for: .touchUpInside)
        _whiteView.addSubview(_sendMessageButton)
        _sendMessageButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(44)
        }
        
        //  手机号
        let mobileTitleLabel = UILabel()
        mobileTitleLabel.text = "手机号:"
        mobileTitleLabel.textColor = UIColor(hex: "#b2b2b2")
        mobileTitleLabel.font = UIFont.systemFont(ofSize: 13)
        _whiteView.addSubview(mobileTitleLabel)
        mobileTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(_sendMessageButton.snp.top).offset(-12)
        }
        
        _orderMobileLabel.text = "0"
        _orderMobileLabel.textColor = UIColor.cp_black()
        _orderMobileLabel.font = UIFont.systemFont(ofSize: 13)
        _whiteView.addSubview(_orderMobileLabel)
        _orderMobileLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mobileTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(mobileTitleLabel)
        }
        
        //  订单号
        let orderIdTitleLabel = UILabel()
        orderIdTitleLabel.text = "订单号:"
        orderIdTitleLabel.textColor = mobileTitleLabel.textColor
        orderIdTitleLabel.font = mobileTitleLabel.font
        _whiteView.addSubview(orderIdTitleLabel)
        orderIdTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(mobileTitleLabel.snp.top).offset(-5)
        }
        
        _orderIdLabel.text = "0"
        _orderIdLabel.textColor = UIColor.cp_black()
        _orderIdLabel.font = _orderMobileLabel.font
        _whiteView.addSubview(_orderIdLabel)
        _orderIdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderIdTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(orderIdTitleLabel)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.cp_grayLine()
        _whiteView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(orderIdTitleLabel.snp.top).offset(-10)
        }
    }
    
    fileprivate func _uploadData() {
        guard let order = self.orderModel else { return }
        guard let plan = order.plan else { return }
        guard let movie = plan.movie else { return }
        guard let cinema = plan.cinema else { return }
        
        //  封面
        if movie.pathVerticalS != nil {
            _postImageView.sd_setImage(with: URL(string: movie.pathVerticalS))
        }
        //  片名
        _movieNameLabel.text = movie.movieName
        
        //  屏幕类型
        if plan.screenType != nil && plan.language != nil {
            _movieScreenTypeLabel.text = " " + plan.screenType + "|" + plan.language + " "
        } else if plan.screenType != nil {
            _movieScreenTypeLabel.text = " " + plan.screenType + " "
        } else if plan.language != nil {
            _movieScreenTypeLabel.text = " " + plan.language + " "
        } else {
            _movieScreenTypeLabel.isHidden = true
        }
        
        //  放映时间
        let dateStr = DateEngine.shared().string(fromDateY: plan.movieTime)
        _movieDateLabel.text = dateStr
        
        //  影厅
        _movieHallLabel.text = plan.hallName
        
        //  座位信息
        _movieSeatLabel.text = order.readableSeatInfos()
        
        //  影院名称 和 地址
        _movieCinemaNameLabel.text = cinema.cinemaName
        _movieCinemaAddressLabel.text = cinema.cinemaAddress
        
        //  取票号
        if order.finalTicketNo != nil {
            var ticketNumber:String = ""
            var index = 1
            for substring in order.finalTicketNo.characters {
                ticketNumber.append(substring)
                if index % 4 == 0 {
                    ticketNumber.append(" ")
                }
                index += 1
            }
            _ticketNumberLabel.text = ticketNumber
        } else {
            _ticketNumberTitleLabel.isHidden = true
            _ticketNumberLabel.isHidden = true
            _ticketCodeTitleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(27)
                make.centerY.equalTo(_grayView)
            })
        }
        
        //  验证码
        if order.finalVerifyCode != nil {
            var verifyCode:String = ""
            var index = 1
            for substring in order.finalVerifyCode.characters {
                verifyCode.append(substring)
                if index % 4 == 0 {
                    verifyCode.append(" ")
                }
                index += 1
            }
            _ticketCodeLabel.text = verifyCode
        } else {
            _ticketCodeLabel.isHidden = true
            _ticketCodeTitleLabel.isHidden = true
            _ticketNumberTitleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(27)
                make.centerY.equalTo(_grayView)
            })
        }
        
        //  订单号
        _orderIdLabel.text = order.orderId
        
        //  手机号
        if order.mobile != nil && order.mobile.characters.count > 0 {
            _orderMobileLabel.text = order.mobile
        } else {
            _orderMobileLabel.text = "\(DataEngine.shared().userName)"//"\(CPUserCenter.shareInstance().userName)"
        }
        
        //  判断是否过期
        if plan.movieTime.compare(Date()) == .orderedDescending {
            //  未过期
            _overdueIconView.isHidden = true
            _sendMessageButton.isEnabled = true
        } else {
            //  已过期
            _overdueIconView.isHidden = false
            _sendMessageButton.isEnabled = false
        }
        
        //  二维码
//        let qrImageURL = URL(string: "\(kKSSQrServer)?order_id=\(order.orderId!)")
//        _ticketQRCodeImageView.sd_setImage(with: qrImageURL)
    }
}

// MARK: - Button - Action
extension CPOrderDetailViewController {
    /// 返回按钮
    @objc fileprivate func closeButtonAction() {
        if isFromChooseSeatView {
            navigationController?.popToRootViewController(animated: true)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YN_POP_TO_ROOT_CONTROLLER_NAME), object: nil, userInfo: [YN_POP_TO_ROOT_CONTROLLER_KEY:0])
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func sendMessageButtonAction() {
        if _overdueIconView.isHidden == false {
            return
        }
        
        guard let orderId = orderModel?.orderId, let mobile = orderModel?.mobile else { return }
//        SVProgressHUD.show()
//        OrderRequest().sendOrderMessageParams(["order_id":orderId, "mobile":mobile], success: { [weak self] (responseDic) in
//            SVProgressHUD.dismiss()
//            if let weakSelf = self {
//                weakSelf.view.makeToast("短信已发出，请注意查收")
//            }
//        }) { [weak self] (error) in
//            SVProgressHUD.dismiss()
//            if let weakSelf = self {
//                weakSelf.view.makeToast("短信发送失败，请检查网络连接")
//            }
//        }
    }
    
    @objc fileprivate func showMap() {
        guard let order = orderModel else { return }
        guard let plan = order.plan else { return }
        guard let cinema = plan.cinema else { return }
        guard let lat = cinema.latitude else { return }
        guard let lon = cinema.longitude else { return }
        
        guard var latitude = Double(lat) else { return }
        guard var longitude = Double(lon) else { return }
        
        if latitude > 90 || latitude < -90 {
            latitude = 0
        }
        if longitude > 180 || longitude < -180 {
            longitude = 0
        }
        if latitude == 0 || longitude == 0 {
            return
        }
        
        let cclocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let map:MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: cclocation, addressDictionary: nil))
        map.name = cinema.cinemaName
        map.openInMaps(launchOptions: nil)
    }
    
    @objc fileprivate func tellCs() {
        UIApplication.shared.openURL(URL(string: "tel://4000009666")!)
    }
}
