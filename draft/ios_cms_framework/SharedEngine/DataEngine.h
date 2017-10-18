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
@interface DataEngine : NSObject<LoginCenterViewDelegate> {

    
}

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) BOOL isPhoneNum;///是不是用的手机登录的
@property (nonatomic, assign) BOOL isCancel;///是不是可以关闭登录页面

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, assign) double sessionTimeStamp;
@property (nonatomic, copy) LoginFinishedBlock finishBlock;



+ (DataEngine *)sharedDataEngine;
- (NSDictionary *)getSoftwareInfo;
- (NSString *)appUrl;

- (void)startLoginWith:(BOOL) isCancelView withFinished:(LoginFinishedBlock)fBlock;
- (void)signout;
- (void)loginSucceededWithSession:(NSString *)sessionId
                           userId:(NSString *)userId
                         userName:(NSString *)userName;
- (BOOL)isAuthorizeExpired;

@end

