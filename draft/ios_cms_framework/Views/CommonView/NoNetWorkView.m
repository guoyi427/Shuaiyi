//
//  NoNetWorkView.m
//  CIASMovie
//
//  Created by avatar on 2017/7/19.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "NoNetWorkView.h"


@interface NoNetWorkView ()
{
    UIImageView *tipImageView;
    UILabel     *tipLabel;
    UIButton    *refreshBtn;
    
}
@property (nonatomic, copy) void (^myBlock)();

@end

@implementation NoNetWorkView


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    self.backgroundColor = [UIColor whiteColor];
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"mistake"];
    NSString *noOrderAlertStr = @"网络连接";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    
    tipImageView = [[UIImageView alloc] init];
    [self addSubview:tipImageView];
    tipImageView.image = noOrderAlertImage;
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.283*kCommonScreenWidth);
        make.top.equalTo(self).offset(0.277*kCommonScreenHeight);
        make.right.equalTo(self).offset(-0.283*kCommonScreenWidth);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    tipLabel.text = noOrderAlertStr;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.283*kCommonScreenWidth);
        make.top.equalTo(tipImageView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-0.283*kCommonScreenWidth);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [refreshBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.height.equalTo(@50);
    }];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) refreshBtnClick:(UIButton *)sender {
    if (self.myBlock) {
        self.myBlock();
    }
}


/**
 *  刷新回调
 *
 *  @param block 回调block
 */
- (void) setRefreshCallback:(void(^)())block
{
    [self removeFromSuperview];
    self.myBlock = block;
}


@end
