//
//  ClubPostReportWord.m
//  KoMovie
//
//  Created by KKZ on 16/3/4.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostReportWord.h"

#import "Constants.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation ClubPostReportWord
@dynamic typeId;
@dynamic typeName;


- (void)dealloc {
    
    [super dealloc];
}

+ (NSString *)primaryKey {
    return @"typeId";
}

+ (NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                 } retain];
    }
    return map;
}

+ (ClubPostReportWord *)getClubPostReportWordWithId:(NSUInteger)typeId {
    return [[MemContainer me] getObject:[ClubPostReportWord class]
                                 filter:[Predicate predictForKey:@"typeId" compare:Equal value:@(typeId)], nil];
}

@end
