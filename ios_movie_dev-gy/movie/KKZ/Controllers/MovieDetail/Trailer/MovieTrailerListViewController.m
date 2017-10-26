//
//  电影详情 - 预告片列表页面
//
//  Created by KKZ on 16/3/2.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieTrailerListViewController.h"

#import "Movie.h"
#import "MovieTask.h"
#import "MovieTrailerCell.h"
#import "TaskQueue.h"
#import "Trailer.h"
#import "Movie.h"

#define marginX 15
#define marginY 15

#define myCellIndifier @"MovieTrailerCell"

@implementation MovieTrailerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.kkzTitleLabel.text = self.movie.movieName;

    UICollectionViewFlowLayout *flowLauout = [[UICollectionViewFlowLayout alloc] init];
    flowLauout.sectionInset = UIEdgeInsetsZero;

    flowLauout.itemSize = CGSizeMake((screentWith - marginX * 3) * 0.5, (screentWith - marginX * 3) * 0.5 / 16 * 9);

    //添加横向滚动列表
    movieTrailerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - self.contentPositionY + 44)
                                          collectionViewLayout:flowLauout];
    movieTrailerView.contentInset = UIEdgeInsetsMake(marginY, marginX, marginY, marginX);
    movieTrailerView.delegate = self;
    movieTrailerView.dataSource = self;

    [movieTrailerView registerClass:[MovieTrailerCell class]
            forCellWithReuseIdentifier:myCellIndifier];

    [self.view addSubview:movieTrailerView];

    [movieTrailerView setBackgroundColor:[UIColor whiteColor]];
    [self refreshFansList];

    self.videoSource = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithMovie:self.movie] action:AnalyticsActionVideo_list];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Trailer *trailer = [self.videoSource objectAtIndex:indexPath.row];

    MovieTrailerCell *cell = [movieTrailerView
            dequeueReusableCellWithReuseIdentifier:myCellIndifier
                                      forIndexPath:indexPath];
    cell.trailer = trailer;

    if (trailer.trailerCover.length) {
        cell.imagePath = trailer.trailerCover;
    } else {
        if (self.movie.thumbPath.length) {
            cell.imagePath = self.movie.thumbPath;
        } else {
            cell.imagePath = self.movie.pathVerticalS;
        }
    }
    [cell upLoadData];
    return cell;
}

#pragma mark utilities
- (void)refreshFansList {
    currentPage = 1;

    MovieTask *task = [[MovieTask alloc]
            initMovieTrailerWithMovieId:self.movie.movieId.unsignedIntValue
                               finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                   [self trailerListFinished:userInfo status:succeeded];
                               }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark handle notifications
- (void)trailerListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"fans list finished");

    if (succeeded) {
        if (currentPage == 1) {
            [self.videoSource removeAllObjects];
        }

        NSArray *trailers = [userInfo objectForKey:@"trailerList"];
        [self.videoSource addObjectsFromArray:trailers];

        [movieTrailerView reloadData];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

@end
