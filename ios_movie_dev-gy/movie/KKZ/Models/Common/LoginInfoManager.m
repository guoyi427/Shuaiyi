//
//  LoginInfoManager.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "LoginInfoManager.h"

@implementation LoginInfoManager

+ (LoginInfoManager *)sharedLoginEngine{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}



@end
