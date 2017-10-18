//
//  CPNavigatorView.h
//  Cinephile
//
//  Created by Albert on 7/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  座位图缩略图
 */
@interface CPNavigatorView : UIView
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong, readonly) CALayer *spotLayer;
- (void) update;
/**
 *  跟新显示区域
 *
 *  @param rect  显示区域
 *  @param scale 缩放比例
 */
- (void) updateVisibleRect:(CGRect)rect scale:(CGFloat)scale;
@end
