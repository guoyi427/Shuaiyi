//
//  MovirePhotoDetailController.m
//  CIASMovie
//
//  Created by avatar on 2017/2/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovirePhotoDetailController.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovirePhotoDetailController ()

@end

@implementation MovirePhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tmpUrl = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpCover = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i < self.photoList.count; i++) {
        [tmpCover insertObject:[[self.photoList objectAtIndex:i] kkz_stringForKey:@"cover"] atIndex:i];
        [tmpUrl insertObject:[[self.photoList objectAtIndex:i] kkz_stringForKey:@"url"] atIndex:i];
    }
    self.urlStrings = tmpCover;
    self.images = tmpUrl;
    // 快速创建并进入浏览模式
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:self.index imageCount:self.images.count datasource:self];
    // 自定义一些属性
    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor greenColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.scrollView = [[UIScrollView alloc] init];
//    self.scrollView.xl_width = XLScreenW - 30;
//    self.scrollView.xl_height = 100;
//    self.scrollView.xl_x = 15;
//    self.scrollView.xl_y = 100;
//    [self.view addSubview:self.scrollView];
//    self.scrollView.backgroundColor = [UIColor grayColor];
//    
//    [self resetScrollView];
}

- (void)clearImageCache
{
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
}
//- (void)resetScrollView
//{
//    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    CGFloat imageWidth = 100;
//    CGFloat margin = 10;
//    for (int i = 0 ; i < self.images.count; i ++) {
//        UIImageView *headerImageView = [[UIImageView alloc] init];
//        headerImageView.tag = i;
//        headerImageView.userInteractionEnabled = YES;
//        [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
//        headerImageView.xl_x = (imageWidth + margin) * i;
//        headerImageView.xl_y = 0;
//        headerImageView.xl_width = imageWidth;
//        headerImageView.xl_height = imageWidth;
////        headerImageView.image = self.images[i];
//        [headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:i]] placeholderImage:nil];
//        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
//        headerImageView.layer.masksToBounds = YES;
//        [self.scrollView addSubview:headerImageView];
//    }
//    self.scrollView.contentSize = CGSizeMake((imageWidth + margin) * self.images.count,0 );
//}

/**
 */
//- (void)clickImage:(UITapGestureRecognizer *)tap
//{
//    // 快速创建并进入浏览模式
//    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];
//    // 自定义一些属性
//    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
//    browser.currentPageDotColor = [UIColor greenColor];
//    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
//}

#pragma mark    -   XLPhotoBrowserDatasource

/**
 *  返回这个位置的占位图片 , 也可以是原图(如果不实现此方法,会默认使用placeholderImage)
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 占位图片
 */
//- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    return self.images[index];
//}

/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示图片的容器视图,如UIImageView等
 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return self.scrollView.subviews[index];
}

/**
 *  返回指定位置的高清图片URL
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 返回高清大图索引
 */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.urlStrings[index]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
