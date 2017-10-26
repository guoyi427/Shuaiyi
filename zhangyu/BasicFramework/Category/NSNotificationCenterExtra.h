//
//  NSNotificationCenterExtra.h
//  KKZ
//
//  Created by  on 11-7-23.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Constants.h"

@interface NSNotificationCenter (Extra)

- (void)addObserver:(id)observer selector:(SEL)aSelector taskType:(TaskType)taskType;
- (void)removeObserver:(id)observer taskType:(TaskType)taskType;

@end
