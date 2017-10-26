//
//  PassbookTask.m
//  KoMovie
//
//  Created by KKZ on 15/8/18.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "PassbookTask.h"
#import "UserDefault.h"

@implementation PassbookTask

- (id)initPassbookDataWithOrderId:(NSString *)order_id
                     finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypePassBook;
        self.order_id = order_id;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    
    if (taskType == TaskTypePassBook) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"order_passbook" forKey:@"action"];
        [self addParametersWithValue:self.order_id forKey:@"order_id"];
        [self setRequestMethod:@"GET"];
        
        
        
//        http://121.40.237.152:8088/movie/service?action=order_passbook&enc=0675b8d2c8b66d9faf437ae071e7f225&order_id=a1439287393646649255
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypePassBook) {
        DLog(@"语音评论上传成功 %@", result);
        NSDictionary *dict = (NSDictionary *)result;
        NSString *komovie_pkpass = dict[@"komovie_pkpass"];
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   komovie_pkpass, @"komoviePkpass", nil]];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypePassBook) {
        DLog(@"passbook数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}
@end
