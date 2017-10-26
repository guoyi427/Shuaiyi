//
//  User.m
//  KoMovie
//
//  Created by XuYang on 13-4-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "KKZUser.h"
#import "MemContainer.h"

@implementation KKZUser

@dynamic headImg;
@dynamic latitude;
@dynamic longitude;

@dynamic nickname;
@dynamic avatarPath;
@dynamic homeImagePath;
@dynamic mobile;
@dynamic userId;
@dynamic userName;
@dynamic age;
@dynamic sex;
@dynamic birthMonth;
@dynamic birthDay;
@dynamic level;
@dynamic followerCount;
@dynamic status;
@dynamic userNamePY;
@dynamic userNameFirst;
@dynamic favoriteCount;
@dynamic movieTime;
@dynamic updateTime;
@dynamic movieName;
@dynamic isVip;
@dynamic messageCount;
@dynamic collectCount;
@dynamic commentCount;
@dynamic likeCount;
@dynamic friendCount;
@dynamic friendId;
@dynamic nickName;
@dynamic username;
@dynamic userGroup;
@dynamic userRel;
@dynamic declaration;
@dynamic userGroupId;

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{

            @"userNamePY" : @"pinyin",
            @"avatarPath" : @"headimg",
            @"movieName" : @"filmName",
            @"birthMonth" : @"bMonth",
            @"birthDay" : @"bDay",
            @"homeImagePath" : @"bg1",
            @"movieTime" : @"featureTime",
            @"updateTime" : @"createTime",
            @"userRel" : @"rel"

        } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
            @"movieTime" : @"yyyy-MM-dd HH:mm:ss",
            @"updateTime" : @"yyyy-MM-dd HH:mm:ss",

        } retain];
    }
    return map;
}

- (NSString *)nicknameFinal {
    if (self.nickName.length > 0 && ![self.nickName isEqualToString:@"(null)"] && self.nickName) {
        return self.nickName;
    } else if (self.nickname.length && ![self.nickname isEqualToString:@"(null)"] && self.nickname) {
        return self.nickname;
    } else {
        return self.userName;
    }
}

- (NSString *)avatarPathFinal {
    if (self.avatarPath.length > 0 && ![self.avatarPath isEqualToString:@"(null)"] && self.nickname) {
        return self.avatarPath;
    } else {
        return self.headImg;
    }
}

- (void)updateDataFromUser:(NSDictionary *)dict {
    if ([dict kkz_stringForKey:@"friendId"].length != 0 || ![[dict kkz_stringForKey:@"friendId"] isEqualToString:@"0"]) {
        self.userId = [[dict kkz_objForKey:@"friendId"] intValue];
    }
    //查询用户，查询好友
}
//关注
- (void)updateDataFromFavoritesList:(NSDictionary *)dict {
    self.userId = [[dict kkz_objForKey:@"uid"] intValue];
    self.friendId = [[dict kkz_objForKey:@"friendId"] intValue];
}

- (void)updateDataFromUserFollowerList:(NSDictionary *)dict {

    //查询粉丝列表
    self.userId = [[dict kkz_objForKey:@"uid"] intValue];
    self.friendId = [[dict kkz_objForKey:@"friendId"] intValue];
}

- (void)updateDataFromKotaShare:(NSDictionary *)dict {
    self.userId = [[dict kkz_objForKey:@"shareId"] intValue];
    if ([dict kkz_stringForKey:@"shareNickname"].length != 0) {
        self.userName = [dict kkz_stringForKey:@"shareNickname"];
    }
    if ([dict kkz_stringForKey:@"shareHeadimg"].length != 0) {
        self.avatarPath = [dict kkz_stringForKey:@"shareHeadimg"];
    }
    if ([dict kkz_stringForKey:@"shareSex"].length != 0) {
        self.sex = [dict kkz_intNumberForKey:@"shareSex"];
    }
}

- (void)updateDataFromKotaRequest:(NSDictionary *)dict {
    self.userId = [[dict kkz_objForKey:@"requestId"] intValue];
    if ([dict kkz_stringForKey:@"requestNickname"].length != 0) {
        self.userName = [dict kkz_stringForKey:@"requestNickname"];
    }
    if ([dict kkz_stringForKey:@"requestHeadimg"].length != 0) {
        self.avatarPath = [dict kkz_stringForKey:@"requestHeadimg"];
    }
    if ([dict kkz_stringForKey:@"requestSex"].length != 0) {
        self.sex = [dict kkz_intNumberForKey:@"requestSex"];
    }
}

+ (KKZUser *)getUserWithId:(unsigned int)userId {
    return [[MemContainer me] getObject:[KKZUser class]
                                 filter:[Predicate predictForKey:@"userId" compare:Equal value:@(userId)], nil];
}
@end
