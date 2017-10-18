//
//  MovieCommentCell.h
//  CIASMovie
//
//  Created by avatar on 2017/1/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCommentCell : UITableViewCell
{
    UILabel *pointLabel;
    UILabel *judgementLabel;
    UILabel *judgeContentLabel;
    UILabel *timeLabel;
    UILabel *judgeComeFromLabel;
    UIView *line;
    UIImageView *timeImageView;
}

@property (nonatomic, copy) NSString *pointLabelStr;
@property (nonatomic, copy) NSString *judgementLabelStr;
@property (nonatomic, copy) NSString *judgeContentLabelStr;
@property (nonatomic, copy) NSString *timeLabelStr;
@property (nonatomic, copy) NSString *judgeComeFromLabelStr;


- (void)updateLayout;


@end
