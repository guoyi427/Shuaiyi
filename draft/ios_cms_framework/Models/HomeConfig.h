//
//  HomeConfig.h
//  CIASMovie
//
//  Created by cias on 2017/2/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HomeConfig : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *contactUsAddress;//联系我们地址
@property (nonatomic, copy)NSString *contactUsEmail;//联系我们邮箱
@property (nonatomic, copy)NSString *contactUsTel;//联系我们电话
@property (nonatomic, copy)NSString *contactUsTitle;//联系我们标题
@property (nonatomic, copy)NSString *followUsSina;//新浪微博地址
@property (nonatomic, copy)NSString *follwUsWeixin;//微信二维码图片
@property (nonatomic, strong)NSArray *homeBanner;//首页轮播图

@end
