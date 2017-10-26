//
//  Activity.m
//  KKZ
//
//  Created by alfaromeo on 12-3-6.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Activity.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation Activity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSDateFormatter *) dateFormatter
{
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateF;
}

+ (NSValueTransformer *) endTimeJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        NSString *str = value;
        return [[self dateFormatter] dateFromString: str];
    }];
}


+ (NSValueTransformer *) startTimeJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        NSString *str = value;
        return [[self dateFormatter] dateFromString: str];
    }];
}


+ (NSValueTransformer *) createTimeJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        NSString *str = value;
        return [[self dateFormatter] dateFromString: str];
    }];
}


+ (NSValueTransformer *) expireDateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        NSString *str = value;
        return [[self dateFormatter] dateFromString: str];
    }];
}



+ (NSArray *)getActivityWithSourceArray:(NSArray *)arr{
    
    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    NSMutableArray *expiredArray = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (Activity *activity in arr) {
        
        NSTimeInterval timeInterval = [activity.endTime timeIntervalSinceNow];
        if (timeInterval < 0) {
            [expiredArray addObject:activity];//过期的
        }else{
            [otherArray addObject:activity];//没过期的
        }
    }
    
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:
//                                [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES],//正序
//                                nil];
    NSArray *sortDescriptors1 = [[NSArray alloc] initWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO],//倒序
                                nil];

//    [otherArray sortUsingDescriptors:sortDescriptors];
    [otherArray sortUsingDescriptors:sortDescriptors1];
    [expiredArray sortUsingDescriptors:sortDescriptors1];

//    [sortDescriptors release];
    [sortDescriptors1 release];
    
    [array addObjectsFromArray:otherArray];
    [array addObjectsFromArray:expiredArray];



    [expiredArray release];
    [otherArray release];
    
    return [array autorelease];
}



@end
