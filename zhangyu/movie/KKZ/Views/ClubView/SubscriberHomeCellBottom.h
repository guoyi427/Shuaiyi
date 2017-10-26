//
//  SubscriberHomeCellBottom.h
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriberHomeCellBottom : UIView {
    //支持的人数
    UILabel *supportLbl;
    //支持的Icon
    UIImageView *supportIconV;
    //评论的数目
    UILabel *commentLbl;
    //评论的Icon
    UIImageView *commentIconV;
    //发帖的日期
    UILabel *postDateLbl;
}
/**
 *  点赞的用户数
 */
@property (nonatomic, strong) NSNumber *supportNum;

/**
 *  评论的用户数
 */
@property (nonatomic, strong) NSNumber *commentNum;

/**
 *  发帖的日期
 */
@property (nonatomic, strong) NSString *postDate;

/**
 *  更新用户信息
 */
- (void)upLoadData;
@end
