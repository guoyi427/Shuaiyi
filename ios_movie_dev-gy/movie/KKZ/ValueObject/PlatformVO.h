//
//  PlatformVO.h
//  KoMovie
//
//  Created by zhoukai on 3/19/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//
//"platform" : {
//    "name" : "火凤凰",
//    "platformId" : 10004,
//    "showRefer" : true,
//    "icon" : "http:\/\/www.ykse.com.cn\/images\/logo_finixx_fh.png",
//    "homePage" : "http:\/\/www.ykse.com.cn\/"
//}

#import <Foundation/Foundation.h>

@interface PlatformVO : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *platformId;
@property (nonatomic,assign)BOOL showRefer;

@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *homePage;


-(void)updateWithDict:(NSDictionary*)dict;
@end
