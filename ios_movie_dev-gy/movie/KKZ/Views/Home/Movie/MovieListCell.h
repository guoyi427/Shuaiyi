//
//  首页 - 电影列表的Cell
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

typedef enum {
    MovieListFlagType = 1000,
    MovieListShortTitleType,
    MoviePosterFlagType,
} ListFlagType;

@class MovieCellLayout;

@protocol StartShowMovieTrailerDelegate <NSObject>

- (void)startShowMovieTrailer:(NSString *)movieTrailer andMovieName:(NSString *)movieName;

@end

@interface MovieListCell : UITableViewCell

/**
 *  电影
 */
@property (nonatomic, strong) MovieCellLayout *movieCellLayout;

@property (nonatomic, weak) id<StartShowMovieTrailerDelegate> delegate;

/**
 *  加载影片信息
 */
- (void)updateMovieCell;

/**
 右侧按钮点击回调

 @param a_block 回调
 */
- (void) rightButtonClickCallback:( void (^)())a_block;

@end
