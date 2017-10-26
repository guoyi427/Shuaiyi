//
//  CinemaPromotionCell.swift
//  KoMovie
//
//  Created by Albert on 22/02/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SnapKit

class CinemaPromotionCell: UITableViewCell {
    
    var title:String = "" {
        didSet{
            labelTitle.text = title
        }
    }
    
    var showBootomLine = true {
        didSet{
            self.line.isHidden = !showBootomLine
        }
    }
    
    private let labelTitle = UILabel()
    private let line:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hex: "0xebebeb")
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setup() {
        let labelPre = UILabel()
        labelPre.text = "特惠"
        self.addSubview(labelPre)
        labelPre.textColor = UIColor(hex: "#57c45D")
        labelPre.font = UIFont.systemFont(ofSize: 13)
        labelPre.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        
        labelTitle.font = UIFont.systemFont(ofSize: 13)
        labelTitle.textColor = UIColor(hex: "#999999")
        labelTitle.text = title
        self.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(labelPre.snp.right).offset(10)
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp.right).offset(-15)
        }
        
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(1/(UIScreen.main.scale))
            make.bottom.equalTo(self.snp.bottom).offset(-1/(UIScreen.main.scale))
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
