//
//  Relation.h
//  Aimeili
//
//  Created by zhang da on 12-8-28.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//“我关注的”，用来拼接，索引关注对象的最后一次事件。

#import "CustomManagedObject.h"

@interface Relation : CustomManagedObject

@property (nonatomic, strong) NSString * userId;//用户
@property (nonatomic, strong) NSString * targetId;//用户，电影
@property (nonatomic, strong) NSNumber * targetType;//关注和被关注（）
@property (nonatomic, strong) NSNumber * exist;
@property (nonatomic, strong) NSString * index;

+ (BOOL)relationExistFrom:(NSString *)userId
                       to:(NSString *)targetId
                     type:(TargetType)type
                inContext:(NSManagedObjectContext *)context;

+ (void)setRelationFrom:(NSString *)userId
                     to:(NSString *)targetId
                   type:(TargetType)type
                  exist:(BOOL)exist
              inContext:(NSManagedObjectContext *)context;
+ (void)updateRelationFrom:(NSString *)userId
                        to:(NSString *)targetId
                      type:(TargetType)type
                     exist:(BOOL)exist
                 inContext:(NSManagedObjectContext *)context;
+ (void)updateRelationFrom:(NSString *)uId
                        to:(NSString *)tId
                      type:(TargetType)type
                     exist:(BOOL)ext
                     index:(NSString *)index
                 inContext:(NSManagedObjectContext *)context;
//删除 收藏/关注 某个东西的列表
+ (void)deleteFollowersFor:(NSString *)targetId
                      type:(TargetType)type
                 inContext:(NSManagedObjectContext *)context;

//删除 某个东西 关注/收藏的列表
+ (void)deleteFollowingsFor:(NSString *)targetId
                       type:(TargetType)type
                  inContext:(NSManagedObjectContext *)context;

@end
