//
//  CouponListCell.swift
//  CIASMovie
//
//  Created by avatar on 2017/7/7.
//  Copyright © 2017年 cias. All rights reserved.
//

import UIKit

class CouponListCell: UITableViewCell {

    
    @IBOutlet weak var couponBackImage: UIImageView!
    
    @IBOutlet weak var couponPriceLabel: UILabel!
    
    @IBOutlet weak var couponTipLabel: UILabel!
    
    @IBOutlet weak var couponTitleLabel: UILabel!
    
    @IBOutlet weak var couponTypeLabel: UILabel!
    
    @IBOutlet weak var couponDescribeLabel: UILabel!
    
    @IBOutlet weak var couponValidLabel: UILabel!
    
    @IBOutlet weak var couponValidValueLabel: UILabel!
    
    @IBOutlet weak var couponExpireBtn: UIButton!
    
    
    @IBOutlet weak var couponPriceLeft: NSLayoutConstraint!//37
    
    @IBOutlet weak var couponPriceTop: NSLayoutConstraint!//29
    
    @IBOutlet weak var couponTypeLeft: NSLayoutConstraint!//34
    
    @IBOutlet weak var couponTypeTop: NSLayoutConstraint!//37
    
    @IBOutlet weak var couponTitleLabelTop: NSLayoutConstraint!//16
    
    @IBOutlet weak var couponTitleLabelLeft: NSLayoutConstraint!//50
    
    @IBOutlet weak var couponDescribeLabelTop: NSLayoutConstraint!//5
    
    @IBOutlet weak var couponValidLabelTop: NSLayoutConstraint!//5
    
    @IBOutlet weak var couponExpireTop: NSLayoutConstraint!//5
    
    @IBOutlet weak var couponValidValueLabelTop: NSLayoutConstraint!//1
    
    @IBOutlet weak var couponTipLabelTop: NSLayoutConstraint!//3
    
    @IBOutlet weak var couponExpireBtnWitdh: NSLayoutConstraint!//45
    
    @IBOutlet weak var couponExpireBtnHeight: NSLayoutConstraint!//21
    
    @IBOutlet weak var couponDescribeLabelWitdh: NSLayoutConstraint!//150
    
    @IBOutlet weak var couponBackimageWidth: NSLayoutConstraint!//345
    
    @IBOutlet weak var couponBackImageHeight: NSLayoutConstraint!//109
    
    @IBOutlet weak var couponDescribeLabelHeight: NSLayoutConstraint!//24
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addLayoutConstraint()
    }
    
    fileprivate func addLayoutConstraint() {
        
        let couponBackImage = #imageLiteral(resourceName: "coupon_bg1")
        self.couponBackimageWidth.constant = couponBackImage.size.width*Constants.screenWidthRate
        self.couponBackImageHeight.constant = couponBackImage.size.height*Constants.screenHeightRate
        self.couponPriceLeft.constant = 37*Constants.screenWidthRate
        self.couponPriceTop.constant = 29*Constants.screenHeightRate
        self.couponTypeLeft.constant = 34*Constants.screenWidthRate
        self.couponTypeTop.constant = 37*Constants.screenHeightRate
        self.couponTitleLabelTop.constant = 13*Constants.screenHeightRate
        self.couponTitleLabelLeft.constant = 50*Constants.screenWidthRate
        self.couponDescribeLabelTop.constant = 5*Constants.screenHeightRate
        self.couponDescribeLabelHeight.constant = 24*Constants.screenHeightRate
        self.couponValidLabelTop.constant = 5*Constants.screenHeightRate
        self.couponExpireTop.constant = 5*Constants.screenHeightRate
        self.couponValidValueLabelTop.constant = 0.5*Constants.screenHeightRate
        self.couponTipLabelTop.constant = 3*Constants.screenHeightRate
        self.couponExpireBtnWitdh.constant = 45*Constants.screenWidthRate
        self.couponExpireBtnHeight.constant = 23*Constants.screenHeightRate
        self.couponDescribeLabelWitdh.constant = 150*Constants.screenWidthRate
        
        
        //    couponBackImage;
        self.couponPriceLabel.font = UIFont.systemFont(ofSize: 30*Constants.screenWidthRate)
        self.couponTipLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        self.couponTitleLabel.font = UIFont.systemFont(ofSize: 15*Constants.screenWidthRate)
        self.couponTypeLabel.font = UIFont.systemFont(ofSize: 30*Constants.screenWidthRate)
        self.couponDescribeLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        self.couponValidLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        self.couponValidValueLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        self.couponExpireBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13*Constants.screenWidthRate)
        self.couponExpireBtn.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
