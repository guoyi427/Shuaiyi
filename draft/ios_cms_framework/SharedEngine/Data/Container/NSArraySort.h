//
//  NSArraySort.h
//  basic
//
//  Created by zhang da on 14-4-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Sort)

/*
 sorter的格式："property1 asc/desc", "property2 asc/desc",
 */
- (id)sortBy:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION;

@end


@interface NSMutableArray (Sort)

/*
 sorter的格式："property1 asc/desc", "property2 asc/desc",
 */
- (id)sortBy:(NSString *)sorter,... NS_REQUIRES_NIL_TERMINATION;

@end
