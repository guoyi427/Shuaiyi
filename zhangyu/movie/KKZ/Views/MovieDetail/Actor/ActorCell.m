//
//  电影详情页面演员列表Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActorCell.h"

static const CGFloat kMarginX = 15;
static const CGFloat kActorPreviewViewHeight = 165;

@implementation ActorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        previewView = [[ActorsPreviewView alloc] initWithFrame:CGRectMake(kMarginX, 0, screentWith - kMarginX, kActorPreviewViewHeight)];
        previewView.clipsToBounds = YES;
        previewView.backgroundColor = [UIColor clearColor];
        [self addSubview:previewView];
    }
    return self;
}

- (void)dealloc {
    if (previewView) {
        [previewView removeFromSuperview];
    }
}

- (void)updateLayout {
    previewView.actors = self.stars;
    [previewView refreshActorListwith:self.movieId.unsignedIntValue];
}

@end
