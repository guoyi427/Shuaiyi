//
//  RefreshTableView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TableRefreshStatePulling = 1, // 松开就可以进行刷新的状态
    TableRefreshStateNormal = 2, // 普通状态
    TableRefreshStateRefreshing = 3, // 正在刷新中的状态
} TableRefreshState;

@interface RefreshTableView : UIView

/**
 *  下拉文字
 */
@property (strong, nonatomic) NSString *tablePullToRefreshText;

/**
 *  松开手文字
 */
@property (strong, nonatomic) NSString *tableReleaseToRefreshText;

/**
 *  开始刷新的文字
 */
@property (strong, nonatomic) NSString *tableRefreshingText;

/**
 *  刷新状态
 */
@property (assign, nonatomic) TableRefreshState state;

/**
 *  开始进入刷新状态的监听器
 */
@property (weak, nonatomic) id tableBeginRefreshingTaget;

/**
 *  开始进入刷新状态的监听方法
 */
@property (assign, nonatomic) SEL tableBeginRefreshingAction;

@end
