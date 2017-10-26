//
//  InfinitePagingView.m
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd All rights reserved.
//

#import "InfinitePagingView.h"

#define kHistoryCount 2

@interface InfinitePagingView () {

    UIScrollView *pageScrollView;

    NSMutableSet *visiblePages;
    NSMutableSet *recycledPages;
}

@property (nonatomic, assign) int currentPage;

@end

@implementation InfinitePagingView

#pragma mark - Lifecycle methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.delegate = self;
        pageScrollView.pagingEnabled = YES;
        [self addSubview:pageScrollView];

        visiblePages = [[NSMutableSet alloc] init];
        recycledPages = [[NSMutableSet alloc] init];

        [self tilePages];
    }
    return self;
}

- (void)dealloc {
    visiblePages = nil;
    recycledPages = nil;
}

#pragma mark - Public methods
/**
 * 是否正在拖动。
 */
- (BOOL)isDragging {
    return pageScrollView.dragging;
}

/**
 * 是否还没有停止滚动。
 */
- (BOOL)isDecelerating {
    return pageScrollView.decelerating;
}

/**
 * 重新加载数据。
 */
- (void)reloadData {
    NSInteger count = [self.dataSource pagingViewPageCount];
    pageScrollView.contentSize = CGSizeMake(count * [self.dataSource pagingViewPageWidth], pageScrollView.frame.size.height);
    [self refreshVisiblePages:count];
    [self tilePages];
}

- (void)refreshVisiblePages:(NSInteger)count {
    for (ThumbView *page in visiblePages) {
        if (count > 0 && page.index < count) {
            [self configPageView:page index:page.index];
        }
    }
}

/**
 * 滚动到指定的位置。
 *
 * @param index    位置
 * @param animated 是否有动画
 */
- (void)scrollToRowAtIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat pageWidth = [self.dataSource pagingViewPageWidth];
    NSInteger maxPages = [self.dataSource pagingViewPageCount];
    float maxOffset = pageScrollView.contentSize.width - pageScrollView.frame.size.width;

    if (index <= maxPages) {
        CGRect lastPageFrame = [self frameForPageAtIndex:index pageWidth:pageWidth];
        if (lastPageFrame.origin.x < maxOffset) {
            [pageScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x, 0) animated:animated];
        } else {
            [pageScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
        }
    } else {
        CGRect lastPageFrame = [self frameForPageAtIndex:maxPages pageWidth:pageWidth];
        if (lastPageFrame.origin.x < maxOffset) {
            [pageScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x, 0) animated:animated];
        } else {
            [pageScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
        }
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

// UIScrollView开始拖拽的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingViewDragBegan)]) {
        [self.delegate pagingViewDragBegan];
    }
}

// UIScrollView停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingViewScrollEnded)]) {
        [self.delegate pagingViewScrollEnded];
    }
}

#pragma mark - Self methods
- (void)setCurrentPage:(int)currentPage {
    if (currentPage != _currentPage) {
        _currentPage = currentPage;

        if (self.delegate && [self.delegate respondsToSelector:@selector(pagingViewSelectedChanged:)]) {
            [self.delegate pagingViewSelectedChanged:currentPage];
        }
    }
}

- (void)tilePages {
    NSInteger count = [self.dataSource pagingViewPageCount];
    CGFloat width = [self.dataSource pagingViewPageWidth];

    CGRect visibleBounds = pageScrollView.bounds;
    NSInteger firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / width);
    NSInteger lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds) - 1) / width);
    firstNeededPageIndex = MAX(firstNeededPageIndex - kHistoryCount, 0);
    lastNeededPageIndex = MAX(lastNeededPageIndex + 2, 2);
    lastNeededPageIndex = MIN(lastNeededPageIndex, count - 1);

    // Recycle unneeded controllers
    for (ThumbView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];

    self.currentPage = [self currentPageIndex];

    // Add missing pages
    for (NSInteger i = firstNeededPageIndex; i <= lastNeededPageIndex; i++) {
        if (![self isDisplayingPageForIndex:i]) {
            ThumbView *page = [self pageAtIndex:i pageWidth:width pageCount:count];
            [pageScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
}

- (int)currentPageIndex {
    return (int) ((pageScrollView.contentOffset.x + pageScrollView.frame.size.width) / [self.dataSource pagingViewPageWidth]);
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for (ThumbView *page in visiblePages)
        if (page.index == index)
            return YES;
    return NO;
}

- (ThumbView *)pageAtIndex:(NSInteger)index pageWidth:(NSInteger)width pageCount:(NSInteger)count {

    ThumbView *page = [self dequeueRecycledPage];
    if (!page) {
        page = [[ThumbView alloc] initWithFrame:[self frameForPageAtIndex:0 pageWidth:width]];
        

        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [page addGestureRecognizer:tap];
    }

    if (count) {
        @try {
            [self configPageView:page index:index];
        }
        @catch (NSException *exception) {
            LERR(exception);
        }
        @finally {
        }
    }
    page.frame = [self frameForPageAtIndex:index pageWidth:width];
    page.index = index;
    page.tag = index;
    return page;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagingViewTapped:)]) {
        [self.delegate pagingViewTapped:gesture.view.tag];
    }
}

- (ThumbView *)dequeueRecycledPage {
    ThumbView *page = [recycledPages anyObject];
    if (page) {
        [recycledPages removeObject:page];
    }
    return page;
}

- (CGRect)frameForPageAtIndex:(NSInteger)index pageWidth:(NSInteger)width {
    return CGRectMake(index * width, 0, width, pageScrollView.frame.size.height);
}

- (void)configPageView:(ThumbView *)page index:(NSInteger)index {
    page.imagePath = [self.dataSource pagingViewImagePathAtIndex:index];
    [page updateLayout];
}

@end
