//
//  PostPlateCell.h
//  KoMovie
//
//  Created by KKZ on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPlateCell : UITableViewCell {
    UIImageView *imageV;
    UILabel *titleLbl;
    UILabel *subTitleLblPostNum;
    UILabel *subTitleLblCommentNum;
    UILabel *subTitleLblComment;
    UILabel *subTitleLblPost;
}

/**
 *  图片地址
 */
@property(nonatomic,copy) NSString *imagePath;

/**
 *  社区板块标题
 */
@property(nonatomic,copy)NSString *title;


@property(nonatomic,copy)NSString *postNum;

@property(nonatomic,copy)NSString *commentNum;

-(void)upLoadData;

@end
