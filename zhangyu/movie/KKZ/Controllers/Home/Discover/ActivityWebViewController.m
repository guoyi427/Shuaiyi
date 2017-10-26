//
//  我的 - 发现 - 活动
//
//  Created by 艾广华 on 16/4/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActivityWebViewController.h"

#import "NSURL+QueryDictionary.h"
#import "UserDefault.h"

@implementation ActivityWebViewController

- (id)initWithRequestURL:(NSString *)requestURL {
    self = [super init];
    if (self) {
        
        if (USER_CITY > 0) {
            //加入城市ID
            NSDictionary *dic = @{@"city_id":[NSNumber numberWithInt:USER_CITY]};
            NSURL *URL_pre = [NSURL URLWithString:requestURL];
            NSURL *newURL = [URL_pre uq_URLByAppendingQueryDictionary:dic];
             self.requestURL = newURL.absoluteString;
        }else{
             self.requestURL = requestURL;
        }
       
    }
    return self;
}

- (BOOL)showNavBar {
    return NO;
}

@end
