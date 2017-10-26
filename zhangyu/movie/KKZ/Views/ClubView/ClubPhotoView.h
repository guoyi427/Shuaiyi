//
//  ClubPhotoView.h
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizonTableView.h"

//照片列表cell宽高
static NSInteger actorImageWidth = 122; //更改此处，自动改变ui大小
static NSInteger actorImageHeight = 85;

@interface ClubPhotoView : UIView <HorizonTableViewDatasource, HorizonTableViewDelegate> {
    HorizonTableView *postListView;
    NSInteger currentPage;
}
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) ClubPost *post;

- (void)reloadData;
@end
