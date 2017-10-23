//
//  MemContainer.m
//  baby
//
//  Created by zhang da on 14-2-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "MemContainer.h"
#import "ConcurrentMutableArray.h"
#import "Predicate.h"
#import "NSArraySort.h"

@implementation MemContainer

static MemContainer *_me = nil;

+ (MemContainer *)me {
    if (!_me) {
        @synchronized([MemContainer class]) {
            if (!_me) {
                DLog(@"memcontainer init");
                _me = [[MemContainer alloc] init];
            }
        }
    }
    return _me;
}

- (void)dealloc {
    self.holder = nil;
    
}

- (id)init {
    self = [super init];
    if (self) {
        self.holder = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)putObject:(id)obj {
    ConcurrentMutableArray *container = [self getContainer:NSStringFromClass([obj class])];
    [container addObject:obj];
}

- (ConcurrentMutableArray *)getContainer:(NSString *)name {
    ConcurrentMutableArray *array = nil;
    if ([self.holder valueForKey:name]) {
        array = [self.holder valueForKey:name];
    } else {
        @synchronized([MemContainer class]) {
            if (![self.holder valueForKey:name]) {
                array = [[ConcurrentMutableArray alloc] init];
                [self.holder setValue:array forKey:name];
                
            }
        }
    }
    return array;
}

- (Model *)instanceFromDict:(NSDictionary *)dict clazz:(Class)cls exist:(NSNumber **)existed {
    
    return [self instanceFromDict:dict clazz:cls updateTypeWhenExisted:UpdateTypeReplace exist:existed];
}

- (Model *)instanceFromDict:(NSDictionary *)dict
                      clazz:(Class)cls
      updateTypeWhenExisted:(UpdateType)type
                      exist:(NSNumber **)existed {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        if ([cls isSubclassOfClass:[Model class]] && [cls primaryKey]) {
            NSString *primaryKey = [[cls propertyMapping] objectForKey:[cls primaryKey]];
            if (!primaryKey) {
                primaryKey = [cls primaryKey];
            }
            NSObject *value = [dict objectForKey:primaryKey];
            Model *current = [self getObject:cls
                                      filter:[Predicate predictForKey:[cls primaryKey] compare:Equal value:value], nil];
            if (!current) {
                Model *new = [cls instanceFromDict:dict];
                [self putObject:new];
                *existed = [NSNumber numberWithBool:NO];
                return new;
            } else {
                [current updateFromDict:dict updateType:type];
                *existed = [NSNumber numberWithBool:YES];
                return current;
            }
        }

    }
    return nil;
}



#pragma mark predicate
- (id)getObject:(Class)cls filters:(NSArray *)predicates {
    NSArray *array = [self getObjects:cls filters:predicates];
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (id)getObject:(Class)cls filter:(Predicate *)predicate,... NS_REQUIRES_NIL_TERMINATION {
    NSArray *array = [self getObjects:cls filter:predicate, nil];
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (id)getObject:(Class)cls filters:(NSArray *)predicates sorters:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION {
    NSArray *array = [self getObjects:cls filters:predicates];
    
    if (sorter && array) {
        array = [array sortBy:sorter, nil];
    }

    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)getObjects:(Class)cls filters:(NSArray *)predicates {
    ConcurrentMutableArray *set = [self getContainer:NSStringFromClass(cls)];
    return [set filteredArrayUsingPredicate:predicates];
}

- (NSArray *)getObjects:(Class)cls filter:(Predicate *)predicate,... NS_REQUIRES_NIL_TERMINATION {
    if (predicate) {
        va_list list;
        va_start(list, predicate);
        
        NSMutableArray *preds = [[NSMutableArray alloc] init];
        for (Predicate *pred = predicate; pred != nil; pred = va_arg(list, Predicate *)) {
            [preds addObject:pred];
        }
        va_end(list);
        
        NSArray *ret = [self getObjects:cls filters:preds];
        

        return ret;
    }
    return nil;
}

- (NSArray *)getObjects:(Class)cls filters:(NSArray *)predicates sorters:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION {
    NSArray *array = [self getObjects:cls filters:predicates];
    
    if (sorter && array) {
        return [array sortBy:sorter, nil];
    }
    
    return array;
}


@end
