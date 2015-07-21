//
//  MPHomeCollectionView.m
//  MobilePrint
//
//  Created by guoyi on 15/6/8.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPHomeCollectionView.h"

//  View
#import "MPHomeCollectionCell.h"

//  Model
#import "MPMobileShellModel.h"

/// 首页单元格ID
static NSString * cellIdentifier = @"HomeCollectionCell";

@interface MPHomeCollectionView () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    //  Data
    /// 私有动画A名称  不可以上 appstore的哦 如果你想冒险一试也可以~ 有记录可以通过
    NSArray * _privateAnmationNamePathList;
    
    //  UI
    
}
@end

@implementation MPHomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(100, 100);
    
    self = [self initWithFrame:frame collectionViewLayout:flowLayout];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self _prepareData];
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare 

- (void)_prepareData {
    /*
     方法名                                是否支持方向
     cube	立方体翻转效果               是
     oglFlip	翻转效果                是
     suckEffect	收缩效果                否
     rippleEffect	水滴波纹效果	   	   否
     pageCurl	向上翻页效果             是
     pageUnCurl	向下翻页效果              是
     cameralIrisHollowOpen	摄像头打开效果		否
     cameraIrisHollowClose	摄像头关闭效果		否
     */
    _privateAnmationNamePathList = @[@"cube",
                                     @"oglFlip",
                                     @"suckEffect",
                                     @"rippleEffect",
                                     @"pageCurl",
                                     @"pageUnCurl",
                                     @"cameralIrisHollowOpen",
                                     @"cameraIrisHollowClose"];
}

- (void)_prepareUI {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[MPHomeCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.pagingEnabled = YES;
}

#pragma mark - Collection Datasource & Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPHomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    /// 手机壳数据模型
    MPMobileShellModel * model = nil;
    if (_mobileShellModelList.count > indexPath.row) {
        model = _mobileShellModelList[indexPath.row];
    }
    
    //  更新数据
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 动画下表  0~7
    NSUInteger animationIndex = indexPath.row % 7;
    
    /// 所选动画名称
    NSString * animationNamePath = _privateAnmationNamePathList[animationIndex];
    
    collectionView.backgroundColor = [UIColor colorWithRed:arc4random()%100/100.0f
                                                     green:arc4random()%100/100.0f
                                                      blue:arc4random()%100/100.0f
                                                     alpha:1];
    
    CATransition * transition = [[CATransition alloc] init];
    transition.type = animationNamePath;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 2.0f;
    [collectionView.layer addAnimation:transition forKey:@"animations"];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mobileShellModelList.count;
}

#pragma mark - Set & Get

- (void)setMobileShellModelList:(NSArray *)mobileShellModelList {
    _mobileShellModelList = nil;
    _mobileShellModelList = mobileShellModelList;
    [self reloadData];
}


@end
