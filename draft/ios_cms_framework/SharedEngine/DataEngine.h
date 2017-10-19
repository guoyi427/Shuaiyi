//
//  DataEngine.h
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCenterView.h"

typedef void ( ^ LoginFinishedBlock )(BOOL succeeded);
@class UserLogin;
@interface DataEngine : NSObject<LoginCenterViewDelegate> {

    
}

@property (nonatomic, assign) double balance;
@property (nonatomic, assign) BOOL isCancel;///是不是可以关闭登录页面

@property (nonatomic, assign) double sessionTimeStamp;
@property (nonatomic, copy) LoginFinishedBlock finishBlock;


/**
 *  用户名的ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户的SessionId
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  手机号码
 */
@property (nonatomic, strong) NSString *phoneNum;

/**
 *  环信聊天的密码
 */
@property (nonatomic, copy) NSString *huanXinPwd;

/**
 *  用户头像地址
 */
@property (nonatomic, strong) NSString *headImg;
/**
 *  用户的vip等级
 */
@property (nonatomic, assign) CGFloat vipBalance;

/**
 *  是不是用的手机登录的
 */
@property (nonatomic, assign) BOOL isPhoneNum;

+ (DataEngine *)sharedDataEngine;
- (NSDictionary *)getSoftwareInfo;
- (NSString *)appUrl;

- (void)startLoginWith:(BOOL) isCancelView withFinished:(LoginFinishedBlock)fBlock;
- (void)signout;
- (void)loginSucceededWithSession:(NSString *)sessionId
                           userId:(NSString *)userId
                         userName:(NSString *)userName;
- (BOOL)isAuthorizeExpired;

/**
 *  设置用户登录数据模型
 *
 *  @param model
 */
- (void)setUserDataModel:(UserLogin *)model;

@end

