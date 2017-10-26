//
//  显示积分信息的View
//
//  Created by KKZ on 15/12/24.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface KKZIntegralView : UIView

- (void)updateWithTitle:(NSString *)title
               andScore:(NSString *)score
            andIconPath:(NSString *)iconPath;

@end
