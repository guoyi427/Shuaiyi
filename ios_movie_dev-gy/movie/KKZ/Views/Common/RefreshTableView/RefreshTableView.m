//
//  RefreshTableView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "RefreshTableView.h"
#import "UIView+RefreshTable.h"
#import "UIScrollView+RefreshExtension.h"
#import <objc/runtime.h>

NSString *const TableRefreshHeaderPullToRefresh = @"下拉可以刷新";
NSString *const TableRefreshHeaderReleaseToRefresh = @"松开立即刷新";
NSString *const TableRefreshHeaderRefreshing = @"正在帮你刷新...";
NSString *const TableRefreshContentOffset = @"contentOffset";

const CGFloat TableRefreshFastAnimationDuration = 0.25;

#define refreshMsgSend(...) ((void (*)(void *, SEL, UIView *)) objc_msgSend)(__VA_ARGS__)
#define refreshMsgTarget(target) (__bridge void *)(target)

@interface RefreshTableView ()

/**
 *  状态标签
 */
@property (nonatomic, strong) UILabel *statusLabel;

/**
 *  父滚动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  父类的inset坐标
 */
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

/**
 *  加载框
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation RefreshTableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tablePullToRefreshText = TableRefreshHeaderPullToRefresh;
        self.tableReleaseToRefreshText = TableRefreshHeaderReleaseToRefresh;
        self.tableRefreshingText = TableRefreshHeaderRefreshing;
        self.state = TableRefreshStateNormal;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {

    CGFloat statusX = 0;
    CGFloat statusY = 18;
    CGFloat statusHeight = self.headerView_height * 0.5;
    CGFloat statusWidth = self.headerView_width;
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);

    //加载框尺寸
    _activityView.frame = CGRectMake((self.frame.size.width - 20) / 2, self.frame.size.height - 35, 20, 20);
}

- (void)setTablePullToRefreshText:(NSString *)tablePullToRefreshText {
    _tablePullToRefreshText = tablePullToRefreshText;
    [self settingLabelText];
}

- (void)setTableReleaseToRefreshText:(NSString *)tableReleaseToRefreshText {
    _tableReleaseToRefreshText = tableReleaseToRefreshText;
    [self settingLabelText];
}

- (void)setTableRefreshingText:(NSString *)tableRefreshingText {
    _tableRefreshingText = tableRefreshingText;
    [self settingLabelText];
}

- (void)settingLabelText {
    switch (self.state) {
        case TableRefreshStateNormal: {
            self.statusLabel.text = self.tablePullToRefreshText;
            break;
        }
        case TableRefreshStatePulling: {
            self.statusLabel.text = self.tableReleaseToRefreshText;
            break;
        }
        case TableRefreshStateRefreshing: {
            self.statusLabel.text = self.tableRefreshingText;
            break;
        }
        default:
            break;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    //移除旧的父类通知
    [self.superview removeObserver:self
                        forKeyPath:TableRefreshContentOffset
                           context:nil];

    if (newSuperview) {

        //添加观察者
        [newSuperview addObserver:self
                       forKeyPath:TableRefreshContentOffset
                          options:NSKeyValueObservingOptionNew
                          context:nil];

        //设置位置
        self.headerView_x = 0;

        //设置宽度
        self.headerView_width = newSuperview.headerView_width;

        //设置y坐标
        self.headerView_y = -self.headerView_height;

        //设置滚动视图
        _scrollView = (UIScrollView *) newSuperview;

        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;

        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden)
        return;

    //当前正在刷新就直接返回
    if (self.state == TableRefreshStateRefreshing) {
        return;
    }

    //如果是ContentOffset的属性变化就执行变化状态操作
    if ([TableRefreshContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

- (void)adjustStateWithContentOffset {

    //当前滚动条滚动的距离
    CGFloat currentOffsetY = self.scrollView.table_contentOffsetY;

    //当前滚动条的顶部偏移量
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;

    if (self.scrollView.isDragging) {

        //如果顶部inset变量有值时
        CGFloat normal2pullingOffsetY = happenOffsetY - self.headerView_height;

        if (self.state == TableRefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
            self.state = TableRefreshStatePulling;
        } else if (self.state == TableRefreshStatePulling && currentOffsetY > normal2pullingOffsetY) {
            self.state = TableRefreshStateNormal;
        }
    } else if (self.state == TableRefreshStatePulling) {
        self.state = TableRefreshStateRefreshing;
    }
}

- (void)setState:(TableRefreshState)state {

    if (self.state == state) {
        return;
    }

    _state = state;

    switch (state) {
        case TableRefreshStateNormal: {
            self.statusLabel.text = _tablePullToRefreshText;
            [self.activityView stopAnimating];
            self.scrollView.scrollEnabled = YES;
            [UIView animateWithDuration:TableRefreshFastAnimationDuration
                             animations:^{
                                 self.scrollView.table_contentInsetTop = 0;
                             }];
            break;
        }
        case TableRefreshStatePulling: {
            self.statusLabel.text = _tableReleaseToRefreshText;
            [self.activityView stopAnimating];
            break;
        }
        case TableRefreshStateRefreshing: {
            self.statusLabel.text = @"";
            [self.activityView startAnimating];
            self.scrollView.scrollEnabled = NO;
            [UIView animateWithDuration:TableRefreshFastAnimationDuration
                             animations:^{

                                 // 1.增加滚动区域
                                 CGFloat top = self.scrollViewOriginalInset.top + self.headerView_height;
                                 self.scrollView.table_contentInsetTop = top;

                                 // 2.设置滚动位置
                                 self.scrollView.table_contentOffsetY = -top;
                             }];

            // 回调
            if ([self.tableBeginRefreshingTaget respondsToSelector:self.tableBeginRefreshingAction]) {
                //                refreshMsgSend(refreshMsgTarget(self.tableBeginRefreshingTaget),self.tableBeginRefreshingAction,self);
                [self.tableBeginRefreshingTaget performSelector:self.tableBeginRefreshingAction
                                                     withObject:nil];
            }

            break;
        }
        default:
            break;
    }
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:13];
        _statusLabel.textColor = [UIColor colorWithRed:150.0f / 255.0f
                                                 green:150.0f / 255.0f
                                                  blue:150.0f / 255.0f
                                                 alpha:1.0f];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)activityView {

    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
    }
    return _activityView;
}

@end
