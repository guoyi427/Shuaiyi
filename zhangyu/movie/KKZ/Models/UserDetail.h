//
//  UserDetail.h
//  KoMovie
//
//  Created by Albert on 26/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 UserDetail是为了统一UserInfo和UserSocoal的相同属性
 */
@interface UserDetail : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSNumber *day;
@property (nonatomic, copy) NSNumber *month;
@property (nonatomic, copy) NSNumber *year;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSNumber *sex;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *nickName;

@end


