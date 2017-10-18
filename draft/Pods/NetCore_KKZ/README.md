# 网络请求
---

`NetCore_KKZ`是用来做网络请求和处理网络请求结果`model`映射的库。

`NetCore_KKZ`用在[AFNetworking](https://github.com/AFNetworking/AFNetworking)处理网络请求，[Mantle](https://github.com/Mantle/Mantle)做请求结果的`model`映射之上进行封装的。


## 安装
添加[kokozu私有库源](http://git.cias.net.cn/ios_specs/Specs)

在Podfile内添加

	pod 'NetCore_KKZ'

执行`pod install`

## 使用

举例具体参见[NetCore_KKZ_example](http://git.cias.net.cn/ios_specs/NetCore_KKZ/tree/master/NetCore_KKZ_example)

共分为两部分，`model声明`、每个接口的`Request`。


### model声明
此处只是简单举例，更详细的`Mantle`使用方法，前往[Mantle](https://github.com/Mantle/Mantle)。

KKZBanner.h

```
#import <Mantle/Mantle.h>

@interface KKZBanner : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *bannerId;
@property (nonatomic, copy) NSString *channelIds;
@property (nonatomic) BOOL  del;
@property (nonatomic, copy) NSURL *imagePath;
@property (nonatomic, copy) NSURL *targetUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *url;
@end

```
KKZBanner.m

```
#import "KKZBanner.h"

@implementation KKZBanner
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bannerId":@"bannerId",
             @"channelIds":@"channelIds",
             @"del":@"del",
             @"imagePath":@"imagePath",
             @"targetUrl":@"targetUrl",
             @"title":@"title",
             @"url":@"url",
             };
}

+ (NSValueTransformer *) delJSONTransformer
{
    return  [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *) imagePathSONTransformer
{
    return  [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *) targetUrlPathSONTransformer
{
    return  [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *) urlPathSONTransformer
{
    return  [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end

```

### Request例子
BannerRequest.h

```
#import <Foundation/Foundation.h>
#import "KKZBanner.h"

@interface BannerRequest : NSObject
- (void) requestBannersParams:(NSDictionary * _Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable banners))success
                      failure:(nullable void (^)(NSError * _Nullable err))failure;
@end

```

根据API参数要求，在`.m`内整理API请求参数，指明请求响应需要解析的`key`和对应的`model`

BannerRequest.m

```
#import "BannerRequest.h"

#import <NetCore_KKZ/KKZBaseNetRequest.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>

@implementation BannerRequest
- (void) requestBannersParams:(NSDictionary * _Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable banners))success
                      failure:(nullable void (^)(NSError * _Nullable err))failure
{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:@"http://121.40.179.94:8081" baseParams:baseParams];
    
    NSDictionary *dicHeader = @{
                                @"channel_id":@"1",
                                @"channel_name":@"App Store",
                                @"version":@"5.2.6",
                                };
    request.headerField = dicHeader;
    //set model peser key
    request.paserKey = @"banners";
    
    NSMutableDictionary *bannerParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setObject:@"banner_query" forKey:@"action"];
    [bannerParams setObject:@"36" forKey:@"city_id"];
    [bannerParams setObject:@"1" forKey:@"target_type"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:bannerParams];
    
    [request GET:@"/api_movie/service" parameters:newParams
     resultClass:[KKZBanner class]
         success:^(id  _Nullable data, id  _Nullable respomsObject) {
        if (success) {
            success(data);
        }
    } failure:failure];
    
}
@end

```
### header
请求headser统一设置参考[KKZBaseNetRequest+HeaderField.m](NetCore_KKZ_example/NetCore_KKZ_example/KKZBaseNetRequest+HeaderField.m)