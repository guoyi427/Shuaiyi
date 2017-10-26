//
//  MatchCell.h
//  Aimeili
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
// 收藏的影片cell，包含三个MyFavUnit

#import "AudioBarView.h"
#import "Favorite.h"

@class MyFavUnit;
@class CollectedMovieCell;

@protocol MatchCellDelegate <NSObject>

- (void)matchCell:(CollectedMovieCell *)cell touchedAtIndex:(NSInteger)index;

@end

@interface CollectedMovieCell : UITableViewCell <UIGestureRecognizerDelegate> {

    MyFavUnit *lUnit, *mUnit, *rUnit;
}

@property (nonatomic, weak) id<MatchCellDelegate> delegate;

@property (nonatomic, assign) BOOL isCollect; // 是否是看过（收藏），还是想看
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) Favorite *lFavorite;
@property (nonatomic, copy) NSNumber *lMovieId;
@property (nonatomic, strong) NSString *lMovieName;
@property (nonatomic, strong) NSString *lImgUrl;
@property (nonatomic, assign) NSInteger lindex;

@property (nonatomic, strong) Favorite *mFavorite;
@property (nonatomic, copy) NSNumber *mMovieId;
@property (nonatomic, strong) NSString *mMovieName;
@property (nonatomic, strong) NSString *mImgUrl;
@property (nonatomic, assign) NSInteger mindex;

@property (nonatomic, strong) Favorite *rFavorite;
@property (nonatomic, copy) NSNumber *rMovieId;
@property (nonatomic, strong) NSString *rMovieName;
@property (nonatomic, strong) NSString *rImgUrl;
@property (nonatomic, assign) NSInteger rindex;

@property (nonatomic, assign) BOOL lShowFront;
@property (nonatomic, assign) BOOL mShowFront;
@property (nonatomic, assign) BOOL rShowFront;

- (void)updateLayout;
- (void)flipLUint;
- (void)flipMUint;
- (void)flipRUint;

@end
