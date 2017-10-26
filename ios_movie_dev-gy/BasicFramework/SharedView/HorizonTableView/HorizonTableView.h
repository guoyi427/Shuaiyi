//
//  HorizonTableView.h
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@class HorizonTableView;

@protocol HorizonTableViewDelegate <NSObject>

@optional
- (NSInteger)rowWidthForHorizonTableView:(HorizonTableView *)tableView;
- (void)horizonTableView:(HorizonTableView *)tableView didSelectRowAtIndex:(int)index;
- (void)horizonTableView:(HorizonTableView *)tableView loadHeavyDataForCell:(UIView *)cell atIndex:(int)index;
- (void)horizonTableView:(HorizonTableView *)tableView configureCell:(id)cell atIndex:(int)index;

- (BOOL)shouldRefreshHorizonTableView:(HorizonTableView *)tableView;
- (void)refreshHorizonTableView:(HorizonTableView *)tableView;//refreshHorizonTableView
- (BOOL)shouldLoadmoreHorizonTableView:(HorizonTableView *)tableView;
- (void)loadmoreHorizonTableView:(HorizonTableView *)tableView;

@end 

@protocol HorizonTableViewDatasource <NSObject>

@required
- (NSInteger)numberOfRowsInHorizonTableView:(HorizonTableView *)tableView;
- (UIView *)horizonTableView:(HorizonTableView *)tableView cellForRowAtIndex:(int)index;

@end 

@interface HorizonTableView: UIView  < UIScrollViewDelegate >{
    id <HorizonTableViewDelegate> delegate;
    id <HorizonTableViewDatasource> datasource;

    UIScrollView *holderScrollView;
    NSRange visibleRange;
    
    PullToRefreshView *refreshView, *loadMoreView;
    
    NSMutableSet *visibleCells;
    NSMutableSet *recycledCells;
}

@property (nonatomic, assign) id <HorizonTableViewDelegate> delegate;
@property (nonatomic, assign) id <HorizonTableViewDatasource> datasource;

@property (nonatomic, retain) PullToRefreshView *refreshView;
@property (nonatomic, retain) PullToRefreshView *loadMoreView;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) float leftInset;
@property (nonatomic, strong) UIScrollView  *holderScrollViewYN;
@property (nonatomic, assign) BOOL isFromMovieList;

- (id)dequeueReusableCell;
- (id)cellAtIndex:(int)index;
- (void)scrollToRowAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)setTableBackgroundColor:(UIColor *)color;
- (void)showsHorizontalScrollIndicator:(BOOL)show;

- (void)resetRefreshStatusAndHideLoadMore:(BOOL)hide;
- (void)startRefresh;
- (void)finishRefresh;
- (void)startLoadmore;
- (void)finishLoadmore;

- (void)showLoadMore:(BOOL)show;
- (void)showRefresh:(BOOL)show;

- (void)reloadData;
- (void)reloadVisibleCells;

- (BOOL)dragging;
- (BOOL)decelerating;

@end
