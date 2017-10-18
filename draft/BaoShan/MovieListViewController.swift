//
//  MovieListViewController.swift
//  CIASMovie
//
//  Created by Albert on 01/06/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit
import SnapKit
import NSURL_QueryDictionary


@objc protocol MovieListProtocol: class {
    var movieList: [Movie] {get set}
    var selectedMovie: ((_ movie: Movie, _ posterView:UIView) -> ())? {get set}
    var headerView: UIView? {get set}
    var refreshCallbck:(() -> ())? {get set}
}

class MovieListViewController: UIViewController {
    
    let banner = CPBannerView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 125))
    
    var movieList = [Movie]()
    var movieListPage = 0
    var incomintMovieList = [Movie]()
    var incomintListPage = 0
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 160))
    let segmentedControl = UISegmentedControl(items: ["正在热映","即将上映"])
    
    var banners = [BannerNew]()
    
    let inTheaterVC = InTheatersMovieViewController()
    let commingSoonVC = CommingSoonMovieViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar = true
        hideBackBtn = true
        
        let navBar = UIView()
        navBar.backgroundColor = UIColor(hex: "0x333333")
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(64)
        }
        navBar.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(toggleMovieList), for: .valueChanged)
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(27)
            make.width.equalTo(180)
            make.bottom.equalTo(navBar.snp.bottom).offset(-10)
        }
        
        
        headerView.addSubview(banner)
        banner.setSelectCallback { [unowned self] (index) in
            let banner = self.banners[index]
            self.handleBanner(banner)
        }
        
        
        addChildViewController(inTheaterVC)
        inTheaterVC.didMove(toParentViewController: self)
        view.addSubview(inTheaterVC.view)
        inTheaterVC.view.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
        inTheaterVC.headerView = banner
        
        addChildViewController(commingSoonVC)
        view.addSubview(commingSoonVC.view)
        commingSoonVC.view.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
        commingSoonVC.view.isHidden = true
        
        let selectCallback:(Movie,UIView) -> () = { [unowned self] movie, poster in
            self.sf_targetView = poster
            let movieDetaileVC = MovieDetailViewController()
            movieDetaileVC.myMovie = movie
            movieDetaileVC.isReying = movie.isInTheater
            self.navigationController?.pushViewController(movieDetaileVC, animated: true)
        }
        
        let refreshCallback:() -> () = { [unowned self] in
            self.requestBanner()
        }
        
        inTheaterVC.selectedMovie = selectCallback
        commingSoonVC.selectedMovie = selectCallback
        inTheaterVC.refreshCallbck = refreshCallback
        commingSoonVC.refreshCallbck = refreshCallback
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.removeGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.addGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)
    }
    
    func requestBanner() {
        AppConfigureRequest().requestQueryBannerParams(["cinemaId":kCinemaId], success: { (banners) in
            self.banners = banners as! [BannerNew]
            self.banner.loadConten(withArr: self.banners)
        }) { (err) in
            print(err ?? "e")
        }
    }
    
    func toggleMovieList () {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            inTheaterVC.view.isHidden = false
            commingSoonVC.view.isHidden = true
            commingSoonVC.headerView = nil
            inTheaterVC.headerView = banner
        case 1:
            inTheaterVC.view.isHidden = true
            commingSoonVC.view.isHidden = false
            inTheaterVC.headerView = nil
            commingSoonVC.headerView = banner
        default:
            break
        }
    }
    
    
    /// 处理banner点击
    ///
    /// - Parameter banner: banner
    func handleBanner(_ banner: BannerNew) {
        
        guard let link = banner.slideUrl, link.characters.count > 0 else {
            return
        }
        
        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            let webVC = WebViewController()
            webVC.webViewTitle = banner.slideTitle
            webVC.requestURL = link
            self.navigationController?.pushViewController(webVC, animated: true)
            
            return
        }
        
        guard link.contains("/app/page?name="),
            let url = NSURL(string:link),
            let params = url.uq_queryDictionary(),                  // url query
            let pageName:String = params["name"] as? String,        // name
            let movieId:String = params["movie_id"] as? String      // movieId
            else {
                return
        }
        
        let cinemaId:String = params["cinema_id"] as? String ?? kCinemaId  // 是否存在cinema_id，没有的话用Defaults.cinemaID
        let ishot:Bool = (params["is_hot"] as? String ?? "") == "0"
        
        // 检查影院ID与用户的影院ID是否一致
        guard cinemaId != String(describing: kCinemaId)  else {
            return
        }
        
        switch pageName {
        case "movieDetail":
            // 影片详情
            UIConstants.sharedDataEngine().loadingAnimation()
            MovieRequest().requestMovieDetailParams(["cinemaId":cinemaId, "filmId":movieId], success: { (movie) in
                if let mv = movie {
                    let movieVC = MovieDetailViewController()
                    movieVC.isReying = ishot
                    movieVC.isHiddenAnimation = true
                    Constants.isHidAnimation = true
                    movieVC.myMovie = mv
                    self.navigationController?.pushViewController(movieVC, animated: true)
                }
                UIConstants.sharedDataEngine().stopLoadingAnimation()
                }, failure: { (err) in
                    UIConstants.sharedDataEngine().stopLoadingAnimation()
                    CIASPublicUtility.showAlertView(forTaskInfo: err)
            })
        case "moviePlan":
            let planVC = XingYiPlanListViewController()
            planVC.movieId = movieId
            planVC.cinemaId = cinemaId
            planVC.isFromBanner = true
            self.navigationController?.pushViewController(planVC, animated: true)
        default:
            print("banner link route failed")
        }
    }
    
}



