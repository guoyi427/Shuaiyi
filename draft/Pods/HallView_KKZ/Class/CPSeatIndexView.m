//
//  CPSeatIndexView.m
//  Cinephile
//
//  Created by Albert on 7/22/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPSeatIndexView.h"

//索引字体大小
#define kIndicatorSize 8

@interface CPSeatIndexView()

@property (nonatomic, strong) NSArray *indexs;
@property (nonatomic) CGFloat positionY;
@property (nonatomic, strong) CALayer *contentLayer;
@end

@implementation CPSeatIndexView
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
    CALayer *contentLayer = [CALayer layer];
    contentLayer.cornerRadius = self.frame.size.width/2;
    contentLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    contentLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.contentLayer = contentLayer;
}

- (void) updateData
{
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:self.count];
    NSInteger seatRow = 1;
    for (NSInteger i = 1; i < self.count + 1; i++) {
        if ([self.aisles containsObject:@(i)]) {
            [rows addObject:@"∙"];
            //过道
            continue;
        }
        
        [rows addObject:[NSString stringWithFormat:@"%ld",seatRow]];
        seatRow++;
        
    }
    self.indexs = [rows copy];
    
    [self setNeedsDisplay];
    
    
}

- (void) updatePosition:(CGPoint)position scale:(CGFloat)scale;
{
    self.zoomLevel = scale;
    self.positionY = -position.y;
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    if (self.indexs.count == 0) {
        return;
    }
    
    self.contentLayer.sublayers = nil;
    
    CGFloat space = self.rowHeight/2;  //顶部空间
    CGFloat bottom = 0; //最底部
    
    for (NSInteger i = 0; i < self.indexs.count; i++) {
        
        CGRect frame = CGRectMake(0, self.rowHeight * i * self.zoomLevel + space * self.zoomLevel, self.frame.size.width, self.rowHeight * self.zoomLevel);
        
        CATextLayer *label = [[CATextLayer alloc] init];
        [label setFontSize:kIndicatorSize];
        label.contentsScale = [UIScreen mainScreen].scale;
        [label setFrame:frame];
        [label setString:self.indexs[i]];
        [label setAlignmentMode:kCAAlignmentCenter];
        [label setForegroundColor:[[UIColor whiteColor] CGColor]];
        [self.contentLayer addSublayer:label];
        
        bottom = frame.origin.y + frame.size.height;
    }
    
    self.contentLayer.frame = CGRectMake(0, 0, self.frame.size.width,bottom);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0,self.positionY));
    [self.contentLayer renderInContext:context];
    
    
}


@end

