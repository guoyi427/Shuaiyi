//
//  PlanDateCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "PlanDateCollectionViewCell.h"
#import <DateEngine_KKZ/DateEngine.h>

@implementation PlanDateCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 2;
        self.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
        self.layer.borderWidth = 0.5;
        
        selectBg = [UIView new];
        selectBg.backgroundColor = [UIColor colorWithHex:@"#FCCB2F"];
        selectBg.layer.cornerRadius = 2;
        [self addSubview:selectBg];
        selectBg.hidden = YES;
        [selectBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        dateLabel = [UILabel new];
        

        if (Constants.isIphone5) {
            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        }else
        {
            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        }
//        dateLabel.font = [UIFont systemFontOfSize:16];
        dateLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            if (Constants.isIphone5) {
                make.top.equalTo(@(8));
            }else{
                make.top.equalTo(@(13));
            }
            make.height.equalTo(@(15));
        }];
        detailDateLabel = [UILabel new];
        detailDateLabel.font = [UIFont systemFontOfSize:10];
        detailDateLabel.textColor = [UIColor colorWithHex:@"#999999"];
        detailDateLabel.backgroundColor = [UIColor clearColor];
        detailDateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:detailDateLabel];
        [detailDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(dateLabel.mas_bottom).offset(3);
            make.height.equalTo(@(15));
        }];

    }
    return self;
}

- (void)updateLayout{
//    self.dateString = @"2017-03-06";
    DLog(@"self.dateString == %@", self.dateString);

    NSDate *planDate = [[DateEngine sharedDateEngine] dateFromStringY:self.dateString];
    dateLabel.text = [[DateEngine sharedDateEngine] stringFromDate:planDate withFormat:@"MM.dd"];
    
    if ([self.planNum integerValue]>0) {
        detailDateLabel.text = [[DateEngine sharedDateEngine] relativeDateStringFromDate:planDate];

    } else {
        selectBg.hidden = YES;
        self.layer.borderWidth = 0.5;
        dateLabel.textColor = [UIColor colorWithHex:@"#999999"];
        detailDateLabel.textColor = [UIColor colorWithHex:@"#999999"];
        detailDateLabel.text = @"暂无排期";
    }

}

- (void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        selectBg.hidden = NO;
        self.layer.borderWidth = 0;
        dateLabel.textColor = [UIColor colorWithHex:@"#000000"];
        detailDateLabel.textColor = [UIColor colorWithHex:@"#000000"];

    } else {
        selectBg.hidden = YES;
        self.layer.borderWidth = 0.5;
        dateLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        detailDateLabel.textColor = [UIColor colorWithHex:@"#999999"];
    }
}

@end
