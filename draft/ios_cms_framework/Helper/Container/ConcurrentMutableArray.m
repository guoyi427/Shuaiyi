//
//  ConcurrentMutableArray.m
//  Test
//
//  Created by Joe on 13-5-8.
//  Copyright (c) 2013年 Joe. All rights reserved.
//

#import "ConcurrentMutableArray.h"

@implementation ConcurrentMutableArray

- (void)dealloc {
    self.container = nil;
//    dispatch_release(_queue);
    _queue = nil;
    self.container = nil;
    
    
}

- (id)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("ALFA.MUTABLEARRAY", DISPATCH_QUEUE_CONCURRENT);
        self.container = [NSMutableArray array];
    }
    return self;
}

- (void)addObject:(id)object {
    dispatch_barrier_sync(_queue, ^{
        //防止添加同一对象
        if ([self.container containsObject:object]) {
            return ;
        }
        [self.container addObject:object];
    });
}

- (void)removeObject:(id)object {
    dispatch_barrier_sync(_queue, ^{
        [self.container removeObject:object];
    });
}

- (NSArray *)filteredArrayUsingPredicate:(NSArray *)predicates {
    __block NSArray *array = nil;
    dispatch_sync(_queue, ^{
        NSIndexSet *indexes = [self.container
                               indexesOfObjectsWithOptions:NSEnumerationConcurrent
                               passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                   for (Predicate *p in predicates) {
                                       
                                       //                                       DLog(@"p = $$$$$$$$$ %@ $$$$$$ obj = $$$$$$$$%@ predicates.count = %d",p,obj,predicates.count);
                                       
                                       if (![p match:obj]) {
                                           return NO;
                                       }
                                   }
                                   return YES;
                               }];
        array = [self.container objectsAtIndexes:indexes];
    });
    return array;
}

@end
