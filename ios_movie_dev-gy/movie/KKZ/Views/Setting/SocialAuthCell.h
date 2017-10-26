//
//  第三方授权管理的Cell
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>

@protocol SocialAuthCellDelegate <NSObject>

- (void)socialSwitchAuth:(ShareType)shareType onAuth:(BOOL)on;

@end

@interface SocialAuthCell : UITableViewCell

@property (nonatomic, strong) id<SocialAuthCellDelegate> delegate;

@property (nonatomic, assign) BOOL isAuthOn;
@property (nonatomic, assign) ShareType platformType;
@property (nonatomic, strong) NSString *platformName;
@property (nonatomic, strong) UIImage *platformImage;

- (void)updateLayout;

@end
