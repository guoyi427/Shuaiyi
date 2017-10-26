//
//  InfinitePagingView.h
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd All rights reserved.
//

#import "ThumbView.h"

@protocol InfinitePagingViewDataSource <NSObject>

@required

/**
 * 指定每一页图片的数据。
 */
- (NSString *)pagingViewImagePathAtIndex:(NSInteger)index;

/**
 * 页数。
 */
- (NSInteger)pagingViewPageCount;

/**
 * 每一页的宽度。
 */
- (CGFloat)pagingViewPageWidth;

@end

@protocol InfinitePagingViewDelegate <NSObject>

@optional
/**
 * 选中的Index发生改变。
 */
- (void)pagingViewSelectedChanged:(NSInteger)newPage;

/**
 * Page被点击的事件。
 */
- (void)pagingViewTapped:(NSInteger)index;

/**
 * 开始拖动UIScrollView。
 */
- (void)pagingViewDragBegan;

/**
 * 停止滚动。
 */
- (void)pagingViewScrollEnded;

@end

@interface InfinitePagingView : UIView <UIScrollViewDelegate>

/**
 * DataSource。
 */
@property (nonatomic, assign) id<InfinitePagingViewDataSource> dataSource;

/**
 * Delegate。
 */
@property (nonatomic, assign) id<InfinitePagingViewDelegate> delegate;

/**
 * 是否正在拖动。
 */
@property (nonatomic, readonly, getter=isDragging) BOOL dragging;

/**
 * 是否还没有停止滚动。
 */
@property (nonatomic, readonly, getter=isDecelerating) BOOL decelerating;

/**
 * 重新加载数据。
 */
- (void)reloadData;

/**
 * 滚动到指定的位置。
 *
 * @param index    位置
 * @param animated 是否有动画
 */
- (void)scrollToRowAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
