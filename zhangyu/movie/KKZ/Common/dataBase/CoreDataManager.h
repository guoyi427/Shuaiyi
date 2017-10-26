//
//  CoreDataManager.h
//  coreData
//
//  Created by 艾广华 on 15-3-9.
//  Copyright (c) 2015年 艾广华. All rights reserved.
//


//PersistentStore 数据真正存储的地方,CoreData提供了两种存储的选择,分别是sqlite和二进制文件。

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

/**
 *  创建单例对象
 *
 *  @return
 */
+(CoreDataManager *)sharedInstance;

/**
 *  数据库的上下文
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 *  保存数据到数据库
 *
 *  @return  保存成功与否
 */
- (BOOL)saveToDatabase;

@end
