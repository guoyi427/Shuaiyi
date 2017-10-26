//
//  App.h
//  KoMovie
//
//  Created by XuYang on 12-11-28.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Model.h"

//应用推荐
@interface App : Model

@property (nonatomic, assign) int appId;
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSString * appImage;
@property (nonatomic, retain) NSString * appUrl;
@property (nonatomic, retain) NSString * appIntro;

+ (App *)getAppWithId:(int)appId;

@end
