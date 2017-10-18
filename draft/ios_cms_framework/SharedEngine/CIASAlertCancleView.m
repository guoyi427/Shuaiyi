//
//  CIASAlertCancleView.m
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CIASAlertCancleView.h"

@interface CIASAlertCancleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnCancle;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, copy) void (^callbackBlock)(BOOL confirm);

@end

@implementation CIASAlertCancleView

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
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    UIView *container = [UIView new];
    [self addSubview:container];
    container.layer.cornerRadius = 3.5;
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleL = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHex:@"#999999"] textAlignment:NSTextAlignmentCenter];
    titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    titleL.numberOfLines = 0;
    [container addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container);
        make.top.equalTo(@27);
        make.left.equalTo(container.mas_left).offset(24);
        make.right.equalTo(container.mas_right).offset(-24);
        make.height.mas_lessThanOrEqualTo(@((kCommonScreenHeight*2/3-109)/2));
    }];
    self.titleLabel = titleL;
    
    UILabel *titleM = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentCenter];
    titleM.numberOfLines = 0;
    titleM.lineBreakMode = NSLineBreakByTruncatingTail;
    [container addSubview:titleM];
    [titleM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(10);
        make.centerX.equalTo(container);
        make.left.equalTo(container.mas_left).offset(16);
        make.right.equalTo(container.mas_right).offset(-16);
        make.height.mas_lessThanOrEqualTo(@((kCommonScreenHeight*2/3-109)/2));
    }];
    self.subtitleLabel = titleM;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [container addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(0);
        make.right.equalTo(container.mas_right).offset(0);
        make.height.equalTo(@44);
        make.top.equalTo(lineView.mas_bottom).offset(0.5);
    }];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.bottom.equalTo(cancle.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset((0.14*kCommonScreenWidth));
        make.right.equalTo(self.mas_right).offset(-(0.14*kCommonScreenWidth));
        make.height.mas_lessThanOrEqualTo(@(kCommonScreenHeight*2/3));
    }];
    
    [cancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void) show:(NSString *)title
      message:(NSString *)message
  cancleTitle:(NSString *)cancleTitle
     callback:(void(^)(BOOL confirm))a_block
{
    self.titleLabel.text = title;
    self.subtitleLabel.text = message;
    [self.btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
    self.callbackBlock = a_block;
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    
    [win addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(win);
    }];
}

- (void)     show:(NSString *)title
 attributeMessage:(NSMutableAttributedString *)message
      cancleTitle:(NSString *)cancleTitle
         callback:(void(^)(BOOL confirm))a_block {
    
    self.titleLabel.text = title;
    self.subtitleLabel.attributedText = message;
    [self.btnCancle setTitle:cancleTitle forState:UIControlStateNormal];
    
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
