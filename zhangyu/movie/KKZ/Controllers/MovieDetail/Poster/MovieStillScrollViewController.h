//
//  全屏显示图片，可以左右滑动切换的页面
//
//  Created by alfaromeo on 12-3-23.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PhotoScrollView.h"

@interface MovieStillScrollViewController : CommonViewController <PhotoScrollViewDelegte>

@property (nonatomic, assign) BOOL isMovie;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *gallerys;

@end
