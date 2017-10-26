//
//  解除手机绑定页面
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "BindPhoneViewModel.h"
#import "CommonViewController.h"

@interface UnbindViewController : CommonViewController

/**
 *  需要解除绑定的类型
 */
@property (nonatomic, assign) UnbindType unbindType;

/**
 *  账户名称
 */
@property (nonatomic, strong) NSString *accountName;

@end
