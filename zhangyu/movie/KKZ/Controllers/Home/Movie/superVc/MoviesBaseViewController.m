//
//  MoviesBaseViewController.m
//  KoMovie
//
//  Created by renzc on 16/9/1.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MoviesBaseViewController.h"

@interface MoviesBaseViewController () {
}
@end

@implementation MoviesBaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith,
                               screentHeight - 50 - 44 - self.contentPositionY)
              style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];

  UIView *footer =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
  _tableView.tableFooterView = footer;

  //添加列表数据提示信息
  [self addTableNotice];

  [self setupRefresh];
}

-(void)refreshMovieList
{
    
}

#pragma mark - TableViewDelegate

- (void)configureMovieCell:(MovieListCell *)cell
               atIndexPath:(NSIndexPath *)indexPath {
  if (!self.movieLayoutList || self.movieLayoutList.count <= 0 ||
      indexPath.row > self.movieLayoutList.count) {
    return;
  }

  MovieCellLayout *layout = [self.movieLayoutList objectAtIndex:indexPath.row];
  cell.movieCellLayout = layout;
  [cell updateMovieCell];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (!self.movieLayoutList || self.movieLayoutList.count <= 0 ||
      indexPath.row > self.movieLayoutList.count) {
    return 0;
  }

  if (self.movieLayoutList.count > indexPath.row) {
    MovieCellLayout *layOut =
        [self.movieLayoutList objectAtIndex:indexPath.row];
    return layOut.height;
  } else {
    return 0;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.movieLayoutList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"MovieHomeCellIdentifier";
  _movieCell = (MovieListCell *)[tableView
      dequeueReusableCellWithIdentifier:CellIdentifier];
  if (_movieCell == nil) {
    _movieCell =
        [[MovieListCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:CellIdentifier];
    _movieCell.selectedBackgroundView =
        [[UIView alloc] initWithFrame:_movieCell.frame];
    _movieCell.selectedBackgroundView.backgroundColor =
        [UIColor r:234 g:239 b:243];
    _movieCell.delegate = self;
  }
  return _movieCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //点击跳转之后去掉cell的点击效果
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if (!isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
    NSDate *lastShow =
        [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
    if (!lastShow || [lastShow timeIntervalSinceNow] < -2) {
      UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@""
                    message:@"网络好像有点问题, 稍后再试吧"
                   delegate:nil
          cancelButtonTitle:@"好的"
          otherButtonTitles:nil, nil];
      [alertView show];
      [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                                forKey:kLastShowAlertTime];
    }
    return;
  }
}

#pragma mark 添加列表的提示信息
- (void)addTableNotice {

  _noAlertView = [[AlertViewY alloc]
      initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120,
                               screentWith, 120)];
  _noAlertView.alertLabelText = @"正在查询影片列表，请稍候...";

  [_tableView addSubview:_noAlertView];
}

#pragma mark 集成刷新控件
- (void)setupRefresh {
  [_tableView addHeaderWithTarget:self
                           action:@selector(loadNewData)
                          dateKey:@"table"];
  [_tableView headerBeginRefreshing];
  _tableView.headerPullToRefreshText = @"下拉可以刷新";
  _tableView.headerReleaseToRefreshText = @"松开马上刷新";
  _tableView.headerRefreshingText = @"数据加载中...";
}



-(void)callApiDidSucceed:(id)responseData
{
    [super callApiDidSucceed:responseData];
    
    [appDelegate hideIndicator];

    [self.tableView addSubview:self.noDataView];
    [_tableView headerEndRefreshing];
    [_noAlertView removeFromSuperview];
    
    [self.movieList removeAllObjects];
    [self.movieLayoutList removeAllObjects];
}
-(void)callApiDidFailed:(id)responseData{
    [super callApiDidFailed:responseData];
     [appDelegate hideIndicator];
    
    [_tableView headerEndRefreshing];
    [_noAlertView removeFromSuperview];
    [self.tableView addSubview:self.noDataView];
    [self.movieList removeAllObjects];
    [self.movieLayoutList removeAllObjects];

}


- (void)setTableHeaderView:(UIView *)tableHeaderView {
  _tableHeaderView = tableHeaderView;
  self.tableView.tableHeaderView = tableHeaderView;
}

- (void)loadNewData {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)appBecomeActiveReloadData {
  if (self.movieList.count == 0) {
    [self loadNewData];
  }
}

- (void)startShowMovieTrailer:(NSString *)movieTrailer
                 andMovieName:(NSString *)movieName {
  DLog(@"点击播放预告片");

  if (self.movieVC) {
    DLog(@"self.movieVC 未被销毁");
    return;
  }

  self.movieVC = [[MoviePlayerViewController alloc]
      initNetworkMoviePlayerViewControllerWithURL:
          [NSURL URLWithString:movieTrailer]
                                       movieTitle:movieName];
  self.movieVC.view.frame = CGRectMake(0, 0, screentHeight, screentWith);
  [appDelegate.window addSubview:self.movieVC.view];
  [self.movieVC playerViewDelegateSetStatusBarHiden:YES];

  CGAffineTransform landscapeTransform =
      CGAffineTransformMakeRotation(M_PI * 0.5);

  CGFloat landscapeTransformX = 0;
  if (screentHeight == 480) {
    landscapeTransformX = 80;
  } else if (screentHeight == 667) {
    landscapeTransformX = 146;
  } else if (screentHeight == 568) {
    landscapeTransformX = 124;
  } else if (screentHeight == 736) {
    landscapeTransformX = 161;
  }
  landscapeTransform = CGAffineTransformTranslate(
      landscapeTransform, landscapeTransformX, landscapeTransformX);

  [UIView animateWithDuration:0.2
      animations:^{
        [self.movieVC.view setTransform:landscapeTransform];
      }
      completion:^(BOOL finished){

      }];
  self.movieVC.delegate = self;
}

- (void)movieFinished:(CGFloat)progress {

  CGAffineTransform landscapeTransform =
      CGAffineTransformMakeRotation(0 * M_PI / 180);

  CGFloat landscapeTransformX = 0;
  if (screentHeight == 480) {
    landscapeTransformX = 80;
  } else if (screentHeight == 667) {
    landscapeTransformX = 146;
  } else if (screentHeight == 568) {
    landscapeTransformX = 124;
  } else if (screentHeight == 736) {
    landscapeTransformX = 161;
  }

  [UIView animateWithDuration:0.3
      animations:^{
        [self.movieVC.view setTransform:landscapeTransform];
        self.movieVC.view.alpha = 0.1;
      }
      completion:^(BOOL finished) {

        self.movieVC.delegate = nil;
        [self.movieVC willMoveToParentViewController:nil];
        [self.movieVC.view removeFromSuperview];
        [self.movieVC removeFromParentViewController];
        self.movieVC = nil;
        DLog(@"播放完成，此时的self.movieVC === %@", self.movieVC);
      }];
}
- (void) setRefreshCallback:(void(^)())a_block
{
    self.refreshBlock = a_block;
}

#pragma mark - 懒加载

- (NSMutableArray *)movieList {
  if (!_movieList) {
    _movieList = [NSMutableArray arrayWithCapacity:0];
  }
  return _movieList;
}

- (NSMutableArray *)movieLayoutList {
  if (!_movieLayoutList) {
    _movieLayoutList = [NSMutableArray arrayWithCapacity:0];
  }
  return _movieLayoutList;
}

- (NoDataViewY *)noDataView {

  if (!_noDataView) {
    _noDataView = [[NoDataViewY alloc]
        initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120,
                                 screentWith, 120)];
    _noDataView.alertLabelText = @"未获取到影片列表";
  }
  return _noDataView;
}

@end
