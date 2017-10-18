//
//  CPPageControl.m
//  Cinephile
//
//  Created by Albert on 8/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPPageControl.h"
#define K_TAG_BASE 1000

@interface CPPageItemView : UIControl
@property (nonatomic, strong) CALayer *doitLayer;
@end

@implementation CPPageItemView

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

@implementation CPPageControl
- (void) setPageNumbers:(NSUInteger)count
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *last;
    for (NSInteger i = 0; i<count; i++) {

        CPPageItemView *doit = [CPPageItemView new];
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
    
    if (last) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(last.mas_right);
        }];
    }
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
    
    CPPageItemView *imP = [self viewWithTag:K_TAG_BASE+_currentPage];
    imP.selected = NO;
    
    _currentPage = currentPage;
    //8
    
    CPPageItemView *imN = [self viewWithTag:K_TAG_BASE+_currentPage];
    imN.selected = YES;
    

    
}
@end
