//
//  电影详情页面电影评价的Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface MovieSupportCell : UITableViewCell {

    //喜欢的数目
    UILabel *likeNumLbl;

    //不喜欢的数目
    UILabel *unlikeNumLbl;
}

/**
 *  喜欢的数目
 */
@property (nonatomic, strong) NSNumber *likeNum;

/**
 *  不喜欢的数目
 */
@property (nonatomic, strong) NSNumber *unlikeNum;

/**
 *  不喜欢的数目
 */
@property (nonatomic, assign) NSInteger relation;

/**
 *  不喜欢的数目
 */
@property (nonatomic, assign) unsigned int movieId;

@property (nonatomic, copy) void (^supportFinished)(BOOL finished, NSDictionary *result);

/**
 *  更新数据
 */
- (void)upLoadData;

@end
