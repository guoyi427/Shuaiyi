//
//  KKZAnalytics.swift
//  KoMovie
//
//  Created by Albert on 05/01/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import Foundation
import Category_KKZ
import DateEngine_KKZ
import KKZExtension
/*
dev：http://192.168.2.71:8085/gatherer/gymf/data.do
beta：http://139.224.196.246:8085/gatherer/gymf/data.do
prod: http://log.moviebigdata.com:8085/gatherer/gymf/data.do
 suilt:
    dev:1VIBXdNuDag8X3yz
    prod:hZh4BioJrZP45vkk
 */
let AnalyticsURL = "http://log.moviebigdata.com:8085/gatherer/gymf/data.do"
let AnalyticsSalt = "hZh4BioJrZP45vkk"

@objc public enum AnalyticsAction: Int, RawRepresentable {
    
    // MARK: - 影片相关
    case attention_film
    case comment_voice
    case comment_text
    case film_like
    case film_unlike
    case operation_banner
    case operation_buy
    case ticket_remind
    
    
    // MARK: - 选座购票
    case homepage_buy
    case chooseseat_buy
    case confirm_order
    
    // MARK: - 订单
    case confirm_pay
    case alipay_only
    case wechat_only
    case ebank_only
    case yipay_only
    case balance_only
    case alipaye_favorable
    case wechat_favorable
    case ebank_favorable
    case yipay_favorable
    case balance_favorable
    case user_location
    case user_time
    case payorder_ios
    case payorder_pc
    case payorder_wap
    case order_tickets
    
    // MARK: - 电影
    case showing_film
    case future_show_film
    case film_details
    case actor_list
    case video_list
    case still_list
    case music_list
    case comment_list
    case comment_details
    
    // MARK: - 影院
    case cinema_list
    case cinema_details
    case cinema_introduce
    case cinema_photo
    case cinema_film_list_today
    case cinema_film_list_tomorrow
    case cinema_film_list_after_tomorrow
    case cinema_film_list_shade
    
    // MARK: - 选座
    case choose_seat
    case pay_order
    case pay_success
    case pay_fail
    
    // MARK: - 发现
    case news_list
    case news_details
    case operation_list
    case operation_details
    
    // MARK: - 周边
    case product_list
    case product_details
    case shopping_cart
    case order_confirm
    case derivative_pay_success
    case derivative_pay_fail
    
    // MARK: - 我的
    case my
    case message_list
    case message_details
    case my_attention
    case my_fans
    case order_manage
    case ticket_manage
    case derivative_order
    case ticket_order_details
    case derivative_order_details
    case stay_comment_list
    
    
    case undefined
    
    public typealias RawValue = String
    
    public var rawValue: RawValue{
        switch self {
        // MARK: - 影片相关
        case .attention_film:           return "attention-film" //关注影片
        case .comment_voice:            return "comment-voice"    //吐槽-语音
        case .comment_text:             return "comment-text"  //吐槽-图文
        case .film_like:                return "film-like"    //影片-喜欢
        case .film_unlike:              return "film-unlike" //影片-不喜欢
        case .operation_banner:         return "operation-banner"  //运营活动banner
        case .operation_buy:            return "operation-buy"    //活动页面的特惠购票
        case .ticket_remind:            return "ticket-remind"    //取票提醒
            
            
        // MARK: - 选座购票
        case .homepage_buy:             return "homepage-buy"
        case .chooseseat_buy:           return "chooseseat-buy"
        case .confirm_order:            return "confirm-order"
        
        // MARK: - 订单
        case .confirm_pay:              return "confirm-pay"
        case .alipay_only:              return "alipay-only"    //单一指只有当前一种支付方式
        case .wechat_only:              return "wechat-only"
        case .ebank_only:               return "ebank-only"
        case .yipay_only:               return "yipay-only"
        case .balance_only:             return "balance-only"
        case .alipaye_favorable:        return "alipay-favorable" //优惠／兑换／红包指除了当前的支付方式，还有使用优惠、兑换、红包
        case .wechat_favorable:         return "wechat-favorable"
        case .ebank_favorable:          return "ebank-favorable"
        case .yipay_favorable:          return "yipay-favorable"
        case .balance_favorable:        return "balance-favorable"
        case .user_location:            return "user-location"
        case .user_time:                return "user-time"
        case .payorder_ios:             return "payorder-ios"
        case .payorder_pc:              return "payorder-pc"
        case .payorder_wap:             return "payorder-wap"
        case .order_tickets:            return "order-tickets"
            
        // MARK: - 电影
        case .showing_film:             return "showing-film"
        case .future_show_film:         return "future-show-film"
        case .film_details:             return "film-details"
        case .actor_list:               return "actor-list"
        case .video_list:               return "video-list"
        case .still_list:               return "still-list"
        case .music_list:               return "music-list"
        case .comment_list:             return "comment-list"
        case .comment_details:          return "comment-details"
            
        // MARK: - 影院
        case .cinema_list:              return "cinema-list"
        case .cinema_details:           return "cinema-details"
        case .cinema_introduce:         return "cinema-introduce"
        case .cinema_photo:             return "cinema-photo"
        case .cinema_film_list_today:   return "cinema-film-list-today"
        case .cinema_film_list_tomorrow:return "cinema-film-list-tomorrow"
        case .cinema_film_list_after_tomorrow:return "cinema-film-list-after-tomorrow"
        case .cinema_film_list_shade:   return "cinema-film-list-shade"
            
        // MARK: - 选座
        case .choose_seat:              return "choose-seat"
        case .pay_order:                return "pay-order"
        case .pay_success:              return "pay-success"
        case .pay_fail:                 return "pay-fail"
            
        // MARK: - 发现
        case .news_list:                return "news-list"
        case .news_details:             return "news-details"
        case .operation_list:           return "operation-list"
        case .operation_details:        return "operation-details"
            
        // MARK: - 周边
        case .product_list:             return "product-list"
        case .product_details:          return "product-details"
        case .shopping_cart:            return "shopping-cart"
        case .order_confirm:            return "order-confirm"
        case .derivative_pay_success:   return "derivative-pay-success"
        case .derivative_pay_fail:      return "derivative-pay-fail"
            
        // MARK: - 我的
        case .my:                       return "my"
        case .message_list:             return "message-list"
        case .message_details:          return "message-details"
        case .my_attention:             return "my-attention"
        case .my_fans:                  return "my-fans"
        case .order_manage:             return "order-manage"
        case .ticket_manage:            return "ticket-manage"
        case .derivative_order:         return "derivative-order"
        case .ticket_order_details:     return "ticket-order-details"
        case .derivative_order_details: return "derivative-order-details"
        case .stay_comment_list:        return "stay-comment-list"  //待评价列表页
        
            
        case .undefined:                return ""
        }
        
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
            
        default:
            self = .undefined
        }
    }
    
}



extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

public extension UIViewController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        guard let naVC = self.navigationController else { return nil };
        
        let lenght = naVC.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? naVC.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}



public class KKZAnalyticsEvent:NSObject {
    var movie_id:String?
    var movie_name:String?
    var cinema_id:String?
    var cinema_name:String?
    var hall_id:String?
    var hall_name:String?
    var featur_name:String?
    var seat:[[String:Any]]?
    var count:UInt8 = 0
    var price:Float = -1
    var total_amount:Float = -1
    var activity_id:String?
    var activity_name:String?
    var pay_channel:String?
    var pay_result:String?
    
    
    private var dic = Dictionary<String, Any>()
    
    override init() {
        super.init()
    }
    
    public init(plan:Ticket?) {
        super.init()
        handle(plan: plan)
    }
    
    public init(movie:Movie?) {
        super.init()
        handle(movie: movie)
    }
    
    public init(cinema:CinemaDetail?) {
        super.init()
        handle(cinema: cinema)
    }
    
    public init(order:Order?) {
        super.init()
        handle(order: order)
    }
    
    private func handle(cinema:CinemaDetail?){
        guard let cinema = cinema else {return}
        cinema_name = cinema.cinemaName
        cinema_id = cinema.cinemaId?.stringValue
        
    }

    private func handle(movie:Movie?){
        guard let movie = movie else {return}
        movie_id = movie.movieId?.stringValue
        movie_name = movie.movieName
    }
    
    private func handle(plan:Ticket?){
        guard let plan = plan else {return}
        handle(movie: plan.movie)
        hall_id = plan.hallNo
        hall_name = plan.hallName
        activity_id = plan.promotionId?.stringValue
//        featur_name = plan.movieTime//////////////////
        //seat info
        
    }
    
    
    private func handle(order:Order?){
        guard let order = order else {return}
        handle(movie: order.plan.movie)
        handle(plan: order.plan)
    }
    

    
    public func toDic() -> [String:Any]?{
        
        if let value = movie_id {
            dic.updateValue(value, forKey: "movie_id")
        }
        if let value = movie_name {
            dic.updateValue(value, forKey: "movie_name")
        }
        if let value = cinema_id {
            dic.updateValue(value, forKey: "cinema_id")
        }
        if let value = cinema_name {
            dic.updateValue(value, forKey: "cinema_name")
        }
        if let value = hall_id {
            dic.updateValue(value, forKey: "hall_id")
        }
        if let value = hall_name {
            dic.updateValue(value, forKey: "hall_name")
        }
        if let value = featur_name {
            dic.updateValue(value, forKey: "featur_name")
        }
        if let value = seat {
            dic.updateValue(value, forKey: "seat")
        }
        if count > 0 {
            dic.updateValue(count, forKey: "count")
        }
        if  price >= 0 {
            dic.updateValue(price, forKey: "price")
        }
        if  total_amount >= 0 {
            dic.updateValue(total_amount, forKey: "total_amount")
        }
        if let value = activity_id {
            dic.updateValue(value, forKey: "activity_id")
        }
        if let value = activity_name {
            dic.updateValue(value, forKey: "activity_name")
        }
        if let value = pay_channel {
            dic.updateValue(value, forKey: "pay_channel")
        }
        if let value = pay_result {
            dic.updateValue(value, forKey: "pay_result")
        }
        
        if dic.count > 0 {
           return ["event":dic];
        }else{
            return nil
        }
    
    }
}



public class KKZAnalytics:NSObject {
    
    
    fileprivate static var analysticsSource: [String : Any] = ["source":["busi_type":"komovie","channel":"ios"]]
    
    fileprivate static let token:String = {
        //token: random 32 characters
        return randomString(length: 32)
    }()
    
    
    /// 用户信息
    fileprivate static var userInfo: [String:Any]{
        get {
            
            var userDic = [String:Any]()
            if let phone = UserDefaults.standard.object(forKey: "booking_phone") {
                userDic.updateValue(phone, forKey: "phone")
            }
            if let uid = UserDefaults.standard.object(forKey: "user_id"){
                userDic.updateValue(uid, forKey: "uid")
            }
            
            if let cityId = UserDefaults.standard.object(forKey: "user_city"), let city = City.getWithId(cityId as! Int32) {
                userDic.updateValue(city.cityName, forKey: "city")
            }
            
            userDic.updateValue(token, forKey: "token")
            if let uid = UIDevice.current.identifierForVendor?.uuidString {
                userDic.updateValue( uid, forKey: "gid")
            }
            
            return ["user":userDic]
        }
    }
    
    /// 上传事件
    ///
    /// - Parameters:
    ///   - event: 事件event
    ///   - action: 事件action
    class func postAction(event:KKZAnalyticsEvent? = nil, action:AnalyticsAction){
        
        DispatchQueue.global().async {
            do {
                debugPrint("event:\(event)\naction:\(action)")
                
                
                var analystics = analysticsSource
                analystics.merge(dict: userInfo)
                
                if let eve = event?.toDic() {
                    analystics.merge(dict: eve)
                }
                
                if action != .undefined {
                    let actionDic = ["action":action.rawValue]
                    analystics.merge(dict: actionDic)
                }
                
                /// 获取当前VC，然后再根据当前VC获取上一个VC
                if let currentVC = UIApplication.shared.keyWindow?.kkz.visibleViewController {
                    analystics.updateValue(String(describing: type(of:currentVC)), forKey: "path")
                    if let preVC = currentVC.previousViewController() {
                        analystics.updateValue(String(describing: type(of:preVC)), forKey: "referrer")
                    }
                }
                
                let time:String = DateEngine.shared().string(from: Date())
                analystics.updateValue(time, forKey: "time")
                
                postRequest(paramas: analystics)
                
            }
        }
        
        
    }

    static private func postRequest(paramas:[String:Any]) {
        
        guard paramas.count != 0 else {
            return
        }
        
        
        do {
            
            // sign
            let json = try JSONSerialization.data(withJSONObject: paramas)
            let jsonStr = String(data: json, encoding: .utf8)!
            let str:String = jsonStr + AnalyticsSalt
            let md5 = NSString(string:str).md5() as String
            let bodystr = jsonStr + "&sign=" + md5
            // create post request
            let url = URL(string: AnalyticsURL)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodystr.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, resons, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                
            })
            
            task.resume()
            
        } catch {
            
        }
        
        
        
    }
    
    /// 随机字符串
    ///
    /// - Parameter length: 长度
    /// - Returns: 生成的随机字符串
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
}




