//
//  SaleViewController.swift
//  CIASMovie
//
//  Created by avatar on 2017/5/11.
//  Copyright © 2017年 cias. All rights reserved.
//


import UIKit
import SnapKit

class SaleViewController: UIViewController, UISearchBarDelegate {
    
    fileprivate let _mallSearchbar = CSSearchBar()
    fileprivate let _topSearchView = UIView()//搜索框
    fileprivate let _topSortView = UIView()//综合，销量，价格等
    fileprivate let _topCategoryView = UIView()//有货，电影系列，模型/手办
    fileprivate let _multipleBtn = UIButton(type: .custom)//综合按钮
    fileprivate let _saleCountBtn = UIButton(type: .custom)//销量排序按钮
    fileprivate let _salePriceBtn = UIButton(type: .custom)//价格排序按钮
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString(hex: "#669966")
        //MARK: 设置导航栏
        hideNavigationBar = true
        _setTopSearchView()//搜索栏
        _setTopSortView()//
        
    }
    
    fileprivate func _setTopSearchView() {
        _topSearchView.backgroundColor = UIColor.white
        view.addSubview(_topSearchView)
        _topSearchView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(69)
            make.height.equalTo(44)
        }
        _mallSearchbar.delegate = self
        _mallSearchbar.placeholder = "输入商品名称或者拼音"
        _mallSearchbar.backgroundColor = UIColor.colorWithHexString(hex: "#f2f4f5")
        _mallSearchbar.layer.cornerRadius = 13.5
        _mallSearchbar.clipsToBounds = true
//        _mallSearchbar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "searchbar.png"), for: .normal)//searchbar.png
//        _mallSearchbar.setBackgroundImage(#imageLiteral(resourceName: "searchBarViewBg.png"), for: .any, barMetrics: .default)//searchBarViewBg.png
        _topSearchView.addSubview(_mallSearchbar)
        _mallSearchbar.snp.makeConstraints { (make) in
            make.left.equalTo(_topSearchView.snp.left).offset(15)
            make.right.equalTo(_topSearchView.snp.right).offset(-15)
            make.top.equalTo(_topSearchView.snp.top).offset(8)
            make.height.equalTo(28)
        }
        let lineView = UIView()
        lineView.backgroundColor = UIColor.cs_e0Line()
        _topSearchView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(_topSearchView)
            make.top.equalTo(43)
            make.height.equalTo(1)
        }
    }
    
    fileprivate func _setTopSortView() {
        _topSortView.backgroundColor = UIColor.white
        view.addSubview(_topSortView)
        _topSortView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(_topSearchView.snp.bottom).offset(0)
            make.height.equalTo(35)
        }
        _multipleBtn.setTitle("综合", for: .normal)
        _multipleBtn.setTitleColor(UIColor.colorWithHexString(hex: "#ff9900"), for: .selected)
        _multipleBtn.setTitleColor(UIColor.colorWithHexString(hex: "#ff9900"), for: .highlighted)
        _multipleBtn.setTitleColor(UIColor.colorWithHexString(hex: "#b2b2b2"), for: .normal)
        _multipleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _multipleBtn.backgroundColor = UIColor.clear
        _multipleBtn.addTarget(self, action: #selector(multipleBtnClick(_:)), for: .touchUpInside)
        _topSortView.addSubview(_multipleBtn)
        _multipleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(_topSortView.snp.left).offset(30)
            make.centerY.equalTo(_topSortView.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(14)
        }
        _multipleBtn.isSelected = true
        _multipleBtn.isUserInteractionEnabled = false

    }
    
    @objc func multipleBtnClick(_ sender:UIButton) {
//        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            _multipleBtn.isUserInteractionEnabled = false
             print("选中状态")
            
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}
