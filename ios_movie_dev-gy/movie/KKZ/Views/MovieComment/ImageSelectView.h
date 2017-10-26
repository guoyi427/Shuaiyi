//
//  ImageSelectView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieCommentViewController;

@interface ImageSelectView : UIView

/**
 *  初始化视图
 *
 *  @param frame      <#frame description#>
 *  @param controller <#controller description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame
     withController:(MovieCommentViewController *)controller;

@end
