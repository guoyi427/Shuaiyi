//
//  UserCenterCell.m
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterCell.h"

@interface UserCenterCell ()
{
    //  UI
    UILabel *_titleLabel;
    UILabel *_rightLabel;
}
@end

@implementation UserCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat Padding = 15;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = appDelegate.kkzTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(Padding);
        }];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = appDelegate.kkzTextColor;
        _rightLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowGray"]];
        [self.contentView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-Padding);
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = appDelegate.kkzLine;
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)updateTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)updateRightTitle:(NSString *)title {
    _rightLabel.text = title;
}

@end
