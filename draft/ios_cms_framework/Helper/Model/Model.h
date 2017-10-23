//
//  Model.h
//  baby
//
//  Created by zhang da on 14-2-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_KEY @"orm.default"

typedef enum {
    UpdateTypeReplace = 0,
    UpdateTypeMerge
} UpdateType;

@interface Model : NSObject


+ (NSDictionary *)propertyMapping;
+ (NSDictionary *)formatMapping;

+ (NSString *)primaryKey;

+ (Model *)instanceFromDict:(NSDictionary *)dict;
+ (NSPredicate *)predicateForProperty:(NSString *)propertyName value:(id)value;

- (id)initWithDict:(NSDictionary *)dict;
- (void)updateFromDict:(NSDictionary *)dict updateType:(UpdateType)type;
- (NSDictionary *)exportData;

@end
