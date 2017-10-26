//
//  MovieDetailCommentCell.swift
//  KoMovie
//
//  Created by kokozu on 21/08/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit

import DateEngine_KKZ

class MovieDetailCommentCell: UITableViewCell {
    
    fileprivate let _headImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "avatarSImg.png"))
    fileprivate let _userNameLabel: UILabel = UILabel()
    fileprivate let _dateLabel: UILabel = UILabel()
    fileprivate let _commentLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 准备UI
    fileprivate func prepareUI() {
        //  头像
        _headImageView.frame = CGRect(x: 15, y: 17.5, width: 35, height: 35)
        _headImageView.layer.cornerRadius = 17.5
        _headImageView.layer.masksToBounds = true
        contentView.addSubview(_headImageView)
        
        //  用户昵称
        _userNameLabel.textColor = UIColor.black
        _userNameLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(_userNameLabel)
        _userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_headImageView.snp.right).offset(10)
            make.centerY.equalTo(_headImageView)
        }
        
        //  评论时间
        _dateLabel.textColor = UIColor.gray
        _dateLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(_dateLabel)
        _dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(_headImageView)
        }
        
        //  评论内容
        _commentLabel.textColor = UIColor(hex: "#999999")
        _commentLabel.font = UIFont.systemFont(ofSize: 14)
        _commentLabel.numberOfLines = 0
        contentView.addSubview(_commentLabel)
        _commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_headImageView)
            make.right.equalTo(_dateLabel)
            make.top.equalTo(65)
        }
        
        //  分割线
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor(hex: "#F2F2F2")
        contentView.addSubview(grayLine)
        grayLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
}

// MARK: - Public - Methods
extension MovieDetailCommentCell {
    func update(model: CPMovieComment?) {
        guard let n_model = model else { return }
        _headImageView.loadImage(withURL: n_model.userIcon.absoluteString, andSize: ImageSizeOrign, defaultImagePath: "")
        _userNameLabel.text = n_model.nickName
        _commentLabel.text = n_model.content
        _dateLabel.text = DateEngine.shared().formattedString(fromDateNew: n_model.createTime)
    }
}
