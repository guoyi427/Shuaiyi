//
//  CPSeatIndexView.h
//  Cinephile
//
//  Created by Albert on 7/22/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  座位索引
 */
@interface CPSeatIndexView : UIView
/**
 *  行数
 */
@property (nonatomic) NSUInteger count;
/**
 *  过道所在行
 */
@property (nonatomic, strong) NSArray *aisles;
/**
 *  缩放比例
 */
@property (nonatomic) CGFloat zoomLevel;
/**
 *  行高
 */
@property (nonatomic) CGFloat rowHeight;
/**
 *  处理完过道的索引
 */
@property (nonatomic, strong, readonly) NSArray *indexs;


/**
 内容layer
 */
@property (nonatomic, strong, readonly) CALayer *contentLayer;

/**
 *  更新数据
 */
- (void) updateData;
/**
 *  更新显示
 *
 *  @param position  位置 scrollView的contentOffset
 *  @param scale 缩放 scrollView的zoomScale
 */
- (void) updatePosition:(CGPoint)position scale:(CGFloat)scale;
@end
