//
//  NetworkStatus.m
//  KoMovie
//
//  Created by KKZ on 15/10/14.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "NetworkStatus.h"

@implementation NetworkStatus
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"4";//2G
                    break;
                case 2:
                    state = @"3";//3G
                    break;
                case 3:
                    state = @"2";//4G
                    break;
                case 5:
                {
                    state = @"1";//WIFI
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


@end
