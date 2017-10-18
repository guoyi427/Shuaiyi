//
//  CPTabItemView.h
//  Cinephile
//
//  Created by Albert on 7/7/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  tabbar item
 */
@interface CPTabItemView : UIView

@property(nonatomic, setter=setHighlight:) BOOL isHighlight;

/**
 *  构造方法
 *
 *  @param title title
 *  @param icon  icon
 *  @param highlightIcon icon for highlight
 *
 *  @return  an instance of CPTabItemView
 */
+ (instancetype) itemWith:(NSString *)title icon:(UIImage *) icon highlightIcon:(UIImage *)highlightIcon point:(NSString *)loc;
/**
 *  选中回调
 *
 *  @param block 回调
 */
- (void) didSelect:(void (^)(CPTabItemView *item))block;

- (void)setHighlight:(BOOL)heighlight;
@end
