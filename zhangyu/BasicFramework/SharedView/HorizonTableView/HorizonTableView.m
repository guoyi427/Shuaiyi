//

//  HorizonTableView.m

//  simpleread

//

//  Created by zhang da on 11-4-24.

//  Copyright 2011年 __MyCompanyName__. All rights reserved.

//



#import "HorizonTableView.h"



@interface HorizonTableView (Private)



- (void)tilePages;

- (int)indexFromFrame:(CGRect)frame;



- (int)currentPageIndex;

- (CGRect)frameForPageAtIndex:(NSInteger)index;



- (NSInteger)widthForRow;

- (NSInteger)numOfCells;



@end





@implementation HorizonTableView





@synthesize delegate, datasource;

@synthesize refreshView, loadMoreView;

@synthesize scrollEnabled;



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = NO;
        
        holderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        holderScrollView.backgroundColor = [UIColor clearColor];
        
        holderScrollView.showsHorizontalScrollIndicator = NO;
        
        holderScrollView.alwaysBounceHorizontal = YES;
        
        holderScrollView.clipsToBounds = NO;
        
        holderScrollView.delegate = self;
        
        [self addSubview: holderScrollView];

        
        
        
        self.holderScrollViewYN =holderScrollView;
        
        
        
        refreshView = [[PullToRefreshView alloc] initWithFrame:CGRectMake(-40,
                                                                          
                                                                          0.0f,
                                                                          
                                                                          40,
                                                                          
                                                                          holderScrollView.bounds.size.height)];
        
        refreshView.titleColor = [UIColor whiteColor];
        
        //        [holderScrollView addSubview:refreshView];
        
        loadMoreView = [[PullToRefreshView alloc] initWithFrame:CGRectMake(holderScrollView.bounds.size.width,
                                                                           
                                                                           0.0f,
                                                                           
                                                                           40,
                                                                           
                                                                           holderScrollView.bounds.size.height)];
        
        
        
        visibleCells = [[NSMutableSet alloc] init];
        
        recycledCells = [[NSMutableSet alloc] init];
        
        
        
        visibleRange = NSMakeRange(0, 0);
        
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                       
                                                                              action:@selector(tapDetected:)];
        
        tap.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:tap];
        
        [tap release];
        
        
        
        [self tilePages];
        
    }
    
    return self;
    
}



- (void)dealloc {
    
    [visibleCells release];
    
    [recycledCells release];
    
    
    
    [refreshView release];
    
    [loadMoreView release];
    
    [holderScrollView release];
    
    [super dealloc];
    
}







#pragma mark utility

- (void)reloadData {
    
    //    int currentIndex = [self currentPageIndex];
    
    if (self.isFromMovieList) {
            holderScrollView.contentInset = UIEdgeInsetsMake(0, (screentWith - [self widthForRow]) * 0.5, 0, (screentWith - [self widthForRow]) * 0.5 - 15);
    }


    [self tilePages];
    
    [self reloadVisibleCells];
    
    
    
    holderScrollView.contentSize = CGSizeMake( MAX([self widthForRow]*[self numOfCells], holderScrollView.frame.size.width),
                                              
                                              holderScrollView.frame.size.height);
    
    refreshView.state = RefreshNormal;
    
    loadMoreView.state = RefreshNormal;

}



- (NSInteger)widthForRow {
    
    if (delegate && [delegate respondsToSelector:@selector(rowWidthForHorizonTableView:)]) {
        
        return [delegate rowWidthForHorizonTableView:self];
        
    }
    
    return 44;
    
}



- (NSInteger)numOfCells {
    
    if (datasource && [datasource respondsToSelector:@selector(numberOfRowsInHorizonTableView:)]) {
        
        return [datasource numberOfRowsInHorizonTableView:self];
        
    }
    
    return 0;
    
}



- (void)doHeavyWorkForVisibleRows {
    
    /*
     
     if (delegate && [delegate respondsToSelector:@selector(horizonTableView:loadHeavyDataForCell:atIndex:)]) {
     
     for (UIView *cell in visibleCells) {
     
     int cellIndex = [self indexFromFrame:cell.frame];
     
     [delegate horizonTableView:self loadHeavyDataForCell:cell atIndex:cellIndex];
     
     }
     
     }*/
    
}



- (void)scrollToRowAtIndex:(NSInteger)index animated:(BOOL)animated {
    
     NSInteger maxPages = [self numOfCells];
     
    float maxOffset = holderScrollView.contentSize.width;
//    - holderScrollView.frame.size.width;
    
     
     
     if (index <= maxPages) {
     
     CGRect lastPageFrame = [self frameForPageAtIndex:index];
     
//     if (lastPageFrame.origin.x < holderScrollView.frame.size.width) {
//         
//         [holderScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x - holderScrollView.frame.size.width * 0.5, 0) animated:animated];
//         
//     } else
         
    if (lastPageFrame.origin.x < maxOffset) {
     
     [holderScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x - holderScrollView.frame.size.width * 0.5 + (lastPageFrame.size.width - 15) * 0.5, 0) animated:animated];
     
     } else {
     
     [holderScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
     
     }
     
     } else {
     
     CGRect lastPageFrame = [self frameForPageAtIndex:maxPages];
     
     if (lastPageFrame.origin.x < maxOffset) {
     
     [holderScrollView setContentOffset:CGPointMake(lastPageFrame.origin.x, 0) animated:animated];
     
     } else {
     
     [holderScrollView setContentOffset:CGPointMake(maxOffset, 0) animated:animated];
     
     }
     
     }
}



- (id)cellAtIndex:(int)index {
    
    for (UIView *cell in visibleCells) {
        
        int cellIndex = [self indexFromFrame:cell.frame];
        
        if (cellIndex == index) {
            
            return [[cell retain] autorelease];
            
        }
        
    }
    
    return nil;
    
}



- (void)tapDetected:(UITapGestureRecognizer *)gesture {
    
    for (UIView *view in visibleCells) {
        
        CGPoint point = [gesture locationInView:view];
        
        if ([view pointInside:point withEvent:nil]) {
            
            int cellIndex = [self indexFromFrame:view.frame];
            
            if (delegate && [delegate respondsToSelector:@selector(horizonTableView:didSelectRowAtIndex:)]) {
                
                [delegate horizonTableView:self didSelectRowAtIndex:cellIndex];
                
            }
            
            return;
            
        }
        
    }
    
}



- (BOOL)dragging {
    
    return holderScrollView.dragging;
    
}



- (BOOL)decelerating {
    
    return holderScrollView.decelerating;
    
}



- (void)startRefresh {
    
    /*
     
     refreshView.state = RefreshLoading;
     
     
     
     [UIView animateWithDuration:.3
     
     animations:^{
     
     holderScrollView.contentInset = UIEdgeInsetsMake(0, 40.0f, 0, 0.0f);
     
     [holderScrollView setContentOffset:CGPointMake(-40, 0)
     
     animated:YES];
     
     }];
     
     */
    
}



- (void)finishRefresh {
    
    /*
     
     [UIView animateWithDuration:.3
     
     delay:0
     
     options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
     
     
     
     holderScrollView.contentInset = UIEdgeInsetsZero;
     
     
     
     } completion:^(BOOL finished) {
     
     refreshView.state = RefreshNormal;
     
     if (holderScrollView.contentOffset.x <= 0) {
     
     [holderScrollView setContentOffset:CGPointZero animated:YES];
     
     }
     
     }];
     
     */
    
}



- (void)startLoadmore {
    
    /*
     
     loadMoreView.state = RefreshLoading;
     
     
     
     [UIView animateWithDuration:.3
     
     animations:^{
     
     holderScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 40.0f);
     
     [holderScrollView setContentOffset:CGPointMake(holderScrollView.contentSize.width
     
     - holderScrollView.frame.size.width
     
     + 40.0f,
     
     0)
     
     animated:YES];
     
     }];
     
     */
    
}



- (void)finishLoadmore {
    
    /*
     
     [UIView animateWithDuration:.3
     
     delay:0
     
     options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
     
     
     
     holderScrollView.contentInset = UIEdgeInsetsZero;
     
     
     
     } completion:^(BOOL finished) {
     
     loadMoreView.state = RefreshNormal;
     
     if (holderScrollView.contentOffset.x >=
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width ) {
     
     [holderScrollView setContentOffset:CGPointMake(holderScrollView.contentSize.width
     
     - holderScrollView.frame.size.width, 0)
     
     animated:YES];
     
     }
     
     }];
     
     */
    
}



- (void)showLoadMore:(BOOL)show {
    
    /*
     
     if (show) {
     
     [holderScrollView addSubview:loadMoreView];
     
     } else {
     
     [loadMoreView removeFromSuperview];
     
     UIEdgeInsets origin = holderScrollView.contentInset;
     
     origin.right = 0;
     
     holderScrollView.contentInset = origin;
     
     if (holderScrollView.contentOffset.x >=
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width ) {
     
     [holderScrollView setContentOffset:CGPointMake(holderScrollView.contentSize.width
     
     - holderScrollView.frame.size.width, 0)
     
     animated:YES];
     
     }
     
     }
     
     */
    
}



- (void)showRefresh:(BOOL)show {
    
    /*
     
     if (show) {
     
     [holderScrollView addSubview:refreshView];
     
     } else {
     
     [refreshView removeFromSuperview];
     
     UIEdgeInsets origin = holderScrollView.contentInset;
     
     origin.left = 0;
     
     holderScrollView.contentInset = origin;
     
     if (holderScrollView.contentOffset.x <= 0) {
     
     [holderScrollView setContentOffset:CGPointZero animated:YES];
     
     }
     
     }*/
    
    
    
}



- (void)resetRefreshStatusAndHideLoadMore:(BOOL)hide {
    
    /*
     
     [UIView animateWithDuration:0.3f
     
     delay:0.0f
     
     options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
     
     
     
     holderScrollView.contentInset = UIEdgeInsetsZero;
     
     
     
     } completion:^(BOOL finished) {
     
     refreshView.state = RefreshNormal;
     
     loadMoreView.state = RefreshNormal;
     
     
     
     if (holderScrollView.contentOffset.x <= 0) {
     
     [holderScrollView setContentOffset:CGPointZero animated:YES];
     
     } else if (holderScrollView.contentOffset.x >=
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width ) {
     
     [holderScrollView setContentOffset:CGPointMake(holderScrollView.contentSize.width
     
     - holderScrollView.frame.size.width, 0)
     
     animated:YES];
     
     }
     
     
     
     if (hide) {
     
     [loadMoreView removeFromSuperview];
     
     } else {
     
     loadMoreView.frame = CGRectMake(holderScrollView.contentSize.width,
     
     0.0f,
     
     40,
     
     holderScrollView.bounds.size.height);
     
     [holderScrollView addSubview:loadMoreView];
     
     }
     
     }];
     
     */
    
}



- (void)setTableBackgroundColor:(UIColor *)color {
    
    holderScrollView.backgroundColor = color;
    
    refreshView.backgroundColor = color;
    
    loadMoreView.backgroundColor = color;
    
}



- (void)showsHorizontalScrollIndicator:(BOOL)show {
    
    holderScrollView.showsHorizontalScrollIndicator = show;
    
}



- (void)setScrollEnabled:(BOOL)sEnabled{
    
    holderScrollView.scrollEnabled = sEnabled;
    
}



#pragma mark uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isFromMovieList) {
        if (holderScrollView.contentOffset.y >= 0) {
            DLog(@"scrollView.contentOffset.y >= 0 %f",scrollView.contentOffset.y);
            holderScrollView.contentInset = UIEdgeInsetsMake(0, (screentWith - [self widthForRow]) * 0.5, 0, (screentWith - [self widthForRow]) * 0.5 - 15);
        }else{
            DLog(@"scrollView.contentOffset.y < 0 %f",scrollView.contentOffset.y);
            holderScrollView.contentInset = UIEdgeInsetsZero;
        }

    }
        [self tilePages];
    
    /*
     
     if (!refreshView.superview && scrollView.contentOffset.x<0) {
     
     [holderScrollView setContentOffset:CGPointZero animated:NO];
     
     }
     
     if (scrollView.isDragging
     
     && refreshView.state != RefreshLoading
     
     && loadMoreView.state != RefreshLoading ) {
     
     
     
     if (refreshView.state == RefreshPulling
     
     && scrollView.contentOffset.x >= -40.0f
     
     && scrollView.contentOffset.x < 0.0f ) {
     
     refreshView.state = RefreshNormal;
     
     } else if (refreshView.state == RefreshNormal
     
     && scrollView.contentOffset.x < -40.0f ) {
     
     refreshView.state = RefreshPulling;
     
     }
     
     
     
     if ( loadMoreView.state == RefreshPulling
     
     && holderScrollView.contentOffset.x <= holderScrollView.contentSize.width - holderScrollView.frame.size.width + 40.0f
     
     && holderScrollView.contentOffset.x >
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width ) {
     
     loadMoreView.state = RefreshNormal;
     
     } else if (loadMoreView.state == RefreshNormal
     
     && holderScrollView.contentOffset.x >
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width + 40.0f ) {
     
     loadMoreView.state = RefreshPulling;
     
     }
     
     
     
     }*/
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    /*
     
     if (!decelerate) {
     
     [self doHeavyWorkForVisibleRows];
     
     }
     
     
     
     if (refreshView.state == RefreshLoading
     
     || loadMoreView.state == RefreshLoading )
     
     return;
     
     
     
     if (holderScrollView.contentOffset.x < - 40.0f) {
     
     BOOL refresh = NO;
     
     if (delegate && [delegate respondsToSelector:@selector(shouldRefreshHorizonTableView:)]) {
     
     refresh = [delegate shouldRefreshHorizonTableView:self];
     
     }
     
     if (refresh) {
     
     if (delegate && [delegate respondsToSelector:@selector(refreshHorizonTableView:)]) {
     
     [delegate refreshHorizonTableView:self];
     
     refreshView.state = RefreshLoading;
     
     [UIView animateWithDuration:.5
     
     animations:^{
     
     holderScrollView.contentInset = UIEdgeInsetsMake(0, 40.0f, 0, 0.0f);
     
     [holderScrollView setContentOffset:CGPointMake(-40, 0)
     
     animated:NO];
     
     }];
     
     }
     
     }
     
     }
     
     if (holderScrollView.contentOffset.x >
     
     holderScrollView.contentSize.width - holderScrollView.frame.size.width + 40.0f
     
     && [loadMoreView superview]) {
     
     BOOL loadmore = NO;
     
     if (delegate && [delegate respondsToSelector:@selector(shouldLoadmoreHorizonTableView:)]) {
     
     loadmore = [delegate shouldLoadmoreHorizonTableView:self];
     
     }
     
     if (loadmore) {
     
     if (delegate && [delegate respondsToSelector:@selector(loadmoreHorizonTableView:)]) {
     
     [delegate loadmoreHorizonTableView:self];
     
     loadMoreView.state = RefreshLoading;
     
     [UIView animateWithDuration:.5
     
     animations:^{
     
     holderScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 40.0f);
     
     [holderScrollView setContentOffset:CGPointMake(holderScrollView.contentSize.width
     
     - holderScrollView.frame.size.width
     
     + 40.0f, 0)
     
     animated:NO];
     
     }];
     
     }
     
     }
     
     }
     
     */
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self doHeavyWorkForVisibleRows];
    
    
    
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    DLog(@"scrollView.contentOffset %f",scrollView.contentOffset.x);
    DLog(@"scrollView.contentInset %f",scrollView.contentInset.left);
    
//    holderScrollView.contentInset = UIEdgeInsetsMake(0, 80.0f, 0, 80.0f);
    /*
     
     if ( scrollView.contentOffset.x <= 0 && refreshView.state != RefreshLoading ) {
     
     [holderScrollView setContentOffset:CGPointZero animated:YES];
     
     }*/
    
}







#pragma mark recyle scroll view part

- (int)currentPageIndex {
    
    return (int)(((holderScrollView.contentOffset.x + holderScrollView.frame.size.width) / [self widthForRow]));
    
}



- (int)indexFromFrame:(CGRect)frame {
    
    return (int)( frame.origin.x / [self widthForRow]);
    
}



- (BOOL)isDisplayingCellForIndex:(int)index {
    
    for (UIView *cell in visibleCells)
        
        if ([self indexFromFrame:cell.frame] == index)
            
            return YES;
    
    return NO;
    
}



- (id)dequeueReusableCell {
    
    id cell = [recycledCells anyObject];
    
    if (cell) {
        
        [[cell retain] autorelease];
        
        [recycledCells removeObject:cell];
        
        return cell;
        
    } else {
        
        return nil;
        
    }
    
}



- (CGRect)frameForPageAtIndex:(NSInteger)index {
    
    return CGRectMake(index*[self widthForRow],
                      
                      0,
                      
                      [self widthForRow],
                      
                      holderScrollView.frame.size.height);
    
}



- (void)tilePages {
    
    
    
    CGRect visibleBounds = holderScrollView.bounds;
    
    
    
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / [self widthForRow]);
    
    NSInteger historyCount = 1;
    
    firstNeededPageIndex = (int)MAX(firstNeededPageIndex - historyCount, 0);
    
    
    
    int lastNeededPageIndex = (int)floorf((CGRectGetMaxX(visibleBounds)-1) / [self widthForRow]);
    
    lastNeededPageIndex  = (int)MAX(lastNeededPageIndex+1, 1);
    
    lastNeededPageIndex = (int)MIN(lastNeededPageIndex, [self numOfCells] -1);
    
    //    lastNeededPageIndex = MAX(lastNeededPageIndex, firstNeededPageIndex);
    
    
    
    if (visibleRange.location != firstNeededPageIndex
        
        || visibleRange.location + visibleRange.length != lastNeededPageIndex) {
        
        
        
        visibleRange.location = firstNeededPageIndex;
        
        visibleRange.length = lastNeededPageIndex - firstNeededPageIndex;
        
        
        
        for (UIView *cell in visibleCells) {
            
            int cellIndex = [self indexFromFrame:cell.frame];
            
            if (cellIndex < firstNeededPageIndex || cellIndex > lastNeededPageIndex) {
                
                [recycledCells addObject:cell];
                
                [cell removeFromSuperview];
                
            }
            
        }
        
        [visibleCells minusSet:recycledCells];
        
        
        
        for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; i++) {
            
            if (![self isDisplayingCellForIndex:i]) {
                
                UIView *cell = [datasource horizonTableView:self cellForRowAtIndex:i];
                
                cell.frame = [self frameForPageAtIndex:i];
                
                [holderScrollView addSubview:cell];
                
                [visibleCells addObject:cell];
                
            }
            
        }
        
        
        
        //        DLog(@"visible pages changed:%@", visibleCells);
        
    }
    
    
    
}



- (void)reloadVisibleCells {
    
    
    
    if (delegate && [delegate respondsToSelector:@selector(horizonTableView:configureCell:atIndex:)]) {
        
        NSInteger pageNum = [self numOfCells];
        
        if (pageNum > 0){
            
            for (UIView *cell in visibleCells) {
                
                int cellIndex = [self indexFromFrame:cell.frame];
                
                if(cellIndex < pageNum) {
                    
                    [delegate horizonTableView:self configureCell:cell atIndex:cellIndex];
                    
                    cell.frame = [self frameForPageAtIndex:cellIndex];
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    
}





@end

