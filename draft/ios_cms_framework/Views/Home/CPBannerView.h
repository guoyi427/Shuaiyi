//
//  CPBannerView.h
//  Cinephile
//
//  Created by Albert on 8/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_BANNER_HEIGHT kCommonScreenWidth * 506/750
/**
 *  Banner
 */
@interface CPBannerView : UIView
/**
 *  加载图片列表
 *
 *  @param imamgUrls 图片列表<NSUrl>
 */
- (void) loadContenWithArr:(NSArray *)imamgUrls;

/**
 *  设置选中回调
 *
 *  @param block 回调block
 */
- (void) setSelectCallback:(void(^)(NSInteger index))block;

@end
