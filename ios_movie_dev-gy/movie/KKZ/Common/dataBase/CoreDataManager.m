//
//  CoreDataManager.m
//  coreData
//
//  Created by 艾广华 on 15-3-9.
//  Copyright (c) 2015年 艾广华. All rights reserved.
//

#import "CoreDataManager.h"

#define kMomdName @"KKZData"
#define kDBName @"db.sqlite"

static CoreDataManager *manager=nil;

@interface CoreDataManager()

/**
 *  数据化存储协调器
 */
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  管理对象模型
 */
@property (nonatomic ,strong) NSManagedObjectModel *managedObjectModel;

@end


@implementation CoreDataManager

@synthesize managedObjectContext=_managedObjectContext;

//创建一个coreDataManegr对象
+(CoreDataManager *)sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager=[[CoreDataManager alloc]init];
    });
    return manager;
}

/**
 *  得到托管对象上下文
 *
 *  @return 
 */
-(NSManagedObjectContext *)managedObjectContext
{
    //这个类是一个用户对persistentStore操作的网关,他维护了用户创建或者加载的managed objects。他记录了用户对managed objects的所有改变,以便用来undo或redo,另外当用户要存储现在的managed objects到persistentStore时,只需要调用managedObjectsContext的save方法就行了
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc]init];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return _managedObjectContext;
}

/**
 *  获取数据持久化协调器
 *
 *  @return
 */
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator!=nil)
    {
        return _persistentStoreCoordinator;
    }
    NSDictionary *optionDictionnary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:NO],NSInferMappingModelAutomaticallyOption,nil];
    NSURL *storeURL = [[self applicationCachesDirectory]URLByAppendingPathComponent:kDBName];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    NSError *error = nil;
    if(![_persistentStoreCoordinator
        addPersistentStoreWithType:NSSQLiteStoreType
        configuration:nil
        URL:storeURL
        options:optionDictionnary
        error:&error]){
        abort();
    }
    return _persistentStoreCoordinator;
}

/**
 *  得到托管对象模型
 *  托管对象模型,持久存储协调器可以依据模型中定义的实体之间的约定使用该模型创建托管对象,
 *  该协调器还将模型中实体映射到物理数据的存储文件,该文件将由CoreData写入磁盘
 *  @return
 */
-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel!=nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:kMomdName withExtension:@"momd"];
    _managedObjectModel= [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 *  获取保存的路径
 *
 *  @return
 */
-(NSURL *)applicationCachesDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 *  保存数据
 *
 *  @return
 */
- (BOOL) saveToDatabase{
    BOOL sucess=FALSE;
    NSError *error;
    sucess = [self.managedObjectContext save:&error];
    return sucess;
}

@end
