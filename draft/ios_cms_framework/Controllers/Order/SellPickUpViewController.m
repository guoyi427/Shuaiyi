//
//  SellPickUpViewController.m
//  cias
//
//  Created by cias on 2017/4/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "SellPickUpViewController.h"
#import "SellPickUpCell.h"

@interface SellPickUpViewController () <refreashCellHeight>

@end

@implementation SellPickUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    [self setNavBarUI];
    [self initData];
    [self initView];
}

- (void) initData {
    for (int i = 0; i < self.productList.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[self.productList objectAtIndex:i] forKey:@"data"];
        [dic setValue:@"0" forKey:@"fold"];
        [self.productStatusList addObject:dic];
    }
}

- (void)initView {
    [self.myTableView registerNib:[UINib nibWithNibName:@"SellPickUpCell" bundle:nil] forCellReuseIdentifier:@"SellPickUpCell"];
    [self.myTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productStatusList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellPickUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellPickUpCell"];
    NSDictionary *dic = [self.productStatusList objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithDic:dic withIndex:indexPath];
    
    CGRect rect = cell.frame;
    rect.size.height = cell.cellHeight;
    cell.frame = rect;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (void)refreashCellHeight:(CGFloat)cellHeght withIndex:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
    
}

- (NSMutableArray *)productStatusList {
    if (!_productStatusList) {
        _productStatusList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _productStatusList;
}

- (NSMutableArray *)productList {
    if (!_productList) {
        _productList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _productList;
}

- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    //[UIColor colorWithHex:@"#333333"]
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(13.5, 27.5, 28, 28);
    [leftBarBtn setImage:[UIImage imageNamed:@"titlebar_back1"]
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(leftItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarBtn];
    

    
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 24, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTitleView];
    //    self.navigationItem.titleView = customTitleView;
    navTitleLabel = [UILabel new];
    navTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = @"卖品取货凭证";
    navTitleLabel.font = [UIFont systemFontOfSize:18];
    [customTitleView addSubview:navTitleLabel];
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(15));
    }];
    
}

- (void)leftItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
