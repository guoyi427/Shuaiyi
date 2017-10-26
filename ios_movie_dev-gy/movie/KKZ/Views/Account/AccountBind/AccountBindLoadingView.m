//
//  绑定、解绑账号操作的提示框
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AccountBindLoadingView.h"

#import "UIColor+Hex.h"

/****************黑色背景****************/
static const CGFloat blackWidth = 150.0f;
static const CGFloat blackHeight = 100.0f;

/****************加载的白色齿轮****************/
static const CGFloat loadOriginY = 25.0f;

/****************加载标签****************/
static const CGFloat loadingLabelOriginY = 14.0f;
static const CGFloat loadingLabelHeight = 14.0f;
static const CGFloat loadingLabelOriginX = 10.0f;

/****************操作成功图片****************/
static const CGFloat successOriginY = 15.0f;

@interface AccountBindLoadingView ()

/**
 *  加载的图片
 */
@property (nonatomic, strong) UIImageView *loadingImgV;

/**
 *  加载的文字
 */
@property (nonatomic, strong) UILabel *loadingLabel;

/**
 *  操作成功图片
 */
@property (nonatomic, strong) UIImageView *successImgV;

/**
 *  存储block对象
 */
@property (nonatomic, strong) animationFinished myBlock;

@end

@implementation AccountBindLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //黑色图层
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - blackWidth) / 2.0f, (frame.size.height - blackHeight) / 2.0f, blackWidth, blackHeight)];
        blackView.layer.cornerRadius = 5.0f;
        blackView.backgroundColor = [[UIColor colorWithHex:@"#7a7a7a"] colorWithAlphaComponent:0.9f];
        [self addSubview:blackView];

        //白色圆轮
        UIImage *loadImg = [UIImage imageNamed:@"AccountBind_loading"];
        _loadingImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(blackView.frame) - loadImg.size.width) / 2.0f, loadOriginY, loadImg.size.width, loadImg.size.height)];
        _loadingImgV.image = loadImg;
        [blackView addSubview:_loadingImgV];

        //加载文字
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingLabelOriginX, loadingLabelOriginY + CGRectGetMaxY(_loadingImgV.frame), CGRectGetWidth(blackView.frame) - 2 * loadingLabelOriginX, loadingLabelHeight)];
        _loadingLabel.textColor = [UIColor whiteColor];
        [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"操作中，请稍候";
        _loadingLabel.font = [UIFont systemFontOfSize:14.0f];
        [blackView addSubview:_loadingLabel];

        //增加进入后台之后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackground)
                                                     name:@"AppDidEnterBackground"
                                                   object:nil];

        //增加进入前台之后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive)
                                                     name:@"appBecomeActive"
                                                   object:nil];
    }
    return self;
}

- (id)initWithSucessFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        //黑色图层
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - blackWidth) / 2.0f, (frame.size.height - blackHeight) / 2.0f, blackWidth, blackHeight)];
        blackView.layer.cornerRadius = 5.0f;
        blackView.backgroundColor = [[UIColor colorWithHex:@"#7a7a7a"] colorWithAlphaComponent:0.9f];
        [self addSubview:blackView];

        //白色圆轮
        UIImage *loadImg = [UIImage imageNamed:@"AccountBind_success"];
        _successImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(blackView.frame) - loadImg.size.width) / 2.0f, successOriginY, loadImg.size.width, loadImg.size.height)];
        _successImgV.image = loadImg;
        [blackView addSubview:_successImgV];

        //加载文字
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingLabelOriginX, loadingLabelOriginY + CGRectGetMaxY(_successImgV.frame), CGRectGetWidth(blackView.frame) - 2 * loadingLabelOriginX, loadingLabelHeight)];
        _loadingLabel.textColor = [UIColor whiteColor];
        [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"操作成功";
        _loadingLabel.font = [UIFont systemFontOfSize:14.0f];
        [blackView addSubview:_loadingLabel];
    }
    return self;
}

- (void)beginShowSuccessView:(animationFinished)block {

    //存储block对象
    self.myBlock = block;

    //执行动画消失逻辑
    [self performSelector:@selector(hideSuccessView)
                 withObject:nil
                 afterDelay:2.0f];
}

- (void)hideSuccessView {
    [self removeFromSuperview];
    if (self.myBlock) {
        self.myBlock();
    }
}

- (void)enterBackground {
    [self stopAnimation];
}

- (void)appBecomeActive {
    [self startAnimation];
}

- (void)startAnimation {
    //设置加载框文字
    if (self.titleString) {
        _loadingLabel.text = self.titleString;
    }

    //旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设置动画属性
    [animation setToValue:@(2 * M_PI)];
    [animation setDuration:1.5];
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [_loadingImgV.layer addAnimation:animation forKey:@"rotationAnim"];
}

- (void)stopAnimation {
    [_loadingImgV.layer removeAllAnimations];
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiden {
    [self stopAnimation];
    [self removeFromSuperview];
}

#pragma mark - Public static methods
+ (AccountBindLoadingView *)showWithTitle:(NSString *)title {

    AccountBindLoadingView *loadingView = [[AccountBindLoadingView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];

    //开始加载
    NSInteger count = [[UIApplication sharedApplication].windows count];
    if (count >= 1) {
        UIWindow *w = [[UIApplication sharedApplication].windows objectAtIndex:count - 1];
        [w addSubview:loadingView];
    }
    loadingView.titleString = title;
    [loadingView startAnimation];
    return loadingView;
}

+ (AccountBindLoadingView *)showWithTitle:(NSString *)title atView:(UIView *)showView {

    AccountBindLoadingView *loadingView = [[AccountBindLoadingView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];

    [showView addSubview:loadingView];
    loadingView.titleString = title;
    [loadingView startAnimation];
    return loadingView;
}

@end
