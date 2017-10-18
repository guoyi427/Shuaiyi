//
//  OpenWaitingViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/16.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OpenWaitingViewController.h"
#import "KKZTextUtility.h"
#import "UIImage+GIF.h"
#import "OrderRequest.h"
#import "OpenSuccessViewController.h"

@interface OpenWaitingViewController ()
{
    UILabel        *titleLabel;
    UIImageView    *gifImageView;
    UILabel        *gifLabel;
}

@property (nonatomic, strong) UIView  *titleViewOfBar;




@end

@implementation OpenWaitingViewController

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
    [timer1 invalidate];
    timer1 = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
    [timer1 invalidate];
    timer1 = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    [self setNavBarUI];
    
    gifImageView = [[UIImageView alloc] init];
    [self.view addSubview:gifImageView];
    NSString *path =  nil;
    if ([UIScreen mainScreen].bounds.size.height > 667) {
        path =  [[NSBundle mainBundle] pathForResource:@"cardout_loading@3x" ofType:@"gif"];
    } else {
        path =  [[NSBundle mainBundle] pathForResource:@"cardout_loading@2x" ofType:@"gif"];
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *gifImage = [UIImage sd_animatedGIFWithData:data];
    [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((kCommonScreenWidth - gifImage.size.width*Constants.screenWidthRate)/2);
        make.top.equalTo(self.view.mas_top).offset(69+180*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(gifImage.size.width*Constants.screenWidthRate, gifImage.size.height*Constants.screenHeightRate));
    }];
    gifImageView.image = gifImage;
    
    gifLabel = [[UILabel alloc] init];
    [self.view addSubview:gifLabel];
    gifLabel.textColor = [UIColor colorWithHex:@"#333333"];
    gifLabel.text = @"正在写入会员信息...";
    gifLabel.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    gifLabel.textAlignment = NSTextAlignmentCenter;
    [gifLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(gifImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(15*Constants.screenHeightRate));
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshBtnInCardClick) userInfo:nil repeats:YES];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInCardCountDown) userInfo:nil repeats:YES];
    countDownNum = 60;
    
    
    
}



- (void)refreshBtnInCardClick{
    if (countDownNum <= 0) {
        [timer invalidate];
        timer = nil;
        [timer1 invalidate];
        timer1 = nil;
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请求超时，请重新开卡" cancleTitle:@"知道了" callback:^(BOOL confirm) {
            if (!confirm) {
                if (self.navigationController.viewControllers.count >= 5) {
                    UIViewController *targetController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-5];
                    [self.navigationController popToViewController:targetController animated:YES];
                }
            }
        }];
        return;
    }
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestCardOrderDetailFromListParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        weakSelf.orderDetail = (OrderDetailOfMovie *)data;
        
        if ([weakSelf.orderDetail.orderMain.status integerValue] == 6) {
            [timer invalidate];
            timer = nil;
            OpenSuccessViewController *ctr = [[OpenSuccessViewController alloc] init];
            ctr.myOrderDetail = weakSelf.orderDetail;
            [self.navigationController pushViewController:ctr animated:YES];
            
        }else if ([weakSelf.orderDetail.orderMain.status integerValue] == 4 || [weakSelf.orderDetail.orderMain.status integerValue] == 2){
            
        }else if ([weakSelf.orderDetail.orderMain.status integerValue] == 5 || [weakSelf.orderDetail.orderMain.status integerValue] == 8){
        
        }else{
            
        }
        
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
}
- (void)timerInCardCountDown{
    if (countDownNum<=0) {
        [timer1 invalidate];
        timer1 = nil;
        return;
    }
    countDownNum--;
}




- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
    [self.view addSubview:self.titleViewOfBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", @"正在为您开卡"];
    
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
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
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
