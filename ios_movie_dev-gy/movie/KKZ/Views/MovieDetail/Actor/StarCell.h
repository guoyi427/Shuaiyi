//
//  电影详情 - 查看全部演职员 演员Cell
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarCell : UITableViewCell {

    UIImageView *starHeaderImg;
    UILabel *nameLabel;
    UIView *whiteBg;
}

@property (nonatomic, strong) NSString *starHeadUrl;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) BOOL isMovie;

- (void)updateLayout;

@end
