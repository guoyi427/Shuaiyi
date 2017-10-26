//
//  第三方授权管理页面
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "SocialAuthCell.h"
#import "SocialAuthViewController.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import <ShareSDK/ShareSDK.h>

#define BASE_TAG 100

@interface SocialAuthViewController ()

/**
 * 第三方平台的UITableView。
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 * 第三方平台。
 */
@property (nonatomic, strong) NSMutableArray *shareTypes;

@end

@implementation SocialAuthViewController

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"第三方授权管理";

    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(authInfoUpdateHandler:)];

    // TODO why?
    //    NSArray *authList = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist", NSTemporaryDirectory()]];
    //    if (authList == nil) {
    //        [self.shareTypes writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist", NSTemporaryDirectory()] atomically:YES];
    //    } else {
    //        for (int i = 0; i < [authList count]; i++) {
    //            NSDictionary *item = [authList objectAtIndex:i];
    //            for (int j = 0; j < [_shareTypeArray count]; j++) {
    //                if ([[[_shareTypeArray objectAtIndex:j] objectForKey:@"type"] integerValue] == [[item objectForKey:@"type"] integerValue]) {
    //                    [_shareTypeArray replaceObjectAtIndex:j withObject:[NSMutableDictionary dictionaryWithDictionary:item]];
    //                    break;
    //                }
    //            }
    //        }
    //    }

    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    if (_tableView) {
        [_tableView removeFromSuperview];
    }

    [ShareSDK removeNotificationWithName:SSN_USER_INFO_UPDATE target:self];
}

- (UITableView *)tableView {
    if (!_tableView) {
        float y = runningOniOS7 ? 20 : 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y + 44, screentWith, screentContentHeight - 44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kUIColorGrayBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark Init data source
- (NSMutableArray *)shareTypes {
    if (!_shareTypes) {
        NSMutableDictionary *sinaWeibo =
                [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"新浪微博", @"title",
                                             @"logoSinaIcon", @"icon",
                                             [NSNumber numberWithInteger:ShareTypeSinaWeibo], @"type",
                                             nil];
        NSMutableDictionary *qqZone =
                [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"腾讯QQ", @"title",
                                             @"logoQQIcon", @"icon",
                                             [NSNumber numberWithInteger:ShareTypeQQSpace], @"type",
                                             nil];
        _shareTypes = [[NSMutableArray alloc] initWithObjects:sinaWeibo, qqZone, nil];
    }
    return _shareTypes;
}

#pragma mark - Handle notifications
- (void)authInfoUpdateHandler:(NSNotification *)notification {
    NSInteger plat = [[[notification userInfo] objectForKey:SSK_PLAT] integerValue];

    for (int i = 0; i < [self.shareTypes count]; i++) {
        NSMutableDictionary *item = [self.shareTypes objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] intValue];
        if (type == plat) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - SocialAuthCell delegate
- (void)socialSwitchAuth:(ShareType)shareType onAuth:(BOOL)on {
    if (on) { // 授权
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [appDelegate bringShareViewControllerToFront];

        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                                    scopes:nil
                                                             powerByHidden:YES
                                                            followAccounts:nil
                                                             authViewStyle:SSAuthViewStyleModal
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];

        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {

                                   if (result) {
                                       [appDelegate sendShareViewControllerToBack];
                                   } else {
                                       [appDelegate sendShareViewControllerToBack];
                                   }
                                   [self.tableView reloadData];

                               }];
    } else { // 取消授权
        [ShareSDK cancelAuthWithType:shareType];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SocialAuthCell *cell = (SocialAuthCell *) [tableView dequeueReusableCellWithIdentifier:@"AuthCell"];
    if (cell == nil) {
        cell = [[SocialAuthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuthCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }

    if (indexPath.row < [self.shareTypes count]) {
        NSDictionary *item = [self.shareTypes objectAtIndex:indexPath.row];
        ShareType shareType = [[item objectForKey:@"type"] intValue];

        cell.platformName = [item kkz_stringForKey:@"title"];
        cell.platformType = shareType;
        cell.platformImage = [UIImage imageNamed:[item kkz_stringForKey:@"icon"]];
        cell.isAuthOn = [ShareSDK hasAuthorizedWithType:shareType];
        [cell updateLayout];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shareTypes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

@end
