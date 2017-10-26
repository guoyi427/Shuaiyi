//
//  RIButtonItem.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIButtonItem : NSObject {

}

@property (nonatomic, retain) NSString *label;
@property (copy, nonatomic) void (^action)();

+ (id)item;
+ (id)itemWithLabel:(NSString *)inLabel;
+ (id)itemWithLabel:(NSString *)inLabel action:(void (^)())aBlock;

@end

