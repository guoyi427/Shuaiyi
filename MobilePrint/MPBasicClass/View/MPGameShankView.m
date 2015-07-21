//
//  MPGameShankView.m
//  MobilePrint
//
//  Created by guoyi on 15/7/13.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPGameShankView.h"

//  View
#import "Masonry.h"

#define Left_Edge 20
#define Shank_Width 30
#define ShankBackGround_Width 80

@interface MPGameShankView ()
{
    //  Data
    
    //  UI
    /// 游戏柄 按钮
    UIView *_gameShankView;
}

@end

@implementation MPGameShankView

- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        [self _prepareUIWithSuperView:superView];
    }
    return self;
}

+ (instancetype)gameShankWithSuperView:(UIView *)superView {
    MPGameShankView *gameShank = [[MPGameShankView alloc] initWithSuperView:superView];
    return gameShank;
}

#pragma mark - Prepare

- (void)_prepareUIWithSuperView:(UIView *)superView {
    [superView addSubview:self];
    
    __weak UIView *weakSuperView = superView;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSuperView).offset(-Left_Edge);
        make.bottom.equalTo(weakSuperView).offset(-Left_Edge - 50);
        make.size.mas_equalTo(CGSizeMake(ShankBackGround_Width, ShankBackGround_Width));
    }];
    
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = ShankBackGround_Width / 2.0f;
    
    [self _prepareGameShankView];
}

/// 准备游戏柄视图
- (void)_prepareGameShankView {
    _gameShankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Shank_Width, Shank_Width)];
    _gameShankView.center = CGPointMake(ShankBackGround_Width / 2.0f, ShankBackGround_Width / 2.0f);
    _gameShankView.backgroundColor = [UIColor yellowColor];
    _gameShankView.layer.cornerRadius = Shank_Width / 2.0f;
    [self addSubview:_gameShankView];
}

#pragma mark - Private Methods

/// 手柄归位
- (void)_gameShankHomeing {
    [UIView animateWithDuration:0.1 animations:^{
        _gameShankView.center = CGPointMake(ShankBackGround_Width / 2.0f, ShankBackGround_Width / 2.0f);
    }];
    if (_delegate &&
        [_delegate respondsToSelector:@selector(gameShankView:touchMove:)]) {
        [_delegate gameShankView:self touchMove:CGPointZero];
    }
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    //  判断是否 移动的游戏柄
    if ([touch.view isEqual:_gameShankView]) {
        
        /// 横纵比
        CGPoint acrossPoint = CGPointZero;
        //  判断 是否在可滑动 区域内
        CGPoint touchPoint = [touch locationInView:self];
        touchPoint = CGPointMake(touchPoint.x - ShankBackGround_Width / 2.0f, touchPoint.y - ShankBackGround_Width / 2.0f);
        /// 触摸半径
        CGFloat touchRadius = sqrtf(touchPoint.x * touchPoint.x + touchPoint.y * touchPoint.y);
        if (touchRadius < (ShankBackGround_Width / 2.0f)) {
            _gameShankView.center = [touch locationInView:self];
            acrossPoint = CGPointMake(touchPoint.x/(ShankBackGround_Width / 2.0f), touchPoint.y/(ShankBackGround_Width / 2.0f));
        } else {
            //  超出范围 这个比较麻烦了 计算出此点与圆心连线在 周长上的交点  为手柄的中心
            CGFloat x = touchPoint.x * (ShankBackGround_Width / 2.0f) / touchRadius;
            CGFloat y = touchPoint.y * (ShankBackGround_Width / 2.0f) / touchRadius;
            _gameShankView.center = CGPointMake(x + ShankBackGround_Width / 2.0f, y + ShankBackGround_Width / 2.0f);
            acrossPoint = CGPointMake(x / (ShankBackGround_Width / 2.0f), y / (ShankBackGround_Width / 2.0f));
        }
        if (_delegate &&
            [_delegate respondsToSelector:@selector(gameShankView:touchMove:)]) {
            [_delegate gameShankView:self touchMove:acrossPoint];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _gameShankHomeing];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _gameShankHomeing];
}

@end
