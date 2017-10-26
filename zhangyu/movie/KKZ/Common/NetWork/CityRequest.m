//
//  CityRequest.m
//  KoMovie
//
//  Created by Albert on 23/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CityRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "NSArraySort.h"

#import "City.h"
#import "MemContainer.h"

@implementation CityRequest
/**
 查询城市列表
 
 @param success 成功回调 cities{index : City} cityIndexes<NSString> 索引
 @param failure 失败会掉
 */
- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setObject:@"city_query" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    //120 cache
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"cities":[City class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             [self handle:[data objectForKey:@"cities"] finish:success];
         }
         failure:failure];
}

/**
 本地加载城市列表
 
 @param success 成功回调 cities{index : City} cityIndexes<NSString> 索引
 @param failure 失败会掉
 */
- (void)loadCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                    failure:(nullable void (^)(NSError * _Nullable err))failure
{
    NSData *dict = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"json"]];
    
    NSError* error;
    NSDictionary* Adata = [NSJSONSerialization JSONObjectWithData:dict options:kNilOptions error:&error];
    NSArray *citiessDic = [Adata objectForKey:@"cities"];
    NSArray *cities = [MTLJSONAdapter modelsOfClass:[City class]
                                      fromJSONArray:citiessDic
                                              error:&error];
    [self handle:cities finish:success];
}

- (void)handle:(NSArray *)cityList finish:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))finish
{
    
    NSMutableDictionary *cities = [[NSMutableDictionary alloc] init];
    NSMutableArray* cityIndexes = [[NSMutableArray alloc] init];
    
    //处理城市列表 排序 分组 索引提取
    //TODO: 优化 KCV实现
    
    if ([cityList count]) {
        
        for (City *city in cityList) {
            
            [[MemContainer me] putObject:city];
            
            NSMutableArray *hotCity = (NSMutableArray *)[cities objectForKey:@"!"];
            if (hotCity.count<=0 && city.cityHot.integerValue > 0) {
                hotCity = [[NSMutableArray alloc] init];
                [cities setValue:hotCity forKey:@"!"];
                [cityIndexes addObject:@"!"];
            }
            if (city.cityHot.integerValue > 0) {
                [hotCity addObject:city];
            }
            
            NSMutableArray *group = (NSMutableArray *)[cities objectForKey:city.nameFirst];
            if (!group && city.nameFirst) {
                group = [[NSMutableArray alloc] init];
                [cities setValue:group forKey:city.nameFirst];
                [cityIndexes addObject:city.nameFirst];
            }
            [group addObject:city];
        }
        
        for (NSString *key in [cities allKeys]) {
            NSMutableArray *group = [cities objectForKey:key];
            if ([key isEqualToString:@"!"]) {
                [group sortBy:@"cityHot asc", nil];
            }else{
                [group sortBy:@"nameFirst asc", @"cityHot desc", @"cityPinYin asc", @"cityId asc", nil];
            }
        }
        [cityIndexes sortUsingSelector:@selector(caseInsensitiveCompare:)];
        
    }
    
    if (finish) {
        finish([cities copy], [cityIndexes copy]);
    }
}


@end
