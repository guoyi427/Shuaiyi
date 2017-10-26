//
//  添加通讯录好友的Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RoundCornersButton.h"

@protocol AddContractCellDelegate <NSObject>

- (void)didSelectedAddFriend:(NSInteger)index;

- (void)didSelectedInvate:(NSInteger)index;

@end

@interface AddContractCell : UITableViewCell {

    UIImageView *avatarView;
    UILabel *nameLable;
    RoundCornersButton *actionButton;
}

@property (nonatomic, weak) id<AddContractCellDelegate> delegate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *avatarUrl;

- (void)updateLayout;

- (void)setInvitedState;

@end