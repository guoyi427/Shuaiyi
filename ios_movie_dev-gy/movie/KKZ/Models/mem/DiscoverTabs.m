//
//  DiscoverTabs.m
//  KoMovie
//
//  Created by KKZ on 15/8/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "DiscoverTabs.h"
#import "MemContainer.h"

@implementation DiscoverTabs

@dynamic tab;
@dynamic link;
@dynamic name;


+ (NSString *)primaryKey {
    return @"tab";
}

+ (NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{ @"tab": @"@\"tab\"",
                   @"link": @"@\"link\"",
                   @"name": @"@\"name\"",}
               retain];
    }
    return map;
}



+ (DiscoverTabs *)getTabWithId:(NSString *)num{
    
    return [[MemContainer me] getObject:[DiscoverTabs class]
                                 filter:[Predicate predictForKey:@"tab" compare:Equal value:num], nil];
}


@end
