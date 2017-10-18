//
//  TicketOutFailedViewController.m
//  CIASMovie
//
//  Created by cias on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "TicketOutFailedViewController.h"
#import "PlanTimeCollectionViewCell.h"
#import "ChooseSeatViewController.h"
#import "Plan.h"
#import "PlanRequest.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserDefault.h"
#import "KKZTextUtility.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <DateEngine_KKZ/DateEngine.h>

@interface TicketOutFailedViewController ()

@end

@implementation TicketOutFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    self.view.backgroundColor = [UIColor colorWithHex:[[UIConstants sharedDataEngine] tableviewBackgroundColor]];
    [self setupUI];

    [self setNavTopView];
    _planList = [[NSMutableArray alloc] initWithCapacity:0];
    [self requestPlanList];
}

- (void)setNavTopView{
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(15, 29, 28, 28);
    [leftBarBtn setImage:[UIImage imageNamed:@"titlebar_close"]
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(leftItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarBtn];

}

- (void)leftItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupUI{
    
    scrollViewHolder = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    scrollViewHolder.showsVerticalScrollIndicator = NO;
    scrollViewHolder.delegate = self;
    [self.view addSubview:scrollViewHolder];
    self.view.backgroundColor = [UIColor colorWithHex:[[UIConstants sharedDataEngine] tableviewBackgroundColor]];
//    [scrollViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//    }];
//    
//    holder = [[UIView alloc] init];
//    holder.backgroundColor = [UIColor whiteColor];
//    [scrollViewHolder addSubview:holder];
//    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(scrollViewHolder.mas_top);
//        make.bottom.equalTo(@0);
//        make.width.equalTo(@(kCommonScreenWidth));
//        make.left.equalTo(scrollViewHolder.mas_left);
//    }];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 224)];
    topView.backgroundColor = [UIColor colorWithHex:@"#ff6666"];
    [scrollViewHolder addSubview:topView];
    
    UIImageView *tipImageView = [UIImageView new];
    tipImageView.backgroundColor = [UIColor clearColor];
    tipImageView.image = [UIImage imageNamed:@"fail"];
    tipImageView.contentMode = UIViewContentModeScaleAspectFit;
    tipImageView.clipsToBounds = YES;
    [scrollViewHolder addSubview:tipImageView];
    
    UILabel *orderStateLabel = [UILabel new];
    orderStateLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    orderStateLabel.text = @"亲，非常抱歉！";
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:30];
    [scrollViewHolder addSubview:orderStateLabel];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
//    tipLabel.text = @"影院繁忙出票失败，请选择其他场次吧~";
    tipLabel.text = @"影院繁忙出票失败，稍后为您退款~";

    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:13];
    [scrollViewHolder addSubview:tipLabel];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kCommonScreenWidth-220)/2));
        make.top.equalTo(@133);
        make.width.equalTo(@(220));
        make.height.equalTo(@(111));
    }];
    
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@68);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(30));
        
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(orderStateLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
        
    }];

    
//    self.selectPlanTimeRow = 0;
    
    UICollectionViewFlowLayout *planListCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [planListCollectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    moviePosterFlowLayout.headerReferenceSize = CGSizeMake(kCommonScreenWidth, 36);
    
    planListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 228+40, kCommonScreenWidth, (((kCommonScreenWidth-4*7.5-30)/5)*0.873)*3+15*4) collectionViewLayout:planListCollectionViewLayout];
    planListCollectionView.backgroundColor = [UIColor whiteColor];
    [scrollViewHolder addSubview:planListCollectionView];
    planListCollectionView.showsHorizontalScrollIndicator = NO;
    planListCollectionView.delegate = self;
    planListCollectionView.dataSource = self;
    [planListCollectionView registerClass:[PlanTimeCollectionViewCell class] forCellWithReuseIdentifier:@"PlanTimeCollectionViewCell"];
    //    [planListCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    
//    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(planListCollectionView.mas_bottom).offset(80);
//    }];
    NSInteger rowNum =  _planList.count%5<=0?_planList.count/5:_planList.count/5+1;
    [planListCollectionView setFrame:CGRectMake(0, 228+40, kCommonScreenWidth, (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15)];

    timeShadowImageview = [UIImageView new];
    timeShadowImageview.backgroundColor = [UIColor clearColor];
    timeShadowImageview.contentMode = UIViewContentModeScaleAspectFill;
    timeShadowImageview.image = [UIImage imageNamed:@"time_shadow"];
    [scrollViewHolder addSubview:timeShadowImageview];
    [timeShadowImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planListCollectionView.mas_bottom);
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
    }];
    
    cinemaPosterImageView = [UIImageView new];
    cinemaPosterImageView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    cinemaPosterImageView.layer.cornerRadius = 3.5;
    cinemaPosterImageView.clipsToBounds = YES;
    [scrollViewHolder addSubview:cinemaPosterImageView];
    [cinemaPosterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeShadowImageview.mas_bottom);
        make.left.equalTo(@(15));
        make.width.equalTo(@(kCommonScreenWidth-30));
        make.height.equalTo(@(145));
        
    }];
    
    hallNameView = [UIView new];
    [cinemaPosterImageView addSubview:hallNameView];
    hallNameView.backgroundColor = [UIColor blackColor];
    hallNameView.alpha = 0.85;
    hallNameView.layer.cornerRadius = 3.5;
    [hallNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cinemaPosterImageView);
        make.width.equalTo(@(181));
        make.height.equalTo(@(63));
    }];
    hallNameLabel = [UILabel new];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    hallNameLabel.textAlignment = NSTextAlignmentCenter;
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    [hallNameView addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(10));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(161));
        make.height.equalTo(@(15));
    }];
    
    screenTypeLabel = [UILabel new];
    screenTypeLabel.textColor = [UIColor colorWithHex:@"#ffcc00"];
    screenTypeLabel.textAlignment = NSTextAlignmentCenter;
    screenTypeLabel.font = [UIFont systemFontOfSize:10];
    [hallNameView addSubview:screenTypeLabel];
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hallNameLabel.mas_bottom).offset(5);
        make.left.equalTo(@(10));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(161));
        make.height.equalTo(@(15));
    }];
    
    
    huiImageView = [UIImageView new];
    huiImageView.backgroundColor = [UIColor clearColor];
    huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
    huiImageView.hidden = YES;
    huiImageView.contentMode = UIViewContentModeScaleAspectFit;
    huiImageView.clipsToBounds = YES;
    [scrollViewHolder addSubview:huiImageView];
    
    promotionLabel = [UILabel new];
    promotionLabel.textColor = [UIColor colorWithHex:@"#333333"];
    promotionLabel.textAlignment = NSTextAlignmentLeft;
    promotionLabel.hidden = YES;
    promotionLabel.font = [UIFont systemFontOfSize:13];
    [scrollViewHolder addSubview:promotionLabel];
    
    [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(cinemaPosterImageView.mas_bottom).offset(10);
        make.width.equalTo(@(16));
        make.height.equalTo(@(16));
    }];
    
    [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(huiImageView.mas_right).offset(5);
        make.top.equalTo(cinemaPosterImageView.mas_bottom).offset(10);
        make.width.equalTo(@(kCommonScreenWidth-50));
        make.height.equalTo(@(15));
        
    }];
    
    buyTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [buyTicketBtn setFrame:CGRectMake(0, kCommonScreenHeight-50, kCommonScreenWidth, 50)];
    [buyTicketBtn setTitle:@"去选座" forState:UIControlStateNormal];
    buyTicketBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [buyTicketBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [buyTicketBtn addTarget:self action:@selector(buyTicketBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyTicketBtn];
    [self.view bringSubviewToFront:buyTicketBtn];
    [buyTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.top.equalTo(self.view.mas_bottom).offset(-50);
    }];
    [scrollViewHolder setContentSize:CGSizeMake(kCommonScreenWidth,  228+40+planListCollectionView.frame.size.height+15+145+30+50)];
}

- (void)updateLayout{
    if (self.planList.count>0) {
        self.selectPlan = [self.planList objectAtIndex:self.selectPlanTimeRow];
    }
    
    if ([self.selectPlan.isDiscount isEqualToString:@"1"]) {
        huiImageView.hidden = NO;
        promotionLabel.hidden = NO;
        promotionLabel.text = self.selectPlan.discount;
        
    } else {
        huiImageView.hidden = YES;
        promotionLabel.hidden = YES;
        
    }

    //    if ([self.selectPlan.wx_issale integerValue] > 0) {
    //        huiImageView.hidden = NO;
    //        promotionLabel.hidden = NO;
    ////        promotionLabel.text = @"火星营救立减10元|微信支付随机减";
    //        promotionLabel.text = self.selectPlan.wx_saleTielt;
    //    }
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic_s"] newSize:cinemaPosterImageView.frame.size bgColor:[UIColor colorWithHex:@"#f2f5f5"]];
    [cinemaPosterImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.selectPlan.screenImage] placeholderImage:placeHolderImage];
    hallNameLabel.text = self.selectPlan.screenName;
    if (self.selectPlan.filmInfo.count) {
        Movie *movie = [self.selectPlan.filmInfo objectAtIndex:0];
        screenTypeLabel.text = movie.availableScreenType;
    }else{
        screenTypeLabel.text = @"";
    }
    NSInteger rowNum =  _planList.count%5<=0?_planList.count/5:_planList.count/5+1;
    [planListCollectionView setFrame:CGRectMake(0, 228+40, kCommonScreenWidth, (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15)];
    [scrollViewHolder setContentSize:CGSizeMake(kCommonScreenWidth,  228+40+planListCollectionView.frame.size.height+15+145+30+50+30)];

    [planListCollectionView reloadData];

}

- (void)buyTicketBtnClick{
    if (self.planList.count) {
        NSComparisonResult result; //是否过期
        int lockTime = [klockTime intValue];
        
        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
        NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:self.selectPlan.startTime];
        result= [startTimeDate compare:lateDate];
        if (result == NSOrderedDescending) {
            
        }else{
            [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
            return;
        }
        buyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        Plan *aPlan = [self.planList objectAtIndex:self.selectPlanTimeRow];
        ChooseSeatViewController *ctr = [[ChooseSeatViewController alloc] init];
        ctr.planList = self.planList;
        ctr.planDateString = aPlan.startTime;
        ctr.selectPlanTimeRow = self.selectPlanTimeRow;
        ctr.movieId = self.myOrder.orderTicket.filmId;
        ctr.cinemaId = self.myOrder.orderTicket.cinemaId;
        ctr.movieName = self.myOrder.orderTicket.filmName;
        ctr.cinemaName = self.myOrder.orderTicket.cinemaName;

        ctr.selectPlanDate = self.selectPlanDate;
        [self.navigationController pushViewController:ctr animated:YES];
    }else{
        buyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)requestPlanList {
    //    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSDate *planBeginTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderTicket.planBeginTime doubleValue]/1000];
    self.selectPlanDateString = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:planBeginTimeDate];
    
    PlanRequest *request = [[PlanRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.myOrder.orderTicket.cinemaId,@"cinemaId", self.myOrder.orderTicket.filmId,@"filmId",self.selectPlanDateString,@"showDate", nil];
    
    [request requestPlanListParams:pagrams success:^(NSArray * _Nullable plans) {
        
        [self.planList removeAllObjects];
        [self.planList addObjectsFromArray:plans];
        [SVProgressHUD dismiss];
        self.selectPlanTimeRow=-1;

        for (int i=0; i<self.planList.count; i++) {
            Plan *aplan = [self.planList objectAtIndex:i];
            if ([aplan.isSale isEqualToString:@"1"]) {
                if ([aplan.sessionId isEqualToString:self.myOrder.orderTicket.sessionId]) {
                    self.selectPlanTimeRow = i;
                    break;
                }else{
                    self.selectPlanTimeRow=-1;
                }
           
            }
            
        }
        if (self.selectPlanTimeRow==-1) {
            for (int i=0; i<self.planList.count; i++) {
                Plan *aplan = [self.planList objectAtIndex:i];
                if ([aplan.isSale isEqualToString:@"1"]) {
                    self.selectPlanTimeRow = i;
                    break;
                }
            }
            
        }
        
        weakSelf.selectPlan = [self.planList objectAtIndex:self.selectPlanTimeRow];
//        DLog(@"number == %ld",_planList.count);
//        
//        DLog(@"_planList.count= %ld", _planList.count%5<=0?_planList.count/5:_planList.count/5+1);
//        NSInteger rowNum =  _planList.count%5<=0?_planList.count/5:_planList.count/5+1;
//        DLog(@"floor= %f", (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873)));
//        
//        [planListCollectionView setFrame:CGRectMake(0, 0, kCommonScreenWidth, (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15)];
//        [scrollViewHolder setContentSize:CGSizeMake(kCommonScreenWidth,  (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15+50+15+145+30)];
        [weakSelf updateLayout];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [planListCollectionView reloadData];
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}


#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.planList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //    if (collectionView==incomingDateCollectionView) {
    //        return 1;
    //    }
    return 1;
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 10, 15);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (Constants.isIphone5) {
        return CGSizeMake(floor((kCommonScreenWidth-4*7.5-30)/5), floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873)+5);
    }else{
        return CGSizeMake(floor((kCommonScreenWidth-4*7.5-30)/5), floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873));
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"PlanTimeCollectionViewCell";
    PlanTimeCollectionViewCell *cell = (PlanTimeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建PlanTimeCollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    Plan *plan = [self.planList objectAtIndex:indexPath.row];
    cell.selectPlan = plan;
    //        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
    //        cell.movieName = movie.filmName;
    //        cell.imageUrl = movie.filmPoster;
    //        cell.point = movie.point;
    //        cell.availableScreenType = movie.availableScreenType;
    if (indexPath.row == self.selectPlanTimeRow) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    [cell updateLayout];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Plan *plan = [self.planList objectAtIndex:indexPath.row];
    if ([plan.isSale isEqualToString:@"1"]) {
        NSComparisonResult result; //是否过期
        int lockTime = [klockTime intValue];
        
        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
        NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:plan.startTime];
        result= [startTimeDate compare:lateDate];
        if (result == NSOrderedDescending) {
            
        }else{
            [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
            return;
        }
        self.selectPlanTimeRow = indexPath.row;
        self.selectPlan = plan;
        [self updateLayout];
        [collectionView reloadData];
    }

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==planListCollectionView) {
        
    }else{
        if (scrollView.contentOffset.y < 0) {
            [scrollView setContentOffset:CGPointZero];
//            scrollView.scrollEnabled = NO;
        }else{
//            scrollView.scrollEnabled = YES;
        }

    }
}


@end
