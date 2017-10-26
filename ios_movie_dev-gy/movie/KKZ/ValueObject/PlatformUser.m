//
//  PlatformUser.m
//  KoMovie
//
//  Created by zhoukai on 3/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "PlatformUser.h"
#import "ChineseToPinyin.h"

@implementation PlatformUser
@synthesize  userId;
@synthesize komovieId;
@synthesize userPlat;
@synthesize userName;
@synthesize namePY;
@synthesize status;
@synthesize userAvatar;
@synthesize userSex;
@synthesize userPhone;
@synthesize nickName;
@synthesize registerTime;
@synthesize markNickName;


- (id)init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)updateDataFromDict:(NSDictionary *)dict
{
    self.komovieId = [dict kkz_stringForKey:@"uid"];
    self.userName = [dict kkz_stringForKey:@"username"];
    self.nickName = [dict kkz_stringForKey:@"nickname"];
    self.namePY = [ChineseToPinyin pinyinFromChiniseString:[dict kkz_objForKey:@"nickname"]];
    self.userId = [dict kkz_stringForKey:@"username"];
    self.status = [dict kkz_intNumberForKey:@"status"];
    self.userSex = [dict kkz_stringForKey:@"sex"];
    self.userAvatar = [dict kkz_stringForKey:@"headImg"];
    
    
    self.markNickName = [dict kkz_stringForKey:@"markNickName"];
    self.registerTime =  [dict kkz_dateForKey:@"registerTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
}
//{
//    age = "";
//    friendId = "";
//    headimg = "http://app.qlogo.cn/mbloghead/07bc31d5be20dfba47c4/120";
//    markNickName = "";
//    nickname = "\U949f\U701a\U6797";
//    registerTime = "";
//    sex = 0;
//    status = 1;
//    uid = 5427A0EADE3486D7FFB2813A9211B0D4;
//    username = z360494820;
//}

//- (void)updateContractDataFromDict:(NSDictionary *)dict
//{
//    self.messageId = [dict kkz_stringForKey:@"rownum"] forKey:@"messageId"];
//
//
//
//
//}

@end
