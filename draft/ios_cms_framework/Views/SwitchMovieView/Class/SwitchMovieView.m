
//  SwitchMovieView.m
//  切换视图
//
//  Created by 艾广华 on 16/4/6.
//  Copyright © 2016年 艾广华. All rights reserved.
//

#import "SwitchMovieView.h"
#import "UIImage+Blur.h"
#import "UIImageView+WebCache.h"
#import <Category_KKZ/UIImage+Resize.h>

@interface SwitchMovieView ()<UIScrollViewDelegate>

/**
 *  滚动条视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

///**
// *  中间标识视图
// */
//@property (nonatomic, strong) UIView *centerView;

/**
 *  显示的图片视图数组
 */
@property (nonatomic, strong) NSMutableArray *imageViewArray;

/**
 *  当前显示的图片视图
 */
@property (nonatomic, strong) UIImageView *currentImgV;

/**
 *  下一个显示的图片视图
 */
@property (nonatomic, strong) UIImageView *nextImgV;

/**
 *  基准位置
 */
@property (nonatomic, assign) CGFloat baseLinePosition;

/**
 *  判断是否是通过接口加载列表
 */
@property (nonatomic, assign) BOOL isFromLoadImages;

@end

@implementation SwitchMovieView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
        //图片上面的单击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isMoviedetailCanbeclickedPush) name:@"isMoviedetailCanbeclickedPush" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isMoviedetailCanbeclickedPop) name:@"isMoviedetailCanbeclickedPop" object:nil];
        
        self.isCanChangeMovie = YES;
        
        //添加模糊特效
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        [self addSubview:effectView];
        CGRect frameTemp = effectView.frame;
        frameTemp = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        effectView.frame = frameTemp;
        NSLog(@"effectView.frame === %@",NSStringFromCGRect(effectView.frame));
        
        UIImageView *posterBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-18, kCommonScreenWidth, 18)];
        [self addSubview:posterBg];
        posterBg.image = [UIImage imageNamed:@"poster_bg"];
        posterBg.contentMode = UIViewContentModeScaleAspectFill;
        posterBg.clipsToBounds = YES;
        [self bringSubviewToFront:posterBg];

    }
    return self;
}

-(void)isMoviedetailCanbeclickedPush
{
    self.isCanChangeMovie = NO;
}

-(void)isMoviedetailCanbeclickedPop
{
    self.isCanChangeMovie = YES;
}

- (void)didMoveToSuperview {
    [self addSubview:self.scrollView];
    UIPanGestureRecognizer *panGesture = self.scrollView.panGestureRecognizer;
    [self addGestureRecognizer:panGesture];
}


- (void)loadImagesWithUrl:(NSArray *)array saw:(NSArray *)sawArray
{
    self.isFromLoadImages = YES;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageViewArray removeAllObjects];
    int index = 0;
    CGFloat leftMargin = (self.scrollView.frame.size.width - self.currentMovieSize.width)/2.0f;
    CGFloat y = 10;//(self.scrollView.frame.size.height - self.currentMovieSize.height)/2.0f;
    CGFloat x = leftMargin;
    for (NSInteger i = 0 ; i < array.count; i++) {
        NSString *promotionString = (NSString *)[sawArray objectAtIndex:i];
        
        //图片显示视图
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,self.currentMovieSize.width, self.currentMovieSize.height)];
        UIImageView *huiLogoImage = [UIImageView new];
        huiLogoImage.backgroundColor = [UIColor clearColor];
        huiLogoImage.image = [UIImage imageNamed:@"hui_tag1"];
        [iv addSubview:huiLogoImage];
        huiLogoImage.clipsToBounds = YES;
        huiLogoImage.contentMode = UIViewContentModeScaleAspectFit;
        [huiLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(iv);
            make.width.height.equalTo(@(34));
        }];
//        promotionString = @"1";
        if ([promotionString isEqualToString:@"1"]) {
            huiLogoImage.hidden = NO;

        }else{
            huiLogoImage.hidden = YES;
        }
        UIView *blackView = [UIView new];
        [iv addSubview:blackView];
        blackView.hidden = YES;
        blackView.tag = 8989;
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(iv);
        }];

        [self.imageViewArray addObject:iv];
        iv.layer.cornerRadius = 4;
        iv.userInteractionEnabled = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        if (index != self.currentIndex) {
            blackView.hidden = NO;
            [self setNormalRectWithImageView:iv];
        }
        UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic_s"] newSize:CGSizeMake(self.currentMovieSize.width, self.currentMovieSize.height) bgColor:[UIColor colorWithHex:@"#f2f5f5"]];

        NSString *URL = array[i];
        [iv sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:URL]
              placeholderImage:placeHolderImage
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         if (self.currentIndex == [self.imageViewArray indexOfObject:iv]) {
                             if (image) {
                                 if (self.currentIndex == [self.imageViewArray indexOfObject:iv]) {
                                     self.image = image;
                                 }
                             }else{
                                 if (self.currentIndex == [self.imageViewArray indexOfObject:iv]) {
                                     self.image = placeHolderImage;
                                 }
                             }
                             
                         }
                     }];
        [self.scrollView addSubview:iv];
        
        if([self.delegate respondsToSelector:@selector(shouldShowOfferIconAtIndex:)] && [self.delegate shouldShowOfferIconAtIndex:i] == YES) {
            UIImage *icon = [UIImage imageNamed:@"offer_icon"];
            UIImageView *iconV = [[UIImageView alloc] initWithImage:icon];
            iconV.translatesAutoresizingMaskIntoConstraints = NO;
            [iv addSubview:iconV];
            NSDictionary* views = NSDictionaryOfVariableBindings(iconV);
            [iv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconV(15)]|" options:NSLayoutFormatAlignAllRight | NSLayoutAttributeTop metrics:nil views:views]];
            [iv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconV(15)]" options:NSLayoutFormatAlignAllRight | NSLayoutAttributeTop metrics:nil views:views]];
        }
        
        index++;
        x += self.currentMovieSize.width;
        if (index == array.count) {
            x += leftMargin;
        }
        /*
        if (sawArray.count == array.count) {
            BOOL saw = [sawArray[i] boolValue];
            if (saw == YES) {
                CGSize sawSize = CGSizeMake(36, 36);
                
                UIView *container = [UIView new];
                container.backgroundColor = [UIColor grayColor];
                container.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                container.layer.cornerRadius = sawSize.width/2;
                container.layer.masksToBounds = YES;
                container.translatesAutoresizingMaskIntoConstraints = NO;
                [iv addSubview:container];
                
                NSDictionary* views = NSDictionaryOfVariableBindings(container);
                //设置高度
                [iv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[container(36)]" options:0 metrics:nil views:views]];
                //设置宽度
                [iv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[container(36)]" options:0 metrics:nil views:views]];
                //垂直居中
                [iv addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:iv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
                //水平居中
                [iv addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:iv attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                
                UILabel *labelSaw = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sawSize.width, sawSize.height)];
                [container addSubview:labelSaw];

                labelSaw.text = @"看过";
                labelSaw.font = [UIFont systemFontOfSize:10];
                labelSaw.textColor = [UIColor whiteColor];
                labelSaw.textAlignment = NSTextAlignmentCenter;


            }
        }
         */
    }
    self.scrollView.contentSize = CGSizeMake(x, 0);
    if (self.currentIndex * self.currentMovieSize.width == self.scrollView.contentOffset.x) {
        //给第一次选中的图片视图进行背景虚化
        if (self.imageViewArray.count > self.currentIndex) {
            self.currentImgV = self.imageViewArray[self.currentIndex];
            [self setCurrentImageViewBlur];
        }
    }else {
        if (self.imageViewArray.count > self.currentIndex) {
            [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.currentMovieSize.width, 0)
                                     animated:YES];
        }
    }
}

- (void)loadImagesWithUrl:(NSArray *)array {
    
    [self loadImagesWithUrl:array saw:nil];
}


- (void)setNormalRectWithImageView:(UIImageView *)iv{
    CGRect image = iv.bounds;
    image.size.width = self.normalMovieSize.width;
    image.size.height = self.normalMovieSize.height;
    iv.bounds = image;
    [self setNormalPositionWithImageView:iv];
}

- (void)setNormalPositionWithImageView:(UIImageView *)iv{
    CGRect frame = iv.frame;
    frame.origin.y = 10;//(CGRectGetHeight(self.scrollView.frame) - CGRectGetHeight(iv.frame)) * 0.5;
    iv.frame = frame;
    for (UIView *view in iv.subviews) {
        if (view.tag == 8989) {
            view.hidden = NO;
        }
    }
}

- (void)setImageViewArrayNormalRect:(NSArray *)imgs{
    for (int i=0; i < self.imageViewArray.count; i++) {
        UIImageView *showImgV = self.imageViewArray[i];
        if ([imgs containsObject:showImgV]) {
            continue;
        }
        [self setNormalRectWithImageView:showImgV];
    }
}

- (void)setCurrentImageViewBlur{
    if (self.currentImgV.image) {
        self.image = self.currentImgV.image;
    }else {
        self.image = [UIImage imageNamed:@"loginMainBg.jpg"];
    }
    for (int i=0; i < self.imageViewArray.count; i++) {
        UIImageView *imgV = self.imageViewArray[i];
        imgV.layer.borderColor = [UIColor clearColor].CGColor;
    }
    _currentImgV.layer.borderColor = [UIColor whiteColor].CGColor;
    _currentImgV.layer.borderWidth = 1.0f;
    _currentImgV.layer.cornerRadius = 4;
    _currentImgV.layer.masksToBounds = YES;
    NSInteger index = [self.imageViewArray indexOfObject:_currentImgV];
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchMovieDidSelectIndex:)] && index != NSNotFound) {
        [self.delegate switchMovieDidSelectIndex:index];
    }
}

- (void)tapGesture:(UIGestureRecognizer *)tap{
//    UIImageView *imgV = (UIImageView *)tap.view;
    if (!self.isCanChangeMovie) {
        return;
    }
    CGPoint point = [tap locationInView:self];
    UIImageView *finalImgV = nil;
    for (int i=0; i < self.imageViewArray.count; i++) {
        UIImageView *imgV = self.imageViewArray[i];
        CGRect finalFrame = [self.scrollView convertRect:imgV.frame toView:self];
        if (CGRectContainsPoint(finalFrame,point)) {
            finalImgV = imgV;
            [self.scrollView setContentOffset:CGPointMake(i * self.currentMovieSize.width, 0)
                                     animated:YES];
            break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchmovieScrollViewDidScroll" object:nil];
    
    if (self.isFromLoadImages) {
        //初始化显示的索引视图
        [self setChangeImageView:self.currentIndex];
        self.isFromLoadImages = NO;
    }else{
        //获取当前显示图片的索引
        NSInteger contentOffset = scrollView.contentOffset.x;
        NSInteger index = contentOffset / (NSInteger)(self.currentMovieSize.width);
        //初始化显示的索引视图
        [self setChangeImageView:index];
    }

    
    //改变当前显示的图片视图
    [self changePostionWithScrollView:scrollView
                                  img:self.currentImgV];
    [self changePostionWithScrollView:scrollView
                                  img:self.nextImgV];
    if (self.currentImgV && self.nextImgV) {
        [self setImageViewArrayNormalRect:@[self.currentImgV,self.nextImgV]];
    }else if (self.currentImgV) {
        [self setImageViewArrayNormalRect:@[self.currentImgV]];
    }else if (self.nextImgV) {
        [self setImageViewArrayNormalRect:@[self.nextImgV]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setImageViewArrayNormalRect:@[self.currentImgV]];
    [self setCurrentImageViewBlur];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchmovieScrollViewDidEndDecelerating" object:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setCurrentImageViewBlur];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"switchmovieScrollViewDidEndDecelerating" object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
         [self setCurrentImageViewBlur];
    }
}

- (void)changePostionWithScrollView:scrollView
                                img:(UIImageView *)iv {
    if(!iv){
        return;
    }
    
    CGRect point = [scrollView convertRect:iv.frame
                                    toView:self];
    CGFloat diff = fabs(CGRectGetMidX(self.frame) - CGRectGetMidX(point))/ self.currentMovieSize.width;
    if (diff >= 1.0f) {
        diff = 1.0f;
    }
    
    //修改当前视图的尺寸
    CGRect curBounds = iv.bounds;
    curBounds.size.width = floor((1-diff) * self.currentMovieSize.width + diff * self.normalMovieSize.width);
    curBounds.size.height = floor((1-diff) * self.currentMovieSize.height + diff * self.normalMovieSize.height);
    iv.bounds = curBounds;
    [self setNormalPositionWithImageView:iv];
}

- (void)setChangeImageView:(NSInteger)index {
    if (index < 0 || index >= self.imageViewArray.count) {
        return;
    }
    if (index + 1 < self.imageViewArray.count) {
        self.nextImgV = self.imageViewArray[index + 1];
    }
    self.currentIndex = index;
    self.currentImgV = self.imageViewArray[index];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_currentIndex < self.imageViewArray.count) {
        self.currentImgV = self.imageViewArray[_currentIndex];
        for (UIView *view in self.currentImgV.subviews) {
            if (view.tag == 8989) {
                view.hidden = YES;
            }
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = CGRectMake((CGRectGetWidth(self.frame)-self.currentMovieSize.width)*0.5,0,self.currentMovieSize.width,CGRectGetHeight(self.frame));
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

//- (UIView *)centerView {
//    if (!_centerView) {
//        _centerView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 1)/2.0f,0,1, CGRectGetHeight(self.frame))];
//        _centerView.backgroundColor = [UIColor redColor];
//    }
//    return _centerView;
//}

- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        self.imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (CGFloat)baseLinePosition {
    return (CGRectGetHeight(self.scrollView.frame) - self.currentMovieSize.height)*0.5 + self.currentMovieSize.height;
}

@end
