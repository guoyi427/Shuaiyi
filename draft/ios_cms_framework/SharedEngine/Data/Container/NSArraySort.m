//
//  NSArraySort.m
//  basic
//
//  Created by zhang da on 14-4-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NSArraySort.h"

@implementation NSArray (Sort)

- (id)sortBy:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION {
    if (sorter) {
        va_list list;
        va_start(list, sorter);
        
        NSMutableArray *sorters = [[NSMutableArray alloc] init];
        for (NSString *tSorter = sorter; tSorter != nil; tSorter = va_arg(list, NSString *)) {
            
            NSArray *comps = [tSorter componentsSeparatedByString:@" "];
            if (comps) {
                if (comps.count == 2) {
                    bool asc = ([[comps objectAtIndex:1] compare:@"asc" options:NSCaseInsensitiveSearch] != NSOrderedDescending);
                    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:[comps objectAtIndex:0] ascending:asc];
                    [sorters addObject:sorter];
                } else if (comps.count == 1) {
                    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:tSorter ascending:YES];
                    [sorters addObject:sorter];
                }
            }
        }
        
        va_end(list);
        NSArray *sortedArray = [self sortedArrayUsingDescriptors:sorters];
        
        return sortedArray;
    }
    
    return self;
}

@end



@implementation NSMutableArray (Sort)

- (id)sortBy:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION {
    if (sorter) {
        va_list list;
        va_start(list, sorter);
        
        NSMutableArray *sorters = [[NSMutableArray alloc] init];
        for (NSString *tSorter = sorter; tSorter != nil; tSorter = va_arg(list, NSString *)) {
            
            NSArray *comps = [tSorter componentsSeparatedByString:@" "];
            if (comps) {
                if (comps.count == 2) {
                    bool asc = ([[comps objectAtIndex:1] compare:@"asc" options:NSCaseInsensitiveSearch] != NSOrderedDescending);
                    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:[comps objectAtIndex:0] ascending:asc];
                    [sorters addObject:sorter];
                } else if (comps.count == 1) {
                    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:tSorter ascending:YES];
                    [sorters addObject:sorter];
                }
            }
        }
        
        va_end(list);
        [self sortUsingDescriptors:sorters];
    }
    
    return self;
}

@end
