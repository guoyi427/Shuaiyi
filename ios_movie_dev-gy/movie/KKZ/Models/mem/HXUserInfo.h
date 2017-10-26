//
//  HXUserInfo.h
//  KoMovie
//
//  Created by avatar on 15/7/22.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HXUserInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber * hxUserId;
@property (nonatomic, copy) NSString * headimg;
@property (nonatomic, copy) NSString * nickname; //未知



+ (HXUserInfo *)getHXUserInfoWithId:(NSString *)userIdChat;
@end
