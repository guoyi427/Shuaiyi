//
//  UserLogin.h
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>


/**
用户登录信息
 */
@interface UserLogin : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *lastSession;
@property (nonatomic, copy) NSNumber *isVip;
@property (nonatomic, copy) NSString *alipayId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *headimg;
//@property (nonatomic, copy) NSString *vipAccount;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *huanxinPassword;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic) BOOL newUser;
@end
