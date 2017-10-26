//
//  UserBind.h
//  KoMovie
//
//  Created by Albert on 09/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户第三方绑定信息
 */
@interface UserBind : NSObject
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *sinaweibo;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *platformAccount;

/**
 *  是否绑定手机
 */
@property (nonatomic, readonly) BOOL isBindMobile;
/**
 *  是否绑定QQ
 */
@property (nonatomic, readonly) BOOL isBindQQ;
/**
 *  是否绑定新浪微博
 */
@property (nonatomic, readonly) BOOL isBindSinaweibo;
/**
 *  是否绑定微信
 */
@property (nonatomic, readonly) BOOL isBindWeiXin;


@end
