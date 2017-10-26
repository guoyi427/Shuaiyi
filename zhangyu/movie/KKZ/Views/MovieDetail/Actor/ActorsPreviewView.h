//
//  电影详情页面演员横向滚动的列表
//
//  Created by KKZ on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "HorizonTableView.h"

static const NSInteger actorImageWidth = 80; // 演员列表cell的宽
static const NSInteger actorImageHeight = 123; // 演员列表cell的高

@interface ActorsPreviewView : UIView <HorizonTableViewDatasource, HorizonTableViewDelegate> {

    HorizonTableView *postListView;
    NSInteger currentPage; //演员列表分页
}

@property (nonatomic, strong) NSArray *actors;

- (void)refreshActorListwith:(unsigned int)movieId;

@end
