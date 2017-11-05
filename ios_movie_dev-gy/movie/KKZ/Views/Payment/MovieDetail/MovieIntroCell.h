//
//  电影详情页面电影简介的cell
//
//  Created by da zhang on 11-5-12.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "Movie.h"

@interface MovieIntroCell : UITableViewCell {

    UILabel *introLabel;
    UIView *line;
    UIView *whiteBg;
    UIImageView *unfoldLbl;
}

@property (nonatomic, strong) NSString *movieIntro;

@property (nonatomic, assign) BOOL isExpand;

- (void)updateLayout;

- (float)heightWithCellState:(BOOL)isExpand;

@end
