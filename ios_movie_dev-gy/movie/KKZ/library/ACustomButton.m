//
//  CustomButton.m
//  TaduFramework
//
//  Created by 艾广华 on 15-4-10.
//  Copyright (c) 2015年 惠每. All rights reserved.
//

#import "ACustomButton.h"


@implementation ACustomButton

-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        _colors=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    if(state==UIControlStateNormal)
    {
        [super setBackgroundColor:color];
    }
    [_colors setValue:color forKey:[self keyForState:state]];
}

//得到按钮不同状态时的背景颜色
-(UIColor *)backgroundColorForState:(UIControlState)state
{
    return [_colors valueForKey:[self keyForState:state]];
}

//设置高亮状态
- (void)setHighlighted:(BOOL)highlighted{
    if (_colors.count > 0) {
        [super setHighlighted:highlighted];
    }else {
        [super setHighlighted:NO];
    }
    NSString *highlightedKey = [self keyForState:UIControlStateHighlighted];
    UIColor *highlightedColor = [_colors valueForKey:highlightedKey];
    if(highlighted && highlightedColor){
        [super setBackgroundColor:highlightedColor];
    }else{
        NSString *normalKey=[self keyForState:UIControlStateNormal];
        [super setBackgroundColor:[_colors valueForKey:normalKey]];
    }
}


-(void)setSelected:(BOOL)selected{
    NSLog(@"设置选择状态 ");
}

-(NSString *)keyForState:(UIControlState)state
{
    return [NSString stringWithFormat:@"state_%lu",state];
}


@end
