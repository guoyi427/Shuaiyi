//
//  PhotoScrollView.h
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@protocol PhotoScrollViewDelegte <NSObject>

@required
- (NSString *)imageUrlAtIndex:(NSInteger)idx;
- (void)currentIndex:(NSInteger)idx;

- (NSInteger)imageCount;

- (void)downloadImageAtIndex:(UIImage *)image imgPath:(NSString *)imgUrl;

@end

@interface PhotoScrollView : UIView <UIScrollViewDelegate> {

    id<PhotoScrollViewDelegte> delegate;

    UIScrollView *pagingScrollView;

    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;

    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int firstVisiblePageIndexBeforeRotation;
    CGFloat percentScrolledIntoFirstVisiblePage;
}

@property (nonatomic, assign) id<PhotoScrollViewDelegte> delegate;

- (id)initWithFrame:(CGRect)frame initIndex:(int)idx delegate:(id<PhotoScrollViewDelegte>)dlg;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
