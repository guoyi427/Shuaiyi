//
//  DataManager.h
//  KoMovie
//
//  Created by zhoukai on 1/17/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsTask.h"

@interface DataManager : NSObject

@property (nonatomic,strong)NSString *sharedUid;
@property (nonatomic,strong)NSString *shareInfo;
@property (nonatomic,assign) StatisticsType statisticsType;
@property (nonatomic,assign)bool isStatistics;
@property (nonatomic,strong)NSString *imageURL;

@property (nonatomic,strong) NSMutableArray *allFriendArray; //TKAddressBook,PlatUser,时间排序。

@property (nonatomic,assign) int newCount0;

@property (nonatomic,strong) NSString *phoneArrayStr;//138122345678,12233445566,
@property (nonatomic,strong) NSMutableArray *dataSource; //<TKAddressBook>
@property (nonatomic,assign) BOOL hasNews; //是否有新的-是否查询。NO，查询，YES，不查。reader之后改成NO



+(DataManager*)shareDataManager;

-(void)findFriends;
-(void)readedMessage;
-(NSString*)getPhoneArrayStr;
-(void)fatchContacts;
@end
