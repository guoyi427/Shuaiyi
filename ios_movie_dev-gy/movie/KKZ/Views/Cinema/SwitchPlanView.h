//
//  SwitchPlanView.h
//  KoMovie
//
//  Created by Albert on 31/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 切换排期视图
 */
@interface SwitchPlanView : UIView
@property (nonatomic, weak, nullable) id <UITableViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;

@property (nonatomic, copy, nullable) NSString *title;

- (void) showInView:(UIView *_Nonnull)view;

- (void) dismiss;

- (void) updateData;

- (void)dismissCallback:(nullable void (^)())a_block;
@end
