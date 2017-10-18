//
//  MovieTableViewCell.swift
//  CIASMovie
//
//  Created by Albert on 01/06/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    var buttonCallback:((Movie?) -> ())?
    var movie:Movie? {
        didSet{
            guard let mv = movie else {
                return
            }
            config(movie: mv)
        }
    }
    
    let poster = UIImageView()
    let movieName = UILabel()
    let plot = UILabel()
    let actors = UILabel()
    let button = UIButton(type: .custom)        // 购票
    let preButton = UIButton(type: .custom)     // 预售
    let format = UILabel()      // 电影支持格式
    let score = UILabel()
    let line:UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(hex: "0xe0e0e0")
        vi.isHidden = true
        return vi
    }()
    let promo:UILabel = {
        let la = UILabel()
        la.isHidden = true
        la.textColor = UIColor(hex: "#333333")
        la.font = UIFont.systemFont(ofSize: 13)
        return la
    }()
    let promoIcon: UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "hui_tag2"))
        im.isHidden = true
        return im
    }()
    
    var buTicketCallback:((Movie) -> ())?
    var trailerCallback:((Movie) -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        poster.layer.cornerRadius = 4
        poster.layer.masksToBounds = true
        self.addSubview(poster)
        poster.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.height.equalTo(90)
            make.width.equalTo(60)
        }
        
        movieName.textColor = UIColor(hex: "#333333")
        movieName.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(movieName)
        movieName.snp.makeConstraints { (make) in
            make.top.equalTo(poster.snp.top)
            make.left.equalTo(poster.snp.right).offset(15)
            make.right.equalTo(self.snp.right).offset(-70)
        }
        
        plot.textColor = UIColor(hex: "#b2b2b2")
        
        plot.font = UIFont.systemFont(ofSize: 12)
        addSubview(plot)
        plot.snp.makeConstraints { (make) in
            make.left.equalTo(movieName.snp.left)
            make.top.equalTo(movieName.snp.bottom).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
        }
        
        actors.textColor = UIColor(hex: "#cccccc")
        actors.font = UIFont.systemFont(ofSize: 10)
        addSubview(actors)
        actors.snp.makeConstraints { (make) in
            make.bottom.equalTo(poster.snp.bottom)
            make.left.equalTo(plot.snp.left)
            make.right.equalTo(self.snp.right).offset(-15 - 50 - 10)
        }
        
        addSubview(button)
        button.layer.borderWidth = K_ONE_PIXEL
        button.layer.borderColor = UIColor(hex: "#ff9900").cgColor
        button.setTitleColor(UIColor(hex: "#ff9900"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 4
        button.snp.makeConstraints { (make) in
            make.top.equalTo(78)
            make.right.equalTo(self.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: 50, height: 27))
        }
        addSubview(preButton)
        preButton.layer.borderWidth = K_ONE_PIXEL
        preButton.layer.borderColor = UIColor(hex: "#0099ff").cgColor
        preButton.setTitleColor(UIColor(hex: "#0099ff"), for: .normal)
        preButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        preButton.layer.cornerRadius = 4
        preButton.snp.makeConstraints { (make) in
            make.top.equalTo(78)
            make.right.equalTo(self.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: 50, height: 27))
        }
        
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        preButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        
        format.backgroundColor = UIColor.black
        format.font = UIFont.systemFont(ofSize: 12)
        format.layer.cornerRadius = 4
        format.layer.masksToBounds = true
        format.textColor = UIColor.white
        format.textAlignment = .center
        addSubview(format)
        format.isHidden = true
        
        score.backgroundColor = UIColor(hex: "0xfdcc02")
        score.font = UIFont.systemFont(ofSize: 12)
        score.layer.cornerRadius = 4
        score.layer.masksToBounds = true
        score.textColor = UIColor.black
        score.textAlignment = .center
        addSubview(score)
        score.isHidden = true
        
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).offset(-36)
            make.height.equalTo(K_ONE_PIXEL)
            make.left.equalTo(90)
        }
        
        addSubview(promo)
        addSubview(promoIcon)
        promoIcon.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        promo.snp.makeConstraints { (make) in
            make.left.equalTo(promoIcon.snp.right).offset(5)
            make.height.equalTo(promoIcon)
            make.right.equalTo(self.snp.right).offset(-10)
            make.centerY.equalTo(promoIcon)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(movie: Movie){
        if let posterURL = URL(string: movie.filmPoster) {
            poster.setImageWith(posterURL, placeholderImage: nil)
        }
        
        //根据演员列表，进行拼接，安卓的做法
        var actorsStr:String = ""
        for (_, value) in movie.filmPeoples.enumerated() {
            if let dic:[String:Any] = value as? [String:Any] {
                for (key, key_vale) in dic {
                    if key == "name" {
                        if let filePeople:String = key_vale as? String {
                            actorsStr.append(filePeople)
                            actorsStr.append("/")
                        }
                    }
                }
            }
        }
        
        var filmActors:String = ""
        if !actorsStr.isEmpty {
            //判断是否为空，否则index找不到
            let index_actor = actorsStr.index(actorsStr.endIndex, offsetBy: -1)
            filmActors = actorsStr.substring(to: index_actor)
        }

        movieName.text = movie.filmName
        plot.text = movie.note
        actors.text = filmActors
        score.text = movie.point
        score.sizeToFit()
        score.frame = CGRect(x: ScreenWidth - score.frame.size.width - 15 - 6, y: 15, width: score.frame.width + 6, height: 15)
        score.isHidden = movie.point.characters.count == 0
        format.text = movie.availableScreenType
        format.isHidden = movie.availableScreenType.characters.count == 0
        format.sizeToFit()
        format.frame = CGRect(x: ScreenWidth - format.frame.size.width - 15 - (score.isHidden ? 0 : score.frame.size.width - 4), y: 15, width: format.frame.size.width + 6, height: 15)
        
        if movie.discountTag != nil {
            line.isHidden = false
            promoIcon.isHidden = false
            promo.isHidden = false
            promo.text = movie.discountTag
        }else {
            line.isHidden = true
            promoIcon.isHidden = true
            promo.isHidden = true
        }
        
        if movie.isInTheater {
            if movie.isPresell == "1" {
                button.isHidden = true
                preButton.setTitle("预售", for: .normal)
                preButton.isHidden = false
            } else {
                button.isHidden = false
                button.setTitle("购票", for: .normal)
                preButton.isHidden = true
            }
        }  else {
            if movie.isPresell == "1" {
                button.isHidden = true
                preButton.setTitle("预售", for: .normal)
                preButton.isHidden = false
            } else {
                button.isHidden = true
                preButton.isHidden = true
            }
        }
        
        //同时被隐藏掉才不用考虑按钮
        if button.isHidden && preButton.isHidden {
            actors.snp.updateConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-15)
            }
        } else {
            actors.snp.updateConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-15 - 50 - 10)
            }
        }
    }
    
    
    func buttonClick() {
        buttonCallback?(movie)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
