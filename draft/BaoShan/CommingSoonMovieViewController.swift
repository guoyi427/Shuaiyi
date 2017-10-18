//
//  CommingSoonMovieViewController.swift
//  CIASMovie
//
//  Created by Albert on 02/06/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit
import MJRefresh

/// 即将上映
class CommingSoonMovieViewController: UIViewController, MovieListProtocol {
    
    var movieList: [Movie] = [Movie]()
    var selectedMovie: ((Movie, UIView) -> ())?
    var refreshCallbck: (() -> ())?
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
            }
        }
    }
    var movieListPage:Int = 1
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var dateList: [String] = []
    let dateView = MovieDateView()
    let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 160))
    // movieList 日期缓存
    private var movieListTemp:[String:[Movie]] = [String:[Movie]]()
    private var currenDateIndex = 1
    
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
        // pull down refresh
        tableView.mj_header = CPRefreshHeader(refreshingBlock: { [unowned self] in
            self.movieListPage = 0
            self.requestDateList(){ [unowned self] in
                self.requestMovieList(dateIndex: self.currenDateIndex)
            }
            self.refreshCallbck?()
            
        })
        tableView.mj_header.beginRefreshing()
//        // load more
//        tableView.mj_footer = CPRefreshFooter(refreshingBlock: { [unowned self] in
//            self.movieListPage += 1
//            self.requestMovieList(self.movieListPage)
//            
//        })
        headerContainer.addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerContainer.snp.bottom)
            make.left.equalTo(0)
            make.width.equalTo(headerContainer)
            make.height.equalTo(35)
        }
        dateView.selectedCallback = { [unowned self] index in
            self.movieListPage = 1
            self.currenDateIndex = index
            // 先检查是否存在缓存数据
            if let list = self.movieListTemp[self.dateList[index]] {
                self.movieList = list
                self.tableView.reloadData()
            }else {
                self.requestMovieList(dateIndex: index)
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func requestDateList( _ success:@escaping  ()->()) {
        MovieRequest().requestIncomingMovieDateListParams(nil, success: { (list) in
            if let dateList = list , dateList.count > 0 {
                self.dateList.removeAll()
                self.dateList += ["全部"]
                self.dateList += (dateList as! [String])
                self.dateView.dateList = self.dateList
                
                success()
            }
        }) { (err) in
            
        }
    }
    
    func requestMovieList(dateIndex: Int = 0) {
        
        let date = (dateIndex == 0 || dateList.count == 0) ? "all" : dateList[dateIndex]
        
        MovieRequest().requestIncomingMovieListParams(["publishDate":date], success: { (list) in
            self.movieList = list as! [Movie]
            self.movieListTemp[self.dateList[dateIndex]] = list as? [Movie]
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { (err) in
            self.tableView.mj_header.endRefreshing()
        }
    }
}

extension CommingSoonMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cell_id"
        var cell:MovieTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? MovieTableViewCell
        if cell == nil {
            cell = MovieTableViewCell()
        }
        
        let mv = movieList[indexPath.row]
        cell?.movie = mv
        if mv.isPresell == "1" {
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
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        return 160
    }
}
