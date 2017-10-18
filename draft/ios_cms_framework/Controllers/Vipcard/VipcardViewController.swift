//
//  VipcardViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/6/16.
//  Copyright © 2017年 cias. All rights reserved.
//

import UIKit
import SnapKit
import NSURL_QueryDictionary
import MJRefresh

class VipcardViewController: UIViewController {
    
    let rightBarBtn     = UIButton(type: .custom)
    
    let gotoGetCardBtnOfCardList      = UIButton(type: .custom)
    let gotoOpenCardBtnOfCardList     = UIButton(type: .custom)

    let vipCardListCount = NSMutableArray(capacity: 0)
    
    var initFirst : Bool = false
    
    let vipCardListTableView:UITableView = UITableView(frame: CGRect(x: 0, y:0, width:kScreenWidth, height: kScreenHeight), style:.plain)
    
    let noCardListAlertView : UIView = {
        
        let noOrderAlertImage = #imageLiteral(resourceName: "empty")
        let noOrderAlertStr = "还没有任何会员卡"
        let noOrderAlertStrSize = KKZTextUtility.measureText(noOrderAlertStr, size: CGSize(width: 500, height:500), font: UIFont.systemFont(ofSize: 15*Constants.screenWidthRate))
        let tmpView = UIView(frame: CGRect(x:0.283*ScreenWidth,y:0.277*ScreenHeight,width:noOrderAlertImage.size.width,height:noOrderAlertStrSize.height+noOrderAlertImage.size.height+15*Constants.screenWidthRate))
        let noOrderAlertImageView = UIImageView()
        tmpView.addSubview(noOrderAlertImageView)
        noOrderAlertImageView.image = noOrderAlertImage
        noOrderAlertImageView.contentMode = .scaleAspectFill
        noOrderAlertImageView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(tmpView)
            make.height.equalTo(noOrderAlertImage.size.height)
        })
        let noOrderAlertLabel = UILabel()
        tmpView.addSubview(noOrderAlertLabel)
        noOrderAlertLabel.text = noOrderAlertStr
        noOrderAlertLabel.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        noOrderAlertLabel.textAlignment = .center
        noOrderAlertLabel.textColor = UIColor(hex: "0xb2b2b2")
        noOrderAlertLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(tmpView)
            make.top.equalTo(noOrderAlertImageView.snp.bottom).offset(15*Constants.screenWidthRate)
            make.height.equalTo(noOrderAlertStrSize.height)
        })
        
        return tmpView
    }()
    
    let chooseAlertView:UIView = {
        let tmpView = UIView()
        if kIsHaveOpencard == "1" {
            tmpView.frame = CGRect(x: ScreenWidth-(119+5)*Constants.screenWidthRate, y: 0, width: 119*Constants.screenWidthRate, height: 101*Constants.screenHeightRate)
        } else {
            tmpView.frame = CGRect(x: ScreenWidth-(119+5)*Constants.screenWidthRate, y: 0, width: 119*Constants.screenWidthRate, height: 50*Constants.screenHeightRate)
        }
        tmpView.backgroundColor = UIColor.clear
        let alertImageView = UIImageView()
        tmpView.addSubview(alertImageView)
        alertImageView.contentMode = .scaleAspectFit
        
        let alertImage = #imageLiteral(resourceName: "titlepop_triangle")
        
        alertImageView.image = alertImage
        alertImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(tmpView.snp.right).offset(-12*Constants.screenWidthRate)
            make.top.equalTo(tmpView.snp.top)
            make.size.equalTo(CGSize(width: alertImage.size.width, height: alertImage.size.height))
        })
        
        let choseView = UIView()
        choseView.backgroundColor = UIColor(hex: "0x000000")
        choseView.alpha = 0.9
        choseView.layer.cornerRadius = 3.5
        choseView.clipsToBounds = true
        tmpView.addSubview(choseView)
        choseView.snp.makeConstraints({ (make) in
            make.left.right.width.equalTo(tmpView)
            make.top.equalTo(alertImageView.snp.bottom).offset(-1)
            if kIsHaveOpencard == "1" {
                make.height.equalTo(101*Constants.screenHeightRate)
            } else {
                make.height.equalTo(50*Constants.screenHeightRate)
            }
        })
        
        let bindCardBtn = UIButton(type: .custom)
        bindCardBtn.setTitle("绑定新卡", for: .normal)
        bindCardBtn.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        bindCardBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnColor), for: .highlighted)
        bindCardBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnColor), for: .selected)
        bindCardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18*Constants.screenWidthRate)
        bindCardBtn.addTarget(self, action: #selector(bindCardBtnClick), for: .touchUpInside)
        
        let openCardBtn = UIButton(type: .custom)
        openCardBtn.setTitle("开通会员卡", for: .normal)
        openCardBtn.setTitleColor(UIColor(hex: "0xffffff"), for: .normal)
        openCardBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnColor), for: .highlighted)
        openCardBtn.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnColor), for: .selected)
        openCardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18*Constants.screenWidthRate)
        openCardBtn.addTarget(self, action: #selector(openCardBtnClick), for: .touchUpInside)
        
        if kIsHaveOpencard == "1" {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hex: "0x333333")
            choseView.addSubview(bindCardBtn)
            choseView.addSubview(lineView)
            choseView.addSubview(openCardBtn)
            bindCardBtn.isSelected = false
            openCardBtn.isSelected = false
            
            bindCardBtn.snp.makeConstraints({ (make) in
                make.top.left.right.width.equalTo(choseView)
                make.height.equalTo(50*Constants.screenHeightRate)
            })
            lineView.snp.makeConstraints({ (make) in
                make.top.equalTo(bindCardBtn.snp.bottom)
                make.left.right.equalTo(choseView)
                make.height.equalTo(1)
            })
            
            openCardBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(lineView.snp.bottom)
                make.left.right.equalTo(choseView)
                make.height.equalTo(50*Constants.screenHeightRate)
            })
            
        } else {
            choseView.addSubview(bindCardBtn)
            bindCardBtn.isSelected = false
            bindCardBtn.snp.makeConstraints({ (make) in
                make.top.left.right.width.equalTo(choseView)
                make.height.equalTo(50*Constants.screenHeightRate)
            })
        }
        return tmpView
    }()
    var pageNum : Int  = 0
    //MARK: 绑卡按钮点击事件
    @objc func bindCardBtnClick() {
        guard kIsHaveVipCard == "1" else {
            CIASAlertCancleView().show("温馨提示", message: "该功能尚未开放", cancleTitle: "知道了", callback: { (confirm) in
            })
            return
        }
        if (chooseAlertView.superview != nil) {
            rightBarBtn.isSelected = !rightBarBtn.isSelected
            chooseAlertView.removeFromSuperview()
        }
        if Constants.isAuthorized {
            let ctr = CinemaListViewController()
            ctr.isBindingCard = true
            ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                let bindCard = BindCardViewController()
                bindCard.cinemaName = cinemaName
                bindCard.cinemaId = cinemaId
                self.navigationController?.pushViewController(bindCard, animated: true)
            }
            self.navigationController?.pushViewController(ctr, animated: true)
        } else {
            DataEngine.shared().startLogin(with: true, withFinished: { (succeeded) in
                if succeeded == true {
                    let ctr = CinemaListViewController()
                    ctr.isBindingCard = true
                    ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                        let bindCard = BindCardViewController()
                        bindCard.cinemaName = cinemaName
                        bindCard.cinemaId = cinemaId
                        self.navigationController?.pushViewController(bindCard, animated: true)
                    }
                    self.navigationController?.pushViewController(ctr, animated: true)
                }
            })
        }
        
    }
    
    //MARK: 开卡按钮点击事件
    @objc func openCardBtnClick() {
        if (chooseAlertView.superview != nil) {
            rightBarBtn.isSelected = !rightBarBtn.isSelected
            chooseAlertView.removeFromSuperview()
        }
        
        if Constants.isAuthorized {
            let ctr = CinemaListViewController()
            ctr.isOpenCard = true
            ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                let cardType = CardTypeListViewController()
                cardType.cinemaName = cinemaName
                cardType.cinemaId = cinemaId
                self.navigationController?.pushViewController(cardType, animated: true)
            }
            self.navigationController?.pushViewController(ctr, animated: true)
        } else {
            DataEngine.shared().startLogin(with: true, withFinished: { (succeeded) in
                if succeeded == true {
                    let ctr = CinemaListViewController()
                    ctr.isOpenCard = true
                    ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                        let cardType = CardTypeListViewController()
                        cardType.cinemaName = cinemaName
                        cardType.cinemaId = cinemaId
                        self.navigationController?.pushViewController(cardType, animated: true)
                    }
                    self.navigationController?.pushViewController(ctr, animated: true)
                }
            })
        }
    }
    
    override func  viewDidLoad() {
         super.viewDidLoad()
        
        hideNavigationBar = false
        self.title = "我的会员卡"
        
        rightBarBtn.frame = CGRect(x: ScreenWidth-(28+15), y: 27.5, width: 28, height: 28)
        rightBarBtn.setImage(#imageLiteral(resourceName: "titlebar_more"), for: .normal)
        rightBarBtn.backgroundColor = UIColor.clear
        rightBarBtn.isSelected = false
        rightBarBtn.addTarget(self, action: #selector(rightItemClick(sender:)), for: .touchUpInside)
        let rightBarBtnItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        self.vipCardListTableView.showsVerticalScrollIndicator = false
        self.vipCardListTableView.backgroundColor = UIColor.white
        self.vipCardListTableView.delegate = self
        self.vipCardListTableView.dataSource = self
        self.vipCardListTableView.separatorStyle = .none
        view.addSubview(self.vipCardListTableView)
        self.vipCardListTableView.mj_header = CPRefreshHeader(refreshingBlock: { [unowned self] in
            
            if self.vipCardListTableView.mj_footer.isRefreshing() {
                self.vipCardListTableView.mj_footer.endRefreshing()
            }
            if Constants.isAuthorized {
                self.pageNum = 1
                self.requestVipCardList(page: self.pageNum, pageSize: 10)
            } else {
                DataEngine.shared().startLogin(with: false, withFinished: { (succeeded) in
                    if succeeded == true {
                        self.pageNum = 1
                        self.requestVipCardList(page: self.pageNum, pageSize: 10)
                    }
                })
            }
        })
        
        self.vipCardListTableView.mj_footer = CPRefreshFooter(refreshingBlock: { 
            [unowned self] in
            if self.vipCardListTableView.mj_header.isRefreshing() {
                self.vipCardListTableView.mj_header.endRefreshing()
            }
            if Constants.isAuthorized {
                self.pageNum += 1
                self.requestVipCardList(page: self.pageNum, pageSize: 10)
            } else {
                DataEngine.shared().startLogin(with: false, withFinished: { (succeeded) in
                    if succeeded == true {
                        self.pageNum += 1
                        self.requestVipCardList(page: self.pageNum, pageSize: 10)
                    }
                })
            }
        })
        
        if kIsHaveOpencard == "1" {
            self.gotoOpenCardBtnOfCardList.setTitle("开通会员卡", for: .normal)
            self.gotoOpenCardBtnOfCardList.backgroundColor  = UIColor(hex: UIConstants.sharedDataEngine().btnColor)
            self.gotoOpenCardBtnOfCardList.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnCharacterColor), for: .normal)
            self.gotoOpenCardBtnOfCardList.titleLabel?.font = UIFont.systemFont(ofSize: 16*Constants.screenWidthRate)
            self.gotoOpenCardBtnOfCardList.layer.cornerRadius = 5.0
            self.gotoOpenCardBtnOfCardList.clipsToBounds = true
            self.gotoOpenCardBtnOfCardList.isHidden = true
            view.addSubview(self.gotoOpenCardBtnOfCardList)
            self.gotoOpenCardBtnOfCardList.snp.makeConstraints({ (make) in
                make.left.equalTo(view.snp.left).offset(15);
                make.right.equalTo(view.snp.right).offset(-15);
                make.bottom.equalTo(view.snp.bottom).offset(-5 - 44 - 2);
                make.height.equalTo(44);
            })
            self.gotoOpenCardBtnOfCardList.addTarget(self, action: #selector(gotoOpenCardBtnClick), for: .touchUpInside)
        }
        
        self.gotoGetCardBtnOfCardList.setTitle("绑定会员卡", for: .normal)
        self.gotoGetCardBtnOfCardList.backgroundColor  = UIColor(hex: UIConstants.sharedDataEngine().btnColor)
        self.gotoGetCardBtnOfCardList.setTitleColor(UIColor(hex: UIConstants.sharedDataEngine().btnCharacterColor), for: .normal)
        self.gotoGetCardBtnOfCardList.titleLabel?.font = UIFont.systemFont(ofSize: 16*Constants.screenWidthRate)
        self.gotoGetCardBtnOfCardList.layer.cornerRadius = 5.0
        self.gotoGetCardBtnOfCardList.clipsToBounds = true
        self.gotoGetCardBtnOfCardList.isHidden = true
        view.addSubview(self.gotoGetCardBtnOfCardList)
        self.gotoGetCardBtnOfCardList.snp.makeConstraints({ (make) in
            make.left.equalTo(view.snp.left).offset(15);
            make.right.equalTo(view.snp.right).offset(-15);
            make.bottom.equalTo(view.snp.bottom).offset(-2);
            make.height.equalTo(44);
        })
        self.gotoGetCardBtnOfCardList.addTarget(self, action: #selector(gotoGetCardBtnClick), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userSignOutForVipCardNotification), name: NSNotification.Name(rawValue:"handleUserSignOutForVipCard"), object: nil)
        
    }
    
    func userSignOutForVipCardNotification() {
        self.vipCardListCount.removeAllObjects()
    }
    
    /*
     deinit属于析构函数
     析构函数(destructor) 与构造函数相反，当对象结束其生命周期时（例如对象所在的函数已调用完毕），系统自动执行析构函数
     和OC中的dealloc 一样的,通常在deinit和dealloc中需要执行的操作有:
     对象销毁
     KVO移除
     移除通知
     NSTimer销毁
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: 绑定会员卡按钮点击事件
    func gotoGetCardBtnClick() {
        
        guard kIsHaveVipCard == "1" else {
            CIASAlertCancleView().show("温馨提示", message: "该功能尚未开放", cancleTitle: "知道了", callback: { (confirm) in
            })
            return
        }
        
        if Constants.isAuthorized {
            let ctr = CinemaListViewController()
            ctr.isBindingCard = true
            ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                let bindCard = BindCardViewController()
                bindCard.cinemaName = cinemaName
                bindCard.cinemaId = cinemaId
                self.navigationController?.pushViewController(bindCard, animated: true)
            }
            self.navigationController?.pushViewController(ctr, animated: true)
        } else {
            DataEngine.shared().startLogin(with: true, withFinished: { (succeeded) in
                if succeeded == true {
                    let ctr = CinemaListViewController()
                    ctr.isBindingCard = true
                    ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                        let bindCard = BindCardViewController()
                        bindCard.cinemaName = cinemaName
                        bindCard.cinemaId = cinemaId
                        self.navigationController?.pushViewController(bindCard, animated: true)
                    }
                    self.navigationController?.pushViewController(ctr, animated: true)
                }
            })
        }
    }
    
    //MARK: 开通会员卡按钮点击事件
    func gotoOpenCardBtnClick() {
        if Constants.isAuthorized {
            let ctr = CinemaListViewController()
            ctr.isOpenCard = true
            ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                let cardType = CardTypeListViewController()
                cardType.cinemaName = cinemaName
                cardType.cinemaId = cinemaId
                self.navigationController?.pushViewController(cardType, animated: true)
            }
            self.navigationController?.pushViewController(ctr, animated: true)
        } else {
            DataEngine.shared().startLogin(with: true, withFinished: { (succeeded) in
                if succeeded == true {
                    let ctr = CinemaListViewController()
                    ctr.isOpenCard = true
                    ctr.selectCinemaForCardBlock = { [unowned self] cinemaId, cinemaName in
                        let cardType = CardTypeListViewController()
                        cardType.cinemaName = cinemaName
                        cardType.cinemaId = cinemaId
                        self.navigationController?.pushViewController(cardType, animated: true)
                    }
                    self.navigationController?.pushViewController(ctr, animated: true)
                }
            })
        }
    }
    
    //MARK: 请求会员卡列表
    func requestVipCardList(page: Int, pageSize: Int) {
        UIConstants.sharedDataEngine().loadingAnimation()
        
        VipCardRequest().requestVipCardListParams(["pageNumber" : page, "pageSize" : pageSize], success: { [unowned self] (cardInfo) in
            
            if page == 1 {
                self.endRefreshing()
                if self.vipCardListCount.count > 0 {
                    self.vipCardListCount.removeAllObjects()
                }
            } else {
                self.endLoadMore()
            }
            if let cardRows = cardInfo?.rows {
                self.vipCardListCount.addObjects(from: cardRows)
            }
            
            //判断数组的数量，进行UI调整
            if self.vipCardListCount.count > 0 {
                self.vipCardListTableView.mj_footer.state = .idle
                if page == 1 {
                    self.vipCardListTableView.setContentOffset(CGPoint.zero, animated: true)
                }
                if (self.noCardListAlertView.superview != nil) {
                    self.noCardListAlertView.removeFromSuperview()
                }
                self.gotoGetCardBtnOfCardList.isHidden = true
                if kIsHaveOpencard == "1" {
                    self.gotoOpenCardBtnOfCardList.isHidden = true
                }
            } else {
                self.vipCardListTableView.mj_footer.state = .noMoreData
                if (self.noCardListAlertView.superview != nil) {
                } else {
                    self.vipCardListTableView.addSubview(self.noCardListAlertView)
                }
                self.gotoGetCardBtnOfCardList.isHidden = false
                if kIsHaveOpencard == "1" {
                    self.gotoOpenCardBtnOfCardList.isHidden = false
                }
            }
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            self.vipCardListTableView.reloadData()
            
        }) { (err) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            if page == 1 {
                self.endRefreshing()
            } else {
                self.endLoadMore()
            }
            if (self.noCardListAlertView.superview != nil) {
                
            } else {
                self.vipCardListTableView.addSubview(self.noCardListAlertView)
            }
            self.gotoGetCardBtnOfCardList.isHidden = false
            if kIsHaveOpencard == "1" {
                self.gotoOpenCardBtnOfCardList.isHidden = false
            }
        }
    }
    
    func endRefreshing() {
        if self.vipCardListTableView.mj_header.isRefreshing() {
            self.vipCardListTableView.mj_header.endRefreshing()
        }
    }
    
    func endLoadMore() {
        if self.vipCardListTableView.mj_footer.isRefreshing() {
            self.vipCardListTableView.mj_footer.endRefreshing()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if K_HENGDIAN
            UIApplication.shared.setStatusBarStyle(.default, animated: false)
        #endif
        
        if !Constants.isAuthorized {
            self.vipCardListCount.removeAllObjects()
            self.vipCardListTableView.reloadData()
            if (self.noCardListAlertView.superview != nil) {
            } else {
                self.vipCardListTableView.addSubview(self.noCardListAlertView)
            }
            self.gotoGetCardBtnOfCardList.isHidden = false
            DataEngine.shared().startLogin(with: true, withFinished: { (succeeded) in
                if succeeded == true {
                    self.pageNum = 1
                    self.requestVipCardList(page: self.pageNum, pageSize: 10)
                }
            })
        } else {
            if self.vipCardListCount.count > 0 {
                if !initFirst {
                    self.pageNum = 1
                    self.requestVipCardList(page: self.pageNum, pageSize: 10)
                }
            } else {
                self.pageNum = 1
                self.requestVipCardList(page: self.pageNum, pageSize: 10)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        initFirst = true
        if (chooseAlertView.superview != nil) {
            rightBarBtn.isSelected = !rightBarBtn.isSelected
            chooseAlertView.removeFromSuperview()
        }
    }
    
    @objc func  rightItemClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (chooseAlertView.superview == nil) {
                view.addSubview(chooseAlertView)
            }
        } else {
            if (chooseAlertView.superview != nil) {
                chooseAlertView.removeFromSuperview()
            }
        }
    }
    
    
    
}


extension VipcardViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "VipCardListCell"
        
        var cell:VipCardListCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? VipCardListCell
        
        if cell == nil {
            cell = VipCardListCell()
        }
        let aCard = self.vipCardListCount[indexPath.row]
        cell?.myCard = aCard as! VipCard
        cell?.updateLayout()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vipCardListCount.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cardBackImage = #imageLiteral(resourceName: "membercard_mask")
        let cellHeight:CGFloat = cardBackImage.size.height*Constants.screenHeightRate + 5
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let aCard:VipCard = self.vipCardListCount[indexPath.row] as! VipCard
        UIConstants.sharedDataEngine().loadingAnimation()
        VipCardRequest().requestVipCardDetailParams(["cardNo":aCard.cardNo], success: { [unowned self] (response) in
            if let data = response {
                let cardListDetail:CardListDetail = data
                let cardDetailVc = CardDetailViewController()
                cardDetailVc.cardListDetail = cardListDetail
                self.navigationController?.pushViewController(cardDetailVc, animated: true)
                UIConstants.sharedDataEngine().stopLoadingAnimation()
                self.vipCardListTableView.reloadData()
            }
            
            
        }) { (err) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            CIASPublicUtility.showMyAlertView(forTaskInfo: err)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if kIsHaveUnbindcard == "1" {
            let aCard:VipCard = self.vipCardListCount[indexPath.row] as! VipCard
            let deleteAction = UITableViewRowAction(style: .default, title: "解绑", handler: { (action, indexPath) in
                CIASAlertVIew().show("提示", message: "您确认要解绑吗？", image: nil, cancleTitle: "否", otherTitle: "是", callback: {[unowned self] (confirm) in
                    if confirm {
                        UIConstants.sharedDataEngine().loadingAnimation()
                        VipCardRequest().requestUnbindCardParams(["cardNo":aCard.cardNo], success: { (response) in
                            guard let resp = response as? [String: Any], resp["status"] as? String == "0" else {
                                return
                            }
                            self.vipCardListCount.removeObject(at: indexPath.row)
                            self.vipCardListTableView.deleteRows(at: [indexPath], with: .automatic)
                            if self.vipCardListCount.count == 0 {
                                if (self.noCardListAlertView.superview != nil) {
                                    
                                } else {
                                    self.vipCardListTableView.addSubview(self.noCardListAlertView)
                                }
                                self.gotoGetCardBtnOfCardList.isHidden = false
                                if kIsHaveOpencard == "1" {
                                    self.gotoOpenCardBtnOfCardList.isHidden = false
                                }
                            }
                            UIConstants.sharedDataEngine().stopLoadingAnimation()
                            self.vipCardListTableView.reloadData()
                            
                        }, failure: { (err) in
                            UIConstants.sharedDataEngine().stopLoadingAnimation()
                            CIASPublicUtility.showMyAlertView(forTaskInfo: err)
                        })
                    }
                })
            })
            return [deleteAction]
        }
        return nil
    }
    
}




