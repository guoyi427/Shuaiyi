//
//  Relation.m
//  Aimeili
//
//  Created by zhang da on 12-8-28.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Relation.h"


#import "Favorite.h"
//#import "Item.h"
#import "KKZUser.h"


@implementation Relation

@dynamic userId;
@dynamic targetId;
@dynamic targetType;
@dynamic exist;
@dynamic index;

+ (NSString *)entityName {
    return @"Relation";
}

+ (BOOL)relationExistFrom:(NSString *)uId
                       to:(NSString *)tId
                     type:(TargetType)type
                inContext:(NSManagedObjectContext *)context {
    Relation *relation = (Relation *)[Relation getWithPredicate:
                                      [NSPredicate predicateWithFormat:@"userId = %@ AND targetId = %@ AND targetType = %d", uId, tId, type]
                                                      inContext:context];
    @try {
        if (!relation || ![relation.exist boolValue]) {
            return NO;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return YES;
}

+ (void)setRelationFrom:(NSString *)uId
                     to:(NSString *)tId
                   type:(TargetType)type
                  exist:(BOOL)ext
              inContext:(NSManagedObjectContext *)context {
    Relation *relation = (Relation *)[Relation getWithPredicate:
                                      [NSPredicate predicateWithFormat:@"userId = %@ AND targetId = %@ AND targetType = %d", uId, tId, type]
                                                      inContext:context];
    if (!relation) {
        relation = (Relation *)[Relation entityInContext:context];
        relation.userId = uId;
        relation.targetType = [NSNumber numberWithInt:type];
        relation.targetId = tId;
    }
    @try {
        relation.exist = [NSNumber numberWithBool:ext];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

+ (void)updateRelationFrom:(NSString *)uId
                        to:(NSString *)tId
                      type:(TargetType)type
                     exist:(BOOL)ext
                 inContext:(NSManagedObjectContext *)context {
    
    Relation *relation = (Relation *)[Relation getWithPredicate:
                                      [NSPredicate predicateWithFormat:@"userId = %@ AND targetId = %@ AND targetType = %d", uId, tId, type]
                                                      inContext:context];
    if (!relation) {
        relation = (Relation *)[Relation entityInContext:context];
        relation.userId = uId;
        relation.targetType = [NSNumber numberWithInt:type];
        relation.targetId = tId;
    }
    @try {
        relation.exist = [NSNumber numberWithBool:ext];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (void)updateRelationFrom:(NSString *)uId
                        to:(NSString *)tId
                      type:(TargetType)type
                     exist:(BOOL)ext
                     index:(NSString *)index
                 inContext:(NSManagedObjectContext *)context {
    
    Relation *relation = (Relation *)[Relation getWithPredicate:
                                      [NSPredicate predicateWithFormat:@"userId = %@ AND targetId = %@ AND targetType = %d", uId, tId, type]
                                                      inContext:context];
    if (!relation) {
        relation = (Relation *)[Relation entityInContext:context];
        relation.userId = uId;
        relation.targetType = [NSNumber numberWithInt:type];
        relation.targetId = tId;
        relation.index = index;
    }
    @try {
        relation.exist = [NSNumber numberWithBool:ext];
        relation.index = index;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//删除 收藏/关注 某个东西的列表
+ (void)deleteFollowersFor:(NSString *)tId
                      type:(TargetType)type
                 inContext:(NSManagedObjectContext *)context {

    return [Relation deleteWithPredicate:
            [NSPredicate predicateWithFormat:@"targetId = %@ AND targetType = %d", tId, type]
                               inContext:context];
    
}

//删除 某个东西 关注/收藏的列表
+ (void)deleteFollowingsFor:(NSString *)tId
                       type:(TargetType)type
                  inContext:(NSManagedObjectContext *)context {

    return [Relation deleteWithPredicate:
            [NSPredicate predicateWithFormat:@"userId = %@ AND targetType = %d", tId, type]
                               inContext:context];
}

@end
