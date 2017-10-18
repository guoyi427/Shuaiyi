//
//  AppConfig.h
//  CIASMovie
//
//  Created by cias on 2017/2/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AppConfig : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *icon;//应用的icon
@property (nonatomic, copy)NSString *appName;//应用的名称
@property (nonatomic, copy)NSString *iosVersion;//应用的版本
@property (nonatomic, copy)NSString *iosLaunchLink;//启动图链接
/*
 ios启动图注意链接为空的不用显示
 file0分辨率为1080×1920
 file1分辨率为750x1334
 file2分辨率为640x1136
 */
@property (nonatomic, strong)NSDictionary *iosLaunchImage;//启动图

/*
 ios引导图注意链接为空的不用显示
 file0分辨率为1080×1920
 file1分辨率为750x1334
 file2分辨率为640x1136
 */
@property (nonatomic, strong)NSDictionary *iosGuideImage;//应用的版本
@property (nonatomic, strong)NSNumber *iosModified;
@property (nonatomic, strong)NSNumber *tenantId;


@end
