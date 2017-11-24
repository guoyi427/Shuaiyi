//
//  ClubNavTab.m
//  KoMovie
//
//  Created by KKZ on 16/2/29.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubNavTab.h"

#import "Constants.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation ClubNavTab

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

- (void)handleDate {

    if (self.type.integerValue == 1) {
        NSString *urLbodyStr = [self.url stringByReplacingOccurrencesOfString:@"ZhangYu://app/page?" withString:@""];

        NSArray *params = [urLbodyStr componentsSeparatedByString:@"url="];

        NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithCapacity:0];

        if (params.count > 1) {

            NSString *subUrlStr = params[1];

            NSArray *contents = [subUrlStr componentsSeparatedByString:@"?"];

            NSArray *subParams = [contents[1] componentsSeparatedByString:@"&"];

            for (int i = 0; i < subParams.count; i++) {
                NSArray *dictParamArray = [subParams[i] componentsSeparatedByString:@"="];

                NSString *dictParamKey = dictParamArray[0];
                if (dictParamKey.length > 0) {
                    NSString *dictParamValue = dictParamArray[1];
                    if (dictParamValue.length > 0) {
                        dictParams[dictParamArray[0]] = dictParamValue;
                    }
                }
            }

            //            NSString *movie_ids = [dictParams kkz_stringForKey:@"movie_ids"];
            NSString *search_state = [dictParams kkz_stringForKey:@"search_state"];
            //            NSString *rows = [dictParams kkz_stringForKey:@"rows"];
            NSString *page = [dictParams kkz_stringForKey:@"page"];
            self.currentPage = [page integerValue];

            self.currentUrl = subUrlStr;

            self.firstPageUrl = subUrlStr;

            self.search_state = search_state;
        }

    } else if (self.type.integerValue == 2) {

        self.currentUrl = self.url;
        self.firstPageUrl = self.url;
    }
}

@end
