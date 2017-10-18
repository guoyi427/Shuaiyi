//
//  CityRequest.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CityRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "NSArraySort.h"
#import "City.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation CityRequest

//返回城市数组，不带index
- (void)requestCityListParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:dicParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews,@"queryCinemaCitys"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews,@"queryCinemaCitys"], newParams);
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews,@"queryCinemaCitys"]
      parameters:newParams
     resultClass:[City class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCityListParams == /n%@/n", data);

             if (success) {
                 success(data);
             }
         }
         failure:failure];

}



- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:dicParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryCinemaCitys"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemaCitys"], newParams);
    //60 cache
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemaCitys"]
      parameters:newParams
    resultKeyMap:@{@"data":[City class]}
  cacheValidTime:1
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCityListSuccess == /n%@/n", respomsObject);
             [self handle:data finish:success];
         }
         failure:failure];

}


- (void)handle:(NSArray *)cityList finish:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))finish
{
    
    CityManager *manager = [CityManager shareInstance];
    manager.cityList = cityList;
    
    NSMutableDictionary *cities = [[NSMutableDictionary alloc] init];
    NSMutableArray* cityIndexes = [[NSMutableArray alloc] init];
    
    if ([cityList count]) {
        
        for (City *city in cityList) {
            
            NSMutableArray *group = (NSMutableArray *)[cities kkz_objForKey:city.nameFirst];
            if (!group && city.nameFirst) {
                group = [[NSMutableArray alloc] init];
                [cities setValue:group forKey:city.nameFirst];
                [cityIndexes addObject:city.nameFirst];
            }
            [group addObject:city];
        }
        
        for (NSString *key in [cities allKeys]) {
            NSMutableArray *group = [cities kkz_objForKey:key];

            [group sortBy:@"nameFirst asc", @"pinyin asc", @"cityid asc", nil];

        }
        [cityIndexes sortUsingSelector:@selector(caseInsensitiveCompare:)];
        
    
  
        if (finish) {
      
            finish([cities copy], [cityIndexes copy]);
   
        }
    }
}


@end
