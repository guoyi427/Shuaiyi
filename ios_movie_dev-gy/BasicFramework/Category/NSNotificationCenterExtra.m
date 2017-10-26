//
//  NSNotificationCenterExtra.m
//  KKZ
//
//  Created by  on 11-7-23.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NSNotificationExtra.h"

@implementation NSNotificationCenter (Extra)

- (void)addObserver:(id)observer selector:(SEL)aSelector taskType:(TaskType)taskType {
    [self addObserver:observer
               selector:aSelector
                   name:[NSString stringWithFormat:@"%@-%d", TaskFinishedNotification, (int) taskType]
                 object:nil];
}

- (void)removeObserver:(id)observer taskType:(TaskType)taskType {
    [self removeObserver:observer
                      name:[NSString stringWithFormat:@"%@-%d", TaskFinishedNotification, (int) taskType]
                    object:nil];
}

@end
