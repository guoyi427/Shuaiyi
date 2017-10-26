//
//  全屏显示图片，可以左右滑动切换的页面
//
//  Created by alfaromeo on 12-3-23.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieStillScrollViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "DataEngine.h"
#import "Gallery.h"
#import "ImageEngine.h"
#import "UIViewControllerExtra.h"

@interface MovieStillScrollViewController () {

    NSTimer *timer;
}

@property (nonatomic, strong) UIImage *saveImg;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation MovieStillScrollViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.navBarView.backgroundColor = [UIColor blackColor];

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(screentWith - 50, 4, 60, 38);

    [doneBtn setImage:[UIImage imageNamed:@"ic_save_white"] forState:UIControlStateNormal];
    [doneBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 20, 9, 20)];
    [doneBtn addTarget:self
                      action:@selector(saveImageToPhoto)
            forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:doneBtn];

    self.library = [[ALAssetsLibrary alloc] init];

    [self currentIndex:self.index];

    PhotoScrollView *photoView = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY, screentWith, screentContentHeight)
                                                              initIndex:0
                                                               delegate:self];
    [self.view addSubview:photoView];
    [photoView scrollToIndex:self.index animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)downloadImageAtIndex:(UIImage *)image imgPath:(NSString *)imgUrl {
    self.imgUrl = imgUrl;
    if (image) {
        self.saveImg = image;
    } else {
        self.saveImg = [[ImageEngine sharedImageEngine]
                getImageFromDiskForURL:imgUrl
                               andSize:ImageSizeOrign];
    }
}

- (void)saveImageToPhoto {
    if (!self.saveImg) {
        // TODO 保存图片的逻辑
        self.saveImg = [[ImageEngine sharedImageEngine]
                getImageFromDiskForURL:self.imgUrl
                               andSize:ImageSizeOrign];

        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(saveImgClick) userInfo:nil repeats:NO];

    } else {
        [self.library writeImageToSavedPhotosAlbum:[self.saveImg CGImage]
                                       orientation:(ALAssetOrientation) self.saveImg.imageOrientation
                                   completionBlock:^(NSURL *assetURL, NSError *error) {

                                       if (error) {
                                           [self showSaveFailedAlertView];
                                       } else {
                                           [self showSaveSucceedAlertView];
                                       }
                                   }];
    }
}

- (void)showSaveSucceedAlertView {
    [UIAlertView showAlertView:@"保存成功" buttonText:@"确定"];
}

- (void)showSaveFailedAlertView {
    [UIAlertView showAlertView:@"保存失败，请您重新保存试试吧～" buttonText:@"确定"];
}

- (void)saveImgClick {
    if (!self.saveImg) {
        [self showSaveFailedAlertView];
        return;
    }

    [self.library writeImageToSavedPhotosAlbum:[self.saveImg CGImage]
                                   orientation:(ALAssetOrientation) self.saveImg.imageOrientation
                               completionBlock:^(NSURL *assetURL, NSError *error) {

                                   if (error) {
                                       [self showSaveFailedAlertView];
                                   } else {
                                       [self showSaveSucceedAlertView];
                                   }
                               }];
    [timer invalidate];
    timer = nil;
}

#pragma mark - Photo Scroll View delegate
- (NSString *)imageUrlAtIndex:(NSInteger)idx {
    if (self.isMovie) {
        Gallery *gallery = self.gallerys[idx];
        return gallery.imageBig;
    } else {
        return self.gallerys[idx];
    }
}

- (NSInteger)imageCount {
    return self.gallerys.count;
}

- (void)currentIndex:(NSInteger)index {
    self.kkzTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, [self imageCount]];
}

#pragma mark - Override from CommonViewController
- (BOOL)isNavMainColor {
    return NO;
}

@end
