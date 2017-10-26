//
//  KKZGetContactList.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *contactListFinished = @"contactListFinished";
static NSString *contactListFailed = @"contactListFailed";
static NSString *phoneListString = @"phoneArrayStr";

@interface KKZGetContactList : NSObject

/**
 *  得到拼音的数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  单例对象
 *
 *  @return
 */
+ (KKZGetContactList *)sharedEngine;

/**
 *  获取联系人
 */
- (void)getContacts;

@end
