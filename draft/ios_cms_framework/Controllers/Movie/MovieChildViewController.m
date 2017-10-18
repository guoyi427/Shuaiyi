//
//  MovieChildViewController.m
//  CIASMovie
//
//  Created by cias on 2017/2/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovieChildViewController.h"
#import "UIColor+Hex.h"
#import "IncomingDateCollectionViewCell.h"
#import "MovieListPosterCollectionViewCell.h"
#import "MovieSmallPosterCollectionViewCell.h"
#import "MovieRequest.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "UserDefault.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "KKZTextUtility.h"
#import <DateEngine_KKZ/DateEngine.h>

@interface MovieChildViewController ()

@property (nonatomic, strong)      UIView *noHotMovieListAlertView;
// 格式化后用于显示的日期列表
@property (nonatomic, strong) NSMutableArray *displayDateList;

@end

@implementation MovieChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hideNavigationBar = YES;
    initFirst = YES;
    self.isReying = YES;

    UIImage *noHotMovieAlertImage = [UIImage imageNamed:@"movie_nodata"];
    NSString *noHotMovieAlertStr = @"准备排片中，请稍后";
    CGSize noHotMovieAlertStrSize = [KKZTextUtility measureText:noHotMovieAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    self.noHotMovieListAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.283*kCommonScreenWidth, 0.277*kCommonScreenHeight, noHotMovieAlertImage.size.width, noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenWidthRate)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noHotMovieListAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noHotMovieAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noHotMovieListAlertView);
        make.height.equalTo(@(noHotMovieAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noHotMovieListAlertView addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noHotMovieAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noHotMovieListAlertView);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(noHotMovieAlertStrSize.height));
    }];
    
    
    [self setUpScrollView];
    [self setMovieSegment];//电影和影院模块切换控件
    [self setMovieUI];
    _incomingDateList = [[NSMutableArray alloc] initWithCapacity:0];//即将上映月份
    _movieList = [[NSMutableArray alloc] initWithCapacity:0];//正在上映电影列表
    _incomingMovieList = [[NSMutableArray alloc] initWithCapacity:0];//即将上映电影列表
    [self requestMovieList:1];
    [self requestIncomingMovieDateList];

    
    
    
}

-(void)setUpScrollView
{
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth*2, kCommonScreenHeight)];
    holder.backgroundColor = [UIColor whiteColor];
    
    holder.delegate = self;
    holder.frame = self.view.bounds;
    holder.pagingEnabled = YES;
    holder.showsVerticalScrollIndicator = NO;
    holder.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:holder];
    
    holder.contentSize = CGSizeMake(kCommonScreenWidth*2, 0);
}

- (void)setMovieSegment{
    segmentBtnBackgroundView = [UIView new];
    [self.view addSubview:segmentBtnBackgroundView];
    segmentBtnBackgroundView.backgroundColor = [UIColor colorWithHex:@"#F2F5F5"];
    [segmentBtnBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(@(64));
        make.height.equalTo(@38);
    }];
    UIView *segmentBtnBackgroundViewLine = [UIView new];
    segmentBtnBackgroundViewLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [segmentBtnBackgroundView addSubview:segmentBtnBackgroundViewLine];
    [segmentBtnBackgroundViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(segmentBtnBackgroundView);
        make.top.equalTo(segmentBtnBackgroundView.mas_bottom).offset(-1);
        make.height.equalTo(@(1));
    }];
    
    btnBottomLine = [UIView new];
    btnBottomLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [segmentBtnBackgroundView addSubview:btnBottomLine];
    
    reyingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reyingBtn.backgroundColor = [UIColor clearColor];
    [reyingBtn setTitle:@"正在热映" forState:UIControlStateNormal];
    reyingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [reyingBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [reyingBtn addTarget:self action:@selector(reyingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [segmentBtnBackgroundView addSubview:reyingBtn];
    
    incomingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    incomingBtn.backgroundColor = [UIColor clearColor];
    [incomingBtn setTitle:@"即将上映" forState:UIControlStateNormal];
    incomingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [incomingBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [incomingBtn addTarget:self action:@selector(incomingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [segmentBtnBackgroundView addSubview:incomingBtn];
    CGRect segmentedControlFrame  = CGRectMake((kCommonScreenWidth-160)/2, 25.0, 160, 27.0);

    [reyingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(segmentedControlFrame.origin.x));
        make.width.equalTo(@(segmentedControlFrame.size.width/2));
        make.height.equalTo(@(38));
    }];
    
    [incomingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(self.view.frame.size.width/2));
        make.width.equalTo(@(segmentedControlFrame.size.width/2));
        make.height.equalTo(@(38));
    }];
    
    [btnBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(reyingBtn.mas_centerX);
        make.width.equalTo(@(66));
        make.height.equalTo(@(3));
        make.top.equalTo(segmentBtnBackgroundView.mas_bottom).offset(-3);
    }];
}

- (void)setMovieUI{
    UICollectionViewFlowLayout *moviePosterFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [moviePosterFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    movieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+38, kCommonScreenWidth, kCommonScreenHeight-64-38-49) collectionViewLayout:moviePosterFlowLayout];
    movieCollectionView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:movieCollectionView];
    movieCollectionView.showsVerticalScrollIndicator = NO;
    movieCollectionView.delegate = self;
    movieCollectionView.dataSource = self;
    [movieCollectionView registerClass:[MovieListPosterCollectionViewCell class] forCellWithReuseIdentifier:@"MovieListPosterCollectionViewCell"];
//    [movieCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    
    __weak __typeof(self) weakSelf = self;
    movieCollectionView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf requestMovieList:pageNum];
    }];
    movieCollectionView.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        
        if ([movieCollectionView.mj_header isRefreshing]) {
            [movieCollectionView.mj_footer endRefreshing];
            return;
        }
        pageNum++;
        [weakSelf requestMovieList:pageNum];
    }];
    if (self.movieList.count == 0) {
        if(self.noHotMovieListAlertView.superview){
            
        }else {
            [movieCollectionView addSubview:self.noHotMovieListAlertView];
        }
    }
    
    
    
    //即将上映一年的月份
    incomingDateCollectionViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 36)];
    incomingDateCollectionViewBg.backgroundColor = [UIColor whiteColor];
    UIView *incomingCollectionViewLine = [UIView new];
    incomingCollectionViewLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [incomingDateCollectionViewBg addSubview:incomingCollectionViewLine];
    [incomingCollectionViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.top.equalTo(incomingDateCollectionViewBg.mas_bottom).offset(-1);
        make.height.equalTo(@(1));
    }];
    
    UICollectionViewFlowLayout *incomingDateFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [incomingDateFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    incomingDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 35) collectionViewLayout:incomingDateFlowLayout];
    incomingDateCollectionView.backgroundColor = [UIColor whiteColor];
    [incomingDateCollectionViewBg addSubview:incomingDateCollectionView];
    incomingDateCollectionView.showsHorizontalScrollIndicator = NO;
    incomingDateCollectionView.delegate = self;
    incomingDateCollectionView.dataSource = self;
    [incomingDateCollectionView registerClass:[IncomingDateCollectionViewCell class] forCellWithReuseIdentifier:@"IncomingDateCollectionViewCell"];
    self.selectDateRow = 0;
//    [_incomingDateList addObjectsFromArray:[NSArray arrayWithObjects:@"全部",@"2017年1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil]];
    
    UICollectionViewFlowLayout *incomingMoviePosterFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [incomingMoviePosterFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    incomingMoviePosterFlowLayout.headerReferenceSize = CGSizeMake(kCommonScreenWidth, 36);
    
    incomingMovieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCommonScreenWidth, 64+38, kCommonScreenWidth, kCommonScreenHeight-64-38-49) collectionViewLayout:incomingMoviePosterFlowLayout];
    incomingMovieCollectionView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:incomingMovieCollectionView];
    incomingMovieCollectionView.showsVerticalScrollIndicator = NO;
    incomingMovieCollectionView.delegate = self;
    incomingMovieCollectionView.dataSource = self;
    [incomingMovieCollectionView registerClass:[MovieListPosterCollectionViewCell class] forCellWithReuseIdentifier:@"IncomingMovieListPosterCollectionViewCell"];
    [incomingMovieCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    
    incomingMovieCollectionView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        incomingPageNum = 1;
        [weakSelf requestIncomingMovieList:incomingPageNum];
    }];
    incomingMovieCollectionView.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        
        if ([incomingMovieCollectionView.mj_header isRefreshing]) {
            [incomingMovieCollectionView.mj_footer endRefreshing];
            return;
        }
        incomingPageNum++;
        [weakSelf requestIncomingMovieList:incomingPageNum];
    }];
//    incomingMovieCollectionView.hidden = YES;
}



- (void)reyingBtnClick{
//    if (self.isReying) {
//        return;
//    }
//    incomingDateCollectionViewBg.hidden = YES;
//    incomingMovieCollectionView.hidden = YES;
//    movieCollectionView.hidden = NO;
    [holder setContentOffset:CGPointZero];
    [movieCollectionView setContentOffset:CGPointZero];

    self.isReying = YES;
#if K_HENGDIAN
    [reyingBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor] forState:UIControlStateNormal];
#else
    [reyingBtn setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
#endif
    [incomingBtn setTitleColor:[UIColor colorWithHex:@"#8D8D8E"] forState:UIControlStateNormal];
    [self.view setNeedsUpdateConstraints];
    
    [btnBottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(66));
        make.height.equalTo(@(3));
        make.top.equalTo(segmentBtnBackgroundView.mas_bottom).offset(-3);
        make.centerX.equalTo(reyingBtn.mas_centerX);
    }];
    
    pageNum = 1;
    [self requestMovieList:pageNum];
}

- (void)incomingBtnClick{
//    if (!self.isReying) {
//        return;
//    }
//    movieCollectionView.hidden = YES;
//    incomingDateCollectionViewBg.hidden = NO;
//    incomingMovieCollectionView.hidden = NO;
    [holder setContentOffset:CGPointMake(kCommonScreenWidth, 0)];

    [incomingMovieCollectionView setContentOffset:CGPointZero];

    self.isReying = NO;
    [reyingBtn setTitleColor:[UIColor colorWithHex:@"#8D8D8E"] forState:UIControlStateNormal];
#if K_HENGDIAN
    [incomingBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor] forState:UIControlStateNormal];
#else
    [incomingBtn setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
#endif
    [self.view setNeedsUpdateConstraints];
    
    [btnBottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(66));
        make.height.equalTo(@(3));
        make.top.equalTo(segmentBtnBackgroundView.mas_bottom).offset(-3);
        make.centerX.equalTo(incomingBtn.mas_centerX);
    }];
    [self requestIncomingMovieDateList];
}

- (void)segmentedControlSelectMovie{
        if (self.isReying) {
            [self reyingBtnClick];
        }else{
            [self incomingBtnClick];
        }
}

/**
 *  MARK: 请求电影列表
 *
 *  @param page 页数
 */
- (void)requestMovieList:(NSInteger)page {
    [[UIConstants sharedDataEngine] loadingAnimation];
    if (self.movieList.count == 0) {
        if(self.noHotMovieListAlertView.superview){
        }else {
            [movieCollectionView addSubview:self.noHotMovieListAlertView];
        }
    }
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
    [request requestMovieListParams:pagrams success:^(NSArray * _Nullable movies) {
        if (pageNum==1) {
            [weakSelf endRefreshing];
        }else{
            [weakSelf endLoadMore];
        }
        if (movies.count > 0) {
            [weakSelf.movieList removeAllObjects];
            [weakSelf.movieList addObjectsFromArray:movies];
            if (weakSelf.movieList.count>0) {
                if (weakSelf.noHotMovieListAlertView.superview) {
                    [weakSelf.noHotMovieListAlertView removeFromSuperview];
                }
            }
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [movieCollectionView reloadData];
            });
            movieCollectionView.mj_footer.state = MJRefreshStateIdle;
            if (pageNum==1) {
                [movieCollectionView setContentOffset:CGPointZero];
            }
            
        }else{
            //没有更多
            [movieCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        if (page == 1) {
            [weakSelf endRefreshing];
        } else {
            [weakSelf endLoadMore];
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
    
}

/**
 格式化日期列表
 */
- (void) formatDateList
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger year = [cal component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *yearStr = [NSString stringWithFormat:@"%@",@(year)];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.incomingDateList.count];
    [self.incomingDateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSString *content = obj;
            NSDate *selectDatef = [[DateEngine sharedDateEngine] dateFromString:content withFormat:@"yyyy-MM"];
            if ([content containsString:yearStr]){
                content = [[DateEngine sharedDateEngine] stringFromDate:selectDatef withFormat:@"M月"];
            }else{
                content = [[DateEngine sharedDateEngine] stringFromDate:selectDatef withFormat:@"yyyy年M月"];
            }
            [arr addObject:content];
        } else {
            [arr addObject:obj];
        }
    }];
    [self.displayDateList addObjectsFromArray:arr];
}

- (void)requestIncomingMovieDateList{
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestIncomingMovieDateListParams:nil success:^(NSArray * _Nullable movies) {
        if (movies.count > 0) {
            [weakSelf.incomingDateList removeAllObjects];
            [weakSelf.incomingDateList addObject:@"全部"];
            [weakSelf.incomingDateList addObjectsFromArray:movies];
            [weakSelf formatDateList];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [incomingDateCollectionView reloadData];
            });
            incomingPageNum = 1;
            
            [self requestIncomingMovieList:incomingPageNum];
            
        }else{
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

//即将上映
- (void)requestIncomingMovieList:(NSInteger)page {
    [[UIConstants sharedDataEngine] stopLoadingAnimation];
    NSString *dateString = @"all";
    if (self.selectDateRow==0) {
        
    }else{
        dateString = [self.incomingDateList objectAtIndex:self.selectDateRow];
    }
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:dateString, @"publishDate",USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestIncomingMovieListParams:pagrams success:^(NSArray * _Nullable movies) {
        if (page==1) {
            [weakSelf endRefreshing];
        }else{
            [weakSelf endLoadMore];
        }
        if (movies.count > 0) {
            [weakSelf.incomingMovieList removeAllObjects];
            [weakSelf.incomingMovieList addObjectsFromArray:movies];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [incomingMovieCollectionView reloadData];
            });
            if (page==1) {
                [incomingMovieCollectionView setContentOffset:CGPointZero];
            }
            incomingMovieCollectionView.mj_footer.state = MJRefreshStateIdle;
            
        }else{
            //没有更多
            [incomingMovieCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        if (page == 1) {
            [weakSelf endRefreshing];
        } else {
            [weakSelf endLoadMore];
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
}




#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView==incomingDateCollectionView) {
        return self.incomingDateList.count;
    }else if (collectionView==movieCollectionView){
        return self.movieList.count;
    }else if (collectionView==incomingMovieCollectionView){
        return self.incomingMovieList.count;

    }
        return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //    if (collectionView==incomingDateCollectionView) {
    //        return 1;
    //    }
    return 1;
}

//定义此UICollectionView在父类上面的位置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView==incomingDateCollectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if (collectionView==movieCollectionView){
        return UIEdgeInsetsMake(15, 15, 20, 15);
    }else if (collectionView==incomingMovieCollectionView){
        return UIEdgeInsetsMake(15, 15, 20, 15);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==incomingDateCollectionView) {
        return 0;
    }else if (collectionView==movieCollectionView) {
        return 20;
    }else if (collectionView==incomingMovieCollectionView){
        return 20;
    }
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==incomingDateCollectionView) {
        return 0;
    }else if (collectionView==movieCollectionView) {
        return 9;
    }else if (collectionView==incomingMovieCollectionView){
        return 9;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==incomingDateCollectionView) {
        NSString *content = [self.displayDateList objectAtIndex:indexPath.row];

        CGSize s = [KKZTextUtility measureText:content font:[UIFont systemFontOfSize:13]];
        
        return CGSizeMake(s.width+34, 35);
        
    }else if (collectionView==movieCollectionView) {
        
        return CGSizeMake(floor((kCommonScreenWidth-2*15-2*9)/3), floor((kCommonScreenWidth-2*15-2*9)/3/0.668)+19);
    }else if (collectionView==incomingMovieCollectionView){
        return CGSizeMake(floor((kCommonScreenWidth-2*15-2*9)/3), floor((kCommonScreenWidth-2*15-2*9)/3/0.668)+19);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==incomingDateCollectionView) {
        static NSString *identify = @"IncomingDateCollectionViewCell";
        IncomingDateCollectionViewCell *cell = (IncomingDateCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.dateString = [self.displayDateList objectAtIndex:indexPath.row];
        [cell updateLayout];
        if (indexPath.row == self.selectDateRow) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
        return cell;
        
    }else if (collectionView==movieCollectionView) {
        
        static NSString *identify = @"MovieListPosterCollectionViewCell";
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            DLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.posterImageBackColor = @"f2f5f5";
        Movie *movie = nil;
        movie = [self.movieList objectAtIndex:indexPath.row];
        cell.movieName = movie.filmName;
        cell.imageUrl = movie.filmPoster;
        cell.point = movie.point;
        cell.availableScreenType = movie.availableScreenType;
        cell.isSale = [movie.isDiscount boolValue];
        cell.isPresell = [movie.isPresell boolValue];
        [cell updateLayout];
        
        return cell;
        
    }else if (collectionView==incomingMovieCollectionView) {
        
        static NSString *identify = @"IncomingMovieListPosterCollectionViewCell";
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建IncomingMovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.posterImageBackColor = @"f2f5f5";
        Movie *movie = nil;
        movie = [self.incomingMovieList objectAtIndex:indexPath.row];
        cell.movieName = movie.filmName;
        cell.imageUrl = movie.filmPoster;
        cell.point = movie.point;
        cell.availableScreenType = movie.availableScreenType;
        cell.isSale = [movie.isSale boolValue];
        cell.isPresell = [movie.isPresell boolValue];
        [cell updateLayout];
        
        return cell;
        
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == incomingDateCollectionView) {
        
        self.selectDateRow = indexPath.row;
        incomingPageNum = 1;
        [self requestIncomingMovieList:1];
        [collectionView reloadData];
        
    }else if (collectionView==movieCollectionView) {
        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        ctr.isReying = self.isReying;
        self.sf_targetView = cell.moviePosterImage;
        ctr.myMovie = movie;
        [self.navigationController pushViewController:ctr animated:YES];
    }else if (collectionView==incomingMovieCollectionView){
        Movie *movie = [self.incomingMovieList objectAtIndex:indexPath.row];
        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.sf_targetView = cell.moviePosterImage;
        ctr.isReying = self.isReying;
        ctr.myMovie = movie;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==incomingMovieCollectionView) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView" forIndexPath:indexPath];
        
        [headerView addSubview:incomingDateCollectionViewBg];//头部广告栏
        return headerView;
    }else
    {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView==incomingMovieCollectionView) {
        CGSize size={kCommonScreenWidth,36};
        return size;
    }
    return CGSizeZero;
}




/**
 *  结束刷新
 */
- (void)endRefreshing {
    if (self.isReying) {
        if ([movieCollectionView.mj_header isRefreshing]) {
            [movieCollectionView.mj_header endRefreshing];
        }
 
    }else{
        if ([incomingMovieCollectionView.mj_header isRefreshing]) {
            [incomingMovieCollectionView.mj_header endRefreshing];
        }

    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    if (self.isReying) {
        if ([movieCollectionView.mj_footer isRefreshing]) {
            [movieCollectionView.mj_footer endRefreshing];
        }

    }else{
        if ([incomingMovieCollectionView.mj_footer isRefreshing]) {
            [incomingMovieCollectionView.mj_footer endRefreshing];
        }

    }
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
/**
 点击动画后停止调用
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    DLog(@"scrollView == %f", scrollView.contentOffset.x);

//    [self addChildViewControllers];
}


/**
 人气拖动的时候，滚动动画结束时调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    DLog(@"%ld", index);

    //点击对应的按钮
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        if (index==1) {
            if (self.isReying) {
                [self incomingBtnClick];
            }
        }else{
            if (self.isReying) {
                
            }else{
                [self reyingBtnClick];
            }
        }

    }
}

- (NSMutableArray *)displayDateList {
    if (!_displayDateList) {
        _displayDateList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _displayDateList;
}

@end
