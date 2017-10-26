//
//  购票失败页面
//
//  Created by KKZ on 15/9/9.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@interface PayOrderFailController : CommonViewController <UIScrollViewDelegate> {

    UIScrollView *holder;
}

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) Order *order;

- (id)initWithOrder:(NSString *)orderNo;

@end
