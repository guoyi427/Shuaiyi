//
//  MovieTimeView.swift
//  KoMovie
//
//  Created by Albert on 16/02/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift

class MovieTimeView: UIControl {
    
    var movieTime:String = "" {
        didSet {
           self.timeLabel.text = movieTime
        }
    }
    var movieType:String = "" {
        didSet{
            typeLabel.text = movieType
        }
    }
    
    var price:String = "" {
        didSet{
            priceLabel.text = price
        }
    }
    
    /// 是否显示优惠标签
    var showOfferIcon = false {
        didSet{
            if showOfferIcon == true, self.offerIcon.superview == nil {
                self.addSubview(self.offerIcon)
                self.offerIcon.snp.makeConstraints({ (make) in
                    make.right.equalTo(self.snp.right).offset(2)
                    make.top.equalTo(-2)
                    make.width.height.equalTo(15)
                })
            }
        }
    }
    
    private let timeLabel = UILabel()
    private let typeLabel = UILabel()
    private let priceLabel = UILabel()
    private lazy var offerIcon:UIImageView = {
        return UIImageView(image: UIImage(named:"offer_icon"))
    }()
    
    public var select: ((_ target: MovieTimeView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        
        self.backgroundColor = UIColor.clear
        
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = UIColor(hex: "#333333")
        timeLabel.textAlignment = NSTextAlignment.center
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(14)
            make.left.equalTo(0)
            make.top.equalTo(8)
        }
        typeLabel.font = UIFont.systemFont(ofSize: 10)
        typeLabel.textColor = UIColor(hex: "#999999")
        typeLabel.textAlignment = NSTextAlignment.center
        self.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.width.equalTo(self)
            make.left.equalTo(0)
            make.top.equalTo(timeLabel.snp.bottom).offset(7)
        }
        priceLabel.font = UIFont.systemFont(ofSize: 11)
        priceLabel.textColor = UIColor(hex: "#FF6900")
        priceLabel.textAlignment = NSTextAlignment.center
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(13)
            make.left.equalTo(0)
        }
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(MovieTimeView.tapHandler))
        
        self.addGestureRecognizer(tapGes)
        
    }
    
    func tapHandler() {
        if let select = self.select {
            select(self)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let borderLayer = CALayer()
        borderLayer.frame = self.bounds
        self.layer.insertSublayer(borderLayer, at: 0)
        
        borderLayer.borderColor = UIColor(hex: "#eaeaea").cgColor
        borderLayer.cornerRadius = 5
        borderLayer.borderWidth = 1/UIScreen.main.scale
    }

}
