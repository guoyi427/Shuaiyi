//
//  MovieDetailViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/20.
//  Copyright © 2016年 cias. All rights reserved.
//


/*
 MARK:  请求数据 有数据才添加相应功能方法
 */
#import "MovieDetailViewController.h"
#import "ProductCollectionViewCell.h"
#import "MovieActorCollectionViewCell.h"
#import "MoviePhotoCollectionViewCell.h"

#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

#import "UIViewController+SFTrainsitionExtension.h"

#import "MovieCommentCell.h"
#import "PlanListViewController.h"
#import "Cinema.h"
#import "Movie.h"
#import "UserDefault.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MovieRequest.h"

#import "MovirePhotoDetailController.h"
#import "KKZTextUtility.h"

#import "XingYiPlanListViewController.h"

#define kNaviViewHeight 69

#define kFilmInfoViewy  46

#define kFilmInfoViewHeight 109
#define kTopImageViewHeight 211
#define kFilmIntroduceViewHeight 125


@interface MovieDetailViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    UILabel *filmIntroduceLabel;
    UICollectionView *productCollectionView;
    UICollectionView *actorCollectionView, *photoCollectionView;

}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * naviView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, strong) UIView * headBkView;
@property (nonatomic, strong) UIView * filmInfoView;
@property (nonatomic, strong) UIView * filmIntroduceView;
@property (nonatomic, strong) UIView * filmProductView;
@property (nonatomic, strong) UIView * filmActorView;
@property (nonatomic, strong) UIView * filmPhotoView;
@property (nonatomic, strong) UIView * filmCommentHeadView;
@property (nonatomic, assign) BOOL isHaveProductInMovieDetailView;


@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *commentList;

@property (nonatomic, strong)      UIView *noMovieInfoAlertView;


@end

@implementation MovieDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.hideNavigationBar = YES;
    self.isHaveProductInMovieDetailView = NO;

    _moviePhotoList = [[NSMutableArray alloc] initWithCapacity:0];//电影剧照列表
    _movieActorList = [[NSMutableArray alloc] initWithCapacity:0];//电影演员列表
    _movieVideoList = [[NSMutableArray alloc] initWithCapacity:0];//电影预告片列表

    
    _productList = [[NSMutableArray alloc] initWithCapacity:0];
    [_productList addObjectsFromArray:[NSArray arrayWithObjects:@"全部",@"2017年1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil]];
    
    _commentList = [[NSMutableArray alloc] initWithCapacity:0];
    photoPageNum = 1;
    
    //初始化界面view
    [self Adds];

    [self requestMovieVideoList];
    [self requestMoviePhotoList:photoPageNum];
    [self requestMovieActorList];
    //创建网络监听管理者对象 开始监听
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                DLog(@"未知网络");
                break;
            case 0:
                DLog(@"网络不可达");
                break;
            case 1:
                DLog(@"GPRS网络");
                break;
            case 2:
                DLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            DLog(@"有网");
            //进行数据请求
            [self requestMovieVideoList];
            [self requestMoviePhotoList:photoPageNum];
            [self requestMovieActorList];
        }else
        {
            DLog(@"没有网");
            //展示无网络页面
            [[CIASAlertCancleView new] show:@"" message:@"哟呵，网络正在开小差~" cancleTitle:@"我知道了" callback:^(BOOL confirm) {
            }];
        }
    }];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.delegate = self;
//    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [productCollectionView reloadData];
    [actorCollectionView reloadData];
//    [photoCollectionView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
    [self createScaleImageViewWithVideoUrl:@""];
    //MARK: 创建header视图
    [self createHeadView];
    //add navinar
    [self  setNavinarView];
    
    [self.naviView addSubview:self.backBtn];
    //添加电影名称title
    [self.naviView addSubview:self.titleLabel];
    //add view
    [self.view addSubview:self.naviView];
    //添加返回按钮
    
    if (self.isReying) {
        if ([self.myMovie.isDiscount integerValue] == 1) {
            UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            buyBtn.frame = CGRectMake(0, kCommonScreenHeight - 50*Constants.screenHeightRate, kCommonScreenWidth, 50*Constants.screenHeightRate);
            buyBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
            [buyBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
            [buyBtn setTitle:@"特惠购票" forState:UIControlStateNormal];
            [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buyBtn];
        }else{
            UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            buyBtn.frame = CGRectMake(0, kCommonScreenHeight - 50*Constants.screenHeightRate, kCommonScreenWidth, 50*Constants.screenHeightRate);
            buyBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
            [buyBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
            [buyBtn setTitle:@"立即购票" forState:UIControlStateNormal];
            [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buyBtn];
        }
   
    } else {
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(0, kCommonScreenHeight - 50*Constants.screenHeightRate, kCommonScreenWidth, 50*Constants.screenHeightRate);
        buyBtn.backgroundColor = [UIColor colorWithHex:@"#666666"];
        [buyBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        buyBtn.userInteractionEnabled = NO;
        [buyBtn setTitle:@"等待排期" forState:UIControlStateNormal];
        [self.view addSubview:buyBtn];
    }
    //添加下面跳转按钮

}

- (void) setNavinarView {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69*Constants.screenHeightRate)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    bar.alpha = 0.0;
    self.mdNaviBar = bar;
    [self.view addSubview:bar];

}

- (void) cancelViewController {
    if (self.isHiddenAnimation) {
        Constants.isHidAnimation = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frameOfTopImageView = _topImageView.frame;
    CGRect frameOfVideoBtn = videoBtn.frame;
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;//注意
    
    if (offsetY > 100*Constants.screenHeightRate&&(!([scrollView isKindOfClass:[actorCollectionView class]] || [scrollView isKindOfClass:[photoCollectionView class]] || [scrollView isKindOfClass:[productCollectionView class]]))) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.naviView.alpha = 0.85;
        self.titleLabel.text = self.myMovie.filmName;
        [self.backBtn setImage:[UIImage imageNamed:@"titlebar_back2"] forState:UIControlStateNormal];
        frameOfTopImageView.origin.y = -offsetY;
        frameOfVideoBtn.origin.y = 79*Constants.screenHeightRate-offsetY;
        frameOfTopImageView.size.height = 211*Constants.screenHeightRate;
        
        
    } else if (offsetY <= 100*Constants.screenHeightRate && offsetY > 0&&(!([scrollView isKindOfClass:[actorCollectionView class]] || [scrollView isKindOfClass:[photoCollectionView class]] || [scrollView isKindOfClass:[productCollectionView class]]))) {
        _alphaMemory = 0;
        self.naviView.alpha = 0.0;
        self.titleLabel.text = @"";
        [self.backBtn setImage:[UIImage imageNamed:@"titlebar_back1"] forState:UIControlStateNormal];

        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        frameOfTopImageView.origin.y = -offsetY;
        frameOfVideoBtn.origin.y = 79*Constants.screenHeightRate-offsetY;
        frameOfTopImageView.size.height = 211*Constants.screenHeightRate;
        
    }
    //下拉放大
    if (offsetY < 0&&(!([scrollView isKindOfClass:[actorCollectionView class]] || [scrollView isKindOfClass:[photoCollectionView class]] || [scrollView isKindOfClass:[productCollectionView class]]))) {
        self.naviView.alpha = 0.0;
        self.titleLabel.text = @"";
        [self.backBtn setImage:[UIImage imageNamed:@"titlebar_back1"] forState:UIControlStateNormal];

        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        frameOfTopImageView.origin.x = offsetY;
        frameOfVideoBtn.origin.y = 79*Constants.screenHeightRate-offsetY;
        frameOfTopImageView.origin.y = 0;
        frameOfTopImageView.size.width = kCommonScreenWidth - offsetY*2;
        frameOfTopImageView.size.height = 211*Constants.screenHeightRate - offsetY;
    }
    _topImageView.frame = frameOfTopImageView;
    videoBtn.frame = frameOfVideoBtn;
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView==productCollectionView) {
        return self.productList.count;
    }else if (collectionView==actorCollectionView){
        return self.movieActorList.count;
    } else if (collectionView==photoCollectionView) {
        return self.moviePhotoList.count;
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
    if (collectionView==productCollectionView) {
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }else if (collectionView==actorCollectionView){
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }else if (collectionView==photoCollectionView){
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==productCollectionView) {
        return 8;
    }else if (collectionView==actorCollectionView) {
        return 5;
    }else if (collectionView==photoCollectionView) {
        return 5;
    }
    
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==productCollectionView) {
        return 0;
    }else if (collectionView==actorCollectionView) {
        return 0;
    }else if (collectionView==photoCollectionView) {
        return 0;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==productCollectionView) {
        return CGSizeMake(105*Constants.screenWidthRate, (105+40)*Constants.screenHeightRate);
    }else if (collectionView==actorCollectionView) {
        return CGSizeMake(90*Constants.screenWidthRate, 125*Constants.screenHeightRate);
    }else if (collectionView==photoCollectionView) {
        return CGSizeMake(125*Constants.screenWidthRate, 125*Constants.screenHeightRate);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==productCollectionView) {
        static NSString *identify = @"productCollectionViewCell";
        ProductCollectionViewCell *cell = (ProductCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            DLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        [cell updateLayout];
        
        return cell;
        
    }else if (collectionView==actorCollectionView) {
        static NSString *identify = @"MovieActorCollectionViewCell";
        MovieActorCollectionViewCell *cell = (MovieActorCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            DLog(@"无法创建MovieActorCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        //        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
        //        cell.movieName = movie.filmName;
        //        cell.imageUrl = movie.filmPoster;
        //        cell.point = movie.point;
        //        cell.availableScreenType = movie.availableScreenType;
        cell.movieActorInfo = [self.movieActorList objectAtIndex:indexPath.row];
        [cell updateLayout];
        
        return cell;
        
    }else if (collectionView==photoCollectionView) {
        static NSString *identify = @"MoviePhotoCollectionViewCell";
        MoviePhotoCollectionViewCell *cell = (MoviePhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            DLog(@"无法创建MoviePhotoCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        cell.moviePhotoInfo = [self.moviePhotoList objectAtIndex:indexPath.row];
        [cell updateLayout];
        
        return cell;
        
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==productCollectionView) {
        
    }else if (collectionView==actorCollectionView) {
        //        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
        //        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
        //        ctr.myMovie = movie;
        //        [self.navigationController pushViewController:ctr animated:YES];
        
    }else if (collectionView == photoCollectionView) {
        
        [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:self.images.count datasource:self];
        
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark  -  XLPhotoBrowserDatasource

// 可以不实现此方法
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.images[index];
}
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.urlStrings[index]];
}


#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"commentCell";
    MovieCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MovieCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    //可以把模型作为cell的属性传过去
    cell.pointLabelStr = @"10.0";
    cell.judgementLabelStr = @"超赞";
    cell.judgeContentLabelStr = @"真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看";
    cell.timeLabelStr = @"2016.01.03 10:47";
    cell.judgeComeFromLabelStr = [NSString stringWithFormat:@"来自：%@", @"大众点评点评网"];
    [cell updateLayout];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看真好看看";
    CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(kCommonScreenWidth - 90, MAXFLOAT) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    return 60 + strSize.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 创建tableHeaderView视图


//MARK: 顶部预告片view
- (void)createScaleImageViewWithVideoUrl:(NSString *)videoUrlStr
{
    if(!_topImageView){
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kTopImageViewHeight*Constants.screenHeightRate)];
    }
    _topImageView.backgroundColor = [UIColor clearColor];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic"] newSize:_topImageView.frame.size bgColor:[UIColor colorWithHex:@"#333333"]];
    [_topImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.myMovie.filmPosterHorizon] placeholderImage:placeHolderImage];
    if ([videoUrlStr hasPrefix:@"http://"] || [videoUrlStr hasPrefix:@"https://"]) {
        UIImage *videoImage = [UIImage imageNamed:@"play_icon"];
        videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        videoBtn.frame = CGRectMake((kCommonScreenWidth - videoImage.size.width*Constants.screenWidthRate)/2, 79*Constants.screenHeightRate, videoImage.size.width*Constants.screenWidthRate, videoImage.size.height*Constants.screenHeightRate);
        [videoBtn setImage:videoImage forState:UIControlStateNormal];
        [self.view addSubview:videoBtn];
        [videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view insertSubview:_topImageView belowSubview:self.tableView];
    
}

//MARK: tableHeaderView 中添加试图
- (void)createHeadView
{
    //MARK: 添加顶部预告片view
     [self.headBkView addSubview:self.headImageView];
    [self.headBkView insertSubview:self.filmInfoView belowSubview:self.headImageView];
    //MARK: 添加影片信息
    [self  setFilmInfoView];
    
    //MARK: 添加影片介绍view
    [self setFilmIntroduceView];
    
    //MARK: 添加热卖商品-----暂时不显示
    [self setHotProductView];
    
    //MARK: 添加主创团队
//    [self setMovieActorView];
    
    //MARK: 添加剧照
//    [self setMoviePhotoView];
    
    //MARK: 添加影评文字展示，影评列表在tableView中展示
//    [self setFilmCommentHeadView];
    
    //MARK: 重新获取headerView的高度
    [self reSetTableHeadViewHeight];
    self.tableView.tableHeaderView = self.headBkView;

}

- (void)setFilmCommentHeadView {
    [self.headBkView addSubview:self.filmCommentHeadView];
    float positionYOfComment = 25;
    UIView *yellowView1 = [[UIView alloc] initWithFrame:CGRectMake(15*Constants.screenWidthRate, positionYOfComment*Constants.screenHeightRate, 5, 18*Constants.screenHeightRate)];
    yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [self.filmCommentHeadView addSubview:yellowView1];
    NSString *str = @"影评";
    CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(MAXFLOAT, 18*Constants.screenHeightRate) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    UILabel *sectionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yellowView1.frame)*Constants.screenWidthRate+5, positionYOfComment*Constants.screenHeightRate, strSize.width*Constants.screenWidthRate, 18*Constants.screenHeightRate)];
    sectionLabel1.text = str;
    sectionLabel1.backgroundColor = [UIColor clearColor];
    sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel1.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    [self.filmCommentHeadView addSubview:sectionLabel1];
    
    positionYOfComment += 18;
    
    CGRect frameOfCommentHeadView = self.filmCommentHeadView.frame;
    frameOfCommentHeadView.size.height = positionYOfComment;
    self.filmCommentHeadView.frame = frameOfCommentHeadView;
}

- (void) setMoviePhotoView {
    
        
    [self.headBkView addSubview:self.filmPhotoView];
    float positionYOfPhoto = 25;
    UIView *yellowView1 = [[UIView alloc] initWithFrame:CGRectMake(15*Constants.screenWidthRate, positionYOfPhoto*Constants.screenHeightRate, 5, 18*Constants.screenHeightRate)];
    yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [self.filmPhotoView addSubview:yellowView1];
    NSString *str = @"剧照";
    CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(MAXFLOAT, 18*Constants.screenHeightRate) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    UILabel *sectionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yellowView1.frame)+5, positionYOfPhoto*Constants.screenHeightRate, strSize.width+5, 18*Constants.screenHeightRate)];
    sectionLabel1.text = str;
    sectionLabel1.backgroundColor = [UIColor clearColor];
    sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel1.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    [self.filmPhotoView addSubview:sectionLabel1];
    
    positionYOfPhoto += 33;
    UICollectionViewFlowLayout *photoFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [photoFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, positionYOfPhoto*Constants.screenHeightRate, kCommonScreenWidth, 125*Constants.screenHeightRate) collectionViewLayout:photoFlowLayout];
    photoCollectionView.backgroundColor = [UIColor clearColor];
    [self.filmPhotoView addSubview:photoCollectionView];
    photoCollectionView.showsHorizontalScrollIndicator = NO;
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    [photoCollectionView registerClass:[MoviePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MoviePhotoCollectionViewCell"];
    
//    __weak __typeof(self) weakSelf = self;
//    photoCollectionView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
//        photoPageNum = 1;
//        [weakSelf requestMoviePhotoList:photoPageNum];
//    }];
//    photoCollectionView.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
//        
//        if ([photoCollectionView.mj_header isRefreshing]) {
//            [photoCollectionView.mj_footer endRefreshing];
//            return;
//        }
//        photoPageNum++;
//        [weakSelf requestMoviePhotoList:photoPageNum];
//       
//    }];
    
    positionYOfPhoto += 125;
    
    CGRect frameOfActorView = self.filmPhotoView.frame;
    frameOfActorView.size.height = positionYOfPhoto;
    self.filmPhotoView.frame = frameOfActorView;

}

- (void)videoBtnClick:(id)sender {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0){
        [[CIASAlertCancleView new] show:@"提示" message:@"网络异常，请查看网络是否连接" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    } else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 1) {
        [[CIASAlertVIew new] show:@"提示" message:@"当前无WIFI，是否允许使用流量播放？" image:nil cancleTitle:@"不允许" otherTitle:@"允许" callback:^(BOOL confirm) {
            if (confirm) {
                [self startShowMovieTrailer:[[self.movieVideoList firstObject] kkz_stringForKey:@"url"]];
            }
        }];
    } else {
        [self startShowMovieTrailer:[[self.movieVideoList firstObject] kkz_stringForKey:@"url"]];
    }
}

/**
 *  MARK: 请求预告片
 */
- (void)requestMovieVideoList {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.myMovie.movieId forKey:@"filmId"];
    [params setValue:@"2" forKey:@"type"];//1 剧照  2预告片
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestMovieVideoParams:params success:^(NSArray * _Nullable movieVideo) {
        DLog(@"预告片%@", movieVideo);
        if (movieVideo.count > 0) {
            [weakSelf.movieVideoList removeAllObjects];
            [weakSelf.movieVideoList addObjectsFromArray:movieVideo];
            [weakSelf createScaleImageViewWithVideoUrl:[[movieVideo firstObject] kkz_stringForKey:@"url"]];
        }else{
        }
    } failure:^(NSError * _Nullable err) {
        //获取网络状态
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0) {
            [weakSelf showMovieTrailerError];
        }
        
    }];
}

- (void)startShowMovieTrailer:(NSString *)url {
    
    movieVC = [[MoviePlayerViewController alloc] initNetworkMoviePlayerViewControllerWithURL:[NSURL URLWithString:url] movieTitle:self.myMovie.filmName];
    movieVC.delegate = self;
    
    [movieVC playerViewDelegateSetStatusBarHiden:NO];
    
    UIScreen *scr = [UIScreen mainScreen];
    movieVC.view.frame = CGRectMake(0, 0, kCommonScreenHeight, scr.bounds.size.width);
    
    CGAffineTransform landscapeTransform;
    landscapeTransform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    CGFloat landscapeTransformX = 0;
    if (kCommonScreenHeight == 480) {
        
        landscapeTransformX = 80;
        
    } else if (kCommonScreenHeight == 667) {
        landscapeTransformX = 146;
        
    } else if (kCommonScreenHeight == 568) {
        landscapeTransformX = 124;
    } else if (kCommonScreenHeight == 736) {
        landscapeTransformX = 161;
    }
    landscapeTransform = CGAffineTransformTranslate(landscapeTransform, landscapeTransformX, landscapeTransformX);
    [movieVC.view setTransform:landscapeTransform];
    [Constants.appDelegate.window addSubview:movieVC.view];
}

- (void)movieFinished:(CGFloat)progress {
    [movieVC.view removeFromSuperview];
}

- (void)showMovieTrailerError {
    [[CIASAlertCancleView new] show:@"" message:@"小编还没有找到预告片，请过段时间再来~" cancleTitle:@"我知道了" callback:^(BOOL confirm) {
    }];
}

/**
 *  MARK: 请求演员列表
 */
- (void)requestMovieActorList {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.myMovie.movieId forKey:@"filmId"];
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestMovieActorListParams:params success:^(NSArray * _Nullable movieActors) {
        
        if (movieActors.count > 0) {
            [self setMovieActorView];
            [self reSetTableHeadViewHeight];

            [weakSelf.movieActorList removeAllObjects];
            [weakSelf.movieActorList addObjectsFromArray:movieActors];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [actorCollectionView reloadData];
            });
            actorCollectionView.mj_footer.state = MJRefreshStateIdle;
        }else{
            //没有更多
            [actorCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nullable err) {
        DLog(@"err == %@", [err description]);
    }];
    
}
/**
 *  MARK: 请求剧照
 *  @param page 页数
 */
- (void)requestMoviePhotoList:(NSUInteger)page {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.myMovie.movieId forKey:@"filmId"];
    [params setValue:@"1" forKey:@"type"];//1 剧照  2预告片
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestMoviePhotoListParams:params success:^(NSArray * _Nullable moviePhotos) {
        if (photoPageNum==1) {
            [weakSelf endRefreshing];
        }else{
            [weakSelf endLoadMore];
        }
        if (moviePhotos.count > 0) {
            
            [self setMoviePhotoView];
            [self reSetTableHeadViewHeight];

            [weakSelf.moviePhotoList removeAllObjects];
            [weakSelf.moviePhotoList addObjectsFromArray:moviePhotos];
            NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *tmpArrImage = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < weakSelf.moviePhotoList.count; i ++) {
                [tmpArr insertObject:[[weakSelf.moviePhotoList objectAtIndex:i] kkz_stringForKey:@"cover"] atIndex:i];
                [tmpArrImage insertObject:[UIImage imageNamed:@"goods_nopic"] atIndex:i];
            }
            weakSelf.urlStrings = tmpArr;
            weakSelf.images = tmpArrImage;
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoCollectionView reloadData];
            });
            photoCollectionView.mj_footer.state = MJRefreshStateIdle;
            if (photoPageNum==1) {
                [photoCollectionView setContentOffset:CGPointZero];
            }
        }else{
            //没有更多
            [photoCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nullable err) {
        if (page == 1) {
            [weakSelf endRefreshing];
        } else {
            [weakSelf endLoadMore];
        }
        
    }];
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

/**
 *  结束刷新
 */
- (void)endRefreshing {
//    if ([photoCollectionView.mj_header isRefreshing]) {
//        [photoCollectionView.mj_header endRefreshing];
//    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    
//    if ([photoCollectionView.mj_footer isRefreshing]) {
//        [photoCollectionView.mj_footer endRefreshing];
//    }

}


- (void) setMovieActorView {
    
    [self.headBkView addSubview:self.filmActorView];
    float positionYOfActor = 25*Constants.screenHeightRate;
    UIView *yellowView1 = [[UIView alloc] initWithFrame:CGRectMake(15*Constants.screenWidthRate, positionYOfActor, 5, 18*Constants.screenHeightRate)];

    yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];

    [self.filmActorView addSubview:yellowView1];
    NSString *str = @"主创团队";
    CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(MAXFLOAT, 18*Constants.screenHeightRate) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    UILabel *sectionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yellowView1.frame)+5, positionYOfActor, strSize.width + 5, 18*Constants.screenHeightRate)];
    sectionLabel1.text = str;
    sectionLabel1.backgroundColor = [UIColor clearColor];
    sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel1.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    [self.filmActorView addSubview:sectionLabel1];
    
    positionYOfActor += 33*Constants.screenHeightRate;
    UICollectionViewFlowLayout *actorFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [actorFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    actorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, positionYOfActor, kCommonScreenWidth, 125*Constants.screenHeightRate) collectionViewLayout:actorFlowLayout];
    actorCollectionView.backgroundColor = [UIColor clearColor];
    [self.filmActorView addSubview:actorCollectionView];
    actorCollectionView.showsHorizontalScrollIndicator = NO;
    actorCollectionView.delegate = self;
    actorCollectionView.dataSource = self;
    [actorCollectionView registerClass:[MovieActorCollectionViewCell class] forCellWithReuseIdentifier:@"MovieActorCollectionViewCell"];
    positionYOfActor += 125*Constants.screenHeightRate;
    
    CGRect frameOfActorView = self.filmActorView.frame;
    frameOfActorView.size.height = positionYOfActor;
    self.filmActorView.frame = frameOfActorView;
        
    
}


- (void) reSetTableHeadViewHeight {
    CGRect frameOfProduct = CGRectZero;
    if (self.filmProductView) {
        frameOfProduct = self.filmProductView.frame;
        frameOfProduct.origin.y = CGRectGetMaxY(self.filmIntroduceView.frame);
        self.filmProductView.frame = frameOfProduct;
    }
    
    CGRect frameOfActor = CGRectZero;
    if (self.filmActorView) {
        frameOfActor = self.filmActorView.frame;
        frameOfActor.origin.y = CGRectGetMaxY(self.filmProductView.frame);
        self.filmActorView.frame = frameOfActor;
    }
    
    CGRect frameOfPhoto = CGRectZero;
    if (self.filmPhotoView) {
        frameOfPhoto = self.filmPhotoView.frame;
        frameOfPhoto.origin.y = CGRectGetMaxY(self.filmActorView.frame);
        self.filmPhotoView.frame = frameOfPhoto;
    }
    
    CGRect frameOfComment = CGRectZero;
    if (self.filmCommentHeadView) {
        frameOfComment = self.filmCommentHeadView.frame;
        frameOfComment.origin.y = CGRectGetMaxY(self.filmPhotoView.frame);
        self.filmCommentHeadView.frame = frameOfComment;
    }
    
    CGRect frameOfHead = self.headBkView.frame;
    frameOfHead.size.height = _topContentInset*Constants.screenHeightRate - 10 + CGRectGetHeight(self.filmIntroduceView.frame) + CGRectGetHeight(self.filmProductView.frame) + CGRectGetHeight(self.filmActorView.frame) + CGRectGetHeight(self.filmPhotoView.frame) + CGRectGetHeight(self.filmCommentHeadView.frame);
    self.headBkView.frame = frameOfHead;
    self.tableView.tableHeaderView = self.headBkView;
    CGRect headRect = CGRectZero;
    headRect.size.height = CGRectGetHeight(self.filmIntroduceView.frame)+CGRectGetHeight(self.filmActorView.frame) + CGRectGetHeight(self.filmPhotoView.frame);
    DLog(@"headRect:%.2f  %.2f", headRect.size.width, headRect.size.height);
    if (headRect.size.height < 10) {
        //MARK: ----加上占位图，后期如果有评论就很麻烦了,不加占位图反而简单
        if (self.noMovieInfoAlertView.superview) {
            DLog(@"添加了提示框1");
        } else {
            DLog(@"添加了提示框2");
            [self.tableView addSubview:self.noMovieInfoAlertView];
        }

    } else {
        
        if (self.noMovieInfoAlertView.superview) {
            DLog(@"移除了提示框");
            [self.noMovieInfoAlertView removeFromSuperview];
        }
    }
    [self.tableView reloadData];

}

- (void) setHotProductView {
    if (self.isHaveProductInMovieDetailView) {
        [self.headBkView addSubview:self.filmProductView];
        float positionYOfProduct = 25*Constants.screenHeightRate;
        UIView *yellowView1 = [[UIView alloc] initWithFrame:CGRectMake(15*Constants.screenWidthRate, positionYOfProduct, 5, 18*Constants.screenHeightRate)];
        yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        [self.filmProductView addSubview:yellowView1];
        NSString *str = @"热卖商品";
        CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(MAXFLOAT, 18*Constants.screenHeightRate) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
        UILabel *sectionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yellowView1.frame)*Constants.screenWidthRate+5, positionYOfProduct, strSize.width+5, 18*Constants.screenHeightRate)];
        sectionLabel1.text = str;
        sectionLabel1.backgroundColor = [UIColor clearColor];
        sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
        sectionLabel1.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
        [self.filmProductView addSubview:sectionLabel1];
        
        positionYOfProduct += 33*Constants.screenHeightRate;
        UICollectionViewFlowLayout *productFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [productFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, positionYOfProduct, kCommonScreenWidth, 145*Constants.screenHeightRate) collectionViewLayout:productFlowLayout];
        productCollectionView.backgroundColor = [UIColor clearColor];
        [self.filmProductView addSubview:productCollectionView];
        productCollectionView.showsHorizontalScrollIndicator = NO;
        productCollectionView.delegate = self;
        productCollectionView.dataSource = self;
        [productCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCollectionViewCell"];
        positionYOfProduct += 145*Constants.screenHeightRate;
        
        CGRect frameOfProductView = self.filmProductView.frame;
        frameOfProductView.size.height = positionYOfProduct;
        self.filmProductView.frame = frameOfProductView;
    } else {
        
    }
    
    
}

- (void) setFilmIntroduceView {
    //添加影片介绍的view，并加入控件
    if (self.myMovie.introduction.length > 0) {
        [self.headBkView addSubview:self.filmIntroduceView];

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//        tap.cancelsTouchesInView = NO;
//        [self.filmIntroduceView addGestureRecognizer:tap];
        float posiY = 25*Constants.screenHeightRate;
        UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*Constants.screenWidthRate, posiY, 5, 18*Constants.screenHeightRate)];
        flagLabel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        [self.filmIntroduceView addSubview:flagLabel];
        NSString *str = @"剧情介绍";
        CGSize strSize = [KKZTextUtility measureText:str size:CGSizeMake(MAXFLOAT, 18*Constants.screenHeightRate) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
        UILabel *titleLabelOfView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(flagLabel.frame)+ 5, posiY, strSize.width + 5, 18*Constants.screenHeightRate)];
        titleLabelOfView.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
        titleLabelOfView.textColor = [UIColor colorWithHex:@"#333333"];
        titleLabelOfView.text = str;
        [self.filmIntroduceView addSubview:titleLabelOfView];
        
        moreOrLessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreOrLessBtn.frame = CGRectMake(kCommonScreenWidth - 30*Constants.screenWidthRate, 28*Constants.screenHeightRate, 15*Constants.screenWidthRate, 9*Constants.screenHeightRate);
        [moreOrLessBtn setImage:[UIImage imageNamed:@"details_downarrow"] forState:UIControlStateNormal];
        [moreOrLessBtn setImage:[UIImage imageNamed:@"details_uparrow"] forState:UIControlStateSelected];
//        [moreOrLessBtn addTarget:self action:@selector(moreOrLessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [moreOrLessBtn setSelected:NO];
        moreOrLessBtn.userInteractionEnabled = NO;
        [self.filmIntroduceView addSubview:moreOrLessBtn];
        
        posiY += (18 + 15)*Constants.screenHeightRate;
        
        filmIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*Constants.screenWidthRate, posiY, kCommonScreenWidth - 28*Constants.screenWidthRate, 62*Constants.screenHeightRate)];
        filmIntroduceLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        filmIntroduceLabel.textColor = [UIColor colorWithHex:@"#666666"];
        filmIntroduceLabel.numberOfLines = 0;
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.myMovie.introduction];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:7];
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.myMovie.introduction length])];
//        [attributedString
//         setAttributes:@{NSParagraphStyleAttributeName :
//                             paragraphStyle, NSFontAttributeName :
//                             [UIFont systemFontOfSize:13*Constants.screenWidthRate]} range:NSMakeRange(0, [self.myMovie.introduction length])];
//        filmIntroduceLabel.attributedText = attributedString;
        filmIntroduceLabel.text = self.myMovie.introduction;
        [self.filmIntroduceView addSubview:filmIntroduceLabel];
//        [self changeLineSpaceForLabel:filmIntroduceLabel WithSpace:7];
        CGRect frameOfFilmIntroduce = self.filmIntroduceView.frame;
        frameOfFilmIntroduce.size.height = posiY + CGRectGetHeight(filmIntroduceLabel.frame);
        self.filmIntroduceView.frame = frameOfFilmIntroduce;
        
        gotoMovieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gotoMovieBtn.frame = self.filmIntroduceView.frame;
        gotoMovieBtn.backgroundColor = [UIColor clearColor];
        [self.headBkView addSubview:gotoMovieBtn];
        [gotoMovieBtn setSelected:NO];
        [gotoMovieBtn addTarget:self action:@selector(moreOrLessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
    }
    
}


//该方法暂不使用
#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.filmIntroduceView];
    if (!CGRectContainsPoint(self.filmIntroduceView.frame, point)) {
        moreOrLessBtn.selected = !moreOrLessBtn.selected;
        if (moreOrLessBtn.selected) {
            CGSize introduceStrSize = [KKZTextUtility measureText:filmIntroduceLabel.text size:CGSizeMake(kCommonScreenWidth - 28*Constants.screenWidthRate, MAXFLOAT) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGRect introduceFrame = filmIntroduceLabel.frame;
            introduceFrame.size.height = introduceStrSize.height;
            filmIntroduceLabel.frame = introduceFrame;
            CGRect frameOfFilmIntroduce = self.filmIntroduceView.frame;
            frameOfFilmIntroduce.size.height = 58 + CGRectGetHeight(filmIntroduceLabel.frame);
            self.filmIntroduceView.frame = frameOfFilmIntroduce;
            [self reSetTableHeadViewHeight];
        } else {
            CGSize introduceStrSize = [KKZTextUtility measureText:filmIntroduceLabel.text size:CGSizeMake(kCommonScreenWidth - 28*Constants.screenWidthRate, 67*Constants.screenHeightRate) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGRect introduceFrame = filmIntroduceLabel.frame;
            introduceFrame.size.height = introduceStrSize.height*Constants.screenHeightRate;
            filmIntroduceLabel.frame = introduceFrame;
            
            CGRect frameOfFilmIntroduce = self.filmIntroduceView.frame;
            frameOfFilmIntroduce.size.height = 58 + CGRectGetHeight(filmIntroduceLabel.frame);
            self.filmIntroduceView.frame = frameOfFilmIntroduce;
            [self reSetTableHeadViewHeight];
        }
    }
}


- (void)moreOrLessBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    //MARK: 处理点击展开更多内容
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.myMovie.introduction];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.myMovie.introduction length])];
//    [attributedString
//     setAttributes:@{NSParagraphStyleAttributeName :
//                         paragraphStyle, NSFontAttributeName :
//                         [UIFont systemFontOfSize:13*Constants.screenWidthRate]} range:NSMakeRange(0, [self.myMovie.introduction length])];
    if (button.selected) {
        moreOrLessBtn.selected = YES;
        CGSize introduceStrSize = [KKZTextUtility measureText:filmIntroduceLabel.text size:CGSizeMake(kCommonScreenWidth - 28*Constants.screenWidthRate, MAXFLOAT) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGRect introduceFrame = filmIntroduceLabel.frame;
        introduceFrame.size.height = introduceStrSize.height;
        filmIntroduceLabel.frame = introduceFrame;
        CGRect frameOfFilmIntroduce = self.filmIntroduceView.frame;
        frameOfFilmIntroduce.size.height = 58 + CGRectGetHeight(filmIntroduceLabel.frame);
        self.filmIntroduceView.frame = frameOfFilmIntroduce;
        gotoMovieBtn.frame = self.filmIntroduceView.frame;
        [self reSetTableHeadViewHeight];

    } else {
        moreOrLessBtn.selected = NO;
//        NSString *introduceStr = self.myMovie.introduction;
        CGSize introduceStrSize = [KKZTextUtility measureText:filmIntroduceLabel.text size:CGSizeMake(kCommonScreenWidth - 28*Constants.screenWidthRate, 67*Constants.screenHeightRate) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGRect introduceFrame = filmIntroduceLabel.frame;
        introduceFrame.size.height = introduceStrSize.height*Constants.screenHeightRate;
        filmIntroduceLabel.frame = introduceFrame;
        CGRect frameOfFilmIntroduce = self.filmIntroduceView.frame;
        frameOfFilmIntroduce.size.height = 58 + CGRectGetHeight(filmIntroduceLabel.frame);
        self.filmIntroduceView.frame = frameOfFilmIntroduce;
        gotoMovieBtn.frame = self.filmIntroduceView.frame;
        [self reSetTableHeadViewHeight];
        
    }
}

//MARK: 购票按钮点击事件
- (void) buyBtnClick:(UIButton *)button {
    DLog(@"可以购票了");
    if ([kIsXinchengPlanListStyle isEqualToString:@"1"]) {
        XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
        ctr.movieId = self.myMovie.movieId;
        ctr.cinemaId = USER_CINEMAID;
        Constants.isShowBackBtn = YES;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    if ([kIsCMSStandardPlanListStyle isEqualToString:@"1"]) {
        PlanListViewController *ctr = [[PlanListViewController alloc] init];
        ctr.movieId = self.myMovie.movieId;
        ctr.movieName = self.myMovie.filmName;
        ctr.cinemaId = USER_CINEMAID;
        ctr.cinemaName = USER_CINEMA_NAME;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    /*
    
     */
}

- (void) setFilmInfoView {
    //MARK: 添加影片名称
    float midx = 15 + 90 + 15;
    float filmWidth = kCommonScreenWidth - 15 - 90 - 15;
    UILabel *filmNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, 0, filmWidth*Constants.screenWidthRate , 18*Constants.screenHeightRate)];
    filmNameLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
    filmNameLabel.backgroundColor = [UIColor clearColor];
    filmNameLabel.textAlignment = NSTextAlignmentLeft;
    filmNameLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    filmNameLabel.text = self.myMovie.filmName.length>0? self.myMovie.filmName:@"";
    [self.headBkView addSubview:filmNameLabel];
    
    //MARK: 添加电影英文名称
    UILabel *filmOfEnglishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, CGRectGetMaxY(filmNameLabel.frame)+ 6, filmWidth*Constants.screenWidthRate, 13*Constants.screenHeightRate)];
    filmOfEnglishNameLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmOfEnglishNameLabel.backgroundColor = [UIColor clearColor];
    filmOfEnglishNameLabel.textAlignment = NSTextAlignmentLeft;
    filmOfEnglishNameLabel.textColor = [UIColor colorWithHex:@"#999999"];
    filmOfEnglishNameLabel.text = self.myMovie.fakeName.length > 0? self.myMovie.fakeName:@"";
    [self.headBkView addSubview:filmOfEnglishNameLabel];
    
    //MARK: 添加影片时长，类型，上映日期等信息
    //MARK: 类型
    
    float positionY = 15*Constants.screenHeightRate;
    NSString *pointStr = self.myMovie.point.length > 0? self.myMovie.point:@"0.0";
    CGSize pointStrSize = [KKZTextUtility measureText:pointStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:28*Constants.screenWidthRate]];
    UIImage *starImage = [UIImage imageNamed:@"star"];
    
    UILabel *filmTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, positionY, (filmWidth - starImage.size.width - 30)*Constants.screenWidthRate - pointStrSize.width, 9*Constants.screenHeightRate)];
    filmTypeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmTypeLabel.textAlignment = NSTextAlignmentLeft;
    filmTypeLabel.backgroundColor = [UIColor clearColor];
    filmTypeLabel.textColor = [UIColor colorWithHex:@"#999999"];
    filmTypeLabel.text = self.myMovie.filmType.length > 0 ? self.myMovie.filmType:@"";
    [self.filmInfoView addSubview:filmTypeLabel];
    //MARK: 评分和星星
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonScreenWidth - pointStrSize.width - (5 + starImage.size.width + 15)*Constants.screenWidthRate, positionY, pointStrSize.width, pointStrSize.height)];
    pointLabel.font = [UIFont systemFontOfSize:28*Constants.screenWidthRate];
    pointLabel.text = pointStr;
    pointLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [self.filmInfoView addSubview:pointLabel];
    
    UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth - (starImage.size.width + 15)*Constants.screenWidthRate, positionY + 14*Constants.screenHeightRate, starImage.size.width*Constants.screenWidthRate, starImage.size.height*Constants.screenHeightRate)];
    starImageView.image = starImage;
    starImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.filmInfoView addSubview:starImageView];
    //MARK: 时长
    positionY += 16*Constants.screenHeightRate;
    UILabel *filmLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, positionY, CGRectGetWidth(filmTypeLabel.frame), CGRectGetHeight(filmTypeLabel.frame))];
    filmLengthLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmLengthLabel.textColor = [UIColor colorWithHex:@"#999999"];
    filmLengthLabel.textAlignment = NSTextAlignmentLeft;
    filmLengthLabel.backgroundColor = [UIColor clearColor];
    filmLengthLabel.text = [NSString stringWithFormat:@"时长：%@分钟", self.myMovie.duration.intValue>0?self.myMovie.duration:@"90"];
    [self.filmInfoView addSubview:filmLengthLabel];
    
    //MARK: 上映日期
    positionY += 16*Constants.screenHeightRate;
    UILabel *filmPublishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, positionY, CGRectGetWidth(filmLengthLabel.frame), CGRectGetHeight(filmLengthLabel.frame))];
    filmPublishTimeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmPublishTimeLabel.textAlignment = NSTextAlignmentLeft;
    filmPublishTimeLabel.backgroundColor = [UIColor clearColor];
    filmPublishTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    NSArray *publishArr = [self.myMovie.publishDate componentsSeparatedByString:@"-"];
    NSString *publishTime = [NSString stringWithFormat:@"%@年%@月%@日", publishArr[0], publishArr[1], publishArr[2]];
    filmPublishTimeLabel.text = self.myMovie.publishDate.length > 0? [NSString stringWithFormat:@"%@上映", [NSString stringWithFormat:@"%@", publishTime]]:@"";
    if (self.myMovie.publishDate.length > 0) {
        [self.filmInfoView addSubview:filmPublishTimeLabel];
    }
    
    
    //MARK: 电影屏幕类型和语言
    positionY += 27*Constants.screenHeightRate;
    NSString *strOfFilmScreenType = self.myMovie.availableScreenType;
    CGSize strOfFilmScreenTypeSize = [KKZTextUtility measureText:strOfFilmScreenType size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    UILabel *filmScreenTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(midx*Constants.screenWidthRate, positionY, (strOfFilmScreenTypeSize.width+2), 15*Constants.screenHeightRate)];
    filmScreenTypeLabel.layer.cornerRadius = 3.5;
    filmScreenTypeLabel.clipsToBounds = YES;
    filmScreenTypeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmScreenTypeLabel.backgroundColor = [UIColor colorWithHex:@"#ffcc00"];
    filmScreenTypeLabel.textColor = [UIColor colorWithHex:@"#000000"];
    filmScreenTypeLabel.textAlignment = NSTextAlignmentCenter;
    filmScreenTypeLabel.text = strOfFilmScreenType;
    if (self.myMovie.availableScreenType.length > 0) {
        [self.filmInfoView addSubview:filmScreenTypeLabel];
    }
    
    
    
    NSString *strOfFilmLanguageLabel = self.myMovie.language;
    CGSize strOfFilmLanguageLabelSize = [KKZTextUtility measureText:strOfFilmLanguageLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    UILabel *filmLanguageLabel = [[UILabel alloc] init];
    if (self.myMovie.availableScreenType.length > 0) {
        filmLanguageLabel.frame = CGRectMake(CGRectGetMaxX(filmScreenTypeLabel.frame)+5, positionY, (strOfFilmLanguageLabelSize.width+2), 15*Constants.screenHeightRate);
    } else {
        filmLanguageLabel.frame = CGRectMake(CGRectGetMaxX(filmScreenTypeLabel.frame), positionY*Constants.screenHeightRate, (strOfFilmLanguageLabelSize.width+2), 15*Constants.screenHeightRate);
    }
    filmLanguageLabel.layer.cornerRadius = 3.5;
    filmLanguageLabel.clipsToBounds = YES;
    filmLanguageLabel.textAlignment = NSTextAlignmentCenter;
    filmLanguageLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    filmLanguageLabel.backgroundColor = [UIColor colorWithHex:@"#333333"];
    filmLanguageLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    filmLanguageLabel.text = strOfFilmLanguageLabel;
    if (self.myMovie.language.length > 0) {
        [self.filmInfoView addSubview:filmLanguageLabel];
    }
    
    //MARK: 高为1的线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108*Constants.screenHeightRate, kCommonScreenWidth, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.filmInfoView addSubview:lineLabel];
    CGRect frameOfFilmInfoView = self.filmInfoView.frame;
    frameOfFilmInfoView.size.height = 109*Constants.screenHeightRate;
    self.filmInfoView.frame = frameOfFilmInfoView;
}

#pragma mark - 设置分割线顶头
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1];
}


#pragma mark -- 初始化各个控件


- (UIView *)noMovieInfoAlertView {
    if (!_noMovieInfoAlertView) {
        UIImage *noHotMovieAlertImage = [UIImage imageNamed:@"movie_nodata"];
        NSString *noHotMovieAlertStr = @"影片信息尚未公布";
        CGSize noHotMovieAlertStrSize = [KKZTextUtility measureText:noHotMovieAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        _noMovieInfoAlertView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - noHotMovieAlertImage.size.width)/2, 250*Constants.screenHeightRate, noHotMovieAlertImage.size.width, noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenHeightRate)];
        UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
        [_noMovieInfoAlertView addSubview:noOrderAlertImageView];
        noOrderAlertImageView.image = noHotMovieAlertImage;
        noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
        [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_noMovieInfoAlertView);
            make.height.equalTo(@(noHotMovieAlertImage.size.height));
        }];
        UILabel *noOrderAlertLabel = [[UILabel alloc] init];
        [_noMovieInfoAlertView addSubview:noOrderAlertLabel];
        noOrderAlertLabel.text = noHotMovieAlertStr;
        noOrderAlertLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
        noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#666666"];
        [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_noMovieInfoAlertView);
            make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
            make.height.equalTo(@(noHotMovieAlertStrSize.height));
        }];
    }
    return _noMovieInfoAlertView;
}




//MARK: 初始化tableview
- (UITableView *)tableView{
    _topContentInset = 165; //136+64=200
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - 50*Constants.screenHeightRate)];
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(_topContentInset*Constants.screenHeightRate, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_topContentInset*Constants.screenHeightRate, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//MARK: 初始化naviView
- (UIView *) naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kNaviViewHeight*Constants.screenHeightRate)];
        _naviView.backgroundColor = [UIColor whiteColor];
        _naviView.alpha = 0.0;
    }
    return _naviView;
}
//MARK: 初始化backBtn
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15*Constants.screenWidthRate, 29*Constants.screenHeightRate, 30*Constants.screenWidthRate, 30*Constants.screenHeightRate);
        [_backBtn setImage:[UIImage imageNamed:@"titlebar_back1"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
//MARK: 初始化导航栏标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*Constants.screenWidthRate, 36*Constants.screenHeightRate, kCommonScreenWidth - 60*2*Constants.screenWidthRate, 15*Constants.screenHeightRate)];
        _titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
        _titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
//MARK: 初始化tableheadview
- (UIView *)headBkView {
    if (!_headBkView) {
        _headBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0)];
        _headBkView.backgroundColor = [UIColor clearColor];
    }
    return _headBkView;
}
//MARK: 初始化headView中电影缩略图
- (UIImageView *) headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(15*Constants.screenWidthRate, 0, 90*Constants.screenWidthRate, 135*Constants.screenHeightRate);
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.layer.cornerRadius = 3.5;
        _headImageView.layer.masksToBounds = YES;
        UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic"] newSize:_headImageView.frame.size bgColor:[UIColor colorWithHex:@"#f2f5f5"]];
        [_headImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.myMovie.filmPoster] placeholderImage:placeHolderImage];
        if (self.isHiddenAnimation) {
        } else {
            self.sf_targetView = _headImageView;
        }
    }
    return _headImageView;
}
//MARK: 初始化headView中电影信息view
- (UIView *)filmInfoView {
    if (!_filmInfoView) {
        _filmInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, kFilmInfoViewy*Constants.screenHeightRate, kCommonScreenWidth, 0)];
        _filmInfoView.backgroundColor = [UIColor colorWithHex:@"#f3f5f5"];
    }
    return _filmInfoView;
}

//MARK: 电影介绍
- (UIView *)filmIntroduceView {
    if (!_filmIntroduceView) {
        _filmIntroduceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmInfoView.frame), kCommonScreenWidth, 0)];
        _filmIntroduceView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _filmIntroduceView;
}

//MARK: 热卖商品
- (UIView *) filmProductView {
    if (!_filmProductView) {
        _filmProductView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmIntroduceView.frame), kCommonScreenWidth, 0)];
        _filmProductView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _filmProductView;
}


- (UIView *)filmActorView {
    if (!_filmActorView) {
        _filmActorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmProductView.frame), kCommonScreenWidth, 0)];
        _filmActorView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _filmActorView;
}

- (UIView *)filmPhotoView {
    if (!_filmPhotoView) {
        _filmPhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmActorView.frame), kCommonScreenWidth, 0)];
        _filmPhotoView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _filmPhotoView;
}

- (UIView *)filmCommentHeadView {
    if (!_filmCommentHeadView) {
        _filmCommentHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmPhotoView.frame), kCommonScreenWidth, 0)];
        _filmCommentHeadView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _filmCommentHeadView;
}


- (CGSize)measureFilmIntroduceText:(NSAttributedString *)text
                 size:(CGSize)size
                 font:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return rect.size;
}


- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeThatFits:label.frame.size];
}


@end
