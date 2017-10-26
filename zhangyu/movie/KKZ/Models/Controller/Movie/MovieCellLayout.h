//
//  MovieCellLayout.h
//  KoMovie
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Movie;

@interface MovieCellLayout : NSObject

/**
 *  电影
 */
@property (nonatomic, strong) Movie *movie;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  cell的高度
 */
@property (nonatomic, assign) BOOL isIncoming;

/**
 *  电影海报的frame
 */
@property (nonatomic, assign) CGRect moviePostFrame;

/**
 *  电影播放按钮的frame
 */
@property (nonatomic, assign) CGRect moviePlayFrame;

/**
 *  电影名称的frame
 */
@property (nonatomic, assign) CGRect movieNameFrame;

/**
 *  电影名称的font
 */
@property (nonatomic, assign) CGFloat movieNameFont;

/**
 *  电影标签的frame数组
 */
@property (nonatomic, strong) NSMutableArray *movieFlagFrameArrY;

/**
 *  电影标签image的数组
 */
@property (nonatomic, strong) NSMutableArray *movieFlagImageArrY;

/**
 *  人为添加电影标签的frame数组
 */
@property (nonatomic, strong) NSMutableArray *movieFlagFrameArr;

/**
 *  人为添加电影标签image的数组
 */
@property (nonatomic, strong) NSMutableArray *movieFlagImageArr;
/**
 *  人为添加电影标签的font
 */
@property (nonatomic, assign) CGFloat movieFlagFontY;

/**
 *  电影标签的font
 */
@property (nonatomic, assign) CGFloat shortTitleFont;

/**
 *  电影描述的frame
 */
@property (nonatomic, assign) CGRect movieDescribeFrame;

/**
 *  电影描述的font
 */
@property (nonatomic, assign) CGFloat movieDescribeFont;

/**
 *  电影详情
 */
@property (nonatomic, copy) NSString *movieDetailInfo;

/**
 *  电影详情的font
 */
@property (nonatomic, assign) CGFloat movieDetailInfoFont;

/**
 *  电影详情的frame
 */
@property (nonatomic, assign) CGRect movieDetailInfoFrame;

/**
 *  购票、预售、简介 按钮的frame
 */
@property (nonatomic, assign) CGRect buyBtnFrame;

/**
 *  购票、预售、简介 按钮的title
 */
@property (nonatomic, copy) NSString *buyBtnTitle;

/**
 *  得分、多少人想看num的frame
 */
@property (nonatomic, assign) CGRect movieScoreNumFrame;

/**
 *  得分、多少人想看num的font
 */
@property (nonatomic, assign) CGFloat movieScoreNumFont;

/**
 *  得分、多少人想看num
 */
@property (nonatomic, copy) NSString *movieScoreNum;

/**
 *  分、人想看lbl的frame
 */
@property (nonatomic, assign) CGRect movieScoreTextFrame;

/**
 *  分、人想看lbl的
 */
@property (nonatomic, copy) NSString *movieScoreText;

/**
 *  分、人想看lbl的Font
 */
@property (nonatomic, assign) CGFloat movieScoreTextFont;

/**
 *  电影活动的frame数组
 */
@property (nonatomic, strong) NSMutableArray *movieActivityFrameArr;

/**
 *  更新MovieCellLayout
 */
- (void)updateMovieCellLayout;

@end
