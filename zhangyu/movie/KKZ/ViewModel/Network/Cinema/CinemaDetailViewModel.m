//
//  CinemaDetailViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CinemaDetailViewModel.h"
#import <objc/runtime.h>


@implementation CinemaDetailViewModel

+ (CinemaDetailModel *)getModelByCinemaModel:(NSObject *)cinema
                                         shareModel:(NSObject *)share
{
    CinemaDetailModel *info = [[CinemaDetailModel alloc] init];
    info = (CinemaDetailModel *)[CinemaDetailViewModel getModelAllInstance:cinema
                                                           withCommonModel:info];
    info = (CinemaDetailModel *)[CinemaDetailViewModel getModelAllInstance:share
                                                           withCommonModel:info];
    return info;
}

+ (NSObject *)getModelAllInstance:(NSObject *)model
                  withCommonModel:(NSObject *)info{
    u_int out_count;
    Ivar *ivar = class_copyIvarList([model class], &out_count);
    for (int i=0; i < out_count; i++) {
        NSString *name = [NSString stringWithCString:ivar_getName(ivar[i])
                                            encoding:NSUTF8StringEncoding];
//        const char *const_type = ivar_getTypeEncoding(ivar[i]);
        name = [name substringFromIndex:1];
        
        id propertyValue = [model valueForKey:(NSString *)name];
        if (propertyValue == nil || [propertyValue isEqual:[NSNull null]]) {
            continue;
        }

//        if ([propertyValue isMemberOfClass:[shareEditProfileModel class]]) {
//            continue;
//        }
        [info setValue:propertyValue forKey:name];
    }
    return info;
}

@end
