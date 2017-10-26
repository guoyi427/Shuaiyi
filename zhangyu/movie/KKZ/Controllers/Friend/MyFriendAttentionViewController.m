//
//  好友的关注列表页面
//
//  Created by avatar on 14-11-13.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved
//

#import "DataEngine.h"
#import "FollowingListViewController.h"
#import "MyFriendAttentionViewController.h"

@implementation MyFriendAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"TA的关注";

    noAttentionAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 70)];
    noAttentionAlertView.backgroundColor = [UIColor whiteColor];
    noAttentionAlertView = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, screentWith - 50 * 2, 40)];
    noAttentionAlertLabel.font = [UIFont systemFontOfSize:14.0];
    noAttentionAlertLabel.textColor = appDelegate.kkzTextColor;
    noAttentionAlertLabel.text = @"亲，您还没有下过单哦~\n快去挑选一部喜欢的影片吧！";
    noAttentionAlertLabel.backgroundColor = [UIColor clearColor];
    noAttentionAlertLabel.textAlignment = NSTextAlignmentCenter;
    noAttentionAlertLabel.numberOfLines = 2;
    [noAttentionAlertView addSubview:noAttentionAlertLabel];
    attentionTableView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, self.view.frame.size.height)];

    [self.view addSubview:attentionTableView];
    FollowingListViewController *followVc = [[FollowingListViewController alloc] initWithShowTopBar:NO];
    followVc.isFromFriend = YES;
    [self addChildViewController:followVc];
    [self.view addSubview:followVc.view];
    followVc.userId = self.userId;
    followVc.isFriend = NO;
    followVc.isMyList = [[DataEngine sharedDataEngine].userId isEqualToString:[NSString stringWithFormat:@"%@", self.userId]];
    [attentionTableView addSubview:followVc.view];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
