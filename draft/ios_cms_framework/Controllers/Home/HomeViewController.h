//
//  HomeViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBannerView.h"

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>{
    UIScrollView     *srollViewHolder;
    UIView           *holder;
    UITableView      *homeTableView;
    UIView           *headerTableView;
    CPBannerView     *bannerView;
    UIButton         *reyingBtn, *incomingBtn;
    UIView           *btnBottomLine;
    UICollectionView *movieCollectionView, *productCollectionView, *futureCollectionView;
    
    UIView      *cinemaNameView;
    UILabel     *cinemaNameLabel;
    UIImageView *arrowImageView;
    UIButton    *selectCinemaBtn;
    BOOL        isFirstInit;
    UIView      *yellowView1;
    UILabel     *sectionLabel1;
    UIButton    *gotoProductBtn;
    UIButton    *gotoOrderDetailBtn;
    UIImageView *gotoOrderImageView,*gotoOrderTipImageView;
    UILabel     *gotoOrderTipLabel;
}

@property (nonatomic, strong) UIView        *navBar;
@property (nonatomic, strong) NSMutableArray         *bannerList;
@property (nonatomic, strong) NSMutableArray         *movieList;
@property (nonatomic, strong) NSMutableArray         *cinemaList;
@property (nonatomic, strong) NSMutableArray         *productList;
@property (nonatomic, strong) NSMutableDictionary    *homeOrderDic;
@property (nonatomic, strong)      UIView *noMovieListAlertView;
@property (nonatomic, strong)      UIView *noGoodListAlertView;

@property (nonatomic, strong) NSDictionary *cities;
@property (nonatomic, strong) NSArray *cityIndexes;

/**
 *  设置banner回调
 *
 *  @param a_block 回调
 */
- (void) selectBanner:(void (^)(NSInteger index))a_block;


@end
