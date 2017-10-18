//
//  CPRefreshAnimationView.m
//  Cinephile
//
//  Created by Albert on 07/11/2016.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPRefreshAnimationView.h"
#import "UIColor+Hex.h"
#define KBAR_WIDTH 2  //bar宽度


#define K_BAR_HEIGHT_MIN 2      //最低高度

#define K_BAR_DURATION 0.3  //时长

#define K_BAR_SPACE 4

@interface CPRefreshAnimationView ()
@property (nonatomic, strong) CALayer *bar1;
@property (nonatomic, strong) CALayer *bar2;
@property (nonatomic, strong) CALayer *bar3;
@end

@implementation CPRefreshAnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    
    
    self.bar1 = [self bar:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor].CGColor frame:CGRectMake(0, 0, KBAR_WIDTH, K_BAR_HEIGHT_MIN)];
    [self.layer addSublayer:self.bar1];
    
    self.bar2 = [self bar:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor].CGColor frame:CGRectMake(KBAR_WIDTH+K_BAR_SPACE, 0, KBAR_WIDTH, K_BAR_HEIGHT_MIN)];
    [self.layer addSublayer:self.bar2];
    
    self.bar3 = [self bar:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor].CGColor frame:CGRectMake((KBAR_WIDTH+K_BAR_SPACE)*2, 0, KBAR_WIDTH, K_BAR_HEIGHT_MIN)];
    [self.layer addSublayer:self.bar3];
    
}

- (void) startAnimation
{
    [self addAnimation];
}


/**
 添加动画
 */
- (void) addAnimation
{
    NSString *stretchAnimationKey = @"stretchAnimationKey";
    
    CABasicAnimation *animation1 = [self stretchAnimationFromHeight:@K_BAR_HEIGHT_MIN toHeight:@K_BAR_HEIGHT_MAX];
    [self.bar1 addAnimation:animation1 forKey:stretchAnimationKey];
    
    CABasicAnimation *animation2 = [self stretchAnimationFromHeight:@K_BAR_HEIGHT_MIN toHeight:@K_BAR_HEIGHT_MAX];
    [animation2 setBeginTime:CACurrentMediaTime()+0.2];
    [self.bar2 addAnimation:animation2 forKey:stretchAnimationKey];
    
    CABasicAnimation *animation3 = [self stretchAnimationFromHeight:@K_BAR_HEIGHT_MAX toHeight:@K_BAR_HEIGHT_MIN];
    [self.bar3 addAnimation:animation3 forKey:stretchAnimationKey];
}


- (CALayer *) bar:(CGColorRef)color frame:(CGRect)frame
{
    CALayer *layer = [CALayer new];
    layer.backgroundColor = color;
    layer.frame = frame;
    
    return layer;
}

- (CABasicAnimation *) stretchAnimationFromHeight:(NSNumber *)heightF toHeight:(NSNumber *)heightT
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    animation.fromValue = heightF;
    animation.toValue = heightT;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.duration = K_BAR_DURATION;
    
    return animation;
}


@end
