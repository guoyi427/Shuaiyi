//
//  PhotoScrollView.m
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageEngine.h"
#import "ImageScrollView.h"
#import "PhotoScrollView.h"

@interface PhotoScrollView ()

- (void)configurePage:(ImageScrollView *)page forIndex:(int)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (ImageScrollView *)dequeueRecycledPage;

@end

@implementation PhotoScrollView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame initIndex:(int)idx delegate:(id<PhotoScrollViewDelegte>)dlg {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = dlg;

        CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
        pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
        pagingScrollView.pagingEnabled = YES;
        pagingScrollView.backgroundColor = [UIColor blackColor];
        pagingScrollView.showsVerticalScrollIndicator = NO;
        pagingScrollView.showsHorizontalScrollIndicator = NO;
        pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
        pagingScrollView.delegate = self;
        [self addSubview:pagingScrollView];

        recycledPages = [[NSMutableSet alloc] init];
        visiblePages = [[NSMutableSet alloc] init];
        [self tilePages];
    }
    return self;
}

- (void)dealloc {
    [pagingScrollView release];
    pagingScrollView = nil;
    [recycledPages release];
    recycledPages = nil;
    [visiblePages release];
    visiblePages = nil;

    [super dealloc];
}

#pragma mark Tiling and page configuration
- (void)tilePages {

    CGRect visibleBounds = pagingScrollView.bounds;

    NSInteger firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    NSInteger historyCount = 1, previewCount = 0;
    //preview count = 0, will load image at current index + 1
    firstNeededPageIndex = MAX(firstNeededPageIndex - historyCount, 0);

    NSInteger lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    lastNeededPageIndex = MAX(lastNeededPageIndex + previewCount, previewCount);
    lastNeededPageIndex = MIN(lastNeededPageIndex, [delegate imageCount] - 1);

    // Recycle no-longer-visible pages
    for (ImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];

    // add missing pages
    for (NSInteger index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:(int) index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
}

- (ImageScrollView *)dequeueRecycledPage {
    ImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (ImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ImageScrollView *)page forIndex:(int)index {
    page.index = index;
    page.imageURL = [delegate imageUrlAtIndex:index];
    page.frame = [self frameForPageAtIndex:index];
    if (pagingScrollView.dragging == NO && pagingScrollView.decelerating == NO) {

        [page loadImage];
    }
    UIImage *img = [[ImageEngine sharedImageEngine] getImageFromDiskForURL:[delegate imageUrlAtIndex:index]
                                                                   andSize:ImageSizeOrign];

    [self.delegate downloadImageAtIndex:img imgPath:[delegate imageUrlAtIndex:index]];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    NSInteger maxPages = [delegate imageCount];
    float maxOffset = pagingScrollView.contentSize.width - pagingScrollView.frame.size.width;

    if (index <= maxPages) {
        CGRect lastPageFrame = [self frameForPageAtIndex:index];

        DLog(@"lastPageFrame.origin.x%f", lastPageFrame.origin.x);

        if (lastPageFrame.origin.x < maxOffset) {
            [pagingScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x, 0) animated:animated];
        } else {
            [pagingScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
        }
    } else {
        CGRect lastPageFrame = [self frameForPageAtIndex:maxPages];
        if (lastPageFrame.origin.x < maxOffset) {
            [pagingScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x, 0) animated:animated];
        } else {
            [pagingScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
        }
    }
}

#pragma mark ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSMutableSet *s = [NSMutableSet setWithSet:visiblePages];
        for (ImageScrollView *page in s) {
            [page loadImage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int maxIndex = 0;
    NSMutableSet *s = [NSMutableSet setWithSet:visiblePages];
    for (ImageScrollView *page in s) {
        [page loadImage];
        maxIndex = MAX(maxIndex, page.index);

        DLog(@"index-----%d", page.index);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentIndex:)]) {
        [self.delegate currentIndex:maxIndex];
    }
}

#pragma mark Frame calculations
#define PADDING 1
- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = bounds.size.width * index;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [delegate imageCount], bounds.size.height);
}

@end
