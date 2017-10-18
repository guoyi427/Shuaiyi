//
//  键盘上带有完成按钮的ToolBar
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol KKZKeyboardTopViewDelegate <NSObject>

- (void)KKZKeyboardDismissed;

@end

@interface KKZKeyboardTopView : UIToolbar

@property (nonatomic, weak) id<KKZKeyboardTopViewDelegate> keyboardDelegate;

@end
