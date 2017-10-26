//
//  SegmentTab.m
//  KoMovie
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SegmentTab.h"

@interface SegmentTab()
@property(nonatomic,strong)UIView *bottomLine;
@end
@implementation SegmentTab

-(id)initWithFrame:(CGRect)frame text:(NSString*)text {
    self=[super initWithFrame:frame];
    if(self){
        [self setTitle:text forState:UIControlStateNormal];
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * 0.5, self.frame.size.height - 1.5, 60, 1.5)];
        [self addSubview:self.bottomLine];
        
    }
    return self;
}

-(void)setTextFont:(UIFont*)font forUIControlState:(UIControlState)state{
    self.titleLabel.font = font;
}
-(void)setTextColor:(UIColor*)color forUIControlState:(UIControlState)state andBottomLineHidden:(BOOL)isHidden{
    [self setTitleColor:color forState:state];
    self.bottomLine.hidden = isHidden;
    [self.bottomLine setBackgroundColor:color];
}

@end
