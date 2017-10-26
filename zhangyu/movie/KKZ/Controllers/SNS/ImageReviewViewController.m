//
//  ImageReviewViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ImageReviewViewController.h"
#import "UIColor+Hex.h"
#import "ImageReviewView.h"

/**************左导航栏视图*******************/
static const CGFloat closeButtonOriginX = 15.0f;
static const CGFloat closeButtonOriginY = 13.0f;

/**************右导航栏视图*******************/
static const CGFloat deleteButtonRight = 15.0f;

/**************导航栏标题*******************/
static const CGFloat navBarTitleLeft = 80.0f;

typedef enum : NSUInteger {
    closeButtonTag = 1000,
    deleteButtonTag,
} allButtonTag;

typedef enum : NSUInteger {
    ExchangeFirstView = 2000,
    ExchangeLastView,
} ExchangeState;

@interface ImageReviewViewController ()<UIScrollViewDelegate>

/**
 *  内容滚动条
 */
@property (nonatomic, strong) UIScrollView *contentScroll;

/**
 *  左导航按钮
 */
@property (nonatomic, strong) UIButton *leftNavBarBtn;

/**
 *  右导航按钮
 */
@property (nonatomic, strong) UIButton *rightNavBarBtn;

/**
 *  导航栏标题
 */
@property (nonatomic, strong) UILabel *navBarTitle;

/**
 *  当前视图的索引
 */
@property (nonatomic, assign) NSInteger viewIndex;

/**
 *  显示的视图数组
 */
@property (nonatomic, strong) NSMutableArray *viewsArray;

@end

@implementation ImageReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载导航条视图
    [self loadScrollView];
    
    //加载图片视图
    [self loadImageReviewView];
    
    //加载导航视图
    [self loadNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)loadNavBar {
    
    //左导航按钮
    [self.view addSubview:self.leftNavBarBtn];
    
    //右导航按钮
    [self.view addSubview:self.rightNavBarBtn];
    
    //导航栏标题
    [self.view addSubview:self.navBarTitle];
}

-(void)loadScrollView{
    
    //初始化滚动条视图
    [self.view addSubview:self.contentScroll];
}

- (void)loadImageReviewView {
    
    //显示的视图个数
    NSUInteger viewCount = self.imagesArray.count;
    if (viewCount > 3) {
        viewCount = 3;
    }
    
    //视图的偏移索引值
    NSUInteger offsetIndex = self.showIndex;
    if (self.imagesArray.count > 3) {
        if (self.showIndex == 0) {
            offsetIndex = 0;
        }else if (self.showIndex == self.imagesArray.count - 1) {
            offsetIndex = 2;
        }else {
            offsetIndex = 1;
        }
    }
    self.viewIndex =offsetIndex;
    for (int i=0; i < viewCount; i++) {
        ImageReviewView *imageReviewView = [self getImageReviewView];
        imageReviewView.backgroundColor = [UIColor clearColor];
        imageReviewView.frame = CGRectMake(i * CGRectGetWidth(self.contentScroll.frame), 0, CGRectGetWidth(self.contentScroll.frame), CGRectGetHeight(self.contentScroll.frame));
        if (self.showIndex == 0) {
            imageReviewView.originalImage = self.imagesArray[i];
        }else if (self.showIndex == self.imagesArray.count - 1) {
            imageReviewView.originalImage = self.imagesArray[self.showIndex - (viewCount - 1) + i];
        }else {
            imageReviewView.originalImage = self.imagesArray[self.showIndex - 1 + i];
        }
        [self.viewsArray addObject:imageReviewView];
    }
    self.contentScroll.contentSize = CGSizeMake(CGRectGetWidth(self.contentScroll.frame) * viewCount, self.contentScroll.contentSize.height);
    [self.contentScroll setContentOffset:CGPointMake(CGRectGetWidth(self.contentScroll.frame) * offsetIndex, self.contentScroll.contentOffset.y)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / kCommonScreenWidth;
    if(self.imagesArray.count > 3){
        //如果划屏显示的页面索引值是当前页面的话 ｜ 显示到最后一个视图索引值
        if(index == self.viewIndex){
            return;
        }else if (index > self.viewIndex){
            
            //当前视图的索引值加1
            self.showIndex = self.showIndex + index - self.viewIndex;
            self.viewIndex = index;
            
            //如果当前是最后一个视图
            if (index == 2) {
                if (self.showIndex == self.imagesArray.count - 1) {
                    return;
                }else {
                    //交换视图
                    [self exchangeImageViewFrame:ExchangeFirstView];
                    [self.contentScroll setContentOffset:CGPointMake(CGRectGetWidth(self.contentScroll.frame),scrollView.contentOffset.y) animated:NO];
                    self.viewIndex = 1;
                    return;
                }
            }
            
        }else{
            //当前视图的索引值减1
            self.showIndex = self.showIndex - (self.viewIndex - index);
            self.viewIndex = index;
            
            //如果当前是第一个视图
            if (index == 0) {
                if (self.showIndex == 0) {
                    return;
                }else {
                    //交换视图
                    [self exchangeImageViewFrame:ExchangeLastView];
                    [self.contentScroll setContentOffset:CGPointMake(CGRectGetWidth(self.contentScroll.frame),scrollView.contentOffset.y) animated:NO];
                    self.viewIndex = 1;
                    return;
                }
            }
        }
    }else{
        if(index == self.viewIndex){
            return;
        }else if (index > self.viewIndex){
            self.viewIndex = index;
            self.showIndex = self.showIndex + 1;
            if (self.showIndex == self.imagesArray.count - 1) {
                return;
            }
        }else{
            self.viewIndex = index;
            self.showIndex = self.showIndex - 1;
            if (self.showIndex == 0) {
                return;
            }
        }
    }
}

-(void)exchangeImageViewFrame:(ExchangeState)state {
    ImageReviewView *firstView = self.viewsArray[0];
    ImageReviewView *secondView = self.viewsArray[1];
    ImageReviewView *thirdView = self.viewsArray[2];
    firstView.contentScroll.zoomScale = 1.0f;
    secondView.contentScroll.zoomScale = 1.0f;
    thirdView.contentScroll.zoomScale = 1.0f;
    if (state == ExchangeFirstView) {
        
        //改变第三个视图的尺寸
        CGRect thirdRect = thirdView.frame;
        thirdRect.origin.x = _contentScroll.frame.size.width;
        thirdView.frame = thirdRect;
        
        //改变第二个视图的尺寸
        CGRect secondRect = secondView.frame;
        secondRect.origin.x = _contentScroll.frame.origin.x;
        secondView.frame = secondRect;
        
        //改变第一个视图的尺寸
        CGRect firstRect = firstView.frame;
        firstRect.origin.x = _contentScroll.frame.size.width*2;
        firstView.frame = firstRect;
        
        //得到当前索引的下一个图片
        NSInteger index = self.showIndex + 1;
        UIImage *image = self.imagesArray[index];
        firstView.originalImage = image;
        
        //交换数组视图位置
        [self.viewsArray removeObjectAtIndex:0];
        [self.viewsArray addObject:firstView];
        
    }else if (state == ExchangeLastView) {
        
        //改变第三个视图的尺寸
        CGRect thirdRect = thirdView.frame;
        thirdRect.origin.x = _contentScroll.frame.origin.x;
        thirdView.frame = thirdRect;
        
        //改变第二个视图的尺寸
        CGRect secondRect = secondView.frame;
        secondRect.origin.x = _contentScroll.frame.size.width*2;
        secondView.frame = secondRect;
        
        //改变第一个视图的尺寸
        CGRect firstRect = firstView.frame;
        firstRect.origin.x = _contentScroll.frame.size.width;
        firstView.frame = firstRect;
        
        //得到当前索引的上一个图片
        NSInteger index = self.showIndex - 1;
        UIImage *image = self.imagesArray[index];
        thirdView.originalImage = image;
        
        //交换数组视图位置
        [self.viewsArray removeLastObject];
        [self.viewsArray insertObject:thirdView
                              atIndex:0];
    }
}

-(void)deleteImageViewAtIndex:(NSInteger)index{
    
    if(self.imagesArray.count <= 3){
    
        //循环遍历数组元素
        NSInteger currentImgIndex = index;
        for(NSInteger i = self.viewIndex;i < self.viewsArray.count;i++){
            if(currentImgIndex >= self.imagesArray.count - 1){
                break;
            }
            currentImgIndex++;
            ImageReviewView *currentView = (ImageReviewView *)self.viewsArray[i];
            [currentView setOriginalImage:self.imagesArray[currentImgIndex]];
        }
        
        //移除滚动条视图最后一个视图
        ImageReviewView *photoView = [self.viewsArray lastObject];
        [photoView removeFromSuperview];
        [self.viewsArray removeLastObject];
        [self removeObjectAtIndex:index];
        self.contentScroll.contentSize = CGSizeMake(self.viewsArray.count * CGRectGetWidth(_contentScroll.frame),self.contentScroll.contentSize.height);
        self.showIndex = _contentScroll.contentOffset.x / CGRectGetWidth(_contentScroll.frame);
        
    }else{
        
        //移除要删除的数组元素
        [self removeObjectAtIndex:index];
        
        //最后一张图片删除
        NSInteger currentImgIndex;
        if(index == 0 || index == 1){
            currentImgIndex = 0;
        }else if (index == self.imagesArray.count) {
            currentImgIndex = index - 3;
        }else if(index == self.imagesArray.count - 1) {
            currentImgIndex = index - 2;
        }else {
            currentImgIndex = index - 1;
        }
        
        //循环遍历数组元素
        for(NSInteger i = 0;i < self.viewsArray.count;i++){
            if(currentImgIndex > self.imagesArray.count - 1){
                break;
            }
            ImageReviewView *currentView = (ImageReviewView *)self.viewsArray[i];
            [currentView setOriginalImage:self.imagesArray[currentImgIndex]];
            currentImgIndex++;
        }
        
        //当前显示索引值大于等于1，就减1
        NSInteger index = self.contentScroll.contentOffset.x / CGRectGetWidth(self.contentScroll.frame);
        ImageReviewView *curView = self.viewsArray[index];
        self.showIndex = [self.imagesArray indexOfObject:curView.originalImage];
    }
}

#pragma mark - public Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case closeButtonTag:{
            [self popViewControllerAnimated:YES];
            break;
        }
        case deleteButtonTag: {
            [self deleteImageViewAtIndex:self.showIndex];
            if (self.imagesArray.count == 0) {
                [self popViewControllerAnimated:YES];
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)showNavBar {
    return FALSE;
}

- (UIButton *)leftNavBarBtn {
    
    if (!_leftNavBarBtn) {
        UIImage *closeImg = [UIImage imageNamed:@"movieComment_back"];
        _leftNavBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftNavBarBtn.frame = CGRectMake(0.0f,0.0f,closeImg.size.width + closeButtonOriginX*2,closeImg.size.height + closeButtonOriginY * 2);
        _leftNavBarBtn.backgroundColor = [UIColor clearColor];
        [_leftNavBarBtn setImage:closeImg
                        forState:UIControlStateNormal];
        [_leftNavBarBtn setImageEdgeInsets:UIEdgeInsetsMake(closeButtonOriginY, closeButtonOriginX,closeButtonOriginY, closeButtonOriginX)];
        _leftNavBarBtn.tag = closeButtonTag;
        [_leftNavBarBtn addTarget:self
                           action:@selector(commonBtnClick:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBarBtn;
}

- (UIButton *)rightNavBarBtn {
    
    if (!_rightNavBarBtn) {
        UIImage *deleteImg = [UIImage imageNamed:@"movieComment_delete"];
        _rightNavBarBtn = [UIButton buttonWithType:0];
        CGFloat totalWidth = deleteImg.size.width + 2 * deleteButtonRight;
        _rightNavBarBtn.frame = CGRectMake(kCommonScreenWidth - totalWidth,0,totalWidth,deleteImg.size.height + closeButtonOriginY * 2);
        _rightNavBarBtn.tag = deleteButtonTag;
        [_rightNavBarBtn setImage:deleteImg
                         forState:UIControlStateNormal];
        [_rightNavBarBtn setImageEdgeInsets:UIEdgeInsetsMake(closeButtonOriginY, deleteButtonRight, closeButtonOriginY, deleteButtonRight)];
        [_rightNavBarBtn addTarget:self
                            action:@selector(commonBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBarBtn;
}

- (UILabel *)navBarTitle {
    
    if (!_navBarTitle) {
        _navBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(navBarTitleLeft, closeButtonOriginY, screentWith - navBarTitleLeft * 2, 17.0f)];
        _navBarTitle.font = [UIFont boldSystemFontOfSize:16];
        _navBarTitle.backgroundColor = [UIColor clearColor];
        _navBarTitle.textAlignment = NSTextAlignmentCenter;
        _navBarTitle.textColor = [UIColor whiteColor];
    }
    return _navBarTitle;
}

- (ImageReviewView *)getImageReviewView {
    ImageReviewView *_imageReviewView = [[ImageReviewView alloc] initWithFrame:CGRectZero];
    [self.contentScroll addSubview:_imageReviewView];
    return _imageReviewView;
}

- (UIScrollView *)contentScroll {
    
    if (!_contentScroll) {
        _contentScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,kCommonScreenWidth,kCommonScreenHeight)];
        _contentScroll.backgroundColor=[UIColor colorWithHex:@"#191821"];
        _contentScroll.pagingEnabled = YES;
        _contentScroll.delegate = self;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_contentScroll];
    }
    return _contentScroll;
}

#pragma mark - getter Method

- (NSMutableArray *)viewsArray {
    
    if (!_viewsArray) {
        _viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}

#pragma mark - setter Method

- (void)setShowIndex:(NSInteger)showIndex {
    _showIndex = showIndex;
    self.navBarTitle.text = [NSString stringWithFormat:@"%ld/%lu",(long)_showIndex + 1,(unsigned long)self.imagesArray.count];
}

- (void)setImagesArray:(NSMutableArray *)imagesArray {
    _imagesArray = imagesArray;
    self.navBarTitle.text = [NSString stringWithFormat:@"%ld/%lu",(long)_showIndex + 1,(unsigned long)self.imagesArray.count];
}

- (void)removeObjectAtIndex:(NSInteger)index {
    [self.imagesArray removeObjectAtIndex:index];
    self.navBarTitle.text = [NSString stringWithFormat:@"%ld/%lu",(long)_showIndex + 1,(unsigned long)self.imagesArray.count];
}

@end
