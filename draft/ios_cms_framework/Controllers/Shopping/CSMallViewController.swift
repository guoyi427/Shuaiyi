//
//  CSMallViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/5/8.
//  Copyright © 2017年 cias. All rights reserved.
//

import UIKit
import SnapKit

class CSMallViewController: UIViewController {
    // 导航条
    fileprivate let _navibar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 69))
    fileprivate let _navibarLine = UIView.init(frame: CGRect(x: 0, y: 68.5, width: kScreenWidth, height: 0.5))
    
    fileprivate let _naviSegment = UISegmentedControl.init(items: ["观影小吃","衍生品"])
    
    fileprivate let _snackViewController = SnacksViewController()
    fileprivate let _saleViewController = SaleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString(hex: "#ffffff")
        //MARK: 设置导航栏
        hideNavigationBar = true
        _setUpNavBar()
        _setUpBodyUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.view.removeGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer)!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.view.addGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer)!)
    }
    
    //MARK: 设置UI
    fileprivate func _setUpBodyUI() {
        self.addChildViewController(_snackViewController)
        view.addSubview(_snackViewController.view)
        self.addChildViewController(_saleViewController)
        view.addSubview(_saleViewController.view)
        _snackViewController.view.isHidden = false
        _saleViewController.view.isHidden = true
        view.bringSubview(toFront: _navibar)
    }
    
    
    
    //MARK: 设置navBar
    fileprivate func _setUpNavBar() {
        _navibar.setBackgroundImage(UIImage.init(color: UIColor.colorWithHexString(hex: "#333333"), size: CGSize.init(width: kScreenWidth, height: 69)), for: .any, barMetrics: .default)
        _navibar.alpha = 1.0
        
        _naviSegment.frame = CGRect(x: (kScreenWidth-180)/2, y:30, width:180, height:27)
        _naviSegment.selectedSegmentIndex = 0 //默认选择项索引
        _naviSegment.tintColor = UIColor.white
        _navibar.addSubview(_naviSegment)
        _naviSegment.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        
        _navibarLine.backgroundColor = UIColor.cs_e0Line()
        _navibar.addSubview(_navibarLine)
        view.addSubview(_navibar)
    }
    
    @objc  func segmentChange(_ segment:UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            _snackViewController.view.isHidden = false
            _saleViewController.view.isHidden = true
//            print("选中第一个了")
        } else {
            _snackViewController.view.isHidden = true
            _saleViewController.view.isHidden = false
//            print("选中第二个了")
        }
    }
}

