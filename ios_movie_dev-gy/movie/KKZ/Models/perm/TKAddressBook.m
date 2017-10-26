//
//  MainViewController.h
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "TKAddressBook.h"

@implementation TKAddressBook
@synthesize name,namePY, tel, thumbnail, recordID, uId, status;


-(void)updaInfoWithDic:(NSDictionary*)dic{
    self.status = [[dic kkz_intNumberForKey:@"status"] intValue]; //status=0 未添加，status=2已经添加
    self.uId = [dic kkz_stringForKey:@"uid"];
    
    self.username = [dic kkz_stringForKey:@"username"];
    self.nickname = [dic kkz_stringForKey:@"nickname"];
    self.age = [dic kkz_stringForKey:@"age"];
    self.friendId = [dic kkz_stringForKey:@"friendId"];
    self.headimg = [dic kkz_stringForKey:@"headimg"];
    self.markNickName = [dic kkz_stringForKey:@"markMickName"];
    self.sex = [dic kkz_intNumberForKey:@"sex"];
    self.registerTime = [dic kkz_dateForKey:@"registerTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
