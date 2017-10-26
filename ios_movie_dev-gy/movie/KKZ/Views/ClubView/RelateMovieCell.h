//
//  RelateMovieCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RelatedMovieView;
@class Movie;

@interface RelateMovieCell : UITableViewCell
{
    //相关电影信息
    UIButton *relateMovieViewBg;
    RelatedMovieView *relateMovieV;
}

@property(nonatomic,assign) NSInteger movieId;
@property(nonatomic,strong) Movie *movie;

/**
 *  加载数据
 */
-(void)upLoadData;
@end
