//
//  Trailer.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "Trailer.h"

@interface Trailer ()

/**
 *  哪些字段不需要解析的数组
 */
@property (nonatomic, strong) NSMutableArray *shieldArray;

@end

@implementation Trailer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

- (Trailer *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        for (id key in dict) {
            id obj = [dict valueForKey:(NSString *) key];
            if ([self.shieldArray containsObject:key]) {
                continue;
            }
            if ([obj isKindOfClass:[NSNumber class]]) {
                [self setValue:[NSString stringWithFormat:@"%d", [obj intValue]]
                          forKey:(NSString *) key];
            } else {
                [self setValue:obj
                          forKey:(NSString *) key];
            }
        }
    }
    return self;
}

- (NSMutableArray *)shieldArray {
    if (!_shieldArray) {
        _shieldArray = [[NSMutableArray alloc] initWithObjects:@"id", @"channelIds", @"type", nil];
    }
    return _shieldArray;
}

@end
