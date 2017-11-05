//
//  电影详情页面演员横向滚动的列表
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "Actor.h"
#import "ActorDetailViewController.h"
#import "ActorsPreviewView.h"
#import "CommonViewController.h"
#import "ImageEngine.h"
#import "KKZUtility.h"
#import "MovieDBTask.h"
#import "TaskQueue.h"
#import "UIColorExtra.h"
#import "UIImageVIew+WebURL.h"

#define previewImageWidth 80
#define previewImageHeight 123
#define actorNameLblFont 13
#define actorPositionFont 12
#define actorNameLblHeight 30

@interface ActorImagePageYN : UIView {

    UIImageView *previewImage;
    UILabel *actorNameLbl;
    UILabel *actorPosition;
}

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) unsigned int actorId;
@property (nonatomic, strong) NSString *actorName;
@property (nonatomic, strong) NSString *actorPositionStr;

- (void)updateLayout;

@end

@implementation ActorImagePageYN
@synthesize imageURL;
@synthesize actorId;
@synthesize actorName;
@synthesize actorPositionStr;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, previewImageWidth, previewImageWidth)];
        previewImage.clipsToBounds = YES;
        previewImage.contentMode = UIViewContentModeScaleAspectFill;
        [previewImage setBackgroundColor:[UIColor whiteColor]];
        previewImage.layer.cornerRadius = 5.0;
        previewImage.layer.masksToBounds = true;
        [self addSubview:previewImage];

        actorNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previewImage.frame), previewImageWidth, actorNameLblHeight)];
        actorNameLbl.textColor = [UIColor r:51 g:51 b:51];
        actorNameLbl.textAlignment = NSTextAlignmentCenter;
        actorNameLbl.font = [UIFont systemFontOfSize:actorNameLblFont];
        [self addSubview:actorNameLbl];

        actorPosition = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(actorNameLbl.frame), previewImageWidth, actorPositionFont)];
        actorPosition.textColor = [UIColor r:51 g:51 b:51];
        actorPosition.textAlignment = NSTextAlignmentCenter;
        actorPosition.font = [UIFont systemFontOfSize:actorPositionFont];
        [self addSubview:actorPosition];
    }
    return self;
}

- (void)updateLayout {
    [previewImage loadImageWithURL:self.imageURL andSize:ImageSizeTiny];
    actorNameLbl.text = self.actorName;
    if (self.actorPositionStr.length) {
        actorPosition.text = [NSString stringWithFormat:@"饰：%@", self.actorPositionStr];
    } else {
        actorPosition.text = @"";
    }
}

@end

@implementation ActorsPreviewView {

    UILabel *noImageLabel;
}

@synthesize actors;

- (void)dealloc {
    if (postListView)
        [postListView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        actors = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        postListView = [[HorizonTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        postListView.datasource = self;
        postListView.delegate = self;
        [postListView setTableBackgroundColor:[UIColor clearColor]];
        [postListView showsHorizontalScrollIndicator:NO];
        [self addSubview:postListView];
    }
    return self;
}

#pragma horizon table view delegate

- (void)horizonTableView:(HorizonTableView *)tableView loadHeavyDataForCell:(UIView *)cell atIndex:(int)index {
    ActorImagePageYN *page = (ActorImagePageYN *) cell;
    [page updateLayout];
}

#pragma mark horizon table view datasource
- (void)horizonTableView:(HorizonTableView *)tableView configureCell:(id)cell atIndex:(int)index {
    ActorImagePageYN *page = (ActorImagePageYN *) cell;

    Actor *actor = actors[index];

    @try {
        page.imageURL = actor.imageSmall;
        page.actorId = actor.starId;
        page.actorName = actor.chineseName;
        page.actorPositionStr = actor.character;
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
    return actors.count;
}

- (UIView *)horizonTableView:(HorizonTableView *)tableView cellForRowAtIndex:(int)index {
    ActorImagePageYN *cell = (ActorImagePageYN *) [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[ActorImagePageYN alloc] initWithFrame:CGRectMake(0, 0, actorImageWidth, actorImageHeight)];
    }
    [self horizonTableView:tableView configureCell:cell atIndex:index];

    return cell;
}

- (void)horizonTableView:(HorizonTableView *)tableView didSelectRowAtIndex:(int)index {
    return;
    ActorImagePageYN *cell = [tableView cellAtIndex:index];

    @try {
        ActorDetailViewController *ctr = [[ActorDetailViewController alloc] init];
        ctr.userId = cell.actorId;
        ctr.actorD = actors[index];
        
//        ctr.actorD = [Actor getActorWithId:cell.actorId];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
    @catch (NSException *exception) {

    }
    @finally {
    }
}

- (void)refreshActorListwith:(unsigned int)movieId {
    [postListView reloadData];
}

#pragma mark handle notifications
- (void)actorListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    if (succeeded) {
        self.actors = (NSMutableArray *) [userInfo objectForKey:@"actors"];
        [postListView reloadData];
    }
}

@end
