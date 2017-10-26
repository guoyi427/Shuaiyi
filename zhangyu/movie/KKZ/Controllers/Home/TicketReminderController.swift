//
//  TicketReminderController.swift
//  KoMovie
//
//  Created by Albert on 11/01/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import Foundation
import DateEngine_KKZ
import UIColor_Hex_Swift
class TicketReminderController: NSObject {
    
    
    internal lazy var ticketView:TicketRemindView = TicketRemindView()
    internal lazy var container:UIView = UIView()
    internal var timer:Timer?
    internal var order:Order?
    
    /// 开场时间
    internal var movieDate:Date?
    static let shared = TicketReminderController()
    
    /// 检查是否有订单提醒
    ///
    /// - Parameters:
    ///   - show:  是否显示影票信
    ///   - hasOrder: 有无订单提醒, 有无新订单
    func checkRemindOrder(show:Bool, _ hasOrder: ((Bool, Bool)->Void)?)  {

        /// 当有影票信息时要显示影票，不再请求
        if let order = self.order, show {
            showTicket(order: order)
            hasOrder?(true, false)
            return
        }
        
        OrderRequest().requestOrderRemind({ (order) in
            
            guard let order = order else {
                self.order = nil
                hasOrder?(false, false)
                return
            }

            hasOrder?(true, !self.didShowOrder(orderID: order.orderId))
            self.order = order
            if show {
                self.showTicket(order: order)
            }
            
        }) { (err) in
            hasOrder?(false, false)
        }
    
    }
    
    /// 显示影票信息
    ///
    /// - Parameter order: 订单
    fileprivate func showTicket(order:Order?) {
        
        guard let ticket = order, let win = UIApplication.shared.keyWindow else {
            return
        }
        // 记下显示状态
        if didShowOrder(orderID: ticket.orderId) == false {
            store(orderID: ticket.orderId)
        }
        
        // 统计信息
        let event = KKZAnalyticsEvent(order: order)
        KKZAnalytics.postAction(event: event, action: .ticket_remind)
        
        container.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        container.addSubview(ticketView)
        ticketView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(container.snp.centerY).offset(-20)
            make.height.equalTo(350)
        }
        
        win.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(win)
        }
        let movieInfo = DateEngine.shared().string(fromDateYYYYMMDD: ticket.plan.movieTime) + " " + DateEngine.shared().weekDayXingQi(fromDateCP: ticket.plan.movieTime) + "  (" + ticket.plan.screenType + " " + ticket.plan.language + ")"
        ticketView.setTicketInfo(name: ticket.plan.movie.movieName,
                                 time: movieInfo,
                                 cinema: ticket.plan.cinema.cinemaName,
                                 seat: ticket.plan.hallName + " " + ticket.readableSeatInfos(),
                                 ticketCode: TicketReminderController.insertSpacesFormat(ticket.finalTicketNo),
                                 ticketCodeName: ticket.finalTicketNoName,
                                 authCode: TicketReminderController.insertSpacesFormat(ticket.finalVerifyCode),
                                 authCodeName: ticket.finalVerifyCodeName,
                                 posterURL:URL(string:ticket.plan.movie.pathVerticalS))
        //开场时间
        movieDate = ticket.plan.movieTime
        if (countDownString(date: movieDate) != nil) {
            
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
            
            timer = Timer(timeInterval: 1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }else{
            ticketView.updateCountdwon(str: titleString(str: nil))
            timer?.invalidate()
        }
        timerHandler()
        
        
        let btnClose = UIButton.init(type: .custom)
        btnClose.setBackgroundImage(#imageLiteral(resourceName: "close_btn.png"), for: .normal)
        container.addSubview(btnClose)
        btnClose.snp.makeConstraints { (make) in
            make.top.equalTo(ticketView.snp.bottom).offset(30)
            make.centerX.equalTo(container)
        }
        btnClose.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    /// dismiss
    @objc private func dismiss() {
        timer?.invalidate()
        timer = nil
        container.removeFromSuperview()
    }
    
    
    /// 倒计时
    ///
    /// - Parameter date: 未来时间
    /// - Returns: 倒计时描述 00:00:00
    private func countDownString(date:Date?) -> String? {
        
        guard let date = date else {
            return nil
        }
        
        let dateNow = Date()
        let second = date.timeIntervalSince1970 - dateNow.timeIntervalSince1970
        
        if second < 0 {
            return nil
        }
        
        let hour = UInt16(second / (60*60))
        let min = UInt16(second.truncatingRemainder(dividingBy: (60*60)) / 60)
        let sec = UInt16(second.truncatingRemainder(dividingBy: 60))
        let str = "\(NSString(format:"%02d",hour)):\(NSString(format:"%02d",min)):\(NSString(format:"%02d",sec))"
        
        debugPrint(str)
        
        return str
        
    }
    
    /// 提醒票根 标题
    ///
    /// - Parameter str: 倒计时 已开场传nil
    /// - Returns: 标题
    private func titleString(str:String?) -> NSAttributedString? {
        
        let result:NSMutableAttributedString!
        
        if let count = str {
            let pre = "距离开场时间还剩 "
            let tiTitle = pre + count
            result = NSMutableAttributedString(string: tiTitle)
            result.addAttributes([NSForegroundColorAttributeName : UIColor("#999999")], range: NSMakeRange(0, pre.characters.count))
            result.addAttributes([NSForegroundColorAttributeName : UIColor("#ff5301")], range: NSMakeRange(pre.characters.count, count.characters.count))
        }else{
            let ti = "已经开场"
            result = NSMutableAttributedString(string: ti)
            result!.addAttributes([NSForegroundColorAttributeName : UIColor("#999999")], range: NSMakeRange(0, ti.characters.count))
        }
        
        return result.copy() as? NSAttributedString
    }
    
    @objc private func timerHandler() {
        let str = countDownString(date: movieDate)
        ticketView.updateCountdwon(str: titleString(str: str))
    }
    
    
    /// 没4个字符加空格
    ///
    /// - Parameter string: origin string
    /// - Returns: sting with space
    public static func insertSpacesFormat(_ string : String?) -> String? {
        guard let string = string else {
            return nil
        }
        var newStr:String = ""
        var string_no_space = string.replacingOccurrences(of: " ", with: "")
        if string_no_space.characters.count == 0 {
            return nil
        }
        while string_no_space.characters.count > 0 {
            let len = string_no_space.characters.count
            let index = string_no_space.index(string_no_space.startIndex, offsetBy: min (len, 4))
            var subString = string_no_space.substring(to: index)
            if subString.characters.count == 4 {
                subString = subString + " "
            }
            newStr = newStr + subString
            let from = string_no_space.index(string_no_space.startIndex, offsetBy: min (len, 4))
            string_no_space = string_no_space.substring(from: from)
            
        }
        return newStr
    }
    
}

extension TicketReminderController {
    
    static private let KOrderRemind = "KOrderRemind"
    ///
    ///
    /// - Parameter orderID: 订单ID
    func store(orderID: String?)  {
        
        guard let order = orderID else {
            return
        }
        
        var orderList = Set<String>()
        let userDef = UserDefaults.standard
        if let orderIds = userDef.object(forKey: TicketReminderController.KOrderRemind) as? Set<String> {
            orderList = orderIds
        }
        orderList.insert(order)
        userDef.set(Array(orderList), forKey: TicketReminderController.KOrderRemind)
        userDef.synchronize()
    }
    
    /// 检查是否记录订单被查看
    ///
    /// - Parameter orderID: 订单ID
    /// - Returns: true：订单已被查看 false：订单没有被查看
    func didShowOrder(orderID: String?) -> Bool {
        guard let order = orderID, let orderIds = UserDefaults.standard.object(forKey: TicketReminderController.KOrderRemind) as? [String]  else {
            return false
        }
        
        return orderIds.contains(order)
    }
}

