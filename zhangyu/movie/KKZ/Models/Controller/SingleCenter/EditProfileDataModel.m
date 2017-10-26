//
//  EditProfileDataModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileDataModel.h"

static NSMutableArray *static_heightArray = nil;
static NSMutableArray *static_weightArray = nil;
static NSMutableArray *static_cityArray = nil;
static NSMutableArray *static_cityNameArray = nil;
static NSMutableArray *static_jobArray = nil;
static NSMutableArray *static_hobbyArray = nil;
static NSMutableArray *static_movieTypeArray = nil;

@implementation EditProfileDataModel

+ (NSMutableArray *)heightArray {
    if (!static_heightArray) {
        
        //初始化数组
        static_heightArray = [[NSMutableArray alloc] init];
        
        //添加数据
        for (int i = 100; i < 211; i++) {
            [static_heightArray addObject:[NSString stringWithFormat:@"%dcm",i]];
        }
    }
    return static_heightArray;
}

+ (NSMutableArray *)weightArray {
    if (!static_weightArray) {
        
        //初始化数组
        static_weightArray = [[NSMutableArray alloc] init];
        
        //添加数据
        for (int i = 40; i < 200; i++) {
            [static_weightArray addObject:[NSString stringWithFormat:@"%dkg",i]];
        }
    }
    return static_weightArray;
}

+(NSMutableArray *)citysArray {
    if (!static_cityArray) {
        
        //初始化数组
        static_cityArray = [[NSMutableArray alloc] init];
        
        //获取城市列表数据
        NSData *dict = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"json"]];
        NSError* error;
        NSDictionary* Adata = [NSJSONSerialization JSONObjectWithData:dict options:kNilOptions error:&error];
        NSArray *citys = [Adata objectForKey:@"cities"];
        if ([citys count]) {
            for (NSDictionary *aCity in citys) {
                [static_cityArray addObject:aCity];
            }
        }
    }
    return static_cityArray;
}

+(NSMutableArray *)cityNameArray {
    NSMutableArray *citys = [EditProfileDataModel citysArray];
    if (!static_cityNameArray) {
        
        //初始化数组
        static_cityNameArray = [[NSMutableArray alloc] init];
        
        //添加城市名字列表
        for (int i=0; i < citys.count; i++) {
            NSDictionary *dataDic = citys[i];
            NSString *name = [dataDic valueForKey:@"cityName"];
            [static_cityNameArray addObject:name];
        }
    }
    return static_cityNameArray;
}

+(NSString *)getCityIdByCityName:(NSString *)cityName {
    NSMutableArray *citys = [EditProfileDataModel citysArray];
    NSString *cityId = nil;
    for (int i=0; i < citys.count; i++) {
        NSDictionary *dataDic = citys[i];
        NSString *name = [dataDic valueForKey:@"cityName"];
        if (name == cityName) {
            cityId = [dataDic valueForKey:@"cityId"];
            break;
        }
    }
    return cityId;
}

+ (NSMutableArray *)jobArray {
    if (!static_jobArray) {
        
        //初始化数组
        static_jobArray = [[NSMutableArray alloc] initWithObjects:@"信息技术",@"金融保险",@"商业服务",@"建筑地产",@"工程制造",@"交通运输",@"文化传媒",@"娱乐体育",@"公共事业",@"学生",nil];
    }
    return static_jobArray;
}

+ (NSMutableArray *)hobbyArray {
    if (!static_hobbyArray) {
        //初始化数组
        static_hobbyArray = [[NSMutableArray alloc] initWithObjects:@"美食",@"动漫",@"摄影",@"电影",@"体育",@"财经",@"音乐",@"游戏",@"科技",@"旅游",@"文学",@"公益",@"汽车",@"时尚",@"宠物",nil];
    }
    return static_hobbyArray;
}

+ (NSMutableArray *)movieTypeArray {
    if (!static_movieTypeArray) {
        //初始化数组
        static_movieTypeArray = [[NSMutableArray alloc] initWithObjects:@"爱情",@"喜剧",@"动作",@"剧情",@"动画",@"科幻",@"音乐",@"青春",@"文艺",@"战争",@"犯罪",@"恐怖",@"悬疑",@"惊悚",@"纪录片",nil];
    }
    return static_movieTypeArray;
}

+ (NSMutableArray *)genderArray {
    static NSMutableArray *static_genderArray = nil;
    if (!static_genderArray) {
        static_genderArray = [[NSMutableArray alloc] initWithObjects:@"男",@"女",nil];
    }
    return static_genderArray;
}

+ (NSString *)getGenderIndex:(NSString *)genderString {
    static NSDictionary *static_genderDic = nil;
    if (!static_genderDic) {
        static_genderDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"男",@"0",@"女",nil];
    }
    return [static_genderDic valueForKey:genderString];
}

+ (NSString *)getGenderStringByIndex:(int)sex {
    static NSDictionary *static_genderDic = nil;
    if (!static_genderDic) {
        static_genderDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"男",@"1",@"女",@"0",nil];
    }
    NSString *index = [NSString stringWithFormat:@"%d",sex];
    return [static_genderDic valueForKey:index];
}


@end
