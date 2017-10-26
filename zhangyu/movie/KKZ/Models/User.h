//
//  User.h
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterMark.h"
#import "UserInfo.h"


@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSNumber *site;
@property (nonatomic, copy) NSNumber *vipAccount;
@property (nonatomic, copy) UserInfo *detail;
@property (nonatomic, copy) NSString *loginTime;

@property (nonatomic, copy) NSString *lastSession;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSNumber *sex;


@end
