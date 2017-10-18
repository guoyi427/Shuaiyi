//
//  MovieCommentCell.m
//  CIASMovie
//
//  Created by avatar on 2017/1/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovieCommentCell.h"
#import "KKZTextUtility.h"

@implementation MovieCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *imageLabel = [UILabel new];
        imageLabel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].withColor];
        [self addSubview:imageLabel];
        
        pointLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:pointLabel];
        
        judgementLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:10] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:judgementLabel];
        
        judgeContentLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#666666"] textAlignment:NSTextAlignmentLeft];
        judgeContentLabel.numberOfLines = 0;
        [self addSubview:judgeContentLabel];
        
        timeImageView = [UIImageView new];
        timeImageView.backgroundColor = [UIColor clearColor];
        timeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:timeImageView];
        
        timeLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:10] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:timeLabel];
        
        judgeComeFromLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:11] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentRight];
        [self addSubview:judgeComeFromLabel];
        
        [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(5, 36));
        }];
        
        [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageLabel.mas_right).offset(5);
            make.top.equalTo(@(17));
            make.width.equalTo(@(80));
            make.height.equalTo(@(16));
        }];
        [judgementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageLabel.mas_right).offset(5);
            make.width.equalTo(@(25));
            make.top.equalTo(pointLabel.mas_bottom).offset(5);
            make.height.equalTo(@(13));
        }];
        [judgeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.right.equalTo(self.mas_right).offset(-14);
            make.left.equalTo(@(75));
            make.height.equalTo(@(20));
        }];
        
        [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(75));
            make.top.equalTo(judgeContentLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeImageView.mas_right).offset(5);
            make.top.equalTo(judgeContentLabel.mas_bottom).offset(15);
            make.width.equalTo(@(103));
            make.height.equalTo(@(13));
        }];
        
        [judgeComeFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_right).offset(15);
            make.top.equalTo(judgeContentLabel.mas_bottom).offset(16);
            make.right.equalTo(self.mas_right).offset(-21);
            make.width.equalTo(@((kCommonScreenWidth-90)/2));
            make.height.equalTo(@(13));
        }];
        
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(@(75));
            make.top.equalTo(timeLabel.mas_bottom).offset(15);
            make.right.equalTo(self);
            make.width.equalTo(@(kCommonScreenWidth - 75));
            make.height.equalTo(@(1));
        }];
    }
    return self;
}



- (void)updateLayout{
    
    pointLabel.text = self.pointLabelStr;
    judgementLabel.text = self.judgementLabelStr;
    judgeContentLabel.text = self.judgeContentLabelStr;
    timeImageView.image = [UIImage imageNamed:@"clock_icon"];
    timeLabel.text = self.timeLabelStr;
    judgeComeFromLabel.text = self.judgeComeFromLabelStr;
    CGSize strSize = [KKZTextUtility measureText:self.judgeContentLabelStr size:CGSizeMake(kCommonScreenWidth - 90, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
    [judgeContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-14);
        make.left.equalTo(@(75));
        make.height.equalTo(@(strSize.height));
    }];
    
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.0f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}

@end
