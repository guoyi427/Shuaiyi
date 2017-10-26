//
//  KotaHeadImageView.m
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

// 约电影首页 header 横向头像列表

#import "DataEngine.h"
#import "FriendHomeViewController.h"
#import "ImageEngine.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "KotaHeadImageView.h"
#import "KotaTask.h"
#import "TaskQueue.h"
#import "UIConstants.h"

#define kUserImagePaddingLeft 10
#define kUserImagePaddingTop 15

//头像宽高
static NSInteger headImageWidth = 45;
static NSInteger headImageHeight = 45;

@interface headImagePage : UIView {

    UIImageView *headImage;

  @private
}

@property (nonatomic, strong) NSString *imageURL;

- (void)updateLayout;

@end

@implementation headImagePage

@synthesize imageURL;

- (void)dealloc {
    DLog(@"headImagePage dealloc");
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUserImagePaddingLeft, kUserImagePaddingTop, headImageWidth, headImageHeight)];

        headImage.image = [UIImage imageNamed:@"avatarSImg"];
        CALayer *l = headImage.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:6.0];

        headImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:headImage];
    }
    return self;
}

- (void)updateLayout {
    [headImage loadImageWithURL:self.imageURL andSize:ImageSizeTiny imgNameDefault:@"avatarSImg"];
}
@end

@implementation KotaHeadImageView {
    NSMutableArray *headImageGallaries;
    UILabel *noImageLabel;
}

@synthesize delegate;

- (void)dealloc {
    if (headImageListView)
        [headImageListView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        headImageGallaries = [[NSMutableArray alloc] init];
        headImageListView = [[HorizonTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        headImageListView.datasource = self;
        headImageListView.delegate = self;
        [headImageListView setTableBackgroundColor:[UIColor clearColor]];
        [headImageListView showsHorizontalScrollIndicator:YES];
        [self addSubview:headImageListView];
        [headImageListView reloadData];

        noImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith, frame.size.height)];
        noImageLabel.backgroundColor = [UIColor clearColor];
        noImageLabel.textColor = [UIColor grayColor];
        noImageLabel.textAlignment = NSTextAlignmentCenter;
        noImageLabel.font = [UIFont systemFontOfSize:kTextSizeContent];
        noImageLabel.text = @"正在加载，请稍候...";
        [self addSubview:noImageLabel];
    }
    return self;
}

- (void)updateLayout {

    KotaTask *task = [[KotaTask alloc] initKotaHeadImageListByCityId:@""
                                                                page:1
                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                [self headImageGalleryFinished:userInfo status:succeeded];
                                                            }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark handle notifications
- (void)headImageGalleryFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        headImageGallaries = userInfo[@"kotaUsers"];

        if ([headImageGallaries count]) {

            [headImageListView reloadData];
            [headImageListView resetRefreshStatusAndHideLoadMore:YES];
            headImageListView.hidden = NO;

            noImageLabel.hidden = YES;

        } else {

            headImageListView.hidden = YES;

            noImageLabel.text = @"亲，还没有人约电影哦，快来参与吧";
            noImageLabel.hidden = NO;
        }

    } else {
        [headImageListView resetRefreshStatusAndHideLoadMore:YES];
        DLog(@"headImage gallery failed");
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
    headImagePage *page = (headImagePage *) cell;
    [page updateLayout];
}

#pragma mark horizon table view datasource
- (void)horizonTableView:(HorizonTableView *)tableView configureCell:(id)cell atIndex:(int)index {
    headImagePage *page = (headImagePage *) cell;

    KKZUser *user = headImageGallaries[index];

    @try {
        page.imageURL = user.headImg;
        [page updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (NSInteger)rowWidthForHorizonTableView:(HorizonTableView *)tableView {
    return headImageWidth + 7;
}

- (NSInteger)numberOfRowsInHorizonTableView:(HorizonTableView *)tableView {
    return headImageGallaries.count;
}

- (UIView *)horizonTableView:(HorizonTableView *)tableView cellForRowAtIndex:(int)index {
    headImagePage *cell = (headImagePage *) [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[headImagePage alloc] initWithFrame:CGRectMake(0, 0, headImageWidth, headImageHeight)];
    }
    [self horizonTableView:tableView configureCell:cell atIndex:index];

    return cell;
}

- (void)horizonTableView:(HorizonTableView *)tableView didSelectRowAtIndex:(int)index {

    if (![[NetworkUtil me] reachable]) {
        return;
    }
    KKZUser *user = headImageGallaries[index];
    FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
    ctr.userId = user.userId;
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

@end
