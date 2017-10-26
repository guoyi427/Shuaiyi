//
//  演员详情页面电影列表Cell
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class ActorMovieUnit;
@class ActorMovieCell;

@protocol ActorMovieCellDelegate <NSObject>

- (void)matchCell:(ActorMovieCell *)cell touchedAtIndex:(NSInteger)index;

@end

@interface ActorMovieCell : UITableViewCell <UIGestureRecognizerDelegate> {

    ActorMovieUnit *lUnit, *mUnit, *rUnit;
}

@property (nonatomic, weak) id<ActorMovieCellDelegate> delegate;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger lMovieId;
@property (nonatomic, strong) NSString *lMovieName;
@property (nonatomic, strong) NSString *lImgUrl;

@property (nonatomic, assign) NSInteger mMovieId;
@property (nonatomic, strong) NSString *mMovieName;
@property (nonatomic, strong) NSString *mImgUrl;

@property (nonatomic, assign) NSInteger rMovieId;
@property (nonatomic, strong) NSString *rMovieName;
@property (nonatomic, strong) NSString *rImgUrl;

- (void)updateLayout;

@end
