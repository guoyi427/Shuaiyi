//
//  UserBind.m
//  KoMovie
//
//  Created by Albert on 09/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserBind.h"

@interface UserBind ()
/**
 *  是否绑定手机
 */
@property (nonatomic) BOOL isBindMobile;
/**
 *  是否绑定QQ
 */
@property (nonatomic) BOOL isBindQQ;
/**
 *  是否绑定新浪微博
 */
@property (nonatomic) BOOL isBindSinaweibo;
/**
 *  是否绑定微信
 */
@property (nonatomic) BOOL isBindWeiXin;

@end

@implementation UserBind

- (BOOL) isBindMobile
{
    return self.mobile.length > 0;
}

- (BOOL) isBindQQ
{
    return self.qq.length > 0;
}

- (BOOL) isBindSinaweibo
{
    return self.sinaweibo.length > 0;
}

- (BOOL) isBindWeiXin
{
    return self.weixin.length > 0;
}

@end
