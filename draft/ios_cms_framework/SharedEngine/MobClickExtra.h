//
//  MobClickExtra.h
//  kkz
//
//  Created by kokozu on 10-12-18.
//  Copyright 2010 公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMMobClick/MobClick.h>

@interface MobClick (MobClickExtra) 

+ (void)kkzEvent:(NSString *)eventId;
+ (void)kkzEvent:(NSString *)eventId label:(NSString *)label;

@end
