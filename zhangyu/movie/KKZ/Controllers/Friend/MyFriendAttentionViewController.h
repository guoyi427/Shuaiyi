//
//  好友的关注列表页面
//
//  Created by avatar on 14-12-12.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "FollowingListViewController.h"

@interface MyFriendAttentionViewController : CommonViewController <UITableViewDelegate> {

    UIView *headview, *noAttentionAlertView, *sectionHeader;

    UILabel *noAttentionAlertLabel;

    UIView *attentionTableView, *fansTableView, *friendsTableView;
}

@property (nonatomic, strong) NSString *userId;

@end
