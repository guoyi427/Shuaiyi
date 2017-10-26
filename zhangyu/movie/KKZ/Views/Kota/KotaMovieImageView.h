//
//  KotaHeadImageView.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "HorizonTableView.h"
#import "Movie.h"

@protocol KotaMovieImageViewDelegate <NSObject>
@optional
- (void)viewAllStillsForHead;
@end

@interface KotaMovieImageView : UIView <HorizonTableViewDatasource, HorizonTableViewDelegate> {

    HorizonTableView *movieImageListView;
    int currentPage;
    //头像宽高
    NSInteger headImageWidth; //更改此处，自动改变ui大小
    NSInteger headImageHeight;
    NSInteger highlightRow;
}

@property (nonatomic, weak) id<KotaMovieImageViewDelegate> delegate;
@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) BOOL wantSee;
@property (nonatomic, strong) Movie *wantSeeMovie;

- (id)initWithFrame:(CGRect)frame;
- (void)updateLayout;

@end
