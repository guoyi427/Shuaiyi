//
//  NoNetWorkView.h
//  CIASMovie
//
//  Created by avatar on 2017/7/19.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoNetWorkView : UIView

/**
 *  刷新回调
 *
 *  @param block 回调block
 */
- (void) setRefreshCallback:(void(^)())block;

@end
