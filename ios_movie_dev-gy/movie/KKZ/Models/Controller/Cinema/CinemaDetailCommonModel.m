//
//  CinemaDetailCommonModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CinemaDetailCommonModel.h"
#import "TaskQueue.h"
#import "FavoriteTask.h"
#import "DataEngine.h"

static CinemaDetailCommonModel *instance = nil;

@implementation CinemaDetailCommonModel

+(CinemaDetailCommonModel *)sharedInstance {
    @synchronized(self) {
        if (!instance) {
            instance = [[CinemaDetailCommonModel alloc] init];
        }
        return instance;
    }
}

- (void)doCollectCinemaWithCinemaId:(NSInteger)cinemaId {
    
    //如果没有授权
    if (!appDelegate.isAuthorized) {
        [[DataEngine sharedDataEngine] startLoginFinished:nil];
        return;
    }
    
    //是否已经收藏过
    if (self.isCollected) {
        //取消收藏接口
        FavoriteTask *task = [[FavoriteTask alloc] initDelFavCinema:(int)cinemaId
                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                               //取消收藏成功
                                                               if (succeeded) {
                                                                   
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshCinemaList object:nil];
                                                                   
                                                                   //取消收藏
                                                                   self.isCollected = FALSE;
                                                                   
                                                                   //显示提示框
                                                                   [appDelegate showIndicatorWithTitle:@"已取消收藏该影院"
                                                                                              animated:NO
                                                                                            fullScreen:NO
                                                                                          overKeyboard:YES
                                                                                           andAutoHide:YES];
                                                               }else{
                                                                   [appDelegate showAlertViewForTaskInfo:userInfo];
                                                               }
                                                           }];
        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
        return;
    }
    
    //收藏影院请求
    FavoriteTask *task = [[FavoriteTask alloc] initAddFavCinema:cinemaId
                                                       finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                           if (succeeded) {
                                                               self.isCollected = TRUE;
                                                               //显示提示框
                                                               [appDelegate showIndicatorWithTitle:@"影院收藏成功"
                                                                                          animated:NO
                                                                                        fullScreen:NO
                                                                                      overKeyboard:YES
                                                                                       andAutoHide:YES];
                                                           }
                                                           else{
                                                               [appDelegate showAlertViewForTaskInfo:userInfo];
                                                           }
                                                       }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)refreshFavCinemaWithCinemaId:(NSInteger)cinemaId {
    
    //如果没有授权
    if (!appDelegate.isAuthorized) {
        return;
    }
    
    //是否已经已经收藏
    FavoriteTask *task = [[FavoriteTask alloc] initQueryFavForCinema:cinemaId
                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                if (succeeded) {
                                                                    NSArray *arr = (NSArray *)[userInfo objectForKey:@"cinemasFavedList"];
                                                                    if (arr.count) {
                                                                        self.isCollected = YES;
                                                                    }else{
                                                                        self.isCollected = NO;
                                                                    }
                                                                }else{
                                                                    [appDelegate showAlertViewForTaskInfo:userInfo];
                                                                }
                                                            }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cinemaCollectStatusChanged:)]) {
        [self.delegate cinemaCollectStatusChanged:_isCollected];
    }
}

@end
