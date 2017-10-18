//
//  CPRefreshAnimationView.h
//  Cinephile
//
//  Created by Albert on 07/11/2016.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_REFRESH_BAR_WIDTH 17

#define K_BAR_HEIGHT_MAX 20     //每个bar的最高高度

@interface CPRefreshAnimationView : UIView

/**
 开始动画
 */
- (void) startAnimation;
@end
