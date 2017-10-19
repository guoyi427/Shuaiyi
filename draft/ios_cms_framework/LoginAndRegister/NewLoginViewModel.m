//
//  NewLoginViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NewLoginViewModel.h"
#import <objc/runtime.h>

#define TableName @"User"

@implementation NewLoginViewModel

+ (NewLoginViewModel *)sharedLoginEngine{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)insertLoginDataIntoDataBase:(UserLogin *)model {
    
    //获取数据库的单例对象
    CoreDataManager *coreManager = [CoreDataManager sharedInstance];
    
    //获取数据库上下文
    NSManagedObjectContext *context = coreManager.managedObjectContext;
    
    //插入数据
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:TableName
                                                                                 inManagedObjectContext:context];
    u_int out_count;
    Ivar *ivar = class_copyIvarList([model class], &out_count);
    for (int i=0; i < out_count; i++) {
        NSString *name = [NSString stringWithCString:ivar_getName(ivar[i])
                                            encoding:NSUTF8StringEncoding];
        name = [name substringFromIndex:1];
        
        id propertyValue = [model valueForKey:(NSString *)name];
        if (propertyValue == nil || [propertyValue isEqual:[NSNull null]]) {
            continue;
        }
        if ([entity respondsToSelector:NSSelectorFromString(name)]) {
            //确保数据库有对应字段才set
            [entity setValue:propertyValue forKey:name];
        }
        
    }
    free(ivar);
    if(![coreManager saveToDatabase]){
//        NSLog(@"保存数据库失败");
    }
}

+ (UserLogin *)selectLoginDataFromDataBase {
    
    //查询是否已经有此条记录
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName
                                              inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //查询数据库
    NSError *requestError = nil;
    NSArray *resultArray = [[CoreDataManager sharedInstance].managedObjectContext
                            executeFetchRequest:fetchRequest error:&requestError];
    
    if (resultArray && resultArray.count > 0) {
        return resultArray[0];
    }
    return nil;
}

+(void)deleteLoginDataFromDataBase {
    
    //获取数据库的单例对象
    CoreDataManager *coreManager = [CoreDataManager sharedInstance];
    
    //获取数据库上下文
    NSManagedObjectContext *context = coreManager.managedObjectContext;
    
    //查询是否已经有此条记录
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest
                                                  error:&requestError];
    for (UserLogin *deleteObject in resultArray) {
        [context deleteObject:deleteObject];
    }
    if([coreManager saveToDatabase]){
        NSLog(@"删除成功");
    }
}

+ (void)updateLoginModelKey:(NSString *)key
                 modelValue:(NSString *)value {
    //查询是否已经有此条记录
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName
                                              inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //获取数据库的单例对象
    CoreDataManager *coreManager = [CoreDataManager sharedInstance];
    
    //查询数据库
    NSError *requestError = nil;
    NSArray *resultArray = [[CoreDataManager sharedInstance].managedObjectContext
                            executeFetchRequest:fetchRequest error:&requestError];
    if(resultArray!=nil && [resultArray count] > 0){
        UserLogin *login = resultArray[0];
        [login setValue:value forKey:key];
        if([coreManager saveToDatabase]){
            NSLog(@"更新成功");
        }
    }
}

@end
