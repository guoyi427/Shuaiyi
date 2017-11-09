//
//  DataEngine.m
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//一方面保存coredata，一方面保存Keychain

#import "Constants.h"
#import "DataEngine.h"
#import "SFHFKeychainUtilsY.h"
#import "UserDefault.h"

#import "KKZUtility.h"
#import "NewLoginViewModel.h"
#import "TaobaoClient.h"
#import "UserManager.h"

static DataEngine *_dataEngine = nil;

@interface DataEngine ()

@end

@implementation DataEngine

+ (DataEngine *)sharedDataEngine {
    @synchronized(self) {
        if (!_dataEngine) {
            _dataEngine = [[DataEngine alloc] init];
        }
    }
    return _dataEngine;
}

- (id)init {
    self = [super init];
    if (self) {
        if (USER_AlIPAY_TOKEN) {
            self.sessionId = nil;
        } else {
            //从数据库获取用户登录信息
            UserLogin *model = [NewLoginViewModel selectLoginDataFromDataBase];
            [self setUserDataModel:model];
        }
        
        _currentMovieList = [[NSMutableArray alloc] init];
        _futureMovieList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setUserDataModel:(UserLogin *)model {
    if (model) {

        //设置用户Id
        if (model.userId == nil || [model.userId isEqual:[NSNull null]]) {
            self.userId = @"0";
        } else {
            self.userId = [NSString stringWithFormat:@"%d", [model.userId intValue]];
        }
        self.sessionId = model.lastSession;
        self.userName = model.nickName;
        self.huanXinPwd = model.huanxinPassword;
        self.headImg = model.headimg;
        self.phoneNum = model.userName;
        //设置用户的Vip等级
//        if (model.vipAccount == nil || [model.vipAccount isEqual:[NSNull null]]) {
//            self.vipBalance = 0.0f;
//        } else {
//            self.vipBalance = [model.vipAccount doubleValue];
//        }
    }
}

#pragma mark - utilities


- (BOOL)isAuthorizeExpired {
    if (!self.sessionId) {
        self.sessionId = nil;
        return YES;
    }
    return NO;
}

- (void)startLoginFinished:(LoginFinishedBlock)fBlock
            withController:(CommonViewController *)controller {
    
    self.finishBlock = fBlock;
    
    [[UserManager shareInstance] gotoLoginControllerFrom:controller loginDelegate:self];
}

#pragma mark utilities
- (void)startLoginFinished:(LoginFinishedBlock)fBlock {
    
    self.finishBlock = fBlock;
    
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [[UserManager shareInstance] gotoLoginControllerFrom:parentCtr loginDelegate:self];
}

- (void)signout {

    //清空所有的登录信息
    self.sessionId = nil;
    self.userName = nil;
    self.userId = nil;
    self.vipBalance = 0;
    //    self.redCouponBalance = 0;

    //推出淘宝客户端
    [[TaobaoClient sharedTaobaoClient] logoutFinished:^(OAuthClient *client){

    }];

    //删除用户登录信息
    [NewLoginViewModel deleteLoginDataFromDataBase];

    //change appdelegate status at last!!!!!!
    appDelegate.isAuthorized = NO;
}

- (NSDictionary *)getSoftwareInfo {
    NSDictionary *softwareInfo = [[NSDictionary alloc] initWithContentsOfFile:
                                                               [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Info.plist"]];
    return softwareInfo;
}

#pragma LoginViewControllerDelegate
- (void)loginControllerLoginSucceed {
    if (self.finishBlock) {
        self.finishBlock(YES);
    }
}

- (void)loginControllerLoginCancelled {
    if (self.finishBlock) {
        self.finishBlock(NO);
    }
}

@end
