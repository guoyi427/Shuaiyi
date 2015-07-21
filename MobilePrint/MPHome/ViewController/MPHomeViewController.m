//
//  MPHomeViewController.m
//  MobilePrint
//
//  Created by GuoYi on 15/4/9.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPHomeViewController.h"

#import <MediaPlayer/MediaPlayer.h>

//  View
#import "MPHomeCollectionView.h"
#import "Masonry.h"

//  Model
#import "MPMobileShellModel.h"

@interface MPHomeViewController () <UITextFieldDelegate>
{
    //  Data
    
    //  UI
    MPHomeCollectionView * _homeCollectionView;
    MPMoviePlayerController * movie;
}
@end

@implementation MPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareUI];
    
    [self performSelector:@selector(_queryMobileShellModelFromServer) withObject:nil afterDelay:0.25];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    
}

- (void)_prepareUI {
    [self _prepareCollectionView];
}

/// 准备收藏容器
- (void)_prepareCollectionView {
    _homeCollectionView = [[MPHomeCollectionView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_homeCollectionView];
}

#pragma mark - Private Methods

/// 从服务器获取 此人的手机壳数据
- (void)_queryMobileShellModelFromServer {
    /// 缓存手机壳模型的数组
    NSMutableArray * shellModelList = [NSMutableArray array];
    for (int i = 0; i < 100; i ++) {
        MPMobileShellModel * newModel = [[MPMobileShellModel alloc] init];
        newModel.identifer = i;
        newModel.name = [NSString stringWithFormat:@"%d",i];
        [shellModelList addObject:newModel];
    }
    
    _homeCollectionView.mobileShellModelList = shellModelList;
}

@end
