//
//  CPTabBarView.h
//  Cinephile
//
//  Created by Albert on 7/7/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CPTAB_BAR_HEIGHT 49
/**
 *  tabbar
 */
@interface CPTabBarView : UIView

/**
 *  选中的index
 */
@property (nonatomic, setter=selectAtIndex:) NSInteger selectedIndex;

- (void) selectAtIndex:(NSInteger) index;

/**
 *  选中回调
 *
 *  @param block 回调
 */
- (void) didSelec:(void (^)(NSInteger index))block;
@end
