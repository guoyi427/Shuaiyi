//
//  CPRefreshHeader.m
//  Cinephile
//
//  Created by Albert on 8/25/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPRefreshHeader.h"
#import "CPRefreshAnimationView.h"

@interface CPRefreshHeader()
@property (nonatomic, strong) CPRefreshAnimationView *refreshBar;
@end

@implementation CPRefreshHeader
- (void)prepare
{
    [super prepare];
    //隐藏更新日期
    self.lastUpdatedTimeLabel.hidden = YES;
    //设置加载中 文字提示
    [self setTitle:KPullRefreshingHeaderText forState:MJRefreshStateRefreshing];

    CPRefreshAnimationView *refreshBar = [CPRefreshAnimationView new];
    [self addSubview:refreshBar];
    self.refreshBar = refreshBar;
    
    [refreshBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@K_REFRESH_BAR_WIDTH);
        make.height.equalTo(@30);
    }];
    
    self.mj_h = 80;
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    //在返回下拉刷新页面后，刷新动画会停止，所以在刷新状态改变时再次开始动画
    if (state == MJRefreshStatePulling) {
        [self.refreshBar startAnimation];
    }
}

@end
