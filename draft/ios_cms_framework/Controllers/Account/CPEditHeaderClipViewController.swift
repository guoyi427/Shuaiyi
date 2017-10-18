//
//  CPEditHeaderClipViewController.swift
//  Cinephile
//
//  Created by kokozu on 2017/2/10.
//  Copyright © 2017年 Kokozu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class CPEditHeaderClipViewController: UIViewController, UIScrollViewDelegate {
    
    /// 原图
    var originImage: UIImage
    /// 剪裁视图
    let croperView = CPCropperView()
    let finishCallback: (UIImage)->Void?
    
    init(image: UIImage, callback:@escaping (UIImage)->Void) {
        originImage = image
        finishCallback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:     Prepare
    
    fileprivate func _prepareUI() {
        //  topBar height
        let height_topBar:CGFloat = 0//40
        
        view.backgroundColor = UIColor.black
        /*
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: height_topBar))
        topBar.backgroundColor = UIColor(hex: "#2b2b2b")
        view.addSubview(topBar)
        //  返回按钮
        let popButton = UIButton(type: .custom)
        popButton.frame = CGRect(x: 0, y: 0, width: height_topBar, height: height_topBar)
        popButton.setImage(#imageLiteral(resourceName: "back_bar_item.png"), for: .normal)
        popButton.addTarget(self, action: #selector(popButtonAction), for: .touchUpInside)
        topBar.addSubview(popButton)
        */
        //  剪裁视图
        croperView.frame = CGRect(x: 0, y: height_topBar,
                                  width: view.bounds.width,
                                  height: view.bounds.height-height_topBar)
        croperView.image = originImage
        croperView.cropSize = CGSize(width: 256, height: 256)
        croperView.cropsImageToCircle = true
        croperView.cropDisplayOffset = UIOffset(horizontal: 0, vertical: -30)
        view.addSubview(croperView)
        
        //  确定视图
        let bottomBar = UIView(frame: CGRect(x: 0, y: view.bounds.height - 44, width: view.bounds.width, height: 44))
        bottomBar.backgroundColor = UIColor(hex: "#ffffff", a: 1.0)
        view.addSubview(bottomBar)
        
        let btnTitles = ["取消","确定"]
        let selectorList = [#selector(cancelButtonAction), #selector(finishButtonAction)]
        let frameList = [CGRect(x: 15, y: 0, width: 44, height: 44), CGRect(x: bottomBar.bounds.width-44-15, y: 0, width: 44, height: 44)]
        for i in 0 ..< 2 {
            let button = UIButton(type: .custom)
            button.frame = frameList[i]
            button.setTitleColor(UIColor(hex:"#249cf8"), for: .normal)
            button.setTitle(btnTitles[i], for: .normal)
            button.addTarget(self, action: selectorList[i], for: .touchUpInside)
            bottomBar.addSubview(button)
        }
        
        
    }
    
    //MARK      Button - Action
    
    /// 返回按钮
    @objc fileprivate func popButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func finishButtonAction() {
        croperView.renderCroppedImage { (croperImage, croperFrame) in
            if croperImage != nil {
                self.finishCallback(croperImage!)
            }
        }
    }
    
    
}
