//
//  OpenCardNoticeController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/27.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OpenCardNoticeController.h"
#import "KKZTextUtility.h"


@interface OpenCardNoticeController ()<UIScrollViewDelegate>
{
    UIScrollView *holderView;
    UIView *bgView;
    
    UILabel        * titleLabel;
    UIButton       * backButton;
    
    UILabel        * contentLabel;
}
@property (nonatomic, strong) UIView  *titleViewOfBar;



@end

@implementation OpenCardNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    
    self.hideNavigationBar = false;
    self.title = self.titleShowStr;
//    [self setNavBarUI];
    
    // Do any additional setup after loading the view.
    holderView = [[UIScrollView alloc] init];
    bgView = [[UIView alloc] init];
    holderView.delegate = self;
    holderView.backgroundColor = [UIColor clearColor];
    [holderView setShowsVerticalScrollIndicator:YES];
    [holderView setShowsHorizontalScrollIndicator:NO];
    //        [holderView setContentSize:CGSizeMake(kCommonScreenWidth, kCommonScreenHeight*1.2)];
    
    [holderView addSubview:bgView];
    [self.view addSubview:holderView];
    
    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (self.isFromCoupon) {
        //MARK: 1
        NSString *titleLabel1Str = @"1、优惠券有几种类型？有什么不同";
        CGSize titleLabel1StrSize = [KKZTextUtility measureText:titleLabel1Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label1Str = @"可以使用的优惠券包含三种：代金券、通兑券、预售券。";
        CGSize label1StrSize = [KKZTextUtility measureText:label1Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label2Str = @"代金券：在消费付款时可以抵扣相应面值的金额。";
        CGSize label2StrSize = [KKZTextUtility measureText:label2Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label3Str = @"通兑券和预售券：没有固定的面值。一张券可以兑换一张电影票。";
        CGSize label3StrSize = [KKZTextUtility measureText:label3Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        //MARK: 2
        NSString *titleLabel2Str = @"2、如何获取优惠券？";
        CGSize titleLabel2StrSize = [KKZTextUtility measureText:titleLabel2Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label21Str = @"在各种活动中领取代金券；";
        CGSize label21StrSize = [KKZTextUtility measureText:label21Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label22Str = @"在此APP中不定期售卖电影通兑券和预售券；";
        CGSize label22StrSize = [KKZTextUtility measureText:label22Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label23Str = @"您可以在“个人中心”下的优惠券列表中查看或者添加。";
        CGSize label23StrSize = [KKZTextUtility measureText:label23Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        //MARK: 3
        NSString *titleLabel3Str = @"3、如何使用优惠券？";
        CGSize titleLabel3StrSize = [KKZTextUtility measureText:titleLabel3Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label31Str = @"在手机客户端、PC网页或者移动网页中；";
        CGSize label31StrSize = [KKZTextUtility measureText:label31Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label32Str = @"进入影院排片列表；";
        CGSize label32StrSize = [KKZTextUtility measureText:label32Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        
        NSString *label33Str = @"“选择座位一进入优惠券列表一选择或添加优惠券一提交订单一支付差价或直接确认”即可使用相关优惠券";
        CGSize label33StrSize = [KKZTextUtility measureText:label33Str size:CGSizeMake(kCommonScreenWidth-30, 500) font:[UIFont systemFontOfSize:13]];
        CGFloat heightOfBg = titleLabel1StrSize.height + titleLabel2StrSize.height +titleLabel3StrSize.height+label1StrSize.height+label2StrSize.height+label3StrSize.height+label21StrSize.height+label22StrSize.height+label23StrSize.height+label31StrSize.height+label32StrSize.height+label33StrSize.height + 20+(10+30)*2+10;
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(holderView);
            make.width.mas_equalTo(holderView);
            make.height.mas_equalTo(@(heightOfBg+100));
        }];
        
        //MARK: --1
        UILabel *titleLabel1 = [[UILabel alloc] init];
        [bgView addSubview:titleLabel1];
        titleLabel1.textColor = [UIColor colorWithHex:@"#333333"];
        titleLabel1.font = [UIFont systemFontOfSize:13];
        titleLabel1.numberOfLines = 0;
        titleLabel1.text = titleLabel1Str;
        [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(bgView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(titleLabel1StrSize.width+5, titleLabel1StrSize.height+5));
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        [bgView addSubview:label1];
        label1.textColor = [UIColor colorWithHex:@"#999999"];
        label1.font = [UIFont systemFontOfSize:13];
        label1.numberOfLines = 0;
        label1.text = label1Str;
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(titleLabel1.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(label1StrSize.width+5, label1StrSize.height+5));
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        [bgView addSubview:label2];
        label2.textColor = [UIColor colorWithHex:@"#999999"];
        label2.font = [UIFont systemFontOfSize:13];
        label2.numberOfLines = 0;
        label2.text = label2Str;
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label1.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label2StrSize.width+5, label2StrSize.height+5));
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        [bgView addSubview:label3];
        label3.textColor = [UIColor colorWithHex:@"#999999"];
        label3.font = [UIFont systemFontOfSize:13];
        label3.numberOfLines = 0;
        label3.text = label3Str;
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label2.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label3StrSize.width+5, label3StrSize.height+5));
        }];
        
        //MARK: --2
        
        UILabel *titleLabel2 = [[UILabel alloc] init];
        [bgView addSubview:titleLabel2];
        titleLabel2.textColor = [UIColor colorWithHex:@"#333333"];
        titleLabel2.font = [UIFont systemFontOfSize:13];
        titleLabel2.numberOfLines = 0;
        titleLabel2.text = titleLabel2Str;
        [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label3.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(titleLabel2StrSize.width+5, titleLabel2StrSize.height+5));
        }];
        
        UILabel *label21 = [[UILabel alloc] init];
        [bgView addSubview:label21];
        label21.textColor = [UIColor colorWithHex:@"#999999"];
        label21.font = [UIFont systemFontOfSize:13];
        label21.numberOfLines = 0;
        label21.text = label21Str;
        [label21 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(titleLabel2.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(label21StrSize.width+5, label21StrSize.height+5));
        }];
        
        UILabel *label22 = [[UILabel alloc] init];
        [bgView addSubview:label22];
        label22.textColor = [UIColor colorWithHex:@"#999999"];
        label22.font = [UIFont systemFontOfSize:13];
        label22.numberOfLines = 0;
        label22.text = label22Str;
        [label22 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label21.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label22StrSize.width+5, label22StrSize.height+5));
        }];
        
        UILabel *label23 = [[UILabel alloc] init];
        [bgView addSubview:label23];
        label23.textColor = [UIColor colorWithHex:@"#999999"];
        label23.font = [UIFont systemFontOfSize:13];
        label23.numberOfLines = 0;
        label23.text = label23Str;
        [label23 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label22.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label23StrSize.width+5, label23StrSize.height+5));
        }];
        
        //MARK: --3
        UILabel *titleLabel3 = [[UILabel alloc] init];
        [bgView addSubview:titleLabel3];
        titleLabel3.textColor = [UIColor colorWithHex:@"#333333"];
        titleLabel3.font = [UIFont systemFontOfSize:13];
        titleLabel3.numberOfLines = 0;
        titleLabel3.text = titleLabel3Str;
        [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label23.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(titleLabel3StrSize.width+5, titleLabel3StrSize.height+5));
        }];
        
        UILabel *label31 = [[UILabel alloc] init];
        [bgView addSubview:label31];
        label31.textColor = [UIColor colorWithHex:@"#999999"];
        label31.font = [UIFont systemFontOfSize:13];
        label31.numberOfLines = 0;
        label31.text = label31Str;
        [label31 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(titleLabel3.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(label31StrSize.width+5, label31StrSize.height+5));
        }];
        
        UILabel *label32 = [[UILabel alloc] init];
        [bgView addSubview:label32];
        label32.textColor = [UIColor colorWithHex:@"#999999"];
        label32.font = [UIFont systemFontOfSize:13];
        label32.numberOfLines = 0;
        label32.text = label32Str;
        [label32 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label31.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label32StrSize.width+5, label32StrSize.height+5));
        }];
        
        UILabel *label33 = [[UILabel alloc] init];
        [bgView addSubview:label33];
        label33.textColor = [UIColor colorWithHex:@"#999999"];
        label33.font = [UIFont systemFontOfSize:13];
        label33.numberOfLines = 0;
        label33.text = label33Str;
        [label33 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(15);
            make.top.equalTo(label32.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(label33StrSize.width+5, label33StrSize.height+5));
        }];
        
        
    } else {
        //添加显示文字的空间
        CGSize contentLabelSize = [KKZTextUtility measureText:self.contentShowStr size:CGSizeMake(kCommonScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(holderView);
            make.width.mas_equalTo(holderView);
            make.height.mas_equalTo(@(contentLabelSize.height));
        }];
        
        contentLabel = [[UILabel alloc] init];
        [bgView addSubview:contentLabel];
        contentLabel.text = self.contentShowStr;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 0;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(15);
            make.left.equalTo(bgView.mas_left).offset(15);
            make.right.equalTo(bgView.mas_right).offset(-15);
            make.height.equalTo(@(contentLabelSize.height));
        }];
    }
    
    
    [holderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(80).priorityLow();
        make.bottom.mas_greaterThanOrEqualTo(self.view);
    }];
}


- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    //@"#333333"
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
//    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    barLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarLineColor];
    [bar addSubview:barLine];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13.5, 27.5, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"titlebar_back1"]
                forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [self.view addSubview:self.titleViewOfBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
/**
 *  MARK: 返回按钮->返回上一层
 */
- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}


//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 30, kCommonScreenWidth - 60*2, titleStrSize.height)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}

#pragma mark scrollview delegate
// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DLog(@"scrollViewDidEndDecelerating");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
