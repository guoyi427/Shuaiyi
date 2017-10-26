//
//  ClubPosterCommentCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubPostComment;

@interface ClubPosterCommentCell : UITableViewCell
{
    //用户头像
    UIImageView *userHeadImgV;
    //用户昵称
    UILabel *userNickNameLbl;
    //评论楼层
    UILabel *commentFloorLbl;
    //用户评论内容
    UILabel *commentTextLbl;
    //评论时间
    UILabel *commentDateLbl;
    //点赞的数目
    UILabel *supportNumLbl;
    //点赞的Icon
    UIImageView *supportIconV;
    
    UIView *line;
    
    UIButton *supportBtn;


}

/**
 *  楼层
 */
@property(nonatomic,copy)NSString *commentFloor;

/**
 *  是否点赞
 */
@property(nonatomic,assign)NSInteger isUp;


@property(nonatomic,strong)ClubPostComment *commont;

/**
 *  加载数据
 */
-(void)upLoadData;
@end
