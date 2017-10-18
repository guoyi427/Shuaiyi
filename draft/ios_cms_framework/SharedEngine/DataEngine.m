 //
//  DataEngine.m
//  kokozu
//
//  Created by da zhang on 11-5-11.
//  Copyright 2011 kokozu. All rights reserved.
//一方面保存coredata，一方面保存Keychain

#import "DataEngine.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "SFHFKeychainUtils.h"
#import "UserDefault.h"

static DataEngine *_dataEngine = nil;

@interface DataEngine ()

@property (nonatomic, strong) LoginCenterView      * loginCenterView;

@end


@implementation DataEngine


//登陆信息持久化
@synthesize sessionId = _sessionId, sessionTimeStamp = _sessionTimeStamp;
@synthesize userId = _userId, userName = _userName;

//其他信息持久化

//以下没有持久化
@synthesize  balance; //vip余额

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
        self.sessionId = [SFHFKeychainUtils getPasswordForUsername:kKCSessionId
                                                    andServiceName:kKeyChainServiceName
                                                             error:nil];

        if (self.sessionId) {
            self.sessionTimeStamp = [[SFHFKeychainUtils getPasswordForUsername:kKCSessionIdTimestamp
                                                                andServiceName:kKeyChainServiceName
                                                                         error:nil] doubleValue];
            self.userId = [SFHFKeychainUtils getPasswordForUsername:kKCUserId
                                                     andServiceName:kKeyChainServiceName
                                                              error:nil];
            self.userName = [SFHFKeychainUtils getPasswordForUsername:kKCUserName
                                                     andServiceName:kKeyChainServiceName
                                                              error:nil];
        }

	}
	return self;
}

- (void)setSessionId:(NSString *)sessionId {
    if (![_sessionId isEqualToString:sessionId]) {
        _sessionId = [sessionId copy];
        
        if (_sessionId) {
            [SFHFKeychainUtils storeUsername:kKCSessionId
                                 andPassword:_sessionId
                              forServiceName:kKeyChainServiceName
                              updateExisting:YES
                                       error:nil];
        } else {
            [SFHFKeychainUtils deleteItemForUsername:kKCSessionId
                                      andServiceName:kKeyChainServiceName
                                               error:nil];
        }
    }
}

- (void)setUserId:(NSString *)userId {
    if (![_userId isEqualToString:userId]) {
        _userId = [userId copy];
    }
    
    if (_userId) {
        [SFHFKeychainUtils storeUsername:kKCUserId
                             andPassword:_userId
                          forServiceName:kKeyChainServiceName
                          updateExisting:YES
                                   error:nil];
    } else {
        [SFHFKeychainUtils deleteItemForUsername:kKCUserId
                                  andServiceName:kKeyChainServiceName
                                           error:nil];
    }
}

- (void)setUserName:(NSString *)userName {
    if (![_userName isEqualToString:userName]) {
        _userName = [userName copy];
    }
    
    if (_userName) {
        [SFHFKeychainUtils storeUsername:kKCUserName
                             andPassword:_userName
                          forServiceName:kKeyChainServiceName
                          updateExisting:YES
                                   error:nil];
    } else {
        [SFHFKeychainUtils deleteItemForUsername:kKCUserName
                                  andServiceName:kKeyChainServiceName
                                           error:nil];
    }
}



#pragma mark - utilities


//储存login信息。
- (void)loginSucceededWithSession:(NSString *)sId userId:(NSString *)uId userName:(NSString *)uName {
    if (sId) {
        self.sessionId = sId;
        self.userId = uId;
        self.userName = uName;
        self.sessionTimeStamp = [[NSDate date] timeIntervalSince1970];
        
        [SFHFKeychainUtils storeUsername:kKCSessionIdTimestamp
                             andPassword:[NSString stringWithFormat:@"%lf", _sessionTimeStamp]
                          forServiceName:kKeyChainServiceName
                          updateExisting:YES
                                   error:nil];
        
        //change Constants status at last!!!!!!

        Constants.isAuthorized = YES;
    }
}

- (BOOL)isAuthorizeExpired {
//    if (!self.sessionId || [[NSDate date] timeIntervalSince1970] - self.sessionTimeStamp > 7*24*3600) {
//        // force to log out
//        self.sessionId = nil;
//        return YES;
//    }
    if (!self.sessionId) {
        // force to log out
        self.sessionId = nil;
        return YES;
    }
    return NO;
}

#pragma mark utilities
- (void)startLoginWith:(BOOL) isCancelView withFinished:(LoginFinishedBlock)fBlock {
    
    [self loginInWith:isCancelView];
    self.finishBlock = fBlock;
}

- (void)loginInWith:(BOOL)isCancelView {
    //加载虚化浮层,这个浮层可以共用
    self.isCancel = isCancelView;
    if (!Constants.isAuthorized) {
        if (_loginCenterView) {
            [_loginCenterView removeFromSuperview];
            _loginCenterView = nil;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.loginCenterView];
        //            [self.view addSubview:self.loginCenterView];
        
    }
}
- (LoginCenterView *)loginCenterView {
    if (!_loginCenterView) {
        _loginCenterView = [[LoginCenterView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) withIsCancelView:self.isCancel delegate:self];
    }
    return _loginCenterView;
}

- (void)signout {
    self.sessionId = nil;
    self.sessionTimeStamp = 0;

    self.userName = nil;
    self.userId = nil;

    //change Constants status at last!!!!!!

    Constants.isAuthorized = NO;
    
}

- (NSDictionary *)getSoftwareInfo {
	NSDictionary *softwareInfo = [[NSDictionary alloc] initWithContentsOfFile:
								  [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Info.plist"]];
	return softwareInfo;
}

- (NSString *)appUrl {
//    NSDictionary *infoList = [self getSoftwareInfo];
//    NSArray *urlTypes = [infoList objectForKey:@"CFBundleURLTypes"];
//    if ([urlTypes count]) {
//        NSDictionary *urlSchemes = [urlTypes objectAtIndex:0];
//        NSArray *urls = [urlSchemes objectForKey:@"CFBundleURLSchemes"];
//        if ([urls count]) {
//            return [urls objectAtIndex:0];
//        }
//    }
    return kKeyChainServiceName;
}

#pragma LoginViewControllerDelegate
- (void)newAccountDidFinishLogin{
    
    if (self.finishBlock) {
        self.finishBlock(YES);
        self.finishBlock = nil;
    }
    
}


@end
