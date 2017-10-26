//
//  电影详情页面演员列表Cell
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActorsPreviewView.h"

@interface ActorCell : UITableViewCell {

    ActorsPreviewView *previewView;
}

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, strong) NSArray *stars;

- (void)updateLayout;

@end
