//
//  InTheatersMovieViewController.swift
//  CIASMovie
//
//  Created by Albert on 02/06/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit
import MJRefresh

/// 正在热映
class InTheatersMovieViewController: UIViewController, MovieListProtocol {
    
    var movieList: [Movie] = [Movie]()
    var selectedMovie: ((_ movie: Movie, _ posterView:UIView) -> ())?
    var refreshCallbck: (() -> ())?
    let headerContainer = UIView(frame: CGRect(x:0, y:0, width:ScreenWidth, height:180))
    var headerView: UIView?{
        willSet{
            if newValue == nil {
                headerView?.removeFromSuperview()
            }
        }
        didSet {
            if let head = headerView {
                headerContainer.addSubview(head)
                head.snp.makeConstraints({ (make) in
                    make.left.top.equalTo(0)
                    make.right.equalTo(headerContainer.snp.right)
                    make.height.equalTo(125)
                })
                tableView.reloadData()
                
            }
        }
    }
    let notifyLabel = UILabel()
    fileprivate var orderId:String?{
        didSet{
            // 如果修改了orderId则reload()
            if orderId != oldValue {
                self.tableView.reloadData()
            }
        }
    }
    
    let tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.mj_header = CPRefreshHeader(refreshingBlock: { [unowned self] in
            self.requestHomeOrder()
            self.requestMovieList()
            self.refreshCallbck?()
        })
        tableView.mj_header.beginRefreshing()
        
        let notifView = UIView()
        headerContainer.addSubview(notifView)
        notifView.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerContainer.snp.bottom)
            make.left.right.equalTo(headerContainer)
            make.height.equalTo(55)
        }
        let notififImage = UIImageView(image: #imageLiteral(resourceName: "push_icon"))
        notifView.addSubview(notififImage)
        notififImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(0)
        }
        notifyLabel.font = UIFont.systemFont(ofSize: 13)
        notifyLabel.textColor = UIColor(hex: "#333333")
        notifView.addSubview(notifyLabel)
        notifyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(notifView.snp.right).offset(-15)
            make.centerY.equalTo(notifView)
            make.left.equalTo(notififImage.snp.right).offset(15)
        }
        let arrow = UIImageView(image: #imageLiteral(resourceName: "home_more"))
        notifView.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.right.equalTo(notifView.snp.right).offset(-15)
            make.centerY.equalTo(notifView)
        }
        let tapG = UITapGestureRecognizer(target: self, action: #selector(tapHomeOrder))
        notifView.addGestureRecognizer(tapG)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 请求电影列表
    ///
    /// - Parameter page: 页码
    func requestMovieList() {
        MovieRequest().requestMovieListParams(["cinemaId":kCinemaId,"cityId":kCityId], success: { (list) in
            let list = list ?? []
            let newList:[Movie] = list.map{
                $0.isInTheater = true
                return $0
            }
            
            self.movieList = newList
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { (err) in
            
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    
    /// 请求首页订单
    func requestHomeOrder() {
        OrderRequest().requestHomeOrderParams(nil, success: { (respons) in
            self.orderId = nil
            guard let resp = respons as? [String: Any], resp["status"] as? String == "0", let data:[String:Any] = resp["data"] as? [String:Any] else {
                self.orderId = nil
                return
            }
            
            let count:Int = data["count"] as! Int
            let title = "亲，您有\(String(describing: count))张影票还未领取！"
            self.notifyLabel.text = title
            self.orderId = data["orderCode"] as? String
            
        }) { (err) in
            
            self.orderId = nil
            self.notifyLabel.text = "888888888888888888888"
        }
    }
    
    /// 点击首页订单提醒
    func tapHomeOrder() {
        let orderDetailVC = OrderDetailViewController()
        orderDetailVC.orderNo = self.orderId
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
}

extension InTheatersMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cell_id"
        var cell:MovieTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? MovieTableViewCell
        if cell == nil {
            cell = MovieTableViewCell()
        }
        
        let mv = movieList[indexPath.row]
        cell?.movie = mv
        cell?.buttonCallback = { [unowned self] movie in
            guard let movie:Movie = movie else {
                return
            }
            let planVC = XingYiPlanListViewController()
            planVC.movieId = movie.movieId
            planVC.cinemaId = kCinemaId
            Constants.isShowBackBtn = true
            self.navigationController?.pushViewController(planVC, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let movie = movieList[indexPath.row]
        return movie.discountTag == nil ? 120 : 157
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        if let callback = selectedMovie {
            callback(movieList[indexPath.row], cell.poster)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerContainer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.orderId == nil ? 125 : 180
    }
}
