//
//  JXMutableArray.h
//  Test
//
//  Created by Joe on 13-5-8.
//  Copyright (c) 2013年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Predicate.h"

@interface ConcurrentMutableArray : NSObject  {
    dispatch_queue_t _queue;
}

@property (nonatomic, retain) NSMutableArray *container;

- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (NSArray *)filteredArrayUsingPredicate:(NSArray *)predicates;

@end
