//
//  PlatformVO.m
//  KoMovie
//
//  Created by zhoukai on 3/19/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "PlatformVO.h"

@implementation PlatformVO
@synthesize name;
@synthesize homePage;
@synthesize platformId;
@synthesize icon;
@synthesize showRefer;

-(void)updateWithDict:(NSDictionary*)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [self setValue:obj forKey:(NSString *)key];
    }];
}

@end
