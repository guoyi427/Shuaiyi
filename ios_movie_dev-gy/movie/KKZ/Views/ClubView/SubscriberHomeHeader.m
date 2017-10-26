//
//  SubscriberHomeHeader.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "SubscriberHomeHeader.h"
#import "ImageEngineNew.h"
#import "KKZUser.h"
#import "KKZUserTask.h"
#import "TaskQueue.h"
#import "DataEngine.h"
#import "KKZUtility.h"
#import "RIButtonItem.h"
#import "User.h"

#define SubscriberHomeHeaderHeight 210
#define userHeadImgVWidth 75
#define marginHeadViewToNickName 13
#define nickNameFont 17
#define marginNickNameToSubTitle 8
#define subTitleFont 13
#define marginX 15
#define marginSubTitleToBtn 23
#define subscribeBtnWidth 122
#define subscribeBtnHeight 30
#define subscribeBtnColor appDelegate.kkzBlue
#define subscribeBtnColorBook [UIColor r:245 g:185 b:65]

@implementation SubscriberHomeHeader
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //用户头像
        userHeadImgV = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - userHeadImgVWidth) * 0.5, 0, userHeadImgVWidth, userHeadImgVWidth)];
        [self addSubview:userHeadImgV];
        userHeadImgV.layer.cornerRadius = userHeadImgVWidth * 0.5;
        userHeadImgV.clipsToBounds = YES;
        [userHeadImgV setBackgroundColor:[UIColor clearColor]];
        userHeadImgV.layer.borderWidth = 3;
        userHeadImgV.layer.borderColor = [UIColor r:211 g:211 b:211 alpha:0.9].CGColor;
        
        //用户昵称
        nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userHeadImgV.frame) + marginHeadViewToNickName, screentWith - marginX * 2, nickNameFont + 2)];
        [self addSubview:nickNameLbl];
        nickNameLbl.font = [UIFont systemFontOfSize:nickNameFont];
        nickNameLbl.textColor = [UIColor whiteColor];
        nickNameLbl.textAlignment = NSTextAlignmentCenter;
        nickNameLbl.text = @"";
        
        //用户简介
        subTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(nickNameLbl.frame)+ marginNickNameToSubTitle, screentWith - marginX * 2, subTitleFont + 2)];
        subTitleLbl.font = [UIFont systemFontOfSize:subTitleFont];
        subTitleLbl.textColor = [UIColor whiteColor];
        subTitleLbl.textAlignment = NSTextAlignmentCenter;
        subTitleLbl.text = @"";
        [self addSubview:subTitleLbl];
        
        
        //订阅按钮
        subscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - subscribeBtnWidth) * 0.5, CGRectGetMaxY(subTitleLbl.frame) + marginSubTitleToBtn, subscribeBtnWidth, subscribeBtnHeight)];
        subscribeBtn.layer.cornerRadius = subscribeBtnHeight * 0.5;
        [subscribeBtn setBackgroundColor:subscribeBtnColor];
        [subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
        [subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [subscribeBtn setImage:[UIImage imageNamed:@"bookBtnIcon"] forState:UIControlStateNormal];
         [subscribeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 10)];
        [subscribeBtn addTarget:self action:@selector(subscribeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:subscribeBtn];
        
    }
    return self;
}

//加载数据
-(void)upLoadData:(User *) user
{
    [userHeadImgV loadImageWithURL:user.detail.headImg andSize:ImageSizeOrign];
    nickNameLbl.text = user.detail.nickName;
    subTitleLbl.text = self.subTitle;
    
    
    [self checkFriend];
    
}

-(void)subscribeBtnClicked
{
    if (self.isFriend) {
//        [appDelegate showAlertViewForTitle:@"" message:@"该用户已被订阅" cancelButton:@"OK"];
        [self deleteFriend];
    }else{
        [self addFriend];
    }
   
}


- (void)checkFriend {
    
    if (appDelegate.isAuthorized) {
        KKZUserTask *task = [[KKZUserTask alloc] initUserRelationWith:self.userId finished:^(BOOL succeeded, NSDictionary *userInfo) {
            [self checkFriendFinished:userInfo status:succeeded];
        }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
        
    }
    
}

- (void)checkFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"checkFriendFinished finished");
    [appDelegate hideIndicator];
    if (succeeded) {
        self.isFriend = [[userInfo kkz_boolNumberForKey:@"tag"] boolValue];
        
        if (self.isFriend) {
            [subscribeBtn setBackgroundColor:subscribeBtnColorBook];
            [subscribeBtn setTitle:@"已订阅" forState:UIControlStateNormal];
            [subscribeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
            [subscribeBtn setImage:[UIImage imageNamed:@"bookBtnIcon"] forState:UIControlStateNormal];
            [subscribeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 10)];
        }
        
    }else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
        
    }
    
}


- (void)addFriend{
    
    
    
    void (^doAction)() = ^(){
        
        NSString *userid = [NSString stringWithFormat:@"%u", self.userId];
        
        if ([userid isEqualToString:[DataEngine sharedDataEngine].userId]) {
            
            [appDelegate showAlertViewForTitle:@"" message:@"自己不能关注自己" cancelButton:@"确定"];
            
            return;
            
        }
        
        KKZUserTask *task = [[KKZUserTask alloc] initAddFriend:self.userId finished:^(BOOL succeeded, NSDictionary *userInfo) {
            
            [self addFriendFinished:userInfo status:succeeded];
            
        }];
        
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            
            [appDelegate showIndicatorWithTitle:@"正在添加..."
             
                                       animated:YES
             
                                     fullScreen:NO
             
                                   overKeyboard:YES
             
                                    andAutoHide:NO];
            
        }
        
    };
    
    
    
    
    
    if (!appDelegate.isAuthorized) {
        
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        
        [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
            
            if (succeeded){
                
                doAction();
                
            }
            
        } withController:parentCtr];
        
    } else {
        
        doAction();
        
    }
    
    
    
}



- (void)addFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded{
    
    DLog(@"addFriendFinished finished");
    
    [appDelegate hideIndicator];
    
    if (succeeded) {
        
        [appDelegate showAlertViewForTitle:@""
         
                                   message:@"已关注该用户"
         
                              cancelButton:@"确定"];
        
        self.isFriend = YES;
        
        [subscribeBtn setBackgroundColor:subscribeBtnColorBook];
        [subscribeBtn setTitle:@"已订阅" forState:UIControlStateNormal];
        [subscribeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"isSubscriberComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"isFriendY"]];
        
    }else {
        
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
    
}


- (void)deleteFriend{
    KKZUserTask *task = [[KKZUserTask alloc] initDelFriend:self.userId finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self delFriendFinished:userInfo status:succeeded];
    }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"正在取消关注..."
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:NO];
    }

}

- (void)delFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded{
    DLog(@"delFriendFinished finished");
    [appDelegate hideIndicator];
    if (succeeded) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"成功取消关注"
                              cancelButton:@"OK"];
        self.isFriend = NO;
        
        [subscribeBtn setBackgroundColor:subscribeBtnColor];
        [subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
        [subscribeBtn setImage:[UIImage imageNamed:@"bookBtnIcon"] forState:UIControlStateNormal];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"isSubscriberComplete" object:@YES userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"isFriendY"]];
        
    }else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
        
    }
    
}



@end
