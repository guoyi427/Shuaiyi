//
//  MovieDetailViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/20.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"
#import "MoviePlayerViewController.h"

@interface MovieDetailViewController : UIViewController<XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,MoviePlayerViewControllerDataSource,MoviePlayerViewControllerDelegate>
{
    NSInteger photoPageNum;
    MoviePlayerViewController *movieVC;
    UIButton *videoBtn;
    UIButton *moreOrLessBtn;
    UIButton *gotoMovieBtn;
}
@property (nonatomic, strong) Movie *myMovie;
@property (nonatomic, strong) NSMutableArray *moviePhotoList;
@property (nonatomic, strong) NSMutableArray *movieActorList;
@property (nonatomic, strong) NSMutableArray *movieVideoList;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *urlStrings;
@property (nonatomic, assign) BOOL isReying;
@property (nonatomic, assign) BOOL isHiddenAnimation;

@property (nonatomic, strong) UINavigationBar *mdNaviBar;
@end
