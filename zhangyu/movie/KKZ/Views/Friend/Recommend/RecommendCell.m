//
//  RecommendCell.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "RecommendCell.h"
#import "UIImageView+WebCache.h"
#import "UIConstants.h"
#import "UIColor+Hex.h"
#import "KKZUtility.h"

@interface RecommendCell () {
    //白色背景
    UIView *whiteBgView;

    //用户头像
    UIImageView *avatarView;

    //用户姓名
    UILabel *nameLabel;

    //用户距离
    UILabel *distanceLabel;

    //用户介绍
    UILabel *attentionLabel;

    //关注按钮
    UIButton *attentionButton;

    //分割线
    UIView *seperateLine;
}
@end

@implementation RecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //白色背景
        whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(whiteBgOriginX, 0, kAppScreenWidth - whiteBgOriginX * 2, whiteBgHeight)];
        whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBgView];

        //头像
        CGRect avatarRect = CGRectMake(avatarOriginX, avatarOriginY, avatarWidth, avatarWidth);
        avatarView = [[UIImageView alloc] initWithFrame:avatarRect];
        avatarView.backgroundColor = [UIColor clearColor];
        avatarView.clipsToBounds = YES;
        avatarView.layer.cornerRadius = avatarWidth / 2.0f;
        [whiteBgView addSubview:avatarView];

        //关注按钮
        attentionButton = [UIButton buttonWithType:0];
        attentionButton.frame = CGRectMake(CGRectGetWidth(whiteBgView.frame) - attentionBtnWidth - attentionBtnRight, attentionBtnOriginY, attentionBtnWidth, attentionBtnHeight);
        [attentionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [attentionButton addTarget:self
                            action:@selector(attention:)
                  forControlEvents:UIControlEventTouchUpInside];
        attentionButton.layer.cornerRadius = 3.0f;
        attentionButton.layer.borderWidth = 1.0f;
        [whiteBgView addSubview:attentionButton];

        //用户姓名
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        nameLabel.textColor = appDelegate.kkzTextColor;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.lineBreakMode = NSLineBreakByClipping;
        [whiteBgView addSubview:nameLabel];

        //用户距离
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        distanceLabel.textColor = [UIColor colorWithHex:@"#999999"];
        [distanceLabel setTextAlignment:NSTextAlignmentLeft];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.lineBreakMode = NSLineBreakByCharWrapping;
        distanceLabel.hidden = YES;
        [whiteBgView addSubview:distanceLabel];

        //用户介绍
        attentionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        attentionLabel.backgroundColor = [UIColor clearColor];
        attentionLabel.font = [UIFont systemFontOfSize:12];
        attentionLabel.numberOfLines = 1;
        attentionLabel.textColor = [UIColor colorWithHex:@"#999999"];
        [whiteBgView addSubview:attentionLabel];
    }
    return self;
}

/**
 *  关注按钮
 *
 *  @param sender
 */
- (void)attention:(UIButton *)sender {

    //活动用户
    if ([self.model.modelType isEqualToString:modelTypeActivityUser] || [self.model.modelType isEqualToString:modelTypeNearByUser]) {
        if ([self.cellDelegate respondsToSelector:@selector(clickAttentionButton:)]) {
            NSNumber *numberIndex = [NSNumber numberWithInteger:self.cellIndex];
            NSDictionary *dic = @{cellUidKey : self.model.uid, cellIndexKey : numberIndex};
            [self.cellDelegate clickAttentionButton:dic];
        }
    } else if ([self.model.modelType isEqualToString:modelTypePhoneUser]) {

        //当前cell的状态
        if (self.model.status == PlatFormUserNotExist) {
            if ([self.cellDelegate respondsToSelector:@selector(clickInventButton:)]) {
                NSNumber *numberIndex = [NSNumber numberWithInteger:self.cellIndex];
                NSDictionary *dic = @{cellPhoneNumKey : self.model.phone, cellIndexKey : numberIndex};
                [self.cellDelegate clickInventButton:dic];
            }
        } else if (self.model.status == PlatFormUserExist) {
            if ([self.cellDelegate respondsToSelector:@selector(clickAttentionButton:)]) {
                NSNumber *numberIndex = [NSNumber numberWithInteger:self.cellIndex];
                NSDictionary *dic = @{cellUidKey : self.model.uid, cellIndexKey : numberIndex};
                [self.cellDelegate clickAttentionButton:dic];
            }
        }
    }
}

/**
 *  更新子视图
 */
- (void)layoutSubviews {
    seperateLine.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)updateLayout {

    //用户头像
    [avatarView sd_setImageWithURL:[NSURL URLWithString:self.model.avatarUrl]
                  placeholderImage:[UIImage imageNamed:@"avatarRImg"]];

    //用户名尺寸
    nameLabel.frame = self.layout.nameLabelRect;

    //用户名字体
    nameLabel.font = self.layout.nameLabelFont;

    //用户姓名
    nameLabel.text = self.model.nickname;

    //关注标签
    attentionLabel.frame = CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame) + attentionLblTop, CGRectGetWidth(whiteBgView.frame) - attentionBtnWidth - CGRectGetMinX(nameLabel.frame) - attentionBtnRight - nameLabeRight, attentionLblHeight);

    if ([self.model.modelType isEqualToString:modelTypeNearByUser]) {

        //用户距离
        distanceLabel.hidden = NO;
        distanceLabel.font = self.layout.distanceLabelFont;
        distanceLabel.text = self.model.estimateDistance;
        distanceLabel.frame = self.layout.distanceRect;
    }

    //用户介绍
    if (self.model.userDetail) {
        attentionLabel.text = self.model.userDetail;
    } else {
        attentionLabel.text = @"这家伙很懒,什么都没有写";
    }

    if ([self.model.modelType isEqualToString:modelTypeActivityUser] || [self.model.modelType isEqualToString:modelTypeNearByUser]) {

        //判断是不是好友
        if (self.model.isFriend) {

            //已关注状态
            [self setAttentionedState];

        } else {

            //关注状态
            [self setAttentionState];
        }
    } else if ([self.model.modelType isEqualToString:modelTypePhoneUser]) {

        //关注状态
        if (self.model.status == PlatFormUserNotExist) {

            //邀请状态
            [self setInventState];

        } else if (self.model.status == PlatFormUserExist) {

            //关注状态
            [self setAttentionState];

        } else if (self.model.status == PlatFormUserFriend) {

            //已关注状态
            [self setAttentionedState];

        } else if (self.model.status == PlatFormInvitedUserFriend) {

            //已邀请状态
            [self setInventedState];
        }
    }
}

/**
 *  设置邀请状态
 */
- (void)setInventState {

    //改变标题和图片
    [attentionButton setTitle:@"邀请"
                     forState:UIControlStateNormal];
    [attentionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [attentionButton setImage:nil
                     forState:UIControlStateNormal];
    attentionButton.enabled = YES;

    //改变文字颜色和边框颜色
    UIColor *titleColor = [UIColor colorWithHex:@"#008cff"];
    [attentionButton setTitleColor:titleColor
                          forState:UIControlStateNormal];
    attentionButton.layer.borderColor = titleColor.CGColor;
}

/**
 *  设置关注状态
 */
- (void)setAttentionState {

    //改变标题和图片
    [attentionButton setTitle:@"关注"
                     forState:UIControlStateNormal];
    [attentionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [attentionButton setImage:[UIImage imageNamed:@"newFriend_add"]
                     forState:UIControlStateNormal];
    attentionButton.enabled = YES;

    //改变文字颜色和边框颜色
    UIColor *titleColor = [UIColor colorWithHex:@"#ff6900"];
    [attentionButton setTitleColor:titleColor
                          forState:UIControlStateNormal];
    attentionButton.layer.borderColor = titleColor.CGColor;
}

/**
 *  设置已关注状态
 */
- (void)setAttentionedState {

    //改变标题和图片
    [attentionButton setTitle:@"已关注"
                     forState:UIControlStateNormal];
    [attentionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [attentionButton setImage:nil
                     forState:UIControlStateNormal];
    attentionButton.enabled = NO;

    //改变文字颜色和边框颜色
    UIColor *titleColor = [UIColor colorWithHex:@"#999999"];
    [attentionButton setTitleColor:titleColor
                          forState:UIControlStateNormal];
    attentionButton.layer.borderColor = [UIColor clearColor].CGColor;
}

/**
 *  设置已邀请状态
 */
- (void)setInventedState {

    //改变标题和图片
    [attentionButton setTitle:@"已邀请"
                     forState:UIControlStateNormal];
    [attentionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [attentionButton setImage:nil
                     forState:UIControlStateNormal];
    attentionButton.enabled = NO;

    //改变文字颜色和边框颜色
    UIColor *titleColor = [UIColor colorWithHex:@"#999999"];
    [attentionButton setTitleColor:titleColor
                          forState:UIControlStateNormal];
    attentionButton.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
