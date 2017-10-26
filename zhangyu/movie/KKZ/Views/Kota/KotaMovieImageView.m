//
//  KotaHeadImageView.m
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "Constants.h"
#import "DataEngine.h"
#import "ImageEngine.h"
#import "KKZUser.h"
#import "KotaMovieImageView.h"
#import "KotaTask.h"
#import "Movie.h"
#import "TaskQueue.h"
#import "UserDefault.h"

@interface movieImagePage : UIView {

    UIImageView *headImage;

    UIView *bg;

  @private
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString *imageURL;

- (void)updateLayout;

@end

@implementation movieImagePage

@synthesize imageURL;

- (void)dealloc {
    DLog(@"movieImagePage dealloc");
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];

        bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bg.backgroundColor = [UIColor r:255 g:105 b:0];
        [self addSubview:bg];
        bg.hidden = YES;

        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, frame.size.width - 5, frame.size.height - 5)];
        headImage.image = [UIImage imageNamed:@"post_black_shadow"];
        headImage.clipsToBounds = YES;
        headImage.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:headImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    selected = selected;
    bg.hidden = !selected;
}

- (void)updateLayout {
    [headImage loadImageWithURL:self.imageURL andSize:ImageSizeTiny imgNameDefault:@"post_black_shadow"];
}

@end

@implementation KotaMovieImageView {
    NSMutableArray *headImageGallaries;
    UILabel *noImageLabel;
}

@synthesize delegate;

- (void)dealloc {
    if (movieImageListView)
        [movieImageListView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        highlightRow = -1;
        headImageWidth = 70; //更改此处，自动改变ui大小
        headImageHeight = 100;

        headImageGallaries = [[NSMutableArray alloc] init];
        movieImageListView = [[HorizonTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        movieImageListView.datasource = self;
        movieImageListView.delegate = self;
        [movieImageListView setTableBackgroundColor:[UIColor clearColor]];
        [movieImageListView showsHorizontalScrollIndicator:YES];
        [self addSubview:movieImageListView];
        [movieImageListView reloadData];
    }

    return self;
}

- (void)updateLayout {

    if (self.wantSee) {

        [headImageGallaries removeAllObjects];

        [headImageGallaries addObject:self.wantSeeMovie];

        if ([headImageGallaries count]) {

            [movieImageListView reloadData];
            [movieImageListView resetRefreshStatusAndHideLoadMore:YES];
            movieImageListView.hidden = NO;

            noImageLabel.hidden = YES;

        } else {
            movieImageListView.hidden = YES;
            noImageLabel.text = @"未成功加载影片";
            noImageLabel.hidden = NO;
        }

        highlightRow = 0;

        movieImagePage *imagePage = (movieImagePage *) [movieImageListView cellAtIndex:0];

        imagePage.selected = YES;

    } else {

        [self refreshMovieList];
    }
}

- (void)refreshIncomingMovieList {

    currentPage = 1;
    
    MovieRequest *request = [MovieRequest new];
    [request requestMoviesWithCityId:[NSNumber numberWithInt:USER_CITY].stringValue page:currentPage success:^(NSArray * _Nullable movieList) {
        
         [appDelegate hideIndicator];
        
        [headImageGallaries addObjectsFromArray:movieList];
        
        if ([headImageGallaries count]) {
            
            [movieImageListView reloadData];
            [movieImageListView resetRefreshStatusAndHideLoadMore:YES];
            movieImageListView.hidden = NO;
            
            noImageLabel.hidden = YES;
            
        } else {
            movieImageListView.hidden = YES;
            
            noImageLabel.text = @"未成功加载影片";
            noImageLabel.hidden = NO;
        }
        
    } failure:^(NSError * _Nullable err) {
         [appDelegate hideIndicator];
         [movieImageListView resetRefreshStatusAndHideLoadMore:YES];
    }];
}

- (void)refreshMovieList {

    currentPage = 1;

    if (USER_CITY) {
        //查询约电影列表 删除
    }
}

#pragma notification handler

- (void)movieListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    DLog(@"movie list finished");

    [appDelegate hideIndicator];

    if (currentPage == 1) {

        [headImageGallaries removeAllObjects];
    }

    if (succeeded) {

        NSArray *sections = [userInfo objectForKey:@"movielists"];

        [headImageGallaries addObjectsFromArray:sections];

        if ([headImageGallaries count]) {

            [movieImageListView reloadData];
            [movieImageListView resetRefreshStatusAndHideLoadMore:YES];
            movieImageListView.hidden = NO;

            noImageLabel.hidden = YES;

        } else {
            movieImageListView.hidden = YES;

            noImageLabel.text = @"未成功加载影片";
            noImageLabel.hidden = NO;
        }

        //        [self refreshIncomingMovieList];

    } else {

        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma horizon table view delegate
- (BOOL)shouldRefreshHorizonTableView:(HorizonTableView *)tableView {
    return YES;
}

- (void)refreshHorizonTableView:(HorizonTableView *)tableView {
    [self updateLayout];
}

- (void)horizonTableView:(HorizonTableView *)tableView loadHeavyDataForCell:(UIView *)cell atIndex:(int)index {
    movieImagePage *page = (movieImagePage *) cell;
    [page updateLayout];
}

#pragma mark horizon table view datasource
- (void)horizonTableView:(HorizonTableView *)tableView configureCell:(id)cell atIndex:(int)index {
    movieImagePage *page = (movieImagePage *) cell;

    Movie *movie = headImageGallaries[index];

    if (highlightRow == index) {
        page.selected = YES;
    } else {
        page.selected = NO;
    }

    @try {
        if (movie.thumbPath.length) {
            page.imageURL = movie.thumbPath;
        } else {
            page.imageURL = movie.pathVerticalS;
        }

        [page updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (NSInteger)rowWidthForHorizonTableView:(HorizonTableView *)tableView {
    return headImageWidth + 3;
}

- (NSInteger)numberOfRowsInHorizonTableView:(HorizonTableView *)tableView {
    return headImageGallaries.count;
}

- (UIView *)horizonTableView:(HorizonTableView *)tableView cellForRowAtIndex:(int)index {
    movieImagePage *cell = (movieImagePage *) [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[movieImagePage alloc] initWithFrame:CGRectMake(0, 0, headImageWidth, headImageHeight)];
    }
    [self horizonTableView:tableView configureCell:cell atIndex:index];

    return cell;
}

- (void)horizonTableView:(HorizonTableView *)tableView didSelectRowAtIndex:(int)index {

    DLog(@"你选择了一部电影,开始约会吧 ~ ~");
    highlightRow = index;

    Movie *movie = headImageGallaries[index];

    for (int i = 0; i < headImageGallaries.count; i++) {

        movieImagePage *imagePage = (movieImagePage *) [tableView cellAtIndex:i];
        if (movie.thumbPath.length) {
            if ([movie.thumbPath isEqualToString:imagePage.imageURL]) {
                imagePage.selected = NO;
            } else {
                imagePage.selected = YES;
            }
        } else {
            if ([movie.pathVerticalS isEqualToString:imagePage.imageURL]) {
                imagePage.selected = NO;
            } else {
                imagePage.selected = YES;
            }
        }
    }

    [movieImageListView reloadData];

    self.movieId = movie.movieId;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kotaMovieId" object:nil userInfo:[NSDictionary dictionaryWithObject:self.movieId forKey:@"movirId"]];
}

@end
