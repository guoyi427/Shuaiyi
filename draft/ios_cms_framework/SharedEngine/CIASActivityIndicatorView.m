//
//  CIASActivityIndicatorView.m
//  CIASMovie
//
//  Created by avatar on 2017/1/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CIASActivityIndicatorView.h"

@interface CIASActivityIndicatorView ()

@property (strong, nonatomic) UIColor *defaultColor;

@property (readwrite, nonatomic) BOOL isAnimating;

- (void)setupDefaults;

- (void)addRectangles;

- (void)removeRectangles;

- (void)adjustFrame;

- (UIView *)createRectangleWithSize:(CGSize)size color:(UIColor *)color positionX:(CGFloat)x;

- (CAKeyframeAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay;
@end

@implementation CIASActivityIndicatorView

#pragma mark - Initializations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupDefaults
{
    self.numbers = 3;
    self.internalSpacing = 3.0f;
    self.size = CGSizeMake(2, 7);
    self.duration = 0.6f;
    self.delay = 0.15;
    self.defaultColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
}

- (UIView *)createRectangleWithSize:(CGSize)size color:(UIColor *)color positionX:(CGFloat)x
{
    UIView *rectangle = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.size.width, self.size.height)];
    rectangle.backgroundColor = color;
    return rectangle;
}

- (CAKeyframeAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.repeatCount = INFINITY;
    anim.beginTime = CACurrentMediaTime() + delay;
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f],[NSNumber numberWithFloat:2.5f],[NSNumber numberWithFloat:1.0f], nil];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return anim;
}

- (void)addRectangles
{
    for (NSInteger i = 0; i < self.numbers; i++) {
        UIColor *color = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(activityIndicatorView:rectangleBackgroundColorAtIndex:)]) {
            color = [self.delegate activityIndicatorView:self rectangleBackgroundColorAtIndex:i];
        }
        UIView *rectangle = [self createRectangleWithSize:self.size color:(color == nil)?self.defaultColor : color positionX:i * (self.size.width + self.internalSpacing)];
        [rectangle.layer addAnimation:[self createAnimationWithDuration:self.duration delay:self.delay*i] forKey:@"rectangle"];
        [self addSubview:rectangle];
    }
}

- (void)removeRectangles
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)adjustFrame
{
    CGRect frame = self.frame;
    frame.size.width = (self.numbers * (self.size.width + self.internalSpacing)) - self.internalSpacing;
    frame.size.height = self.size.height;
    self.frame = frame;
}

#pragma mark - Public Methods

- (void)startAnimating
{
    if (!self.isAnimating) {
        [self addRectangles];
        self.hidden = NO;
        self.isAnimating = YES;
    }
}

- (void)stopAnimating
{
    if (self.isAnimating) {
        [self removeRectangles];
        self.hidden = YES;
        self.isAnimating = NO;
    }
}

- (void)setNumbers:(NSUInteger)numbers
{
    _numbers = numbers;
    [self adjustFrame];
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self adjustFrame];
}

- (void)setInternalSpacing:(CGFloat)internalSpacing
{
    _internalSpacing = internalSpacing;
    [self adjustFrame];
}

@end
