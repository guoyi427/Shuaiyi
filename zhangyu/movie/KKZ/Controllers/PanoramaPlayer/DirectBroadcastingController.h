//
//  全景播放页面
//
//  Created by KKZ on 15/10/12.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "NSObject+Delegate.h"

@interface DirectBroadcastingController : CommonViewController <HandleUrlProtocol>

@property (nonatomic, strong) UIImageView *postImage;
@property (nonatomic, assign) long recordId;

- (void)requestVideoByRecordidWithRecordId:(long)recordId;

@end
