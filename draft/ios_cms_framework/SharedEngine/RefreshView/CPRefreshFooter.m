//
//  CPRefreshFooter.m
//  Cinephile
//
//  Created by Albert on 8/25/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPRefreshFooter.h"

@implementation CPRefreshFooter
-(void)prepare
{
    [super prepare];
    [self setTitle:KPullRefreshingHeaderText forState:MJRefreshStateRefreshing];
    [self setTitle:KPullLoadMoreTextNull forState:MJRefreshStateNoMoreData];
}
@end
