//
//  ECardViewController.m
//  KoMovie
//
//  Created by avatar on 14-11-13.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "AlertViewY.h"
#import "CheckCoupon.h"
#import "ECardViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EcardHelpInfoViewController.h"
#import "MJRefresh.h"
#import "NSDictionaryExtra.h"
#import "PayTask.h"
#import "TaskQueue.h"
#import "UIColorExtra.h"
#import "UIConstants.h"
#import "NoDataViewY.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation ECardViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    self.kkzTitleLabel.text = @"优惠券/兑换券";

    // 帮助 button

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 50, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"kotahelp"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(helpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];

    sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, 60)];

    sectionHeader.backgroundColor = [UIColor r:245 g:245 b:245];

    [self.view addSubview:sectionHeader];

    RoundCornersButton *bgInput =
            [[RoundCornersButton alloc] initWithFrame:CGRectMake(10, 12.5, screentWith - 105, 35)];
    bgInput.cornerNum = kDimensCornerNum;
    bgInput.fillColor = [UIColor whiteColor];
    bgInput.backgroundColor = [UIColor whiteColor];
    [sectionHeader addSubview:bgInput];

    eCardNo = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, screentWith - 120, 35)];
    eCardNo.font = [UIFont systemFontOfSize:14];
    eCardNo.placeholder = @"请输入优惠券/兑换券";
    [eCardNo setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    eCardNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    eCardNo.backgroundColor = [UIColor clearColor];
    eCardNo.textColor = appDelegate.kkzTextColor;
    eCardNo.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    eCardNo.clearButtonMode = UITextFieldViewModeAlways;
    eCardNo.delegate = self;
    [bgInput addSubview:eCardNo];

    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    //    [topView setBarStyle:UIBarStyleDefault];
    [topView setBackgroundColor:[UIColor whiteColor]];

    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:self
                                                                              action:nil];

    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];

    btnToolBar.frame = CGRectMake(2, 5, 50, 30);

    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];

    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];

    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];

    [topView setItems:buttonsArray];

    [eCardNo setInputAccessoryView:topView];

    RoundCornersButton *eCardBtn =
            [[RoundCornersButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 12.5, 70, 35)];
    eCardBtn.cornerNum = kDimensCornerNum;
    eCardBtn.rimWidth = 0;
    eCardBtn.backgroundColor = [UIColor r:0 g:140 b:255];
    eCardBtn.titleName = @"绑定";
    eCardBtn.titleColor = [UIColor whiteColor];
    eCardBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
    [eCardBtn addTarget:self action:@selector(tieupeCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeader addSubview:eCardBtn];

    redCouponTableView = [[UITableView alloc]
            initWithFrame:CGRectMake(0, 44 + self.contentPositionY + 60, screentWith, screentContentHeight - 44 - 60)];
    redCouponTableView.backgroundColor = [UIColor whiteColor];
    redCouponTableView.delegate = self;
    redCouponTableView.dataSource = self;
    redCouponTableView.scrollEnabled = YES;
    redCouponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:redCouponTableView];

    nodataView = [[NoDataViewY alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];

    nodataView.alertLabelText = @"未获取到优惠券/兑换券列表";

    noAlertView =
            [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];

    noAlertView.alertLabelText = @"正在查询优惠券/兑换券信息，请稍候...";

    showMoreBtn = [[ShowMoreButton alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
    showMoreBtn.delegate = self;
    showMoreBtn.state = ShowMoreButtonStateNormal;

    currentPage = 1;
    tableLocked = NO;

    redCouponList = [[NSMutableArray alloc] initWithCapacity:0];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    tap.delegate = self;

    [self.view addGestureRecognizer:tap];

    //集成刷新控件

    [self setupRefresh];
}

- (void)dismissKeyBoard {
    [eCardNo resignFirstResponder];
}

- (void)helpBtnClicked:(UIButton *)btn {
    EcardHelpInfoViewController *ecardHelp = [[EcardHelpInfoViewController alloc] init];
    [self pushViewController:ecardHelp animation:CommonSwitchAnimationNone];
}

/**

 *  集成刷新控件

 */

- (void)setupRefresh

{
    [redCouponTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [redCouponTableView headerBeginRefreshing];
    redCouponTableView.headerPullToRefreshText = @"下拉可以刷新";
    redCouponTableView.headerReleaseToRefreshText = @"松开马上刷新";
    redCouponTableView.headerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing {
    [self doCouponListTask];
    [nodataView removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {

    CGPoint point = [gesture locationInView:self.view];

    [self touchAtPoint:point];
}

- (void)touchAtPoint:(CGPoint)point {

    if (!CGRectContainsPoint(eCardNo.frame, point)) {
        [eCardNo resignFirstResponder];
        return;
    }
}

- (void)tieupeCardBtnClicked:(UIButton *)btn {
    DLog(@"绑定按钮被选中");

    [eCardNo resignFirstResponder];

    if ([eCardNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {

        [appDelegate showAlertViewForTitle:@"" message:@"请输入优惠券/兑换券" cancelButton:@"好的"];
        return;
    }

    if (!eCardNo.text || [eCardNo.text length] == 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请输入优惠券/兑换券" cancelButton:@"好的"];
        return;
    }

    BOOL isRepeatAction = NO;

    for (CheckCoupon *c in redCouponList) {
        if ([c.couponId isEqualToString:eCardNo.text]) {
            isRepeatAction = YES;
            break;
        }
    }

    if (isRepeatAction) {
        [appDelegate showAlertViewForTitle:@"" message:@"请不要重复绑定优惠券/兑换券" cancelButton:@"OK"];
        return;
    }

//    PayTask *task = [[PayTask alloc]
//            initBindingCouponforUser:[eCardNo.text
//                                             stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
//                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
//                                [self eCardChecked:userInfo status:succeeded];
//                            }];
//    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
//        [appDelegate showIndicatorWithTitle:@"请稍候..." animated:YES fullScreen:NO overKeyboard:NO andAutoHide:NO];
//    }
}

#pragma mark - Override from CommonViewController
- (void)cancelViewController {
    [self popToViewControllerAnimated:YES];
    [appDelegate setSelectedPage:2 tabBar:YES];
}

- (void)doCouponListTask {

    [nodataView removeFromSuperview];
    if (redCouponList.count == 0) {
        [redCouponTableView addSubview:noAlertView];
        [noAlertView startAnimation];
    }

    currentPage = 1;

    PayTask *task = [[PayTask alloc] initCouponListforOrder:@""
                                                   finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                       [self couponListFinished:userInfo status:succeeded];
                                                   }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        //        [appDelegate showIndicatorWithTitle:@"获取优惠券"
        //                                   animated:YES
        //                                 fullScreen:NO
        //                               overKeyboard:NO
        //                                andAutoHide:NO];
        tableLocked = YES;
    }
}

- (void)handleTouchToShowMore:(id)sender {
}

#pragma mark handle notifications
- (void)couponListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    tableLocked = NO;
    [appDelegate hideIndicator];
    showMoreBtn.state = ShowMoreButtonStateNormal;

    [noAlertView removeFromSuperview];

    [redCouponTableView headerEndRefreshing];

    if (succeeded) {

        redCouponList = [userInfo objectForKey:@"myCouponList"];
        redCouponTableView.tableFooterView = nil;

        if (redCouponList.count == 0) {
            [redCouponTableView addSubview:nodataView];
        } else {
            [nodataView removeFromSuperview];
        }

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
    [redCouponTableView reloadData];
    [self resetRefreshHeader];
}

- (void)eCardChecked:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    if (succeeded) {

        [nodataView removeFromSuperview];

        NSArray *coupons = (NSArray *) [userInfo kkz_objForKey:@"myCouponList"];
        if (coupons.count > 0) {
            CheckCoupon *bindCoupon = [coupons objectAtIndex:0];
            //                [redCouponList addObject:bindCoupon];
            [redCouponList insertObject:bindCoupon atIndex:0];

            [appDelegate showAlertViewForTitle:@"" message:@"绑定成功！" cancelButton:@"OK"];
            [redCouponTableView reloadData];
        }
    } else {

        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                redCouponTableView.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {
                if (redCouponTableView.contentOffset.y <= 0) {

                    [redCouponTableView setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // CGRect frame = tableImageBack.frame;
    CGRect frame = CGRectMake(10, 52, 300, 2 * 90 + 10);
    frame.origin.y = 52 - scrollView.contentOffset.y;
    // tableImageBack.frame = frame;
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//
//    if (scrollView.contentOffset.y <= - 65.0f && scrollView == redCouponTableView) {
//        //[self doRedCouponTask];
//        [self doCouponListTask];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - Table View Data Source
- (void)configureEcardCell:(EcardCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (redCouponList.count <= 0) {
        return;
    }
    CheckCoupon *coupon = [redCouponList objectAtIndex:indexPath.row];
    cell.isShow = NO;
    cell.couponId = coupon.couponId;
    cell.maskName = coupon.maskName;
    cell.expiredDate = coupon.expireDate;
    cell.remainCount = coupon.remainCount;
    [cell updateLayoutYN];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"EcardCellIdentifier";

    EcardCell *cell = (EcardCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EcardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureEcardCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return redCouponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return 80;
    CheckCoupon *coupon = [redCouponList objectAtIndex:indexPath.row];

    CGSize s = [coupon.maskName sizeWithFont:[UIFont systemFontOfSize:14]
                           constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];

    //    CGSize s = [coupon.maskName sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith
    //    - 15 * 2, MAXFLOAT)lineBreakMode:NSLineBreakByTruncatingTail];

    return s.height + 35 + 15 + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 45)];
    headHolder.backgroundColor = [UIColor whiteColor];

    UILabel *accountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screentWith, 15.0)];
    accountTitleLabel.font = [UIFont systemFontOfSize:14];
    accountTitleLabel.textColor = [UIColor blackColor];
    accountTitleLabel.backgroundColor = [UIColor clearColor];
    accountTitleLabel.textAlignment = NSTextAlignmentLeft;
    accountTitleLabel.text = @"已绑定的优惠券/兑换券";
    [headHolder addSubview:accountTitleLabel];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screentWith, 1)];
    line.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
    [headHolder addSubview:line];

    return headHolder;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textField:(UITextField *)textField
        shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string {

    if (textField == eCardNo) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}
@end
