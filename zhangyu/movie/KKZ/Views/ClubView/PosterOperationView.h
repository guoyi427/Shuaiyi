//
//  PosterOperationView.h
//  KoMovie
//
//  Created by KKZ on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"

@class ClubPost;

static NSString *shareViewWillShowNotification = @"shareViewWillShowNotification";
static NSString *shareViewWillHidenNotification = @"shareViewWillHidenNotification";

@interface PosterOperationView : UIView <UIGestureRecognizerDelegate, HideCoverViewDelegate> {
    UIView *oprationVBg;
    UIView *cancelView;
}
/**
 *  是否是用户自己的帖子
 */
@property (nonatomic, assign) BOOL isUserSelf;
/**
 *  用户可做操作数组
 */
@property (nonatomic, strong) NSMutableArray *operationArr;

@property (nonatomic, copy) NSNumber *articleId;

@property (nonatomic, assign) NSInteger collectionType;

@property (nonatomic, assign) NSInteger tagY;

@property (nonatomic, strong) UIButton *tagYBtn;

@property (nonatomic, strong) ClubPost *clubPost;

@property (nonatomic, assign) BOOL isFav;

- (void)uploadData;
@end
