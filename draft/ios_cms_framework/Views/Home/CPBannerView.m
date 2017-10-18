//
//  CPBannerView.m
//  Cinephile
//
//  Created by Albert on 8/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPBannerView.h"
#import "CPPageControl.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Category_KKZ/UIImage+Resize.h>
//#import "Banner.h"
#import "BannerNew.h"

@implementation NSTimer (Addition)

- (void)pause
{
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    [self setFireDate:[NSDate date]];
}

@end

@interface CPBannerView()<UIScrollViewDelegate>
{
    UIImageView *_leftImageView;
    UIImageView *_middleImageView;
    UIImageView *_rightImageView;
    
    NSInteger _currentIndex;
    
    NSUInteger _imageCount;
    
    NSTimer                 *_timerLoop ;           // 控制循环
    NSTimer                 *_timerOverflow ;       // 控制手动后的等待时间
    BOOL                    bOpenTimer ;            // 开关
}
#define K_DURATION 5

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) CPPageControl *mPageControl;
@property (nonatomic, strong) NSArray *mImageUrls;

@property (nonatomic, copy) void (^mBlock)(NSInteger index);
@property (nonatomic, strong) CAShapeLayer *curvedLayer;
@property (nonatomic, strong) UIImage *placeHolderImage;
@end

@implementation CPBannerView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void) setup
{
    if (self.mScrollView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.mScrollView = [[UIScrollView alloc]init];
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.delegate = self;
    [self addSubview:self.mScrollView];
    
    [self.mScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
//    self.curvedLayer = [CAShapeLayer new];
//    [self.layer addSublayer:self.curvedLayer];
//    [self.curvedLayer setBackgroundColor:[UIColor redColor].CGColor];
    
    self.mPageControl = [CPPageControl new];
    [self addSubview:self.mPageControl];
    [self.mPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@10);
    }];
    
    UIView*containerView = [UIView new];
    [self.mScrollView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mScrollView);
        make.height.equalTo(self.mScrollView);
    }];
    
    
    _leftImageView = [self commonImageView];
    [self.mScrollView addSubview:_leftImageView];
    _middleImageView = [self commonImageView];
    [self.mScrollView addSubview:_middleImageView];
    _rightImageView = [self commonImageView];
    [self.mScrollView addSubview:_rightImageView];
    
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(containerView);
    }];
    
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self);
        
        make.left.equalTo(_leftImageView.mas_right);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(_middleImageView.mas_right);
    }];
    
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_rightImageView.mas_right);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
    [self addGestureRecognizer:tap];
    
}


- (UIImage *)placeHolderImage
{
    if (_placeHolderImage == nil) {
//        _placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"logo_holder"]
//                                              newSize:self.mScrollView.frame.size
//                                              bgColor:[UIColor colorWithHex:@"0xe3e3e3"]];
        _placeHolderImage = [UIImage imageNamed:@"home_banner"];
    }
    
    return _placeHolderImage;
}

- (UIImageView *) commonImageView
{
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

/**
 *  加载图片列表
 *
 *  @param imamgUrls 图片列表<NSUrl>
 */
- (void) loadContenWithArr:(NSArray *)imamgUrls
{
    
    self.mImageUrls = imamgUrls;
    _imageCount = self.mImageUrls.count;
//    if (self.mImageUrls.count>0) {
        [self.mPageControl setPageNumbers:self.mImageUrls.count];
        //mPageControl会根据个数设置宽度constraint，主动调用下布局iOS10
//    }
    [self layoutSubviews];
    
    self.mPageControl.currentPage = 0;
    
    if (self.mImageUrls.count == 0) {
        //  没有banner内容 清除之前的数据
        _middleImageView.image = self.placeHolderImage;
        return;
    }
//    Banner *banner = [self.mImageUrls objectAtIndex:0];
    BannerNew *banner = [self.mImageUrls objectAtIndex:0];
    [_middleImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner.slideImg] placeholderImage:self.placeHolderImage];
    
    _currentIndex = 0;
    
    
    //设置当前显示的位置为中间图片
    [self.mScrollView setContentOffset:CGPointMake(self.mScrollView.frame.size.width, 0) animated:NO];
    
    if (_imageCount == 1) {
        
        self.mScrollView.scrollEnabled = NO;
        self.mPageControl.hidden = YES;
        return;
    }
    self.mScrollView.scrollEnabled = YES;
    self.mPageControl.hidden = NO;
    
    [self loopStart];
    
}

- (void)loopStart
{
    if ([_timerLoop isValid]) {
        return;
    }
    
    _timerLoop = [NSTimer timerWithTimeInterval:K_DURATION
                                         target:self
                                       selector:@selector(loopAction)
                                       userInfo:nil
                                        repeats:YES] ;
    
    [[NSRunLoop currentRunLoop] addTimer:_timerLoop
                                 forMode:NSDefaultRunLoopMode] ;
}

- (void)loopAction
{
    if (_imageCount == 0) {
        return;
    }
    
    NSInteger leftImageIndex , rightImageIndex ;
    _currentIndex = (_currentIndex + 1) % _imageCount ;
    
    [self.mPageControl setCurrentPage:_currentIndex];
    BannerNew *banner = [self.mImageUrls objectAtIndex:_currentIndex];
    [_middleImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner.slideImg] placeholderImage:self.placeHolderImage];

    
    leftImageIndex  = (_currentIndex + _imageCount - 1) % _imageCount ;
    rightImageIndex = (_currentIndex + 1) % _imageCount ;
    
    BannerNew *banner1 = [self.mImageUrls objectAtIndex:leftImageIndex];
    
    [_leftImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner1.slideImg] placeholderImage:self.placeHolderImage];
    
    BannerNew *banner2 = [self.mImageUrls objectAtIndex:rightImageIndex];
    
    [_rightImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner2.slideImg] placeholderImage:self.placeHolderImage];
    
    [self.mScrollView setContentOffset:CGPointMake(self.mScrollView.frame.size.width , 0) animated:NO];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_middleImageView.layer addAnimation:animation forKey:nil];
    
}



- (void)tapHandler:(UITapGestureRecognizer *)gesture
{
    DLog(@"tag is %ld",_currentIndex);
    
    if (self.mBlock) {
        self.mBlock(_currentIndex);
    }
}


#pragma mark 滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [self.mScrollView setContentOffset:CGPointMake(self.mScrollView.frame.size.width, 0) animated:NO];
    
}


#pragma mark 重新加载图片
- (void)reloadImage
{
    [self resumeTimerWithDelay] ;
    
    if (self.mImageUrls.count == 0) {
        return;
    }
    
    
    NSInteger leftImageIndex,rightImageIndex ;
    CGPoint offset = [self.mScrollView contentOffset] ;
    
    if (offset.x > self.frame.size.width)
    { //向右滑动
        _currentIndex = (_currentIndex + 1) % _imageCount ;
    }
    else if(offset.x < self.frame.size.width)
    { //向左滑动
        _currentIndex = (_currentIndex + _imageCount - 1) % _imageCount ;
    }
    BannerNew *banner = [self.mImageUrls objectAtIndex:_currentIndex];
    [_middleImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner.slideImg] placeholderImage:self.placeHolderImage];
    
    //重新设置左右图片
    leftImageIndex  = (_currentIndex + _imageCount - 1) % _imageCount ;
    rightImageIndex = (_currentIndex + 1) % _imageCount ;
    
    BannerNew *banner1 = [self.mImageUrls objectAtIndex:leftImageIndex];
    [_leftImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner1.slideImg] placeholderImage:self.placeHolderImage];
    
    BannerNew *banner2 = [self.mImageUrls objectAtIndex:rightImageIndex];
    [_rightImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:banner2.slideImg] placeholderImage:self.placeHolderImage];
    

    [self.mPageControl setCurrentPage:_currentIndex];
    
}

- (void)resumeTimerWithDelay
{
    [_timerLoop pause] ;
    
    if (!bOpenTimer)
    {
        if ([_timerOverflow isValid])
        {
            [_timerOverflow invalidate] ;
        }
        
        _timerOverflow = [NSTimer timerWithTimeInterval:K_DURATION
                                                 target:self
                                               selector:@selector(timerIsOverflow)
                                               userInfo:nil
                                                repeats:NO] ;
        
        [[NSRunLoop currentRunLoop] addTimer:_timerOverflow
                                     forMode:NSDefaultRunLoopMode] ;
        
    }
}

- (void)timerIsOverflow
{
    bOpenTimer = YES ;
    
    if (bOpenTimer)
    {
        [_timerLoop resume] ;
        bOpenTimer = NO ;
        
        [_timerOverflow invalidate] ;
        _timerOverflow = nil ;
    }
}


/**
 *  设置选中回调
 *
 *  @param block 回调block
 */
- (void) setSelectCallback:(void(^)(NSInteger index))block
{
    self.mBlock = block;
}

//-(void)drawRect:(CGRect)rect
//{
//    CGFloat y = self.frame.size.height - 16;
//    
//    CGSize finalSize = CGSizeMake(self.frame.size.width, 13);
//    CGFloat layerHeight = finalSize.height * 0.8;
//    CAShapeLayer *layer = self.curvedLayer;
//    UIBezierPath *bezier = [UIBezierPath new];
//    [bezier moveToPoint:CGPointMake(0, finalSize.height - layerHeight + y)];
//    [bezier addLineToPoint:CGPointMake(0, finalSize.height - 1 + y)];
//    [bezier addLineToPoint:CGPointMake(finalSize.width, finalSize.height - 1 + y)];
//    [bezier addLineToPoint:CGPointMake(finalSize.width, finalSize.height - layerHeight + y)];
//    [bezier addQuadCurveToPoint:CGPointMake(0, finalSize.height - layerHeight  + y)
//                   controlPoint:CGPointMake(finalSize.width / 2 , (finalSize.height - layerHeight) + (K_BANNER_HEIGHT - 43))];
//    layer.path = bezier.CGPath;
//    layer.fillColor = [UIColor whiteColor].CGColor;
//}

@end
