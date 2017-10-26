//
//  MovieDetailCommentViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "MovieSelectHeader.h"
#import "MovieCommentSuccessViewController.h"

@interface MovieDetailCommentViewController : CommonViewController

/**
 *  选择的显示类型
 */
@property (nonatomic, assign) chooseType type;

/**
 *  从哪个页面进入
 */
@property (nonatomic, assign) joinCurrentPageFrom pageFrom;

@end
