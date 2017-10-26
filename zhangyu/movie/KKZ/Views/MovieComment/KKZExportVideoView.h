//
//  KKZExportVideoView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKZExportVideoView : UIView

/**
 *  提示文字
 */
@property (nonatomic, strong) NSString *tipString;

/**
 *  视图显示
 */
- (void)show;

/**
 *  视图隐藏
 */
- (void)hiden;

@end
