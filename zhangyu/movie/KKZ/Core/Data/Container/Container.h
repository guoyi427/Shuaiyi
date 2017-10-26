//
//  Container.h
//  baby
//
//  Created by zhang da on 14-2-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "Predicate.h"


@protocol Container <NSObject>

@required

- (Model *)instanceFromDict:(NSDictionary *)dict clazz:(Class)cls updateTypeWhenExisted:(UpdateType)type
                      exist:(NSNumber **)existed;
- (Model *)instanceFromDict:(NSDictionary *)dict clazz:(Class)cls exist:(NSNumber **)existed;

- (void)putObject:(id)obj;

- (id)getObject:(Class)cls filter:(Predicate *)predicate,... NS_REQUIRES_NIL_TERMINATION;
- (id)getObject:(Class)cls filters:(NSArray *)predicates;
- (id)getObject:(Class)cls filters:(NSArray *)predicates sorters:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION;

- (NSArray *)getObjects:(Class)cls filter:(Predicate *)predicate,... NS_REQUIRES_NIL_TERMINATION;
- (NSArray *)getObjects:(Class)cls filters:(NSArray *)predicates;
- (NSArray *)getObjects:(Class)cls filters:(NSArray *)predicates sorters:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION;

@end
