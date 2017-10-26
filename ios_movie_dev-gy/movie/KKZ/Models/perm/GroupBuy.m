//
//  GroupBuy.m
//  KoMovie
//
//  Created by gree2 on 12/12/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "GroupBuy.h"


@implementation GroupBuy

@dynamic groupBuyId;
@dynamic groupBuyNo;
@dynamic createTime;
@dynamic startTime;
@dynamic endTime;
@dynamic picSmall;
@dynamic title;
@dynamic groupBuyPrice;
@dynamic type;

+ (NSString *)entityName{
    return @"GroupBuy";
}

- (void)updateDataFromDict:(NSDictionary *)dict{
    
    [self setObj:[dict stringForKey:@"groupBuyId"] forKey:@"groupBuyId"];
    [self setObj:[dict intNumberForKey:@"groupBuyId"] forKey:@"groupBuyNo"];
    [self setObj:[dict stringForKey:@"imageSmall"] forKey:@"picSmall"];
    [self setObj:[dict stringForKey:@"groupBuyTitle"] forKey:@"title"];
    [self setObj:[dict floatNumberForKey:@"groupBuyPrice"] forKey:@"groupBuyPrice"];
    [self setObj:[dict dateForKey:@"createTime" withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"createTime"];
    [self setObj:[dict dateForKey:@"startTime" withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"startTime"];
    [self setObj:[dict dateForKey:@"endTime" withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"endTime"];
    [self setObj:[dict intNumberForKey:@"couponTypes"] forKey:@"type"];
}

+ (GroupBuy *)getGroupBuyWithId:(NSString *)groupBuyId inContext:(NSManagedObjectContext *)context{
    return (GroupBuy *)[GroupBuy getWithPredicate:[NSPredicate predicateWithFormat:@"groupBuyId == %@", groupBuyId] inContext:context];
}


@end
