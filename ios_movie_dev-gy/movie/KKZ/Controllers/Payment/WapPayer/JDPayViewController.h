//
//  京东支付页面
//
//  Created by KKZ on 15/10/28.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface JDPayViewController : CommonViewController <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *key;

- (void)loadURL:(NSString *)url;

@end
