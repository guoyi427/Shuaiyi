//
//  CPPageControl.h
//  Cinephile
//
//  Created by Albert on 8/18/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  CPBannerView 页码控制
 */
@interface CPPageControl : UIView
@property (nonatomic) NSUInteger currentPage;

- (void) setPageNumbers:(NSUInteger)count;
@end
