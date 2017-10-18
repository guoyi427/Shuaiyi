//
//  CIASAlertVIew.m
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CIASAlertVIew.h"

@interface CIASAlertVIew ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnCancle;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, copy) void (^callbackBlock)(BOOL confirm);

@end

@implementation CIASAlertVIew

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIView *container = [UIView new];
    [self addSubview:container];
    container.layer.cornerRadius = 3.5;
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleL = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHex:@"#999999"] textAlignment:NSTextAlignmentCenter];
    titleL.numberOfLines = 0;
    [container addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container);
        make.top.equalTo(@27);
        make.left.equalTo(container.mas_left).offset(24);
        make.right.equalTo(container.mas_right).offset(-24);
    }];
    self.titleLabel = titleL;
    
    UILabel *titleM = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentCenter];
    titleM.numberOfLines = 0;
    [container addSubview:titleM];
    [titleM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(10);
        make.centerX.equalTo(container);
        make.left.equalTo(container.mas_left).offset(16);
        make.right.equalTo(container.mas_right).offset(-16);
    }];
    self.subtitleLabel = titleM;
    
    UIView *line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [container addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(titleM.mas_bottom).offset(27);
        make.height.equalTo(@(0.5));
    }];
    
    UIButton *cancle = [UIButton buttonWithType:0];
    cancle.layer.cornerRadius = 2.5;
    cancle.layer.masksToBounds = YES;
    cancle.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancle setBackgroundColor:[UIColor colorWithHex:@"#ffffff"]];
    [cancle setTitleColor:[UIColor colorWithHex:@"#0090f7"] forState:UIControlStateNormal];
    [container addSubview:cancle];
    self.btnCancle = cancle;
    
    UIButton *confirm = [UIButton buttonWithType:0];
    confirm.layer.cornerRadius = 2.5;
    confirm.layer.masksToBounds = YES;
    confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirm setBackgroundColor:[UIColor colorWithHex:@"#ffffff"]];
    [confirm setTitleColor:[UIColor colorWithHex:@"#0090f7"] forState:UIControlStateNormal];
    [container addSubview:confirm];
    self.btnConfirm = confirm;
    
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
        make.height.equalTo(@49);
        make.top.equalTo(line1View.mas_bottom).offset(0.5);
    }];
    
    UIView *line2View = [[UIView alloc] init];
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [container addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancle.mas_right).offset(-0.5);
        make.top.equalTo(line1View.mas_bottom).offset(0);
        make.width.equalTo(@0.5);
        make.height.equalTo(@49);
    }];
    
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(cancle);
        make.left.equalTo(line2View.mas_right).offset(0.5);
        make.bottom.equalTo(cancle);
        make.width.equalTo(cancle);
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.bottom.equalTo(confirm.mas_bottom).offset(0);
        make.left.equalTo(@(0.14*kCommonScreenWidth));
        make.right.equalTo(self.mas_right).offset(-(0.14*kCommonScreenWidth));
    }];
    
    [cancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [confirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void) show:(NSString *)title
      message:(NSString *)message
        image:(UIImage *)image
  cancleTitle:(NSString *)cancleTitle
   otherTitle:(NSString *)otherTitle
     callback:(void(^)(BOOL confirm))a_block
{
    self.titleLabel.text = title;
    self.subtitleLabel.text = message;
    [self.btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    [self.btnConfirm setTitle:otherTitle forState:UIControlStateNormal];
    
    self.callbackBlock = a_block;
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    
    [win addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(win);
    }];
}



- (void)dismiss
{
    [self removeFromSuperview];
}

- (void) cancleClick
{
    if (self.callbackBlock) {
        self.callbackBlock(NO);
    }
    
    [self dismiss];
}


- (void) confirmClick
{
    if (self.callbackBlock) {
        self.callbackBlock(YES);
    }
    
    [self dismiss];
}

@end
