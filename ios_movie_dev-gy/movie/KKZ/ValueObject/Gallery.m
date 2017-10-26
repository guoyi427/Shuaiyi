//
//  Gallery.m
//  KoMovie
//
//  Created by zhoukai on 3/7/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery

@synthesize movieId;
@synthesize imageSmall;
@synthesize imageBig;

- (Gallery*)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        for (id key in dict) {
            id obj= [dict valueForKey:(NSString *)key];
            if ([obj isKindOfClass:[NSNumber class]]) {
                if ([key isEqualToString:@"id"]) {
                    continue;
                }
                [self setValue:[NSString stringWithFormat:@"%d",[obj intValue]]
                        forKey:(NSString *)key];
            }else {
                [self setValue:obj
                        forKey:(NSString *)key];
            }
        }
        
//        self.galleryId = [dict kkz_stringForKey:@"galleryId"];
//        self.movieId = [dict kkz_stringForKey:@"movieId"];
//        self.smallImage = [dict kkz_stringForKey:@"imageSmall"];
//        self.bigImage = [dict kkz_stringForKey:@"imageBig"];
    }
    return self;
}



-(void)updateWithDict:(NSDictionary*)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [self setValue:obj forKey:(NSString *)key];
    }];
}

@end
