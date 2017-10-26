//
//  DataEngine.h
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "UserLogin.h"

typedef void ( ^ LoginFinishedBlock )(BOOL succeeded);

// TODO: 将DataEngine用户信息交由UserManager管理
@interface DataEngine : NSObject <LoginViewControllerDelegate >

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

/**
 *  平台标识
 */
@property (nonatomic, assign) SiteType site;

@property (nonatomic, copy) LoginFinishedBlock finishBlock;

+ (DataEngine *)sharedDataEngine;
- (NSDictionary *)getSoftwareInfo;


/**
 *  跳转到登录页面
 *
 *  @param fBlock
 */
- (void)startLoginFinished:(LoginFinishedBlock)fBlock;

/**
 *  在指定的视图上弹出登录页面
 *
 *  @param fBlock
 *  @param controller
 */
- (void)startLoginFinished:(LoginFinishedBlock)fBlock
            withController:(CommonViewController *)controller;

/**
 *  设置用户登录数据模型
 *
 *  @param model
 */
- (void)setUserDataModel:(UserLogin *)model;

/**
 *  当前登录状态是否认证过期
 *
 *  @return 
 */
- (BOOL)isAuthorizeExpired;

/**
 *  清空登录数据
 */
- (void)signout;

@end

