//
//  SwitchPlanView.m
//  KoMovie
//
//  Created by Albert on 31/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SwitchPlanView.h"

#import "UIConstants.h"

@interface SwitchPlanView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void (^dismissBlock)();
@property (nonatomic, strong) UIView *overlayView;
@end

@implementation SwitchPlanView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) didMoveToSuperview
{
    [super didMoveToSuperview];
    
}

- (void) setup
{
    
    UIView *overlayView = [UIView new];
    overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:overlayView];
    self.overlayView = overlayView;
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@110);
        make.top.equalTo(self.mas_top);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleCLick)];
    [self.overlayView addGestureRecognizer:tap];
    
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHex:@"0xf2f2f2"];
    [self addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(overlayView.mas_bottom);
    }];
    
    
    self.titleLabel =[UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(10);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"switch_plan_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleCLick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right);
        make.width.height.equalTo(@44);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.mas_bottom);
    }];


    
}

/**
 *  渲染view
 *
 *  @param yourView 要渲染的view
 *
 *  @return 渲染好的图
 */
- (UIImage*)captureView:(UIView *)yourView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [yourView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void) showInView:(UIView *)view
{
    self.alpha = 0;
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [UIView animateWithDuration:K_POP_ANIMATION_DURATION animations:^{
        self.alpha = 1;
    }];
    
}

- (void) dismiss
{
    [UIView animateWithDuration:K_YN_ANIMATION_DURATION_DISMISS animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) setDataSource:(id<UITableViewDataSource>)dataSource
{
    self.tableView.dataSource = dataSource;
}

- (void) setDelegate:(id<UITableViewDelegate>)delegate
{
    self.tableView.delegate = delegate;
}

- (void) updateData
{
    
    [self.tableView reloadData];
}

- (void) setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void) cancleCLick
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)dismissCallback:(void (^)())a_block
{
    self.dismissBlock = [a_block copy];
}

-(void)dealloc{
    DLog(@"CPSwitchContainerView dealloc");
}

@end
