//
//  IncomingDateCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "IncomingDateCollectionViewCell.h"
#import <DateEngine_KKZ/DateEngine.h>


@implementation IncomingDateCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectBg = [UIView new];
        selectBg.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        selectBg.layer.cornerRadius = 4;
        [self addSubview:selectBg];
        selectBg.hidden = YES;
        [selectBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 15, 5, 11));
        }];
        
        dateLabel = [UILabel new];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor colorWithHex:@"#666666"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        dateLabel.text = @"";
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(2);
//            make.width.equalTo();
//            make.top.equalTo(self).offset(10);
//            make.height.equalTo(@(15));
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 15, 5, 11));

        }];
        
    }
    return self;
}

- (void)updateLayout{
    dateLabel.text = self.dateString;
   
}

- (void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        selectBg.hidden = NO;
        dateLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];

    } else {
        selectBg.hidden = YES;
        dateLabel.textColor = [UIColor colorWithHex:@"#666666"];

    }
}

@end
