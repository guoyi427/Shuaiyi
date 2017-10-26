//
//  Song.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "Song.h"
#import <objc/runtime.h>

@interface Song ()

/**
 *  哪些字段不需要解析的数组
 */
@property (nonatomic, strong) NSMutableArray *shieldArray;

@end

@implementation Song

- (Song*)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        u_int count;
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i=0; i < count; i++) {
            NSString *name = [NSString stringWithCString:ivar_getName(ivar[i])
                                                encoding:NSUTF8StringEncoding];
            name = [name substringFromIndex:1];
            [self.shieldArray addObject:name];
        }
        
        for (id key in dict) {
            id obj= [dict valueForKey:(NSString *)key];
            if (![self.shieldArray containsObject:(NSString *)key]) {
                continue;
            }
            
            if ([obj isKindOfClass:[NSNumber class]]) {
                NSString *value = [NSString stringWithFormat:@"%d",[obj intValue]];
                if ([self validateValue:&value
                                 forKey:(NSString *)key
                                  error:nil]) {
                    [self setValue:value
                            forKey:(NSString *)key];
                }
            }else {
                if ([self validateValue:&obj
                                 forKey:(NSString *)key
                                  error:nil]) {
                    [self setValue:obj
                            forKey:(NSString *)key];
                }
            }
        }
        
    }
    return self;
}

- (NSMutableArray *)shieldArray {
    if (!_shieldArray) {
        _shieldArray = [[NSMutableArray alloc] init];
    }
    return _shieldArray;
}

@end
