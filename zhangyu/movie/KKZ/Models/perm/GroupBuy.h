//
//  GroupBuy.h
//  KoMovie
//
//  Created by gree2 on 12/12/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CustomManagedObject.h"


@interface GroupBuy : CustomManagedObject

@property (nonatomic, strong) NSString * groupBuyId;
@property (nonatomic, strong) NSNumber * groupBuyNo;
@property (nonatomic, strong) NSDate * createTime;
@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, strong) NSString * picSmall;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * groupBuyPrice;
@property (nonatomic, strong) NSNumber * type;

+ (GroupBuy *)getGroupBuyWithId:(NSString *)groupBuyId inContext:(NSManagedObjectContext *)context;

@end
