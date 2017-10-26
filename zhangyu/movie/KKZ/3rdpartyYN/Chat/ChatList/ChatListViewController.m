//
//  ChatListViewController.m
//  KoMovie
//
//  Created by avatar on 15/7/10.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListCell.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageTask.h"
#import "TaskQueue.h"
#import "HXUserInfo.h"
#import "DataEngine.h"
#import "UserDefault.h"


#import "AlertViewY.h"
#import "nodataViewY.h"
#import "MJRefresh.h"
#import "DateEngine.h"




@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) UIView                *networkStateView;

@end

@implementation ChatListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"blue_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9,29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *accountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 0.0, screentWith - 60 * 2, 44.0)];
    accountTitleLabel.text = @"聊天列表";
    accountTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    accountTitleLabel.textColor = [UIColor blackColor];
    accountTitleLabel.backgroundColor = [UIColor clearColor];
    accountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [KKZ_topbar addSubview:accountTitleLabel];
    
    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentContentHeight - 44 - 45)];
    
    [holder setBackgroundColor:[UIColor whiteColor]];
    
    self.userInfosArrM = [[NSMutableArray alloc] initWithCapacity:0];
     [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    [self.view addSubview:self.tableView];
    
    
    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 52) * 0.5, screentWith, 120)];
    noAlertView.alertLabelText = @"亲，正在查询，请稍后~";
    
    
    nodataView = [[nodataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到您的信息";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:@"refreshChatList" object:nil];
    
    [self networkStateView];
    
    //集成刷新控件
    
    [self setupRefresh];
    
  

}


- (void)setupRefresh {
    
    
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"数据加载中...";
    
    
    
    
}



-(void)headerRereshing {
   [self refreshDataSource];
}


- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}


#pragma mark - getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, screentHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}


- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}



#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    
    
    [self.tableView headerEndRefreshing];
    
//    DLog(@"[[EaseMob sharedInstance].chatManager loadDataFromDatabase] ==== %@",[[EaseMob sharedInstance].chatManager loadDataFromDatabase]);
   
    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    
    NSString *userIds = nil;
    

    
    if (sorte.count) {
        for (int i = 0; i < sorte.count; i ++ ) {//chatter
            EMConversation * e = sorte[i];
            if (i == 0) {
                userIds = e.chatter;
            }else
                userIds = [NSString stringWithFormat:@"%@,%@",userIds,e.chatter];
        }
    }
   
    
    if (userIds) {
        [self getUserNickName:userIds];

    }
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
    NSDate *d = [NSDate dateWithTimeIntervalInMilliSecondSince1970:lastMessage.timestamp];
   ret = [[DateEngine sharedDateEngine] formattedStringFromDateNew:d];
        
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    if (self.userInfosArrM.count) {
        
//        HXUserInfo *userInfoHX = self.userInfosArrM[indexPath.row];
        HXUserInfo *userInfoHX = [HXUserInfo getHXUserInfoWithId:conversation.chatter];
        cell.imageURL = [NSURL URLWithString:userInfoHX.headimg];
        cell.name = userInfoHX.nickname;
        cell.userId = [userInfoHX.hxUserId intValue];
    }else{
        cell.name = conversation.chatter;
        cell.userId = [conversation.chatter intValue];
    }
   
    
    if (conversation.conversationType == eConversationTypeChat) {
        cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    cell.name = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        else
        {
            cell.name = [conversation.ext objectForKey:@"groupSubject"];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];

    if (indexPath.row % 2 == 1) {
//        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatListCell *cell = (ChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isFriendHome) {
        return;
    }
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title;
    
 
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];

    
    if (self.userInfosArrM.count) {
        
        HXUserInfo *userInfoHX = self.userInfosArrM[indexPath.row];
        title = userInfoHX.nickname;
        chatController.imageURL = userInfoHX.headimg;
        chatController.name = userInfoHX.nickname;
        chatController.userId = [userInfoHX.hxUserId intValue];
    }else{
    
        chatController.userId = [conversation.chatter intValue];
        title = conversation.chatter;
    }

    
    chatController.chartTitle = title;
    [appDelegate pushViewController:chatController animation:NO];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - public

-(void)refreshDataSource
{
    
    
    if (!USER_LOGIN_HUANXIN) {
        EMError *error = nil;
        NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
        
        if (!error && info) {
            
            NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:[DataEngine sharedDataEngine].userId password:[DataEngine sharedDataEngine].huanXinPwd error:&error];
            
            if (!error && loginInfo) {
                NSLog(@"登陆成功");
                USER_LOGIN_HUANXIN_WRITE(YES);
                self.dataSource = [self loadDataSource];
                [_tableView reloadData];
                
                if (self.dataSource.count > 0) {
                    
                    [nodataView removeFromSuperview];
                }else{
                    
                    [self.tableView addSubview:nodataView];
                    
                    
                }
                
                [self hideHud];
            }
        }
        
    }else{
        
        self.dataSource = [self loadDataSource];
        [_tableView reloadData];
        
        if (self.dataSource.count > 0) {
            
            [nodataView removeFromSuperview];
        }else{
            
            [self.tableView addSubview:nodataView];
            
            
        }
        
        [self hideHud];
        
    }


}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
    [self refreshDataSource];
}



#pragma mark kkzViewController
- (BOOL)showTopbar {
    return YES;
}

- (BOOL)showBackgroundView {
    return NO;
}

- (void)cancelViewController {
    [appDelegate popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserNickName:(NSString *)userIds
{

        MessageTask *task = [[MessageTask alloc] initQueryMessageUserInfoList:userIds
                                                             finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                 [self userinfoListFinished:userInfo status:succeeded];
                                                             }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            
        }

}

-(void)userinfoListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded
{
    if (succeeded) {
        NSArray *arr = userInfo[@"results"];
       
        self.userInfosArrM = [arr copy];
        [self.tableView reloadData];
        
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshChatList" object:nil];

}


@end
