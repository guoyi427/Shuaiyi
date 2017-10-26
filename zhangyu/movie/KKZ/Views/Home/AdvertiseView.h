//
//  首页开屏的广告
//
//  Created by KKZ on 16/4/12.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class Banner;

@interface AdvertiseView : UIView

/**
 *  广告
 */
@property (nonatomic, strong) Banner *banner;

@property (nonatomic, copy) void (^appdelegateAlertDismiss)(BOOL dismiss);

- (void)setAdvertiseImage:(UIImage *)image;

@end
