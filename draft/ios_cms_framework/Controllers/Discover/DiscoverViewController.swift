//
//  DiscoverViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/7/3.
//  Copyright © 2017年 cias. All rights reserved.
//

import Foundation
import SnapKit
import NSURL_QueryDictionary
import MJRefresh


class DiscoverViewController:UIViewController {
    
    
    fileprivate var pageNum:Int = 1
    
    fileprivate let _discoverListArr = NSMutableArray(capacity: 0)
    
    fileprivate let  _discoverTableView = UITableView(frame: CGRect(x: 0, y: 69, width: ScreenWidth, height: ScreenHeight - 69 - 49), style: .plain)
    
    fileprivate let noArticleListAlertView : UIView = {
        
        let noArticleAlertImage = #imageLiteral(resourceName: "empty")
        let noArticleAlertStr = "还没有任何资讯"
        let noArticleAlertStrSize = KKZTextUtility.measureText(noArticleAlertStr, size: CGSize(width: 500, height:500), font: UIFont.systemFont(ofSize: 15*Constants.screenWidthRate))
        let tmpView = UIView(frame: CGRect(x:0.283*ScreenWidth,y:0.277*ScreenHeight,width:noArticleAlertImage.size.width,height:noArticleAlertStrSize.height+noArticleAlertImage.size.height+15*Constants.screenWidthRate))
        let noArticleAlertImageView = UIImageView()
        tmpView.addSubview(noArticleAlertImageView)
        noArticleAlertImageView.image = noArticleAlertImage
        noArticleAlertImageView.contentMode = .scaleAspectFill
        noArticleAlertImageView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(tmpView)
            make.height.equalTo(noArticleAlertImage.size.height)
        })
        let noArticleAlertLabel = UILabel()
        tmpView.addSubview(noArticleAlertLabel)
        noArticleAlertLabel.text = noArticleAlertStr
        noArticleAlertLabel.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        noArticleAlertLabel.textAlignment = .center
        noArticleAlertLabel.textColor = UIColor(hex: "0xb2b2b2")
        noArticleAlertLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(tmpView)
            make.top.equalTo(noArticleAlertImageView.snp.bottom).offset(15*Constants.screenWidthRate)
            make.height.equalTo(noArticleAlertStrSize.height)
        })
        
        return tmpView
    }()
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.view.addGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if K_HENGDIAN
            UIApplication.shared.setStatusBarStyle(.default, animated: false)
        #endif
        navigationController?.view.removeGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar = true
        
        let navBar = UIView()
        #if K_HENGDIAN
            navBar.backgroundColor = UIColor(hex: "#ffffff")
        #else
            navBar.backgroundColor = UIColor(hex: "0x333333")
        #endif
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(64)
        }
        
        let narTitleLabel = UILabel()
        #if K_HENGDIAN
            narTitleLabel.textColor = UIColor.black
        #else
            narTitleLabel.textColor = UIColor.white
        #endif
        narTitleLabel.textAlignment = .center
        narTitleLabel.text = "资讯"
        narTitleLabel.font = UIFont.systemFont(ofSize: 18)
        navBar.addSubview(narTitleLabel)
        narTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(70)
            make.width.equalTo(ScreenWidth-140)
            make.height.equalTo(44)
        }
        
        #if K_HENGDIAN
            let redLineView = UIView(frame: CGRect(x: 0, y: 63, width: ScreenWidth, height: 1))
            redLineView.backgroundColor = UIColor(hex: UIConstants.sharedDataEngine().lumpColor)
            navBar.addSubview(redLineView)
        #endif
        
        view.addSubview(self._discoverTableView)
        self._discoverTableView.register(UINib.init(nibName: "DiscoverViewCell", bundle: nil), forCellReuseIdentifier: "DiscoverViewCell")
        
        self._discoverTableView.delegate = self
        self._discoverTableView.dataSource = self
        self._discoverTableView.showsVerticalScrollIndicator = false
        self._discoverTableView.backgroundColor = UIColor.white
        self._discoverTableView.separatorStyle = .none
        self._discoverTableView.decelerationRate = 0.1
        self._discoverTableView.mj_header = CPRefreshHeader(refreshingBlock: { 
            [unowned self] in
            
            self.pageNum = 1
            self.requestArticleList(page: self.pageNum, pageSize: 10)
        })
        //开始刷新
        self._discoverTableView.mj_header.beginRefreshing()
        
        self._discoverTableView.mj_footer = CPRefreshFooter(refreshingBlock: { 
            [unowned self] in
            self.pageNum += 1
            self.requestArticleList(page: self.pageNum, pageSize: 10)
        })
        
    }
    
    fileprivate func requestArticleList(page:Int , pageSize: Int)   {
        UIConstants.sharedDataEngine().loadingAnimation()
        
        AppConfigureRequest().requestArticleListParams(["pageNumber" : page, "pageSize" : pageSize], success: { [unowned self] (response) in
            if page == 1 {
                self.endRefreshing()
                if self._discoverListArr.count > 0 {
                    self._discoverListArr.removeAllObjects()
                }
            } else {
                self.endLoadMore()
            }
            // 解析数据到数组中
            if let articleList = response?.rows {
                self._discoverListArr.addObjects(from: articleList)
            }
            
            //判断数组的数量，进行UI调整
            if self._discoverListArr.count > 0 {
                self._discoverTableView.mj_footer.state = .idle
                if page == 1 {
                    self._discoverTableView.setContentOffset(CGPoint(x: 0, y: -69), animated: true)
                }
                if (self.noArticleListAlertView.superview != nil) {
                    self.noArticleListAlertView.removeFromSuperview()
                }
            } else {
                self._discoverTableView.mj_footer.state = .noMoreData
                if (self.noArticleListAlertView.superview != nil) {
                } else {
                    self._discoverTableView.addSubview(self.noArticleListAlertView)
                }
            }
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            self._discoverTableView.reloadData()
            
        }) { (err) in
            UIConstants.sharedDataEngine().stopLoadingAnimation()
            if page == 1 {
                self.endRefreshing()
            } else {
                self.endLoadMore()
            }
            if (self.noArticleListAlertView.superview != nil) {

            } else {
                self._discoverTableView.addSubview(self.noArticleListAlertView)
            }
        }
    }
    
    func endRefreshing() {
        if self._discoverTableView.mj_header.isRefreshing() {
            self._discoverTableView.mj_header.endRefreshing()
        }
    }
    
    func endLoadMore() {
        if self._discoverTableView.mj_footer.isRefreshing() {
            self._discoverTableView.mj_footer.endRefreshing()
        }
    }
    
    
}


extension DiscoverViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "DiscoverViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! DiscoverViewCell
        
        let discover:ArticleList = self._discoverListArr[indexPath.row] as! ArticleList
        
        cell.discoverTitleLabel.text = discover.title
        cell.discoverWriterLabel.text = discover.publisher
        cell.discoverReadLabel.text = "\(discover.hits.intValue)"
        let placeholderImage = UIImage.centerResize(from: #imageLiteral(resourceName: "photo_nopic"), newSize: cell.discoverImageView.frame.size, bgColor: UIColor(hex: "#f2f4f5", a: 0.9))
        var urlStr = ""
        
        if discover.cover.hasPrefix("http://") || discover.cover.hasPrefix("https://") {
            urlStr = discover.cover
        }
        
        cell.discoverImageView.sd_setImage(with: CIASPublicUtility.getUrlDeleteChinese(with: urlStr), placeholderImage: placeholderImage)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._discoverListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 96*Constants.screenHeightRate + 14
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article:ArticleList = (self._discoverListArr[indexPath.row] as? ArticleList)!
        
        let linkUrlStr:String = article.url
        if linkUrlStr.hasPrefix("http://")||linkUrlStr.hasPrefix("https://") {
            let webVc = WebNewViewController()
            webVc.webViewTitle = article.title
            webVc.requestURL = article.url
            self.navigationController?.pushViewController(webVc, animated: true)
        }
        
    }

    
}
