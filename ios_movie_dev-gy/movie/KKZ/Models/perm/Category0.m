//
//  Category.m
//  KoMovie
//
//  Created by XuYang on 13-8-7.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Category0.h"
#import "MemContainer.h"


@implementation Category0

@dynamic listId;
@dynamic hot;
@dynamic categoryName;
@dynamic categoryIntro;
@dynamic categoryImg;
@dynamic createTime;

+ (NSString *)primaryKey {
    return @"listId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"categoryName": @"listName",
                 @"categoryIntro": @"listIntro",
                 @"categoryImg": @"image",
                 
                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"createTime": @"yyyy-MM-dd HH:mm:ss",
                 } retain];
    }
    return map;
}

//categoryId
+ (Category0 *)getCategoryWithId:(unsigned int)listId {
    return [[MemContainer me] getObject:[Category0 class]
                                 filter:[Predicate predictForKey: @"listId" compare:Equal value:@(listId)], nil];
}


@end
