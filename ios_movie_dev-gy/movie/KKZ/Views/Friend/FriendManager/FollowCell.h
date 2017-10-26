//
//  关注和粉丝列表的Cell
//
//  Created by xuyang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZUser.h"
#import "RoundCornersButton.h"

#define kFollowCellHeight 76

typedef enum {
    MyAttentionCellType = 0,
    MyFansCellType,
    OtherFriendCellType,
} FriendCellType;

@interface FollowCell : UITableViewCell <UIGestureRecognizerDelegate> {

    UIImageView *avatarView;
    UILabel *nameLabel;
    UILabel *attentionLabel;
    UIView *dividerView;
}

@property (nonatomic, assign) FriendCellType cellType;
@property (nonatomic, strong) KKZUser *user;

- (void)updateLayout;

@end
