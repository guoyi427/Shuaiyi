//
//  CPNavigatorView.m
//  Cinephile
//
//  Created by Albert on 7/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPNavigatorView.h"

const CGFloat K_THUMB_PADDING = 5;

@interface CPNavigatorView()
@property (nonatomic) CGRect originFrame;
@property (nonatomic, strong) CALayer *spotLayer;
@property (nonatomic) CGRect visibleRect;
/**
 *  源View的缩放
 */
@property (nonatomic) CGFloat scale;
/**
 *  缩略图缩放
 */
@property (nonatomic) CGFloat thumbnailScale;
@end

@implementation CPNavigatorView
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
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.spotLayer = [CALayer layer];
    self.spotLayer.borderColor = [UIColor redColor].CGColor;
    self.spotLayer.borderWidth = 1;
    self.spotLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.layer addSublayer:self.spotLayer];
    self.userInteractionEnabled = NO;
}

- (void) setSourceView:(UIView *)sourceView
{
    _sourceView = sourceView;
    self.originFrame = sourceView.frame;
    
    CGFloat scaleW = (self.frame.size.width - K_THUMB_PADDING )/ self.originFrame.size.width;
    CGFloat scaleH = (self.frame.size.height - K_THUMB_PADDING) / self.originFrame.size.height;
    
    self.thumbnailScale = MIN(scaleW, scaleH);
    
    [self setNeedsDisplay];
}


- (void) update
{
   [self setNeedsDisplay];
}

- (void) updateVisibleRect:(CGRect)rect scale:(CGFloat)scale;
{
    //
    CGFloat width = self.originFrame.size.width * self.thumbnailScale;
    CGFloat height = self.originFrame.size.height * self.thumbnailScale;
    
    CGFloat spotWidth = rect.size.width*self.thumbnailScale/scale;
    CGFloat spotHeight = rect.size.height*self.thumbnailScale/scale;
    
    //计算位置，加上居中显示产生的偏移
    CGFloat x = rect.origin.x*self.thumbnailScale/scale + (self.frame.size.width - width) / 2;
    CGFloat y = rect.origin.y*self.thumbnailScale/scale + (self.frame.size.height - height) / 2;
    
    //向外扩大范围，减去框线的，确保全部框住
    x-=6;   // 座位图左侧会有一定间隙
    y-=4;
    spotWidth+=2;
    spotHeight+=2;
    
    //防止越界
    if (x < 0) {
        x = 0;
    }
    if (y < 0) {
        y = 0;
    }
    if (spotWidth + x > self.frame.size.width) {
        spotWidth = self.frame.size.width - x;
    }

    if (spotHeight + y > self.frame.size.height) {
        spotHeight = self.frame.size.height - y;
    }
    
    CGRect spotFrame = CGRectMake(x, y, spotWidth, spotHeight);
   
    //disable CALayer implicit animations
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.spotLayer.frame = spotFrame;
    
    [CATransaction commit];
    
}

- (void) drawRect:(CGRect)rect
{

    CALayer *copyLayer = [CALayer layer];
    
    //get source layer contents
    copyLayer.contents = self.sourceView.layer.contents;
    //calculat frame
    CGFloat width = self.originFrame.size.width * self.thumbnailScale;
    CGFloat height = self.originFrame.size.height * self.thumbnailScale;
    if (width == INFINITY || height == INFINITY || width != width || height != height) {
        NSLog(@"CPNavigatorView width or height Infinity");
        return;
    }
    copyLayer.frame = CGRectMake(0,0, width, height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //center alignment
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation((self.frame.size.width - width) / 2,(self.frame.size.height - height) / 2));
    [copyLayer renderInContext:context];
    
    
}


@end
