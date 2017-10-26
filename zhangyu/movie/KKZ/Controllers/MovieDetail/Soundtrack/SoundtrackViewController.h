//
//  SoundtrackViewController.h
//  KoMovie
//
//  Created by zhoukai on 13-12-10.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//
//  电影原声页面
//

#import "CommonViewController.h"
#import "MovieMusicCell.h"

@class Movie;

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;
@class AudioPlayer;

@interface SoundtrackViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, MovieMusicCellDelegate> {

    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;

    UITableView *fansListTable;

    UIButton *amlFansBtn, *sinaFansBtn;

    UILabel *noFansAlertLabel;
    BOOL tableLocked, taskFinish;

    AudioPlayer *_audioPlayer;
    NSMutableArray *songsList;
}

@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) NSString *posterPath;

@property (nonatomic, strong) UIImageView *shareImageView;

@end
