//  CouponListViewController.swift
//  Created by avatar on 2017/7/5.
//  Copyright © 2017年 cias. All rights reserved.

import UIKit
import SnapKit
import NSURL_QueryDictionary
import MJRefresh

class CouponListViewController: UIViewController {

    /// 绑定优惠券背景，横店不需要 隐藏
    @IBOutlet weak var bindingBGView: UIView!
    
    /// 列表top约束， 横店需要更改为self.view.top
    @IBOutlet weak var couponListTableViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var couponInputField: UITextField!
    
    @IBOutlet weak var couponListTableView: UITableView!
    
    @IBOutlet weak var couponFieldHeight: NSLayoutConstraint!//44
    
    @IBOutlet weak var couponBindBtn: UIButton!
    
    @IBOutlet weak var couponBindBtnHeight: NSLayoutConstraint!//44
    
    @IBOutlet weak var couponBindBtnWidth: NSLayoutConstraint!//99
    
    @IBOutlet weak var couponViewHeight: NSLayoutConstraint!//68
    
    @IBOutlet weak var couponFieldLeft: NSLayoutConstraint!//15
    
    @IBOutlet weak var couponFieldTop: NSLayoutConstraint!//15
    
    @IBOutlet weak var couponBindBtnTop: NSLayoutConstraint!//15
    
    @IBOutlet weak var couponBindBtnRight: NSLayoutConstraint!//15
    
    @IBAction func couponBtnClick(_ sender: UIButton) {
        CIASAlertCancleView().show("温馨提示", message: "此功能暂未开放", cancleTitle: "知道了", callback: nil)
    }
    
    fileprivate let couponListArr = NSMutableArray(capacity: 0)
    
    fileprivate let rightBarBtn   = UIButton(type: .custom)
    
    fileprivate let noCouponListAlertView : UIView = {
        
        let noCouponAlertImage = #imageLiteral(resourceName: "empty")
        let noCouponAlertStr = "还没有任何优惠券"
        let noCouponAlertStrSize = KKZTextUtility.measureText(noCouponAlertStr, size: CGSize(width: 500, height:500), font: UIFont.systemFont(ofSize: 15*Constants.screenWidthRate))
        let tmpView = UIView(frame: CGRect(x:0.283*ScreenWidth,y:0.277*ScreenHeight,width:noCouponAlertImage.size.width,height:noCouponAlertStrSize.height+noCouponAlertImage.size.height+15*Constants.screenWidthRate))
        let noCouponAlertImageView = UIImageView()
        tmpView.addSubview(noCouponAlertImageView)
        noCouponAlertImageView.image = noCouponAlertImage
        noCouponAlertImageView.contentMode = .scaleAspectFill
        noCouponAlertImageView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(tmpView)
            make.height.equalTo(noCouponAlertImage.size.height)
        })
        let noCouponAlertLabel = UILabel()
        tmpView.addSubview(noCouponAlertLabel)
        noCouponAlertLabel.text = noCouponAlertStr
        noCouponAlertLabel.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        noCouponAlertLabel.textAlignment = .center
        noCouponAlertLabel.textColor = UIColor(hex: "0xb2b2b2")
        noCouponAlertLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(tmpView)
            make.top.equalTo(noCouponAlertImageView.snp.bottom).offset(15*Constants.screenWidthRate)
            make.height.equalTo(noCouponAlertStrSize.height)
        })
        
        return tmpView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hideNavigationBar = false
        self.title = "我的优惠券"
        self.addLayoutConstraint()
        

        let str           = "使用说明"
        let strSize       = KKZTextUtility.measureText(str, size: CGSize(width: 500, height: 500), font: UIFont.systemFont(ofSize: 15*Constants.screenWidthRate))
        rightBarBtn.frame = CGRect(x: ScreenWidth-(strSize.width+5+10), y: 34, width: strSize.width+5, height: strSize.height)
        rightBarBtn.setTitle(str, for: .normal)
        rightBarBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        rightBarBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().characterColor), for: .normal)
        rightBarBtn.backgroundColor = UIColor.clear
        rightBarBtn.addTarget(self, action: #selector(rightItemClick(sender:)), for: .touchUpInside)
        let rightBarBtnItem:UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.rightBarButtonItem = rightBarBtnItem;
     
        
        self.couponInputField.layer.borderColor = UIColor(hex: "0xe0e0e0").cgColor
        self.couponInputField.layer.borderWidth = 1.0
        self.couponInputField.textColor         = UIColor(hex: "0x333333")
        self.couponInputField.font              = UIFont.systemFont(ofSize: 14*Constants.screenWidthRate)
        self.couponInputField.keyboardType      = .namePhonePad
        
        let placeHolder              = "请输入优惠券码"
        let placeHolderColor:UIColor = UIColor(hex: "0xb2b2b2")
        let placeHolderFont:UIFont   = UIFont.systemFont(ofSize: 14*Constants.screenWidthRate)
        
        self.couponInputField.attributedPlaceholder    = NSAttributedString(string: placeHolder, attributes: [NSForegroundColorAttributeName:placeHolderColor, NSFontAttributeName:placeHolderFont])
        self.couponInputField.isUserInteractionEnabled = false
        
        
        self.couponBindBtn.layer.cornerRadius = 5.0
        self.couponBindBtn.clipsToBounds      = true
        
        self.couponListTableView.register(UINib.init(nibName: "CouponListCell", bundle: nil), forCellReuseIdentifier: "CouponListCell")
        self.couponListTableView.separatorStyle = .none
        self.couponListTableView.mj_header = CPRefreshHeader(refreshingBlock: {
            [unowned self] in
            if self.couponListTableView.mj_footer.isRefreshing() {
                self.couponListTableView.mj_header.endRefreshing()
                return
            }
            self.refreshCouponList()
        })
        
        self.couponListTableView.mj_header.beginRefreshing()
        
        self.couponListTableView.mj_footer = CPRefreshFooter(refreshingBlock: {
            [unowned self] in
            if self.couponListTableView.mj_header.isRefreshing() {
                self.couponListTableView.mj_footer.endRefreshing()
                return
            }
            self.refreshCouponList()
        })
        //  横店隐藏 绑定 所有都隐藏
        #if K_HENGDIAN
        #endif

            bindingBGView.isHidden = true
            view.removeConstraint(couponListTableViewTop)
            let top = NSLayoutConstraint(item: couponListTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            view.addConstraint(top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if K_HENGDIAN
            UIApplication.shared.setStatusBarStyle(.default, animated: false)
        #endif
    }
    
    
    fileprivate func refreshCouponList() {
        UIConstants.sharedDataEngine().loadingAnimation()
        CouponRequest().requestMyCouponListParams(["filter":"0"], success: { [unowned self] (couponList) in
            self.endRefreshing()
            self.endLoadMore()
            if self.couponListArr.count > 0 {
                self.couponListArr.removeAllObjects()
            }
            
            if let arr = couponList {
                self.couponListArr.addObjects(from: arr)
            }
            
            if self.couponListArr.count > 0 {
                self.couponListTableView.mj_footer.state = .idle
                if (self.noCouponListAlertView.superview != nil) {
                    self.noCouponListAlertView.removeFromSuperview()
                }
            } else {
                self.couponListTableView.mj_footer.state = .noMoreData
                if (self.noCouponListAlertView.superview != nil) {
                    
                } else {
                    self.couponListTableView.addSubview(self.noCouponListAlertView)
                }
            }
            self.couponListTableView.reloadData()
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            
        }) { (err) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            self.endRefreshing()
            self.endLoadMore()
            CIASPublicUtility.showMyAlertView(forTaskInfo: err)
        }
    
        
    }
    
    fileprivate func endRefreshing() {
        if self.couponListTableView.mj_header.isRefreshing() {
            self.couponListTableView.mj_header.endRefreshing()
        }
    }
    
    fileprivate func endLoadMore() {
        if self.couponListTableView.mj_footer.isRefreshing() {
            self.couponListTableView.mj_footer.endRefreshing()
        }
    }
    
    
    @objc func  rightItemClick(sender:UIButton) {
        let openCardVc = OpenCardNoticeController()
        openCardVc.titleShowStr = "优惠券使用说明"
        openCardVc.isFromCoupon = true
        self.navigationController?.pushViewController(openCardVc, animated: true)
    }
    
    fileprivate func addLayoutConstraint() {
        guard let fieldHeight = self.couponFieldHeight else { return }
        
        fieldHeight.constant = 44*Constants.screenHeightRate//44
        self.couponBindBtnHeight!.constant = 44*Constants.screenHeightRate
        self.couponFieldLeft!.constant = 15*Constants.screenWidthRate
        self.couponFieldTop!.constant = 15*Constants.screenHeightRate
        self.couponBindBtnTop!.constant = 15*Constants.screenHeightRate
        self.couponViewHeight!.constant = 68*Constants.screenHeightRate
        self.couponBindBtnRight!.constant = 15*Constants.screenWidthRate
        
        self.couponBindBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension CouponListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "CouponListCell"
        let cell   = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! CouponListCell
        cell.selectionStyle = .none
        let myCoupon:Coupon = self.couponListArr[indexPath.row] as! Coupon
        
        self.getCell(cell, myCoupon: myCoupon)
        
        return cell
    }
    
    fileprivate func getCell(_ cellNew:CouponListCell, myCoupon:Coupon)  {
        if myCoupon.status.intValue == 1 {
            //已绑定
            if myCoupon.couponType.intValue == 1 {
                cellNew.couponBackImage.image = #imageLiteral(resourceName: "coupon_bg3")
            } else if myCoupon.couponType.intValue == 2 {
                cellNew.couponBackImage.image = #imageLiteral(resourceName: "coupon_bg2")
            }else if myCoupon.couponType.intValue == 3 {
                cellNew.couponBackImage.image = #imageLiteral(resourceName: "coupon_bg1")
            }
            
            cellNew.couponValidLabel.text = "有效期"
            var endTime:String = ""
            if (myCoupon.endTime.characters.count >= 16) {
                let cIndex = myCoupon.endTime.index(myCoupon.endTime.startIndex, offsetBy: 16)
                endTime = myCoupon.endTime.substring(to: cIndex)
            } else {
                endTime = myCoupon.endTime;
            }
            var startTime:String = ""
            if (myCoupon.startTime.characters.count >= 16) {
                let cIndex = myCoupon.startTime.index(myCoupon.startTime.startIndex, offsetBy: 16)
                startTime = myCoupon.startTime.substring(to: cIndex)
            } else {
                startTime = myCoupon.startTime;
            }
            cellNew.couponValidValueLabel.text       = "\(startTime)"+"至"+"\(endTime)"
            cellNew.couponValidLabel.isHidden        = false
            cellNew.couponValidValueLabel.isHidden   = false
            cellNew.couponExpireBtn.isHidden         = true
            
        } else if myCoupon.status.intValue == 2 {
            //已使用
            cellNew.couponBackImage.image            = #imageLiteral(resourceName: "coupon_bg4")
            cellNew.couponExpireBtn.isHidden         = false
            cellNew.couponExpireBtn.titleLabel?.text = "已使用"
            cellNew.couponValidLabel.isHidden        = true
            cellNew.couponValidValueLabel.isHidden   = true
            
        } else if myCoupon.status.intValue == 3 {
            //已过期
            cellNew.couponBackImage.image            = #imageLiteral(resourceName: "coupon_bg4");
            cellNew.couponExpireBtn.isHidden         = false
            cellNew.couponExpireBtn.titleLabel?.text = "已过期"
            cellNew.couponValidLabel.isHidden        = true
            cellNew.couponValidValueLabel.isHidden   = true
        }
        cellNew.couponPriceLabel.isHidden = true
        cellNew.couponTipLabel.isHidden   = true
        cellNew.couponTypeLabel.isHidden  = false
        cellNew.couponTypeLabel.text      =  "通兑"
        cellNew.couponTypeLabel.textColor = UIColor(hex: "#ff9900")
        cellNew.couponTitleLabel.text     = myCoupon.couponName
        cellNew.couponDescribeLabel.text  = myCoupon.rule
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let couponBackImage = #imageLiteral(resourceName: "coupon_bg1")
        let cellHeight:CGFloat = couponBackImage.size.height*Constants.screenHeightRate + 5
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
}


