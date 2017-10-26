//
//  RIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem

@synthesize label = _label;
@synthesize action = _action;

- (void)dealloc {
    self.label = nil;
    self.action = nil;
    
    [super dealloc];
}

+ (id)item {
    return [[[RIButtonItem alloc] init] autorelease];
}

+ (id)itemWithLabel:(NSString *)inLabel {
    RIButtonItem *newItem = (RIButtonItem *)[self item];
    newItem.label = inLabel;
    return newItem;
}

+ (id)itemWithLabel:(NSString *)inLabel action:(void (^)())aBlock {
    RIButtonItem *newItem = (RIButtonItem *)[self item];
    newItem.label = inLabel;
    newItem.action = aBlock;
    return newItem;
}

@end

