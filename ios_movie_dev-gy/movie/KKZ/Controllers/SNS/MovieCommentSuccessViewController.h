//
//  MovieCommentSuccessViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@class ClubPost;
typedef enum : NSUInteger {
    joinCurrentPageFromLibrary,
    joinCurrentPageFromCamera,
} joinCurrentPageFrom;

@interface MovieCommentSuccessViewController : CommonViewController

/**
 *  从哪个页面进入
 */
@property (nonatomic, assign) joinCurrentPageFrom pageFrom;



/**
 *  帖子
 */
@property (nonatomic, strong) ClubPost *clubPost;


@end
