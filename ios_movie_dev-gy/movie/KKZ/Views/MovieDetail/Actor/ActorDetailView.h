//
//  演员详情页面演员信息的View
//
//  Created by xuyang on 13-4-10.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class ActorIntroPopView;
@class Actor;

@interface ActorDetailView : UIView {

    UILabel *nameLabel;
    UILabel *friendsNumLabel;
    UILabel *ageLabel;
    UIImageView *avatarImageView;
    CGRect detailRect;
}

@property (nonatomic, assign) unsigned int actorId;

@property (nonatomic,strong) Actor *actorD;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) ActorIntroPopView *poplistview;

- (void)updateLayout;
- (void)disMissIntro;

@end
