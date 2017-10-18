//
//  PromotionCell.m
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PlanPromotionCell.h"
#import "KKZTextUtility.h"

@implementation PlanPromotionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIImageView * huiImageView = [UIImageView new];
        huiImageView.backgroundColor = [UIColor colorWithHex:@"#ffcc00"];
        huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
        huiImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:huiImageView];
        [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(10));
            make.width.equalTo(@(16));
            make.height.equalTo(@(16));
        }];

        detailLabel = [UILabel new];
        detailLabel.textColor = [UIColor colorWithHex:@"#333333"];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.left.equalTo(huiImageView.mas_right).offset(3);
            make.width.equalTo(@(kCommonScreenWidth-60));
            make.height.equalTo(@(16));
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.width.equalTo(@(kCommonScreenWidth-30));
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];
        
    }
    return self;
    
}

- (void)updateLayout{
    detailLabel.text = self.detail.length?self.detail:@"";
}

@end
