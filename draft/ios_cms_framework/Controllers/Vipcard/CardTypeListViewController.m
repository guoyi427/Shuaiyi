//
//  CardTypeListViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardTypeListViewController.h"

#import "CardTypeCell.h"
#import "VipCardRequest.h"
#import "CardTypeDetail.h"
#import "CardTypeList.h"

#import "BindCardViewController.h"
#import "CinemaListViewController.h"
#import "KKZTextUtility.h"
#import "OpenCardDetailController.h"
#import "UserDefault.h"


@interface CardTypeListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int pageNum;
}
@property (nonatomic, strong) UITableView *cardTypeListTableView;
@property (nonatomic, strong) NSMutableArray *cardTypeListCount;
@property (nonatomic, strong) NSMutableArray *cardCinemaListCount;

@property (nonatomic, strong)      UIView *noCardTypeListAlertView;

@end

@implementation CardTypeListViewController


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [[UIScreen mainScreen] setBrightness: 0.8];//0.5是自己设定认为比较合适的亮度值
    if (!Constants.isAuthorized) {
        
    } else {
        //MARK: 进行会员卡开卡类型列表的请求
        pageNum = 1;
        [self requestVipCardTypeListWithPage:pageNum withPageSize:10];
        
    }
    
}

- (void) requestVipCardTypeListWithPage:(int) page withPageSize:(int)pageSize {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d", page] forKey:@"pageNumber"];
    [params setValue:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
    [params setValue:self.cinemaId forKey:@"cinemaId"];

    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardTypeListParams:params success:^(NSDictionary * _Nullable data) {
        if (page==1) {
            [weakSelf endRefreshing];
            if (weakSelf.cardTypeListCount.count > 0) {
                [weakSelf.cardTypeListCount removeAllObjects];
            }
        }else{
            [weakSelf endLoadMore];
        }
        DLog(@"会员卡开卡类型列表：%@", data);
        CardTypeList *detail = (CardTypeList *)data;
        
        [weakSelf.cardTypeListCount addObjectsFromArray:detail.rows];
        if (weakSelf.cardTypeListCount.count > 0) {
            _cardTypeListTableView.mj_footer.state = MJRefreshStateIdle;
            if (page==1) {
                [_cardTypeListTableView setContentOffset:CGPointZero];
            }
            
            if (weakSelf.noCardTypeListAlertView.superview) {
                [weakSelf.noCardTypeListAlertView removeFromSuperview];
            }
        }else{
            //没有更多
            [_cardTypeListTableView.mj_footer endRefreshingWithNoMoreData];
            if (weakSelf.noCardTypeListAlertView.superview) {
            }else{
                [weakSelf.cardTypeListTableView addSubview:weakSelf.noCardTypeListAlertView];
            }
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        [weakSelf.cardTypeListTableView reloadData];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (page == 1) {
            [weakSelf endRefreshing];
        } else {
            [weakSelf endLoadMore];
        }
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}


/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([self.cardTypeListTableView.mj_header isRefreshing]) {
        [self.cardTypeListTableView.mj_header endRefreshing];
    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    
    if ([self.cardTypeListTableView.mj_footer isRefreshing]) {
        [self.cardTypeListTableView.mj_footer endRefreshing];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBarUI];
    //MARK: 添加会员卡tableview
    //
    initFirst = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.cardTypeListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-64) style:UITableViewStylePlain];
    self.cardTypeListTableView.showsVerticalScrollIndicator = NO;
    self.cardTypeListTableView.backgroundColor = [UIColor whiteColor];
    self.cardTypeListTableView.delegate = self;
    self.cardTypeListTableView.dataSource = self;
    self.cardTypeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cardTypeListTableView];
    __weak __typeof(self) weakSelf = self;
    self.cardTypeListTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        //刷新页面
        pageNum = 1;
        [weakSelf requestVipCardTypeListWithPage:pageNum withPageSize:10];
    }];
    self.cardTypeListTableView.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        if ([_cardTypeListTableView.mj_header isRefreshing]) {
            [_cardTypeListTableView.mj_footer endRefreshing];
            return;
        }
        //刷新页面
        pageNum++;
        [weakSelf requestVipCardTypeListWithPage:pageNum withPageSize:10];
    }];
    
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"empty"];
    NSString *noOrderAlertStr = @"还没有任何开卡类型";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    self.noCardTypeListAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.283*kCommonScreenWidth, 0.277*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15*Constants.screenWidthRate)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noCardTypeListAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noCardTypeListAlertView);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noCardTypeListAlertView addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noCardTypeListAlertView);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CardTypeCell";
    CardTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CardTypeDetail *aCardType = [self.cardTypeListCount objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[CardTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.myCardType = aCardType;
    
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardTypeListCount.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
    CGFloat cellHeight = cardBackImage.size.height*Constants.screenHeightRate+5;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //MARK: 跳转填写密码和验证码页面
    //MARK: 请求开卡详情，然后跳转
    CardTypeDetail *aCardType = [self.cardTypeListCount objectAtIndex:indexPath.row];
    [self.cardCinemaListCount addObjectsFromArray:aCardType.cinemas];
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d",aCardType.cardId.intValue] forKey:@"cardProductId"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardTypeDetailParams:params success:^(NSDictionary * _Nullable data) {
        CardTypeDetail *bCardType = (CardTypeDetail *)data;
//        if (_cardCinemaListCount.count > 0) {
//            [_cardCinemaListCount removeAllObjects];
//        }
//        [_cardCinemaListCount addObjectsFromArray:bCardType.cinemas];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

        OpenCardDetailController *openCardVc = [[OpenCardDetailController alloc] init];
        openCardVc.cinemaId = self.cinemaId;
        openCardVc.cinemaName = self.cinemaName;
        openCardVc.cardTypeDetail = bCardType;
        openCardVc.cardCinemaList = bCardType.cinemas;
        [weakSelf.navigationController pushViewController:openCardVc animated:YES];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSMutableArray *)cardTypeListCount {
    if (!_cardTypeListCount) {
        _cardTypeListCount = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cardTypeListCount;
}

- (void)setNavBarUI{
    self.hideNavigationBar = NO;
    self.title = @"选择开卡类型";
    /*
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 64)];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UILabel *narTitleLabel = [UILabel new];
    narTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    narTitleLabel.textAlignment = NSTextAlignmentCenter;
    narTitleLabel.text = @"选择开卡类型";
    narTitleLabel.font = [UIFont systemFontOfSize:18];
    [bar addSubview:narTitleLabel];
    [narTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20));
        make.left.equalTo(@(70));
        make.width.equalTo(@(kCommonScreenWidth-140));
        make.height.equalTo(@(44));
    }];
     */
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
