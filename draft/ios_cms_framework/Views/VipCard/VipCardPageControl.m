//
//  VipCardPageControl.m
//  CIASMovie
//
//  Created by avatar on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardPageControl.h"

#define K_TAG_BASE 2500

@interface VipCardPageItemView : UIControl
@property (nonatomic, strong) CALayer *doitLayer;
@end

@implementation VipCardPageItemView

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
    
    self.doitLayer = [CALayer layer];
    self.doitLayer.anchorPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:self.doitLayer];
    self.selected = NO;
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    //center alignment
    self.doitLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected == YES) {
        self.doitLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.doitLayer.cornerRadius = 4;
        self.doitLayer.borderWidth = 1.5;
        self.doitLayer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.doitLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    CGSize size;
    if (self.selected == YES) {
        size = CGSizeMake(8, 8);
    }else{
        size = CGSizeMake(6, 6);
    }
    self.doitLayer.frame = CGRectMake(self.doitLayer.frame.origin.x, self.doitLayer.frame.origin.y, size.width, size.height);
    self.doitLayer.cornerRadius = size.width/2;
    //    self.doitLayer.masksToBounds = YES;
}

@end

@implementation VipCardPageControl

- (void) setPageNumbers:(NSUInteger)count
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *last;
    for (NSInteger i = 0; i<count; i++) {
        
        VipCardPageItemView *doit = [VipCardPageItemView new];
        if (i == 0) {
            doit.selected = YES;
        }
        [self addSubview:doit];
        
        CGFloat left = i * (4 + 6);
        
        [doit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(left));
            make.centerY.equalTo(self);
            make.height.width.equalTo(@6);
        }];
        
        doit.tag = K_TAG_BASE + i;
        
        last = doit;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(last.mas_right);
    }];
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
    
    VipCardPageItemView *imP = [self viewWithTag:K_TAG_BASE+_currentPage];
    imP.selected = NO;
    
    _currentPage = currentPage;
    //8
    
    VipCardPageItemView *imN = [self viewWithTag:K_TAG_BASE+_currentPage];
    imN.selected = YES;
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
