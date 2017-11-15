//
//  支付订单 - 使用优惠券/兑换券
//
//  Created by gree2 on 16/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CheckCoupon.h"
#import "CouponCheckViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "PayTask.h"
#import "RedCouponTask.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation CouponCheckViewController

- (id)initWithSelectedCoupons:(NSArray *)coupons andFirstLoad:(NSInteger)isFirstLoad {
    self = [super init];
    if (self) {
        ecardValidList = [[NSMutableArray alloc] init];
        ecardInvalidList = [[NSMutableArray alloc] init];
        selectedEcardList = [[NSMutableArray alloc] init];

        if (coupons.count) {
            [selectedEcardList addObjectsFromArray:coupons];
        }

        self.isFirst = isFirstLoad;
        self.isSelectedIndexArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 4, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    self.kkzTitleLabel.text = @"使用章鱼券/章鱼券";

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)];
    [self.view addSubview:holder];
    holder.backgroundColor = [UIColor r:242 g:242 b:242];
    holder.showsVerticalScrollIndicator = NO;

    //兑换券界面UI
    textRe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
    textRe.backgroundColor = [UIColor clearColor];
    [holder addSubview:textRe];

    textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(15, 13, screentWith - 85 - 15 * 2, 35)];
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [holder addSubview:textFieldBg];

    UIView *tableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, screentWith, screentContentHeight - 65 - 44)];
    tableBackView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:tableBackView];

    couponTextField = [[UITextField alloc] initWithFrame:CGRectMake(4.5, 2, screentWith - 120, 30)];
    couponTextField.delegate = self;
    couponTextField.font = [UIFont systemFontOfSize:13];
    couponTextField.placeholder = @"请输入优惠券/兑换券";
    [couponTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    couponTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    couponTextField.backgroundColor = [UIColor clearColor];
    couponTextField.textColor = appDelegate.kkzTextColor;
    couponTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    couponTextField.clearButtonMode = UITextFieldViewModeAlways;
    couponTextField.delegate = self;
    [textFieldBg addSubview:couponTextField];

    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    [topView setBarStyle:UIBarStyleDefault];

    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];

    btnToolBar.frame = CGRectMake(2, 5, 50, 30);

    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];

    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];

    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];

    [topView setItems:buttonsArray];

    [couponTextField setInputAccessoryView:topView];

    useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    useBtn.frame = CGRectMake(screentWith - 93, 11.5, 77, 37);
    useBtn.backgroundColor = appDelegate.kkzBlue;
    [holder addSubview:useBtn];
    useBtn.layer.cornerRadius = 3;
    [useBtn setTitle:@"提交" forState:UIControlStateNormal];
    [useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [useBtn addTarget:self action:@selector(bindCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    ecardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, screentWith, screentContentHeight - 75 - 44 - 105)];
    ecardTableView.backgroundColor = [UIColor clearColor];
    ecardTableView.delegate = self;
    ecardTableView.dataSource = self;
    ecardTableView.showsVerticalScrollIndicator = NO;
    ecardTableView.scrollEnabled = YES;
    ecardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [holder addSubview:ecardTableView];

    //抵扣的金额数
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screentContentHeight + self.contentPositionY - 105, screentWith, 105)];
    view.backgroundColor = [UIColor r:242 g:242 b:242];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];

    CGFloat marginY = (screentWith - 320) * 0.5;

    disccountTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginY + 70, 15, 120, 15)];
    disccountTipLabel.backgroundColor = [UIColor clearColor];
    disccountTipLabel.textColor = appDelegate.kkzTextColor;
    disccountTipLabel.textAlignment = NSTextAlignmentRight;
    disccountTipLabel.text = @"共抵扣金额：";
    disccountTipLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:disccountTipLabel];

    disccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginY + 190, 15, 100, 15)];
    disccountLabel.backgroundColor = [UIColor clearColor];
    disccountLabel.textColor = [UIColor r:55 g:197 b:1];
    disccountLabel.text = [NSString stringWithFormat:@"￥%.2f元", _ecardValue];
    disccountLabel.textAlignment = NSTextAlignmentLeft;
    disccountLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:disccountLabel];

    useCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    useCouponBtn.frame = CGRectMake(15, 45, screentWith - 15 * 2, 42);
    useCouponBtn.backgroundColor = appDelegate.kkzBlue;
    [view addSubview:useCouponBtn];
    useCouponBtn.layer.cornerRadius = 3;
    [useCouponBtn setTitle:@"确认使用" forState:UIControlStateNormal];
    [useCouponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useCouponBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [useCouponBtn addTarget:self action:@selector(finishSelectCoupon) forControlEvents:UIControlEventTouchUpInside];

    noRedAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, screentWith - 10 * 2, 60)];
    noRedAlertLabel.font = [UIFont systemFontOfSize:14.0];
    noRedAlertLabel.textColor = [UIColor grayColor];
    noRedAlertLabel.text = @"无法获取相关兑换券列表, 下拉刷新试试吧";
    noRedAlertLabel.backgroundColor = [UIColor clearColor];
    noRedAlertLabel.textAlignment = NSTextAlignmentCenter;
    noRedAlertLabel.numberOfLines = 0;

    showMoreBtn = [[ShowMoreButton alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
    showMoreBtn.delegate = self;
    showMoreBtn.state = ShowMoreButtonStateNormal;

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f - ecardTableView.bounds.size.height,
                                                                                    screentWith,
                                                                                    ecardTableView.bounds.size.height)];

    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [ecardTableView addSubview:refreshHeaderView];

    currentPage = 1;
    tableLocked = NO;

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 150, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到优惠券/兑换券列表";

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 150, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询优惠券/兑换券列表，请稍候...";

    [self updateEcardList];
}

- (void)dismissKeyBoard {
    [couponTextField resignFirstResponder];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:textRe];
    [self touchAtPoint:point];
}

- (void)touchAtPoint:(CGPoint)point {
    if (!CGRectContainsPoint(couponTextField.frame, point)) {
        [couponTextField resignFirstResponder];
        return;
    }
}

- (void)cancelViewController {
    if (selectedEcardList.count) {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"否"];
        cancel.action = ^{

        };

        RIButtonItem *done = [RIButtonItem itemWithLabel:@"是"];
        done.action = ^{
            [selectedEcardList removeAllObjects];
            _ecardValue = 0;
            self.CouponAmountBlock(_ecardValue, selectedEcardList);
            [self popViewControllerAnimated:YES];
        };

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"现在返回上一页将取消您已经提交的券码，真的要这样做吗？"
                                               cancelButtonItem:cancel
                                               otherButtonItems:done, nil];
        [alert show];
    } else {
        [selectedEcardList removeAllObjects];
        _ecardValue = 0;
        self.CouponAmountBlock(_ecardValue, selectedEcardList);
        [self popViewControllerAnimated:YES];
    }
}

- (void)updateEcardList {
    [nodataView removeFromSuperview];
    self.isRequesting = YES;
    self.isFromRefresh = YES;
    if (ecardValidList.count <= 0 && segmentIndexNum == 0) {
        [ecardTableView addSubview:noAlertView];
        [noAlertView startAnimation];
    } else if (ecardInvalidList.count <= 0 && segmentIndexNum == 1) {
        [ecardTableView addSubview:noAlertView];
        [noAlertView startAnimation];
    }

    PayTask *task = [[PayTask alloc]
            initCouponListforOrder:self.orderNo
                          finished:^(BOOL succeeded, NSDictionary *userInfo) {

                              [appDelegate hideIndicator];
                              tableLocked = NO;
                              self.isRequesting = NO;
                              [noAlertView removeFromSuperview];

                              [ecardInvalidList removeAllObjects];
                              [ecardValidList removeAllObjects];
                              [self.isSelectedIndexArr removeAllObjects];

                              ecardTableView.tableFooterView = nil;

                              if (succeeded) {
                                  [ecardValidList addObjectsFromArray:[userInfo objectForKey:@"rightCouponList"]];
                                  [ecardInvalidList addObjectsFromArray:[userInfo objectForKey:@"wrongCouponList"]];

                                  for (int i = 0; i < ecardValidList.count; i++) {
                                      CheckCoupon *coupon = ecardValidList[i];
                                      if (coupon.selected) {
                                          [self.isSelectedIndexArr addObject:[NSString stringWithFormat:@"%d", i]];
                                      }
                                  }

                              } else {
                                  [appDelegate showAlertViewForTaskInfo:userInfo];
                              }

                              if (ecardValidList.count <= 0 && segmentIndexNum == 0) {
                                  if (!nodataView.superview) {
                                      [ecardTableView addSubview:nodataView];
                                  }
                              } else if (ecardInvalidList.count <= 0 && segmentIndexNum == 1) {
                                  if (!nodataView.superview) {
                                      [ecardTableView addSubview:nodataView];
                                  }
                              } else {
                                  [nodataView removeFromSuperview];
                              }
                              [ecardTableView reloadData];

                              //根据绑定之后返回的数据重新选择兑换券的使用情况（后台返回的默认情况）

                              for (int i = 0; i < self.isSelectedIndexArr.count; i++) {

                                  NSInteger isSelectedIndex = [self.isSelectedIndexArr[i] integerValue];

                                  if (isSelectedIndex >= 0) {
                                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:isSelectedIndex inSection:0];
                                      if ([ecardTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] && (self.isFirst || self.bindingCardNo.length)) {
                                          self.isFirst = NO;
                                          EcardCell *cell = (EcardCell *) [ecardTableView cellForRowAtIndexPath:indexPath];
                                          cell.isSelect = NO;
                                          CheckCoupon *coupon = ecardValidList[isSelectedIndex];
                                          [selectedEcardList removeObject:coupon];
                                          [ecardTableView.delegate tableView:ecardTableView didSelectRowAtIndexPath:indexPath];
                                      }
                                  }
                              }

                              //为了判定新绑定的有效兑换券是 可用 还是 不可用
                              CheckCoupon *bindedCoupon = [CheckCoupon getCouponWithcouponId:self.bindingCardNo];
                              if (self.bindingCardNo.length) {
                                  if (ecardValidList.count) {
                                      if ([ecardValidList containsObject:bindedCoupon]) {
                                          [chooseSegmentView setSegmentSelected:0];
                                      } else {
                                          [chooseSegmentView setSegmentSelected:1];
                                      }
                                  } else {
                                      [chooseSegmentView setSegmentSelected:1];
                                  }
                                  self.bindingCardNo = nil;
                              }

                              [self resetRefreshHeader];

                          }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        tableLocked = YES;
    }
}

- (void)bindCardBtnClicked {
    DLog(@"绑定按钮被选中");

    [couponTextField resignFirstResponder];
    NSString *bindingNoStr = [couponTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (!couponTextField.text || [bindingNoStr length] == 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请输入有效的优惠券/兑换券" cancelButton:@"好的"];
        return;
    }

    self.bindingCardNo = bindingNoStr;
//
//    PayTask *task = [[PayTask alloc]
//            initBindingCouponforUser:bindingNoStr
//                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
//
//                                [appDelegate hideIndicator];
//                                if (succeeded) {
//                                    couponTextField.text = nil;
//
//                                    //只要用户第一次进入  或者 用户新绑定了兑换券  就以后台返回的默认值为准  其他情况下 以用户的选择为准
//                                    //清除以前的兑换券选择情况
//                                    [selectedEcardList removeAllObjects];
//                                    _ecardValue = 0;
//                                    self.CouponAmountBlock(_ecardValue, selectedEcardList);
//
//                                    NSArray *coupons = (NSArray *) [userInfo kkz_objForKey:@"myCouponList"];
//                                    if (coupons.count > 0) {
//                                        [self updateEcardList];
//                                    }
//                                } else {
//                                    [appDelegate showAlertViewForTaskInfo:userInfo];
//                                }
//
//                            }];
//    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
//        [appDelegate showIndicatorWithTitle:@"请稍候..."
//                                   animated:YES
//                                 fullScreen:NO
//                               overKeyboard:NO
//                                andAutoHide:NO];
//    }
}

- (void)finishSelectCoupon {
    if (_ecardValue == 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请输入有效的兑换券" cancelButton:@"确定"];
        return;
    }
    self.CouponAmountBlock(_ecardValue, selectedEcardList);
    [self popViewControllerAnimated:YES];
}

- (void)didSelectSegmentAtIndex:(NSInteger)index {

    self.disccountNum = 0;
    [ecardTableView setContentOffset:CGPointMake(0, 0)];
    [couponTextField resignFirstResponder];

    if (index == segmentIndexNum) {
        return;
    } else {
        segmentIndexNum = index;
        [ecardTableView reloadData];
    }
    if (self.isRequesting) {

        if (ecardValidList.count <= 0 && segmentIndexNum == 0) {
            [ecardTableView addSubview:noAlertView];
            [noAlertView startAnimation];
        } else if (ecardInvalidList.count <= 0 && segmentIndexNum == 1) {
            [ecardTableView addSubview:noAlertView];
            [noAlertView startAnimation];
        } else {
            [noAlertView removeFromSuperview];
        }

    } else {
        if (ecardValidList.count <= 0 && segmentIndexNum == 0) {

            if (!nodataView.superview) {
                [ecardTableView addSubview:nodataView];
            }

        } else if (ecardInvalidList.count <= 0 && segmentIndexNum == 1) {

            if (!nodataView.superview) {
                [ecardTableView addSubview:nodataView];
            }

        } else {
            [nodataView removeFromSuperview];
        }
    }
}

- (void)updateEcardValue:(NSArray *)cardListToCheck {

    if (cardListToCheck.count) {
        NSString *cardIds = [cardListToCheck componentsJoinedByString:@","];
        PayTask *task = [[PayTask alloc] initCheckECard:cardIds
                                               forOrder:_orderNo
                                               groupbuy:nil
                                               finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                   [appDelegate hideIndicator];

                                                   if (succeeded) {
                                                       [selectedEcardList removeAllObjects];

                                                       NSArray *coupons = (NSArray *) [userInfo kkz_objForKey:@"coupons"];
                                                       if (coupons && coupons.count > 0) {
                                                           for (NSDictionary *couponDict in coupons) {
                                                               NSString *couponId = couponDict[@"couponId"];
                                                               [selectedEcardList addObject:couponId];
                                                           }
                                                       }

                                                       CGFloat agio = [userInfo[@"agio"] floatValue];
                                                       _ecardValue = _orderTotalFee - agio;
                                                       disccountLabel.text = [NSString stringWithFormat:@"%.2f元", _ecardValue];
                                                       [ecardTableView reloadData];

                                                   } else {
                                                       [appDelegate showAlertViewForTaskInfo:userInfo];
                                                   }

                                               }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"请稍候..."
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:NO
                                    andAutoHide:NO];
        }
    } else {
        [selectedEcardList removeAllObjects];
        _ecardValue = 0;
        disccountLabel.text = [NSString stringWithFormat:@"%.2f元", _ecardValue];
        [ecardTableView reloadData];
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                ecardTableView.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {
                [refreshHeaderView setState:EGOOPullRefreshNormal];

                if (ecardTableView.contentOffset.y <= 0) {

                    [ecardTableView setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging && scrollView == ecardTableView) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }

    CGRect frame = CGRectMake(10, 52, 300, 2 * 90 + 10);
    frame.origin.y = 52 - scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {
    }

    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65.0f && scrollView == ecardTableView) {
        self.bindingCardNo = nil;

        [self updateEcardList];
    }
}

#pragma mark - Table View Data Source
- (void)configureEcardCell:(EcardCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    if (segmentIndexNum == 0) {
        couponY = [ecardValidList objectAtIndex:indexPath.row];
        couponY.remainCount = @"1";
    } else if (segmentIndexNum == 1) {
        couponY = [ecardInvalidList objectAtIndex:indexPath.row];
        couponY.remainCount = @"0";
    }

    if (segmentIndexNum == 0) {
        cell.isShow = YES;
    } else if (segmentIndexNum == 1) {
        cell.isShow = NO;
    }

    cell.couponId = couponY.couponId;
    cell.maskName = couponY.maskName;
    cell.expiredDate = couponY.expireDate;
    cell.segmentIndex = segmentIndexNum;
    cell.remainCount = couponY.remainCount;

    [cell updateLayoutYN];

    if ([selectedEcardList indexOfObject:couponY.couponId] != NSNotFound) {
        cell.isSelect = YES;
    } else {
        cell.isSelect = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"EcardCheckIdentifier";

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
    if (segmentIndexNum == 0) {
        return [ecardValidList count];
    } else if (segmentIndexNum == 1) {
        return [ecardInvalidList count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!chooseSegmentView) {
        NSArray *segementArr = @[ @{ @"text" : @"可用" }, @{ @"text" : @"不可用" } ];

        couponView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, screentWith - 15 * 2, 40)];

        chooseSegmentView = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(30, 0, screentWith - 15 * 2 * 2, 35)
                                                                     items:segementArr
                                                              iconPosition:IconPositionRight
                                                         andSelectionBlock:^(NSUInteger segmentIndex) {
                                                             [self didSelectSegmentAtIndex:segmentIndex];
                                                         }];

        chooseSegmentView.color = [UIColor whiteColor];
        chooseSegmentView.selectionColor = appDelegate.kkzBlue;

        [chooseSegmentView updateSegmentsFormat];
        [couponView setBackgroundColor:[UIColor whiteColor]];
        [couponView addSubview:chooseSegmentView];
    }
    return couponView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckCoupon *couponYN;
    if (segmentIndexNum == 0) {
        couponYN = [ecardValidList objectAtIndex:indexPath.row];
    } else if (segmentIndexNum == 1) {
        couponYN = [ecardInvalidList objectAtIndex:indexPath.row];
    }
    CGSize s = [couponYN.maskName sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];
    return s.height + 35 + 15 + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (segmentIndexNum == 1) {
        return;
    }
    [couponTextField resignFirstResponder];

    EcardCell *cell = (EcardCell *) [tableView cellForRowAtIndexPath:indexPath];
    CheckCoupon *coupon = [ecardValidList objectAtIndex:indexPath.row];

    if (cell.isSelect) {
        NSMutableArray *cardListToCheck = [[NSMutableArray alloc] initWithArray:selectedEcardList];
        [cardListToCheck removeObject:coupon.couponId];
        [self updateEcardValue:cardListToCheck];
    } else {
        CGFloat moneyToPay = self.orderTotalFee - _ecardValue;
        moneyToPay = floor(moneyToPay * 100) / 100;

        if (moneyToPay <= 0 && !self.isFromRefresh) {
            [appDelegate showAlertViewForTitle:@""
                                       message:@"亲，您已提交的券码总额已足够抵扣该订单哦～"
                                  cancelButton:@"知道了"];
            return;
        }
        [selectedEcardList removeObject:coupon.couponId];
        NSMutableArray *cardListToCheck = [[NSMutableArray alloc] initWithArray:selectedEcardList];
        [cardListToCheck addObject:coupon.couponId];
        [self updateEcardValue:cardListToCheck];
        self.isFromRefresh = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == couponTextField) {
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
