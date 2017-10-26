//
//  CameraFlashView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FlashChooseType) {
    FlashChooseOff  = 0,
    FlashChooseOn   = 1,
    FlashChooseAuto = 2
};

typedef void(^DidChooseFlashTypeBlock)(FlashChooseType flashType);

@interface CameraFlashView : UIView

/**
*  打开闪光灯选择视图
*
*  @param type  当前的闪光灯类型
*  @param block 选择按钮点击之后的回调函数
*/
- (void)openChooseViewWithChooseType:(FlashChooseType)type
                     withChooseBlock:(DidChooseFlashTypeBlock)block;

/**
 *  打开闪光灯选择视图
 */
- (void)closeChooseView;

/**
 *  当前选择视图是否打开
 */
@property (nonatomic, assign) BOOL isOpen;

@end
