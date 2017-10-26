//
//  MicCenterView.m
//  KoMovie
//
//  Created by zhoukai on 12/18/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "MicCenterUIView.h"
#import "MicView.h"

@implementation MicCenterView
{
    MicView *shuoTipView;
    UILabel *durationLabel;
}

- (void)dealloc
{
    DLog(@"MicCenterView dealloc");
    if (shuoTipView) [shuoTipView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        shuoTipView = [[MicView alloc] initWithFrame:CGRectMake(0, (screentContentHeight - screentWith)/2.0 - 50, screentWith, screentWith)];
        
        shuoTipView.userInteractionEnabled = YES;
        [self addSubview:shuoTipView];
        
        durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 160 + 50, screentWith, 14)];
        durationLabel.backgroundColor = [UIColor clearColor];
        durationLabel.textColor = [UIColor whiteColor];
        durationLabel.text = @"";
        durationLabel.font = [UIFont systemFontOfSize:12];
        durationLabel.textAlignment = NSTextAlignmentCenter;
        durationLabel.numberOfLines = 2;
        [shuoTipView addSubview:durationLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
//    self.backgroundColor = [[UIColor blackColor] alpha:.5];
//    self.backgroundColor = [UIColor clearColor];
    

}

-(void)stopAnimation{
    [shuoTipView stopAnimation];
}

-(void)setDurationLabelText:(NSString *)text{
    durationLabel.text = text;
}
-(void)setdurationLabelTextColor:(UIColor *)color{
    durationLabel.textColor = color;
}
-(UILabel *)getDurationLabel{
    return durationLabel;
}


@end
