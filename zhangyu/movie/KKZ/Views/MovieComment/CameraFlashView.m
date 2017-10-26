//
//  CameraFlashView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CameraFlashView.h"
#import "MovieSelectHeader.h"
#import "UIColor+Hex.h"

@interface CameraFlashView ()

/**
 *  所有的闪光灯选择按钮数组
 */
@property (nonatomic, strong) NSMutableArray *flashBtnArr;

/**
 *  打开闪光灯选择按钮数组
 */
@property (nonatomic, strong) NSMutableArray *openFlashBtnArr;

/**
 *  关闭闪光灯选择按钮数组
 */
@property (nonatomic, strong) NSMutableArray *closeFlashBtnArr;

/**
 *  动画的定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  已经进行完动画的按钮个数
 */
@property (nonatomic, assign) NSUInteger animatedCount;

/**
 *  是否正在执行动画
 */
@property (nonatomic, assign) BOOL isAnimateLoading;

/**
 *  当前选择的按钮
 */
@property (nonatomic, strong) UIButton *chooseButton;

/**
 *  选择按钮的回调
 */
@property (nonatomic, strong) DidChooseFlashTypeBlock block;

@end

@implementation CameraFlashView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *titleArr = @[@"自动",@"打开",@"关闭"];
        for (int i=0; i < titleArr.count; i++) {
            
            //创建按钮
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(CGRectGetWidth(frame),(CGRectGetHeight(frame) - 30.0f)/2.0f, 30, 30);
            [btn setTitle:titleArr[i]
                 forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = flashAutoButtonTag + i;
            [btn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHex:@"#f9c452"]
                      forState:UIControlStateSelected];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            [btn addTarget:self
                    action:@selector(commonBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            //将所有的按钮添加到数组里
            [self.flashBtnArr addObject:btn];
        }
        
        self.animatedCount = 1;
    }
    return self;
}

- (void)openChooseViewWithChooseType:(FlashChooseType)type
                     withChooseBlock:(DidChooseFlashTypeBlock)block {
    
    //如果动画正在执行就直接返回
    if (self.isAnimateLoading) {
        return;
    }
    
    //初始化闪光灯选择按钮
    UIButton *button;
    self.chooseButton.selected = FALSE;
    if (type == FlashChooseAuto) {
        button = (UIButton *)self.flashBtnArr[0];
    }else if (type == FlashChooseOff) {
        button = (UIButton *)self.flashBtnArr[2];
    }else if (type == FlashChooseOn) {
        button = (UIButton *)self.flashBtnArr[1];
    }
    button.selected = TRUE;
    self.chooseButton = button;
    self.block = block;
    
    //初始化动画的定时器
    if (!_timer) {
        
        //将闪光灯的按钮拷贝一份
        [self.openFlashBtnArr removeAllObjects];
        [self.openFlashBtnArr addObjectsFromArray:self.flashBtnArr];
        
        //将动画个数置为初始值
        self.animatedCount = 1;
        self.isOpen = TRUE;
        self.isAnimateLoading = TRUE;
        
        //初始化定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001f
                                                  target:self
                                                selector:@selector(_performOpenAnimate)
                                                userInfo:nil
                                                 repeats:YES];
        //禁止页面点击
        self.userInteractionEnabled = NO;
    }
}

- (void)_performOpenAnimate {
    
    //循环遍历按钮
    for (int i=0; i < self.openFlashBtnArr.count; i++) {
        UIButton *btn = (UIButton *)self.openFlashBtnArr[i];
        btn.backgroundColor = self.backgroundColor;
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = btn.frame.origin.x - 1;
        btn.frame = btnFrame;
        if (i==0 && btn.frame.origin.x <= CGRectGetWidth(self.frame) - 80.0f * self.animatedCount) {
            self.animatedCount++;
            [self.openFlashBtnArr removeObjectAtIndex:0];
            break;
        }
    }
    if (self.openFlashBtnArr.count == 0) {
        
        //移除定时器
        [_timer invalidate];
        _timer = nil;
        
        //禁止页面点击
        self.userInteractionEnabled = YES;
        self.isAnimateLoading = FALSE;
    }
}

- (void)closeChooseView {
    
    if (self.isAnimateLoading) {
        return;
    }
    
    if (!_timer) {
        
        //将闪光灯的按钮拷贝一份
        [self.closeFlashBtnArr removeAllObjects];
        [self.closeFlashBtnArr addObjectsFromArray:self.flashBtnArr];
        
        //将动画个数置为初始值
        self.animatedCount = self.closeFlashBtnArr.count - 1;
        self.isOpen = FALSE;
        self.isAnimateLoading = TRUE;
        
        //初始化定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001f
                                                  target:self
                                                selector:@selector(_performCloseAnimate)
                                                userInfo:nil
                                                 repeats:YES];
        //禁止页面点击
        self.userInteractionEnabled = NO;
    }
}

- (void)_performCloseAnimate {
    
    for (NSInteger i = self.closeFlashBtnArr.count - 1; i >= self.animatedCount; i--) {
        
        if (i < 0) {
            break;
        }
        
        UIButton *btn = (UIButton *)self.closeFlashBtnArr[i];
        btn.backgroundColor = self.backgroundColor;
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = btn.frame.origin.x + 1;
        btn.frame = btnFrame;
        if (i==self.closeFlashBtnArr.count - 1
            && btn.frame.origin.x >= CGRectGetWidth(self.frame) - 80.0f * self.animatedCount) {
            self.animatedCount--;
            break;
        }
    }
    
    //判断按钮是否
    UIButton *btn = (UIButton *)[self.closeFlashBtnArr lastObject];
    if (btn.frame.origin.x >= CGRectGetWidth(self.frame) - CGRectGetWidth(btn.frame)) {
        
        //移除定时器
        [_timer invalidate];
        _timer = nil;
        
        //禁止页面点击
        self.userInteractionEnabled = YES;
        self.isAnimateLoading = FALSE;
        
        //将视图从页面上移除
        [self removeFromSuperview];
    }
}

- (NSMutableArray *)flashBtnArr {
    
    if (!_flashBtnArr) {
        _flashBtnArr = [[NSMutableArray alloc] init];
    }
    return _flashBtnArr;
}

- (NSMutableArray *)openFlashBtnArr {
    
    if (!_openFlashBtnArr) {
        _openFlashBtnArr = [[NSMutableArray alloc] init];
    }
    return _openFlashBtnArr;
}

- (NSMutableArray *)closeFlashBtnArr {
    
    if (!_closeFlashBtnArr) {
        _closeFlashBtnArr = [[NSMutableArray alloc] init];
    }
    return _closeFlashBtnArr;
}

- (void)commonBtnClick:(UIButton *)sender {
    
    //回调点击按钮函数
    if (sender.tag == flashAutoButtonTag) {
        self.block(FlashChooseAuto);
    }else if (sender.tag == flashOffButtonTag) {
        self.block(FlashChooseOff);
    }else if (sender.tag == flashOnButtonTag) {
        self.block(FlashChooseOn);
    }
    
    //关闭选择视图
    [self closeChooseView];
}

@end
