//
//  Predict.h
//  basic
//
//  Created by zhang da on 14-4-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Equal = 0,
    More,
    Less,
    MoreEqual,
    LessEqual,
    FuzzyMatch
} Compare;

@interface Predicate : NSObject

@property (nonatomic, assign) Compare compare;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) id value;

+ (Predicate *)predictForKey:(NSString *)key compare:(Compare)compare value:(id)value;
+ (bool)object:(id)object1 compare:(Compare)compare object:(id)object2;
- (bool)match:(NSObject *)data;

@end
