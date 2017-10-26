//
//  第三方授权管理的Cell
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SocialAuthCell.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"

@interface SocialAuthCell ()

@property (nonatomic, strong) UIView *cellContent;
@property (nonatomic, strong) UIImageView *shareImgView;
@property (nonatomic, strong) UILabel *platformNameLabel;
@property (nonatomic, strong) UILabel *authStatusLabel;
@property (nonatomic, strong) UISwitch *authSwitch;

@end

@implementation SocialAuthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];

        self.cellContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 75)];
        self.cellContent.backgroundColor = [UIColor whiteColor];
        self.cellContent.userInteractionEnabled = YES;
        [self addSubview:self.cellContent];

        self.shareImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
        [self.cellContent addSubview:self.shareImgView];

        self.platformNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 200, 24)];
        self.platformNameLabel.backgroundColor = [UIColor clearColor];
        self.platformNameLabel.textColor = [UIColor blackColor];
        self.platformNameLabel.font = [UIFont systemFontOfSize:kTextSizeTitle];
        [self.cellContent addSubview:self.platformNameLabel];

        self.authStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 100, 21)];
        self.authStatusLabel.backgroundColor = [UIColor clearColor];
        self.authStatusLabel.textColor = [UIColor grayColor];
        self.authStatusLabel.font = [UIFont systemFontOfSize:kTextSizeContent];
        [self.cellContent addSubview:self.authStatusLabel];

        self.authSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.authSwitch.onTintColor = appDelegate.kkzBlue;
        [self.authSwitch sizeToFit];
        self.accessoryView = self.authSwitch;
        [self.authSwitch addTarget:self action:@selector(authSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)authSwitchChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(socialSwitchAuth:onAuth:)]) {
        [self.delegate socialSwitchAuth:self.platformType onAuth:sender.on];
    }
}

- (void)updateLayout {
    self.shareImgView.image = self.platformImage;
    self.platformNameLabel.text = self.platformName;
    self.authSwitch.on = self.isAuthOn;
    if (self.isAuthOn) {
        self.authStatusLabel.text = @"已授权";
        self.authStatusLabel.textColor = HEX(@"#008cff");
    } else {
        self.authStatusLabel.text = @"尚未授权";
        self.authStatusLabel.textColor = HEX(@"#C0C0C0");
    }
}

@end
