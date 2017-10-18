//
//  MovieChildViewController.h
//  CIASMovie
//
//  Created by cias on 2017/2/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieChildViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIScrollView *holder;
    UIView *incomingDateCollectionViewBg;
    UICollectionView *incomingDateCollectionView;
    UIView *segmentBtnBackgroundView;
    UIButton *reyingBtn, *incomingBtn;
    UIView *btnBottomLine;
    UICollectionView *movieCollectionView, *incomingMovieCollectionView;
    NSInteger pageNum, incomingPageNum;
    BOOL tableLock, initFirst;

}

@property (nonatomic, assign) NSInteger selectDateRow;
@property (nonatomic, assign) BOOL isReying;

@property (nonatomic, strong) NSMutableArray *incomingDateList;
@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) NSMutableArray *incomingMovieList;

- (void)segmentedControlSelectMovie;
- (void)reyingBtnClick;

- (void)requestMovieList:(NSInteger)page;
- (void)requestIncomingMovieDateList;
- (void)requestIncomingMovieList:(NSInteger)page;

@end
