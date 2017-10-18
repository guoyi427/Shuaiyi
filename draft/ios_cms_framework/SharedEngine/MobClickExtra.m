//
//  MobClickExtra.m
//  kkz
//
//  Created by kokozu on 10-12-18.
//  Copyright 2010 公司. All rights reserved.
//

#import "MobClickExtra.h"


@implementation MobClick (MobClickExtra)

+ (void)kkzEvent:(NSString *)eventId {
    if (Constants.launch3rdSDK) {
        [MobClick event:eventId];
    }
}

+ (void)kkzEvent:(NSString *)eventId label:(NSString *)label {
    if (Constants.launch3rdSDK) {
        [MobClick event:eventId label:label];
    }
}

@end
