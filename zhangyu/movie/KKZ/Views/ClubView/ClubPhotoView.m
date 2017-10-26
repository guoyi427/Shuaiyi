//
//  ClubPhotoView.m
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPhotoView.h"
#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ImageEngine.h"
#import "KKZUtility.h"
#import "MovieStillScrollViewController.h"
#import "TaskQueue.h"
#import "UIColorExtra.h"
#import "UIImageVIew+WebURL.h"

@interface ClubImagePageYN : UIView {
    UIImageView *previewImage;
}

@property (nonatomic, strong) NSString *imageURL;

- (void)updateLayout;

@end

@implementation ClubImagePageYN
@synthesize imageURL;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, actorImageWidth, actorImageHeight)];
        previewImage.clipsToBounds = YES;
        previewImage.layer.cornerRadius = 2;
        previewImage.contentMode = UIViewContentModeScaleAspectFill;
        [previewImage setBackgroundColor:[UIColor whiteColor]];

        [self addSubview:previewImage];
    }
    return self;
}

- (void)updateLayout {
    [previewImage loadImageWithURL:self.imageURL andSize:ImageSizeTiny imgNameDefault:@"clubPostImage"];
}

@end

@implementation ClubPhotoView {

    UILabel *noImageLabel;
}

@synthesize photos;

- (void)dealloc {
    if (postListView)
        [postListView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        postListView = [[HorizonTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        postListView.datasource = self;
        postListView.delegate = self;
        [postListView setTableBackgroundColor:[UIColor clearColor]];
        [postListView showsHorizontalScrollIndicator:YES];
        [self addSubview:postListView];
    }
    return self;
}

#pragma horizon table view delegate

- (void)horizonTableView:(HorizonTableView *)tableView loadHeavyDataForCell:(UIView *)cell atIndex:(int)index {
    ClubImagePageYN *page = (ClubImagePageYN *) cell;
    [page updateLayout];
}

#pragma mark horizon table view datasource
- (void)horizonTableView:(HorizonTableView *)tableView configureCell:(id)cell atIndex:(int)index {
    ClubImagePageYN *page = (ClubImagePageYN *) cell;

    //    Photo *photo = photos[index];

    @try {
        page.imageURL = photos[index];
        [page updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (NSInteger)rowWidthForHorizonTableView:(HorizonTableView *)tableView {
    return actorImageWidth + 3;
}

- (NSInteger)numberOfRowsInHorizonTableView:(HorizonTableView *)tableView {
    return photos.count;
}

- (UIView *)horizonTableView:(HorizonTableView *)tableView cellForRowAtIndex:(int)index {
    ClubImagePageYN *cell = (ClubImagePageYN *) [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[ClubImagePageYN alloc] initWithFrame:CGRectMake(0, 0, actorImageWidth, actorImageHeight)];
    }
    [self horizonTableView:tableView configureCell:cell atIndex:index];

    return cell;
}

- (void)horizonTableView:(HorizonTableView *)tableView didSelectRowAtIndex:(int)index {

    ClubPostPictureViewController *postDetail = [[ClubPostPictureViewController alloc] init];
    postDetail.articleId = self.post.articleId;
    //    postDetail.postType = clubPost.type;
    //    postDetail.clubPost = clubPost;
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:postDetail animation:CommonSwitchAnimationBounce];
}
- (void)reloadData {
    [postListView reloadData];
}
@end
