//
//  添加通讯录好友的Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AddContractCell.h"

#import "ImageEngine.h"
#import "PlatformUser.h"
#import "UIColor+Hex.h"

@implementation AddContractCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (75 - 50) / 2.f, 50, 50)];
        avatarView.contentMode = UIViewContentModeScaleAspectFit;
        avatarView.clipsToBounds = YES;
        avatarView.image = [UIImage imageNamed:@"default_avatar_5"];
        avatarView.layer.cornerRadius = 50 / 2.f;
        [self addSubview:avatarView];

        nameLable = [[UILabel alloc] initWithFrame:CGRectMake(30 + 55, (75 - 20) / 2, screentWith - 120, 20)];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:14];
        nameLable.textColor = appDelegate.kkzTextColor;
        [self addSubview:nameLable];

        CGRect frame = CGRectMake(screentWith - 70, (75 - 30) / 2.f, 55, 30);
        actionButton = [[RoundCornersButton alloc] initWithFrame:frame];
        actionButton.titleFont = [UIFont systemFontOfSize:14];
        actionButton.cornerNum = 4;
        actionButton.userInteractionEnabled = YES;

        actionButton.titleColor = appDelegate.kkzBlue;
        actionButton.backgroundColor = [UIColor whiteColor];
        actionButton.titleName = @"邀请";
        actionButton.rimWidth = 1;
        actionButton.rimColor = appDelegate.kkzBlue;
        [self addSubview:actionButton];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapButton:)];
        [actionButton addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateLayout {
    [avatarView loadImageWithURL:self.avatarUrl andSize:ImageSizeSmall imgNameDefault:@"avatarRImg"];

    nameLable.text = self.name;

    if ([self.state intValue] == PlatUserNotExist) {
        actionButton.titleColor = appDelegate.kkzBlue;
        actionButton.backgroundColor = [UIColor whiteColor];
        actionButton.titleName = @"邀请";
        actionButton.rimWidth = 1;
        actionButton.rimColor = appDelegate.kkzBlue;
    } else if ([self.state intValue] == PlatInvitedUserFriend) {
        actionButton.titleColor = HEX(@"#999999");
        actionButton.backgroundColor = [UIColor clearColor];
        actionButton.titleName = @"已邀请";
        actionButton.rimWidth = 0;
    } else if ([self.state intValue] == PlatUserExist) {
        actionButton.titleColor = [UIColor whiteColor];
        actionButton.backgroundColor = appDelegate.kkzBlue;
        actionButton.titleName = @"关注";
        actionButton.rimWidth = 0;
    } else if ([self.state intValue] == PlatUserFriend) {
        actionButton.titleColor = HEX(@"#999999");
        actionButton.backgroundColor = [UIColor clearColor];
        actionButton.titleName = @"已关注";
        actionButton.rimWidth = 0;
    }
}

- (void)setInvitedState {
    self.state = [NSNumber numberWithInt:PlatUserFriend];
    [self updateLayout];
}

- (void)handleTapButton:(UITapGestureRecognizer *)gesture {
    if (self.delegate) {
        if ([self.state intValue] == PlatUserNotExist && [self.delegate respondsToSelector:@selector(didSelectedInvate:)]) { // 邀请

            [self.delegate didSelectedInvate:self.index];
        } else if ([self.state intValue] == PlatUserExist && [self.delegate respondsToSelector:@selector(didSelectedAddFriend:)]) { // 关注

            [self.delegate didSelectedAddFriend:self.index];
        }
    }
}

@end
