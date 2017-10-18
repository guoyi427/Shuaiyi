//
//  DiscoverViewCell.swift
//  CIASMovie
//
//  Created by avatar on 2017/7/3.
//  Copyright © 2017年 cias. All rights reserved.
//

import Foundation



class DiscoverViewCell: UITableViewCell {
    
    @IBOutlet weak var discoverTitleLabel: UILabel!
    
    @IBOutlet weak var discoverImageView: UIImageView!
    
    @IBOutlet weak var discoverWriterLabel: UILabel!
    
    @IBOutlet weak var discoverReadLabel: UILabel!
    
    @IBOutlet weak var discoverTitleWitdh: NSLayoutConstraint!
    
    @IBOutlet weak var discoverImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var discoverImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var discoverTitleLeft: NSLayoutConstraint!
    
    @IBOutlet weak var discoverTitleTop: NSLayoutConstraint!
    
    @IBOutlet weak var discoverWriteBottom: NSLayoutConstraint!
    
    @IBOutlet weak var discoverImageViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var discoverImageViewRight: NSLayoutConstraint!
    
    @IBOutlet weak var discoverReadLeft: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.discoverImageView.layer.cornerRadius = 5.0
        self.discoverImageView.clipsToBounds = true
        
        //MARK: 添加约束
        self.addLayoutConstraint()
        
    }
    
    fileprivate func addLayoutConstraint() {
        
        self.discoverTitleWitdh.constant = 196*Constants.screenWidthRate //196
        self.discoverImageViewWidth.constant = 120*Constants.screenWidthRate//120
        self.discoverImageViewHeight.constant = 80*Constants.screenHeightRate//80
        self.discoverTitleLeft.constant = 8*Constants.screenWidthRate//8
        self.discoverTitleTop.constant = 8*Constants.screenHeightRate//8
        self.discoverWriteBottom.constant = 8*Constants.screenHeightRate//8
        self.discoverImageViewTop.constant = 8*Constants.screenHeightRate//8
        self.discoverImageViewRight.constant = -8*Constants.screenWidthRate//-8
        self.discoverReadLeft.constant = 20*Constants.screenWidthRate//20
        
        self.discoverTitleLabel.font = UIFont.systemFont(ofSize: 16*Constants.screenWidthRate)
        self.discoverWriterLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        self.discoverReadLabel.font = UIFont.systemFont(ofSize: 10*Constants.screenWidthRate)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
