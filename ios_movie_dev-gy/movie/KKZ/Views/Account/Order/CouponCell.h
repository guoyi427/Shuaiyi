//
//  CouponCell.h
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

- (void)updateName:(NSString *)name
              time:(NSString *)time
             price:(NSString *)price
            canBuy:(NSNumber *)canBuy;

@end
