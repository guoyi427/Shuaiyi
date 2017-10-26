//
//  修改昵称页面
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

typedef enum : NSUInteger {
    NickNameViewType,
    TheaterViewType,
    SignatureViewType,
} ViewType;

@interface NickNameViewController : CommonViewController

/**
 *  用户昵称
 */
@property (nonatomic, strong) NSString *userName;

/**
 *  修改昵称
 */
@property (nonatomic, copy) void (^changeFinished)(NSString *content);

/**
 *  页面类型
 */
@property (nonatomic, assign) ViewType viewType;

@end
