//
//  TicketRemindView.swift
//  KoMovie
//
//  Created by Albert on 11/01/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift
import Kingfisher

class TicketRemindView: UIView {
    
    
    private var titleOpenTime:UILabel!
    private var movieNameLable:UILabel!
    private var timeLabel:UILabel!
    private var cinemaLable:UILabel!
    private var seatLabel:UILabel!
    private var poster:ImageView!
    private var ticketCodeLabelDes:UILabel!
    private var ticketCodeLabel:UILabel!
    private var authCodeLabelDes:UILabel!
    private var authCodeLabel:UILabel!
    private var codeView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup()  {
        self.backgroundColor = UIColor.clear
        let bg = #imageLiteral(resourceName: "ticket_remind_bg.png").stretchableImage(withLeftCapWidth: 20, topCapHeight: 65)
        
        let bgImageView = UIImageView(image: bg)
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        titleOpenTime = UILabel()
        titleOpenTime.textColor = UIColor("#999999")
        titleOpenTime.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(titleOpenTime)
        titleOpenTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(15)
        }
        
        poster = UIImageView()
        poster.contentMode = .scaleAspectFit
        self.addSubview(poster)
        poster.snp.makeConstraints { (make) in
            make.top.equalTo(75)
            make.width.equalTo(65)
            make.height.equalTo(92)
            make.right.equalTo(self.snp.right).offset(-20)
            
        }
        
        movieNameLable = UILabel()
        movieNameLable.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(movieNameLable)
        movieNameLable.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(75)
            make.right.equalTo(poster.snp.left).offset(-10)
        }
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor("#333333")
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(movieNameLable.snp.left)
            make.top.equalTo(movieNameLable.snp.bottom).offset(15)
            make.right.equalTo(movieNameLable)
        }
        
        cinemaLable = UILabel()
        cinemaLable.font = UIFont.systemFont(ofSize: 12)
        cinemaLable.textColor = UIColor("#333333")
        self.addSubview(cinemaLable)
        cinemaLable.snp.makeConstraints { (make) in
            make.left.equalTo(movieNameLable.snp.left)
            make.top.equalTo(timeLabel.snp.bottom).offset(7)
            make.right.equalTo(movieNameLable)
        }
        
        seatLabel = UILabel()
        seatLabel.font = UIFont.systemFont(ofSize: 12)
        seatLabel.textColor = UIColor("#333333")
        self.addSubview(seatLabel)
        seatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(movieNameLable.snp.left)
            make.top.equalTo(cinemaLable.snp.bottom).offset(7)
            make.right.equalTo(movieNameLable)
        }
        
        codeView = UIView()
        codeView.backgroundColor = UIColor("#f4f8fb")
        self.addSubview(codeView)
        codeView.snp.makeConstraints { (make) in
            make.top.equalTo(poster.snp.bottom).offset(40)
            make.height.equalTo(100)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        ticketCodeLabelDes = UILabel()
        ticketCodeLabelDes.font = UIFont.systemFont(ofSize: 12)
        ticketCodeLabelDes.textColor = UIColor("#939ea6")
        codeView.addSubview(ticketCodeLabelDes)
        
        ticketCodeLabel = UILabel()
        ticketCodeLabel.font = UIFont.systemFont(ofSize: 18)
        codeView.addSubview(ticketCodeLabel)
        
        authCodeLabelDes = UILabel()
        authCodeLabelDes.font = UIFont.systemFont(ofSize: 12)
        authCodeLabelDes.textColor = UIColor("#939ea6")
        codeView.addSubview(authCodeLabelDes)
        
        authCodeLabel = UILabel()
        authCodeLabel.font = UIFont.systemFont(ofSize: 18)
        codeView.addSubview(authCodeLabel)
        
        
    }
    
    func setTicketInfo(name:String?,
                       time:String?,
                       cinema:String?,
                       seat:String?,
                       ticketCode:String?,
                       ticketCodeName:String?,
                       authCode:String?,
                       authCodeName:String?,
                       posterURL:URL?){
        
        movieNameLable.text = name
        timeLabel.text = time
        cinemaLable.text = cinema
        seatLabel.text = seat
        ticketCodeLabelDes.text = ticketCodeName
        authCodeLabelDes.text = authCodeName
        if let posURL = posterURL {
            poster.kf.setImage(with: posURL)
        }


        
        /// 取票号和验证码
        if let tiCode = ticketCode, let auCode = authCode {
            
            ticketCodeLabel.text = tiCode
            authCodeLabel.text = auCode
            
            ticketCodeLabelDes.isHidden = false
            ticketCodeLabelDes.snp.remakeConstraints({ (make) in
                make.left.top.equalTo(25)
                make.width.equalTo(38)
                make.height.equalTo(18)
            })
            
            ticketCodeLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(ticketCodeLabelDes.snp.right).offset(15)
                make.centerY.equalTo(ticketCodeLabelDes)
                make.height.equalTo(ticketCodeLabelDes)
                make.right.equalTo(-10)
            })
            
            authCodeLabelDes.isHidden = false
            authCodeLabelDes.snp.remakeConstraints({ (make) in
                make.left.equalTo(ticketCodeLabelDes)
                make.top.equalTo(ticketCodeLabelDes.snp.bottom).offset(16)
                make.width.equalTo(38)
                make.height.equalTo(18)
            })
            authCodeLabel.isHidden = false
            authCodeLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(authCodeLabelDes.snp.right).offset(15)
                make.centerY.equalTo(authCodeLabelDes)
                make.height.equalTo(authCodeLabelDes)
                make.right.equalTo(-10)
            })
            
        }else if let tiCode = ticketCode {
            ticketCodeLabel.text = tiCode
            ticketCodeLabelDes.isHidden = false
            ticketCodeLabelDes.snp.remakeConstraints({ (make) in
                make.left.equalTo(25)
                make.centerY.equalTo(codeView)
                make.width.equalTo(38)
                make.height.equalTo(18)
            })
            ticketCodeLabel.isHidden = false
            ticketCodeLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(ticketCodeLabelDes.snp.right).offset(15)
                make.centerY.equalTo(ticketCodeLabelDes)
                make.height.equalTo(ticketCodeLabelDes)
                make.right.equalTo(-10)
            })
            authCodeLabelDes.isHidden = true
            authCodeLabel.isHidden = true
        }else if let auCode = authCode{
            authCodeLabel.text = auCode
            authCodeLabelDes.isHidden = false
            authCodeLabelDes.snp.remakeConstraints({ (make) in
                make.left.equalTo(25)
                make.centerY.equalTo(codeView)
                make.width.equalTo(38)
                make.height.equalTo(18)
            })
            authCodeLabel.isHidden = false
            authCodeLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(authCodeLabelDes.snp.right).offset(15)
                make.centerY.equalTo(authCodeLabelDes)
                make.height.equalTo(authCodeLabel)
                make.right.equalTo(-10)
            })
            ticketCodeLabelDes.isHidden = true
            ticketCodeLabel.isHidden = true
        }
        
    }
    
    /// 更新倒计时
    ///
    /// - Parameter str: 倒计时
    func updateCountdwon(str:NSAttributedString?){
        
        titleOpenTime.attributedText = str
    
    }
    
    override func draw(_ rect: CGRect) {
        
        /// 分割线
        let layerLine = CAShapeLayer()
        layerLine.frame = CGRect(x: 10, y: 45, width: rect.width - 20, height: 2)
        layerLine.fillColor = UIColor.clear.cgColor
        layerLine.strokeColor = UIColor("#e2e2e2").cgColor
        layerLine.lineWidth = 1
        layerLine.lineJoin = kCALineJoinRound
        layerLine.lineDashPattern = [4,2]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: layerLine.frame.size.width, y: 0))
        layerLine.path = path
        
        self.layer.addSublayer(layerLine)
    }
    
}


