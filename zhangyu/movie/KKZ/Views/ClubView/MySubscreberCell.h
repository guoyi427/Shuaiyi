//
//  MySubscreberCell.h
//  KoMovie
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySubscreberCell : UITableViewCell {
    UIImageView *icon;
    UILabel *titleLbl;
    UILabel *subTitleLbl;
}

@property (nonatomic, assign) unsigned int userId;
- (void)upLoadData;
@end
