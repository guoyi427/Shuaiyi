//
//  我的社区 - 我的订阅号页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@class NoDataViewY;
@interface MySubscribesController : CommonViewController <UITableViewDataSource, UITableViewDelegate> {

    UIScrollView *holder;

    UITableView *mySubscribesView;

    NSInteger currentPage;

    //列表的提示信息
    NoDataViewY *nodataView;
}

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSMutableArray *mySubscribes;

@end
