//
//  XingYiPlanDateCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2017/3/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "XingYiPlanDateCollectionViewCell.h"
#import <DateEngine_KKZ/DateEngine.h>

@implementation XingYiPlanDateCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        dateLabel = [UILabel new];
//        
        
//        if (Constants.isIphone5) {
//            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
//        }else
//        {
//            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
//        }
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(@(15));
            make.height.equalTo(@(15));
        }];
        
        selectLine = [UIView new];
        selectLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        [self addSubview:selectLine];
        selectLine.hidden = YES;
        [selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(dateLabel);
            make.top.equalTo(dateLabel.mas_bottom).offset(12);
            make.height.equalTo(@(3));
        }];
        
    
    }
    return self;
}

- (void)updateLayout{
    //    self.dateString = @"2017-03-06";
    DLog(@"self.dateString == %@", self.dateString);
    
    NSDate *planDate = [[DateEngine sharedDateEngine] dateFromStringY:self.dateString];
    NSString *dateString = [[DateEngine sharedDateEngine] shortDateStringFromDate:planDate];
    NSString *dateString1 = [[DateEngine sharedDateEngine] relativeDateStringFromDate:planDate];
    dateLabel.text = dateString1.length ? [NSString stringWithFormat:@"%@%@", dateString1, dateString]:dateString;
    if ([self.planNum integerValue]>0) {
        
    } else {
        selectLine.hidden = YES;
        dateLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    }
    
}

- (void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        selectLine.hidden = NO;
        dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    } else {
        selectLine.hidden = YES;
        dateLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    }
}

@end
