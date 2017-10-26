//
//  ImageDetailCommentViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "MovieCommentSuccessViewController.h"

typedef void(^addImageBlock)();

@interface ImageDetailCommentViewController : CommonViewController

/**
 *  所有显示图片的数组
 */
@property (nonatomic, strong) NSMutableArray *imagesArray;

/**
 *  从哪个页面进入
 */
@property (nonatomic, assign) joinCurrentPageFrom pageFrom;

@end
