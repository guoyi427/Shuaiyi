//
//  关注和粉丝列表的Cell
//
//  Created by xuyang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "FollowCell.h"

#import "DataEngine.h"
#import "FriendHomeViewController.h"
#import "ImageEngine.h"
#import "KKZUtility.h"
#import "UIConstants.h"

@implementation FollowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];

        // 头像
        CGRect avatarRect = CGRectMake(15, (kFollowCellHeight - 50) / 2.f, 50, 50);
        avatarView = [[UIImageView alloc] initWithFrame:avatarRect];
        avatarView.contentMode = UIViewContentModeScaleAspectFit;
        avatarView.clipsToBounds = YES;
        avatarView.layer.cornerRadius = 50 / 2.f;
        [self addSubview:avatarView];

        // 昵称
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, (kFollowCellHeight - 18) / 2.f, screentWith - 110, 18)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = HEX(@"#323232");
        [self addSubview:nameLabel];

        // 互相关注
        attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 35 + 7, 100, 16)];
        attentionLabel.backgroundColor = [UIColor clearColor];
        attentionLabel.font = [UIFont systemFontOfSize:13];
        attentionLabel.numberOfLines = 1;
        attentionLabel.hidden = YES;
        attentionLabel.text = @"互相关注";
        attentionLabel.textColor = HEX(@"#999999");
        [self addSubview:attentionLabel];

        UIImageView *arrowY = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 25, (kFollowCellHeight - 18) / 2.f, 10, 18)];
        arrowY.image = [UIImage imageNamed:@"arrowRightGray"];
        [self addSubview:arrowY];

        dividerView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, kFollowCellHeight - 1, screentWith - nameLabel.frame.origin.x, 1)];
        dividerView.backgroundColor = kDividerColor;
        [self addSubview:dividerView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateLayout {
    [avatarView loadImageWithURL:[self.user avatarPathFinal] andSize:ImageSizeTiny imgNameDefault:@"avatarRImg"];

    nameLabel.text = self.user.nicknameFinal;

    if (self.user.status == 1 && self.cellType != OtherFriendCellType) { // 互相关注
        attentionLabel.hidden = NO;

        nameLabel.frame = CGRectMake(75, 20, screentWith - 120, 18);
        attentionLabel.frame = CGRectMake(75, CGRectGetMaxY(nameLabel.frame) + 6, 120, 13);
    } else {
        attentionLabel.hidden = YES;

        nameLabel.frame = CGRectMake(75, (kFollowCellHeight - 18) / 2.f, screentWith - 120, 18);
    }
}

- (void)handleTapped:(UITapGestureRecognizer *)gesture {
    if (![[NetworkUtil me] reachable]) {
        return;
    }

    CommonViewController *controller = [KKZUtility getRootNavagationLastTopController];
    FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
    ctr.userId = self.user.userId;
    [controller pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

@end
