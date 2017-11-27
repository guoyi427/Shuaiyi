//
//  电影原声列表页面
//
//  Created by zhoukai on 13-12-10.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "SoundtrackViewController.h"

#import "AudioPlayer.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "Movie.h"
#import "MovieDBTask.h"
#import "MovieSong.h"
#import "MovieTask.h"
#import "ShareView.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "UrlOpenUtility.h"
#import "NSStringExtra.h"

#import "Movie.h"

@implementation SoundtrackViewController

#pragma mark - Lifecycle methods

- (void)dealloc {
    fansListTable.dataSource = nil;
    fansListTable.delegate = nil;
    if (fansListTable)
        [fansListTable removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"电影原声";

    currentPage = 1;
    songsList = [[NSMutableArray alloc] initWithCapacity:0];

    tableLocked = NO;

    [self refreshFansList];

    fansListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
    fansListTable.delegate = self;
    fansListTable.dataSource = self;
    fansListTable.backgroundColor = [UIColor clearColor];
    fansListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansListTable];

    noFansAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, screentWith - 10 * 2, 60)];
    noFansAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noFansAlertLabel.textColor = [UIColor grayColor];
    noFansAlertLabel.backgroundColor = [UIColor clearColor];
    noFansAlertLabel.textAlignment = NSTextAlignmentCenter;
    noFansAlertLabel.numberOfLines = 0;

    if (self.movie.thumbPath.length) {
        self.posterPath = self.movie.thumbPath;
    } else {
        self.posterPath = self.movie.pathVerticalS;
    }

    refreshHeaderView = [[EGORefreshTableHeaderView alloc]
            initWithFrame:CGRectMake(0, -fansListTable.bounds.size.height, screentWith, fansListTable.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [fansListTable addSubview:refreshHeaderView];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    fansListTable.tableFooterView = showMoreFooterView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    KKZAnalyticsEvent *event = [[KKZAnalyticsEvent alloc] initWithMovie:self.movie];
    [KKZAnalytics postActionWithEvent:event action:AnalyticsActionMusic_list];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_audioPlayer stop];
}

#pragma mark - Override from CommonViewController
- (BOOL)showTopbar {
    return YES;
}

- (BOOL)showBackgroundView {
    return NO;
}

#pragma mark utilities

- (void)refreshFansList {
    currentPage = 1;
    MovieTask *task = [[MovieTask alloc]
            initMovieSongsWithMovieId:self.movie.movieId.unsignedIntValue
                             finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                 [self fansListFinished:userInfo status:succeeded];
                             }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        if (refreshHeaderView.state != EGOOPullRefreshLoading) {
            [refreshHeaderView setState:EGOOPullRefreshLoading];
        }
        tableLocked = currentPage == 1;
    }
}

- (void)showMoreFans {
    currentPage++;

    MovieTask *task = [[MovieTask alloc]
            initMovieSongsWithMovieId:self.movie.movieId.unsignedIntValue
                             finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                 [self fansListFinished:userInfo status:succeeded];
                             }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)playAudio:(AudioButton *)button {
    NSInteger index = button.tag;
    MovieSong *managedObject = [songsList objectAtIndex:index];

    if (_audioPlayer == nil) {
        _audioPlayer = [AudioPlayer sharedAudioPlayer];
        [_audioPlayer stop];
    }

    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];

        _audioPlayer.button = button;
        _audioPlayer.url = [NSURL URLWithString:managedObject.songUrl];

        [_audioPlayer play];
    }
}

#pragma mark handle notifications
- (void)fansListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"fans list finished");

    [appDelegate hideIndicator];
    [self resetRefreshHeader];
    showMoreFooterView.isLoading = NO;
    tableLocked = NO;
    taskFinish = YES;
    if (succeeded) {
        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
        if (!hasMore)
            showMoreFooterView.hasNoMore = YES;
        else
            showMoreFooterView.hasNoMore = NO;
        if (currentPage == 1) {
            [songsList removeAllObjects];
        }
        id song = [userInfo objectForKey:@"songsM"];
        [songsList addObjectsFromArray:song];

        if (songsList.count == 0) {
            showMoreFooterView.hidden = YES;
        }

        [fansListTable reloadData];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];

        showMoreFooterView.hasNoMore = YES;
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                fansListTable.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {

                [refreshHeaderView setState:EGOOPullRefreshNormal];
                if (fansListTable.contentOffset.y <= 0) {
                    [fansListTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self showMoreFans];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading || showMoreFooterView.isLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65) {
        [self performSelector:@selector(refreshFansList) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - MovieMusicCell delegate
- (void)handleTouchOnShareAtRow:(NSInteger)row withSong:(MovieSong *)song withImage:(UIImage *)image {

    self.shareImageView = [[UIImageView alloc] init];
    if (self.movie.thumbPath.length) {
        [self.shareImageView loadImageWithURL:self.movie.thumbPath andSize:ImageSizeSmall];
    } else {
        [self.shareImageView loadImageWithURL:self.movie.pathVerticalS andSize:ImageSizeSmall];
    }

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.userShareInfo = @"movieSong";
    NSString *shareUrl = nil;
    if ([DataEngine sharedDataEngine].userId && [[DataEngine sharedDataEngine].userId length]) {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%d&userId=%@", kAppShareHTML5Url, @"5", song.songId, [DataEngine sharedDataEngine].userId];
    } else {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%d", kAppShareHTML5Url, @"5", song.songId];
    }

    NSString *content = [NSString stringWithFormat:@"我分享了《%@》中的原声音乐大碟：%@-%@，查看歌曲内容：%@。更多精彩，尽在【章鱼电影客户端】", self.movie.movieName, song.singer, song.songName, shareUrl];
    NSString *contentQQSpace = [NSString stringWithFormat:@"我分享了《%@》中的原声音乐大碟：%@-%@，查看歌曲内容：%@。更多精彩，尽在【章鱼电影客户端】", self.movie.movieName, song.singer, song.songName, shareUrl];
    NSString *contentWeChat = [NSString stringWithFormat:@"我分享了《%@》中的原声音乐大碟：%@-%@。", self.movie.movieName, song.singer, song.songName];

    NSString *str;
    if (self.movie.thumbPath.length) {
        str = self.movie.thumbPath;
    } else {
        str = self.movie.pathVerticalS;
    }

    [poplistview updateWithcontent:content
                     contentWeChat:contentWeChat
                    contentQQSpace:contentQQSpace
                             title:@"章鱼电影"
                         imagePath:self.shareImageView.image
                          imageURL:str
                               url:shareUrl
                          soundUrl:song.songUrl
                          delegate:self
                         mediaType:SSPublishContentMediaTypeMusic
                    statisticsType:0
                         shareInfo:[NSString stringWithFormat:@"%d", song.songId]
                         sharedUid:[DataEngine sharedDataEngine].userId];
    [poplistview show];
}

#pragma mark - Table View Data Source
- (void)configureCell:(MovieMusicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MovieSong *managedObject = [songsList objectAtIndex:indexPath.row];
    @try {
        cell.song = managedObject;
        cell.avatarUrl = self.posterPath;
        cell.name = managedObject.songName;
        cell.musicType = managedObject.songType;
        cell.musicPlayer = managedObject.singer;
        cell.row = indexPath.row;
        cell.audioButton.tag = indexPath.row;
        [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [cell updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    MovieMusicCell *cell = (MovieMusicCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MovieMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configurePlayerButton];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (taskFinish) {
        if ([songsList count] == 0) {
            [fansListTable addSubview:noFansAlertLabel];
        } else {
            [noFansAlertLabel removeFromSuperview];
        }
        taskFinish = NO;
    }
    return [songsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
