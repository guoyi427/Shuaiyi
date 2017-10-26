//
//  PlatformUser.h
//  KoMovie
//
//  Created by zhoukai on 3/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PlatUserExist = 0,   //存在非好友   0普通抠电影用户
    PlatUserNotExist, //不存在         1未注册抠电影
    PlatUserFriend,     //好友         2是好友
    PlatInvitedUserFriend, //非好友已邀请         3已经邀请
} PlatUserType;

typedef enum {
    PlatUserSinaWeibo = 0, //新浪微博用户
    PlatUserQQWeibo,   //腾讯微博用户
    PlatUserContract,     //通讯录用户
    
} PlatUserPlat;

@interface PlatformUser : NSObject

@property (nonatomic, strong) NSString * userId;//第三方，新浪，微信id
@property (nonatomic, strong) NSString * komovieId;//userid
@property (nonatomic, strong) NSNumber * userPlat;//enum2
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * namePY;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSNumber * status;//enum1
@property (nonatomic, strong) NSString * userAvatar;//url
@property (nonatomic, strong) NSString * userSex;//0,1
@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * markNickName;
@property (nonatomic, strong) NSDate * registerTime;

- (void)updateDataFromDict:(NSDictionary *)dict;

@end

/*
 {
 age: "",
 friendId: "",
 headimg: "http://tp1.sinaimg.cn/3643767572/50/5670032608/1",
 markNickName: "我骑毛驴游宇宙",
 nickname: "我骑毛驴游宇宙",
 registerTime: "",
 sex: 1,
 status: 1,
 uid: "",
 username: "'3643767572_sina'"
 }
 */
