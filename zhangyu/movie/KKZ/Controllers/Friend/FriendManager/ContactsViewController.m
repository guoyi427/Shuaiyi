//
//  添加通讯录好友页面
//
//  Created by alfaromeo on 12-3-30.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "AddContractCell.h"
#import "AlertViewY.h"
#import "Constants.h"
#import "Constants.h"
#import "ContactsViewController.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DataManager.h"
#import "FriendHomeViewController.h"
#import "KKZUserTask.h"
#import "PlatformUser.h"
#import "ShowMoreIndicator.h"
#import "SinaClient.h"
#import "TaskQueue.h"
#import <ShareSDK/ShareSDK.h>

@interface ContactsViewController ()

- (void)refreshFansList;
- (void)resetRefreshHeader;

@end

@implementation ContactsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ContactsPhoneStringFinished" object:nil];
    if (fansTable) {
        [fansTable removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self taskType:TaskTypeInvitedFriend];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeNoAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hasNoContactsPhone" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    currentPage = 1;

    self.kkzTitleLabel.text = @"添加好友";

    filteredArray = [[NSMutableArray alloc] init];
    dataSource = [[NSMutableArray alloc] init];
    phoneArrayStr = @"";

    fansTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)
                                             style:UITableViewStylePlain];
    fansTable.delegate = self;
    fansTable.dataSource = self;
    fansTable.backgroundColor = [UIColor clearColor];
    fansTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    fansTable.separatorColor = [UIColor colorWithWhite:.9 alpha:.8];
    [self.view addSubview:fansTable];

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -fansTable.bounds.size.height, screentWith, fansTable.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [fansTable addSubview:refreshHeaderView];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    fansTable.tableFooterView = showMoreFooterView;
    showMoreFooterView.hidden = YES;

    noFansAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, screentWith - 10 * 2, 40)];
    noFansAlertLabel.text = @"啊哦, 您还没有好友喔~";
    noFansAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noFansAlertLabel.textColor = [UIColor grayColor];
    noFansAlertLabel.backgroundColor = [UIColor clearColor];
    noFansAlertLabel.textAlignment = NSTextAlignmentCenter;
    noFansAlertLabel.numberOfLines = 4;
    noFansAlertLabel.hidden = YES;
    [fansTable addSubview:noFansAlertLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterPhoneArrStrHandler:) name:@"ContactsPhoneStringFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasNoContactsPhone) name:@"hasNoContactsPhone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInvitedFriend:) taskType:TaskTypeInvitedFriend];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removenoAlertView:) name:@"removeNoAlertView" object:nil];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 40, screentWith, 120)];
    noAlertView.alertLabelText = @"通讯录获取中...";
}

- (void)hasNoContactsPhone {
    [noAlertView removeFromSuperview];
    noFansAlertLabel.text = @"啊哦, 您还没有好友喔~";
    noFansAlertLabel.hidden = NO;
    showMoreFooterView.hidden = YES;
}

- (void)removenoAlertView:(NSNotification *) not{
    [noAlertView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshFansList];
}

- (NSString *)sigleCwithType:(int)type {
    if (type) {
        srand((unsigned) time(0));
        int num = rand() % 10;
        return [NSString stringWithFormat:@"%d", num];
    } else {
        srand((unsigned) time(0));
        int num = rand() % 26;
        return [NSString stringWithFormat:@"%c", 'a' + num];
    }
}

- (NSString *)creatArandStringWith:(int)type {
    int num = 11;
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < num; i++) {
        [str appendString:[self sigleCwithType:type]];
    }
    return str;
}

- (void)refreshFansList {
    [[DataManager shareDataManager] fatchContacts];
}

- (void)showMoreFans {
    showMoreFooterView.isLoading = NO;
    showMoreFooterView.hasNoMore = YES;
}

- (void)afterPhoneArrStrHandler:(NSNotification *)notification {
    phoneArrayStr = [notification.userInfo[@"phoneArrayStr"] copy];

    KKZUserTask *task = [[KKZUserTask alloc]
            initIdentifyPhoneNum:phoneArrayStr
                            page:currentPage
                     isNewFriend:nil
                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                            [self checkFinished:userInfo status:succeeded];
                        }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark - handle notifications
- (void)getInvitedFriend:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if ([notification succeeded]) {
        [self refreshFansList];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)checkFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    [self resetRefreshHeader];

    showMoreFooterView.isLoading = NO;
    showMoreFooterView.hasNoMore = YES;
    showMoreFooterView.hidden = NO;

    [noAlertView removeFromSuperview];

    if (succeeded) {
        NSArray *phoneNumsData = [userInfo objectForKey:@"result"];
        if ([phoneNumsData count] == 0) {
            noFansAlertLabel.text = @"啊哦, 您还没有好友喔~";
            noFansAlertLabel.hidden = NO;
        } else {
            noFansAlertLabel.hidden = YES;
        }

        KKZUser *user = [KKZUser
                getUserWithId:[DataEngine sharedDataEngine].userId.intValue];
        NSMutableArray *newDataSource = [[NSMutableArray alloc] init];

        dataSource = [[DataManager shareDataManager].dataSource mutableCopy];

        for (int i = 0; i < phoneNumsData.count; i++) {
            NSDictionary *phoneData = phoneNumsData[i];

            NSString *mobile = [phoneData kkz_stringForKey:@"username"];
            AddressBook *address = [[dataSource objectAtIndex:i] copy]; //保证通讯录是原始的，可以被另一套程序逻辑重用

            if ([address.tel isEqualToString:mobile] //有号码，并且不是自己
                && ![address.tel isEqualToString:user.username]) {
                [address updaInfoWithDic:phoneData];
                [newDataSource addObject:address];
            }
        }

        dataSource = newDataSource;

        NSArray *arr = @[ [[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES],
                          [[NSSortDescriptor alloc] initWithKey:@"namePY"
                                                      ascending:YES] ];

        [dataSource sortUsingDescriptors:arr];
        [fansTable reloadData];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)inviteFriend:(NSString *)tel {
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil && ([smsClass canSendText])) {
        picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = [NSString stringWithFormat:@"全国在线选座，约会购影票，尽在抠电影～下载地址：%@", kAppHTML5Url];
        picker.recipients = [NSArray arrayWithObject:tel];

        [self presentViewController:picker animated:NO completion:nil];
    } else {
        [UIAlertView showAlertView:@"这台设备不支持短信功能" buttonText:@"确定"];
    }
}

- (void)addPlatFriend:(NSString *)kId withIndex:(NSInteger)index {
    if ([kId isEqualToString:[DataEngine sharedDataEngine].userId]) {
        [UIAlertView showAlertView:@"不能关注自己" buttonText:@"确定"];
        return;
    }

    KKZUserTask *task = [[KKZUserTask alloc] initAddFriend:kId.intValue
                                                  finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                      [self addFriendFinished:userInfo status:succeeded withIndex:index];
                                                  }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"正在添加..."
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:NO];
    }
}

#pragma mark - handle notifications
- (void)addFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded withIndex:(NSInteger)index {

    DLog(@"addFriendFinished finished");

    [appDelegate hideIndicator];

    showMoreFooterView.isLoading = NO;
    showMoreFooterView.hasNoMore = YES;

    if (succeeded) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

        AddContractCell *cell = (AddContractCell *) [fansTable cellForRowAtIndexPath:indexPath];
        [cell setInvitedState];

        //改数据
        AddressBook *user;
        if (self.isSearching) {
            user = [filteredArray objectAtIndex:indexPath.row];
        } else {
            user = [dataSource objectAtIndex:indexPath.row];
        }
        user.status = PlatUserFriend;

        [UIAlertView showAlertView:@"已关注该用户" buttonText:@"确定"];
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

                fansTable.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {

                [refreshHeaderView setState:EGOOPullRefreshNormal];
                if (fansTable.contentOffset.y <= 0) {
                    [fansTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
            showMoreFooterView.isLoading = YES;
            [self showMoreFans];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65.0f) {
        [self performSelector:@selector(refreshFansList) withObject:nil afterDelay:.3];
    }
}

#pragma mark - Table view data source
- (void)configureCell:(AddContractCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        AddressBook *user = [filteredArray objectAtIndex:indexPath.row];

        @try {
            cell.avatarUrl = user.headimg;
            cell.index = indexPath.row;
            cell.name = user.name;
            cell.state = [NSNumber numberWithInt:user.status];
            [cell updateLayout];
        }
        @catch (NSException *exception) {
            LERR(exception);
        }
        @finally {
        }

    } else {
        if (indexPath.row < [dataSource count]) {
            AddressBook *user = [dataSource objectAtIndex:indexPath.row];

            @try {
                cell.avatarUrl = user.headimg;
                cell.index = indexPath.row;
                cell.name = user.name;
                cell.state = [NSNumber numberWithInt:user.status];
                [cell updateLayout];
            }
            @catch (NSException *exception) {
                LERR(exception);
            }
            @finally {
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        NSInteger count = [filteredArray count];
        if (count == 0) {
            noFansAlertLabel.hidden = NO;
            noFansAlertLabel.text = @"亲，没有搜索到符合条件的用户\n换个搜索条件试试吧~";
        } else {
            noFansAlertLabel.hidden = YES;
        }
        return count;
    } else {
        NSInteger count = [dataSource count];
        if (!count && noFansAlertLabel.hidden) {
            [self.view addSubview:noAlertView];
        }
        return count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"AddContractCell";

    AddContractCell *cell = (AddContractCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.delegate = self;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)didSelectedInvate:(NSInteger)index {
    if (tableLocked) {
        return;
    }

    if (self.isSearching) {
        AddressBook *user = [filteredArray objectAtIndex:index];
        if (user.status == PlatUserNotExist) {
            invitedUser = user.username;
            [self inviteFriend:user.tel];
        }
    } else {
        AddressBook *user = [dataSource objectAtIndex:index];
        if (user.status == PlatUserNotExist) {
            invitedUser = user.username;
            [self inviteFriend:user.tel];
        }
    }
}

- (void)didSelectedAddFriend:(NSInteger)index {
    if (tableLocked) {
        return;
    }

    if (self.isSearching) {
        AddressBook *user = [filteredArray objectAtIndex:index];
        if (user.status == PlatUserExist) {
            [self addPlatFriend:user.uId withIndex:index];
        }
    } else {
        AddressBook *user = [dataSource objectAtIndex:index];
        if (user.status == PlatUserExist) {
            [self addPlatFriend:user.uId withIndex:index];
        }
    }
}

#pragma mark UISearchBar delegate
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [filteredArray removeAllObjects];
    for (AddressBook *addressBook in dataSource) {
        if ([addressBook.name containsString:searchText]) {
            [filteredArray addObject:addressBook];
            [fansTable reloadData];
        }
    }
    [fansTable reloadData];
}

- (void)cancelSearch {
    self.isSearching = NO;
    noFansAlertLabel.hidden = YES;
    [fansTable reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (tableLocked) {
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length]) {
        self.isSearching = YES;
        NSString *final = [textField.text lowercaseString];
        [self filterContentForSearchText:final scope:nil];
    } else {
        [self cancelSearch];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self cancelSearch];
    return YES;
}

#pragma mark msg delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    switch (result) {
        case MessageComposeResultCancelled: // click cancel button
            [UIAlertView showAlertView:@"短信已取消" buttonText:@"确定"];
            break;

        case MessageComposeResultFailed: // send failed
            [UIAlertView showAlertView:@"短信发送失败" buttonText:@"确定"];
            break;

        case MessageComposeResultSent:
            if (invitedUser.length != 0) {
                KKZUserTask *task = [[KKZUserTask alloc] initGetInvitedFriend:[DataEngine sharedDataEngine].sessionId username:invitedUser];
                [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
            }
            break;

        default:
            break;
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
