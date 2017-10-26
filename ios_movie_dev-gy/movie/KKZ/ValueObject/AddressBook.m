//
//  AddressBook.m
//  KoMovie
//
//  Created by zhoukai on 3/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "AddressBook.h"

@implementation AddressBook

@synthesize name,namePY, tel, thumbnail, recordID, uId, status;

-(void)updaInfoWithDic:(NSDictionary*)dic{
    self.status = [[dic kkz_intNumberForKey:@"status"] intValue]; //status=0 未添加，status=2已经添加
    self.uId = [dic kkz_stringForKey:@"uid"];
    
    self.username = [dic kkz_stringForKey:@"username"];
    self.nickname = [dic kkz_stringForKey:@"nickname"];
    self.age = [dic kkz_stringForKey:@"age"];
    self.friendId = [dic kkz_stringForKey:@"friendId"];
    self.headimg = [dic kkz_stringForKey:@"headImg"];
    self.markNickName = [dic kkz_stringForKey:@"markNickName"];
    self.sex = [dic kkz_intNumberForKey:@"sex"];
    self.registerTime = [dic kkz_dateForKey:@"registerTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (id)copyWithZone:(NSZone *)zone{
     
     AddressBook *address = [[[self class] allocWithZone:zone] init];
    [address setName:[name copy]];
    [address setNamePY:[namePY copy]];
    [address setTel:[tel copy]];
    [address setRecordID:recordID];
    [address setThumbnail:[thumbnail copy]];
    
//    [address setStatus:status];
//    [address setUId:[uId copy]];
//    [address setUsername:[_username copy]];
//    [address setNickname:[_nickname copy]];
//    [address setAge:[_age copy]];
//    [address setFriendId:[_friendId copy]];
//    [address setHeadimg:[_headimg copy]];
//    [address setMarkNickName:[_markNickName copy]];
//    [address setSex:_sex];
//    [address setRegisterTime:[_registerTime copy]];

    return address;
}
@end
