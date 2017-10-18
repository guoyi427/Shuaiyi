//
//  User.h
//  CIASMovie
//
//  Created by avatar on 2017/1/19.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>
//MARK: 1不存在 2存在 / 1成功 2失败
@property (nonatomic, strong)       NSNumber *refundResult;
//MARK: 用户id
@property (nonatomic, strong)       NSNumber *userId;
//状态令牌
@property (nonatomic, copy)    NSString *accountToken;
//租户id long型
@property (nonatomic, strong)       NSNumber *tenantId;
//租户名称
@property (nonatomic, copy)    NSString *tenantName;
//手机号码
@property (nonatomic, copy)    NSString *phoneNumber;
//用户昵称
@property (nonatomic, copy)    NSString *nickName;
//userLevel	用户等级	int
@property (nonatomic, strong)       NSNumber *userLevel;
//账户余额	BigDecimal
@property (nonatomic, strong)       NSNumber *moneyRemainder;
//userPoint	积分	long
@property (nonatomic, strong)       NSNumber *userPoint;
//sex	性别	int	性别(1男,2女)
@property (nonatomic, strong)       NSNumber *sex;
//age	年龄	int
@property (nonatomic, strong)       NSNumber *age;
//headingUrl	头像	string
@property (nonatomic, copy)    NSString *headingUrl;
//fansCount	粉丝数量	long
@property (nonatomic, strong)       NSNumber *fansCount;
//lat	经度	string
@property (nonatomic, copy)    NSString *lat;
//lng	纬度	string
@property (nonatomic, copy)    NSString *lng;
//birthday	生日	date
@property (nonatomic, copy)    NSString *birthday;
//pushUserId	推广用户	long
//@property (nonatomic, assign)      long pushUserId;
//pushChannel	推广渠道	int
//@property (nonatomic, assign)       int pushChannel;
//email	邮箱	string
@property (nonatomic, copy)    NSString *email;
//height	身高	int
@property (nonatomic, strong)       NSNumber *height;
//weight	体重	int
@property (nonatomic, strong)       NSNumber *weight;
//identityType	证件类型	int
@property (nonatomic, copy)    NSString *identityType;
//idNumber	证件号码	int
@property (nonatomic, strong)       NSNumber *idNumber;
//address	地址	int
@property (nonatomic, copy)    NSString *address;
//cityId	城市id	long
@property (nonatomic, strong)       NSNumber *cityId;
//cityName	城市名称	string
@property (nonatomic, copy)    NSString *cityName;
//job	工作	string
@property (nonatomic, copy)    NSString *job;
//hobby	爱好	string
@property (nonatomic, copy)    NSString *hobby;
//hobbyMovieType	喜欢的电影类型	string
@property (nonatomic, copy)    NSString *hobbyMovieType;
//signature	个性签名	string
@property (nonatomic, copy)    NSString *signature;
//gradeId	所在级别	int
//qq	qq	string
@property (nonatomic, copy)    NSString *qq;
//wexin	微信	string
@property (nonatomic, copy)    NSString *wexin;
//weibo	微博	string
@property (nonatomic, copy)    NSString *weibo;

@property (nonatomic, strong)       NSNumber *userDetailId;
@property (nonatomic, strong)       NSNumber *registrySource;

@property (nonatomic, copy)    NSString *loginUsername;

@property (nonatomic, copy)    NSString *loginPassword;
@property (nonatomic, copy)    NSString *payPassword;
@property (nonatomic, strong)       NSNumber *status;
@property (nonatomic, copy)    NSString *lastLoginTime;

@property (nonatomic, copy)    NSString *lastLoginDevice;
@property (nonatomic, copy)    NSString *expireDay;
@property (nonatomic, copy)    NSString *loginIp;
@property (nonatomic, copy)    NSString *note;
@property (nonatomic, copy)    NSString *createTime;
@property (nonatomic, copy)    NSString *timestamp;








@end
