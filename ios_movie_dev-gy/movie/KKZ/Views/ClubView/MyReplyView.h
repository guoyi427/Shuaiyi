//
//  MyReplyView.h
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReplyView : UIView
{
    //评论信息的背景
    UIImageView *myReplyWordVBg;
    //评论信息的lbl
    UILabel *myReplyWordLbl;
    //评论的时间
    UILabel *replyDateLbl;
    UIImageView *arrow;
}
/**
 *  我回复的信息
 */
@property(nonatomic,copy)NSString *myReplyWords;
/**
 *  评论的时间
 */
@property(nonatomic,strong)NSString *replyDate;
/**
 * 更新数据
 */
-(void)upLoadData;
@end
