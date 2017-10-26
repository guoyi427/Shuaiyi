//
//  RelatedMovieView.h
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface RelatedMovieView : UIView {
    //电影海报
    UIImageView *moivePosterView;
    //电影标题
    UILabel *movieTitleLbl;
    //电影得分
    UIView *moviePointView;
    //电影简短介绍
    UILabel *movieSubTitle;
    //电影上映日期
    UILabel *moviePlanDate;
    //评分星星
    RatingView *starView;
    
    UILabel *moviePointLbl;
}

/**
 *  加载数据
 */
- (void)upLoadData;

/**
 *  电影海报
 */
@property (nonatomic, copy) NSString *moviePath;
/**
 *  电影标题
 */
@property (nonatomic, copy) NSString *movieTitle;
/**
 *  电影得分
 */
@property (nonatomic, strong) NSNumber *moviePoint;
/**
 *  电影的简短介绍
 */
@property (nonatomic, copy) NSString *movieSubTitle;
/**
 *  电影上映日期
 */
@property (nonatomic, copy) NSString *movieDate;
@end
