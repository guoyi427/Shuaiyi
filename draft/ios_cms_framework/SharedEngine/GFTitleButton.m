//
//  GFTitleButton.m
//  GFBS
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFTitleButton.h"

@implementation GFTitleButton

-(void)setHighlighted:(BOOL)highlighted{} 

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHex:@"#ffffff" ] forState:UIControlStateSelected];
    }
    return self;
}

@end
