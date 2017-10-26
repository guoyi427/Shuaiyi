//
//  ActivityDetailViewController.h
//  KoMovie
//
//  Created by wuzhen on 15/5/9.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "CommonWebViewController.h"
#import "NSObject+Delegate.h"

@interface ActivityDetailViewController : CommonWebViewController <HandleUrlProtocol>

@property (nonatomic, assign) NSInteger activityId;

- (id)initWithActivityId:(NSInteger)activityId;

@end
