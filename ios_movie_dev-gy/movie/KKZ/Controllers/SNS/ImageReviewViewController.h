//
//  ImageReviewViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@interface ImageReviewViewController : CommonViewController

/**
 *  当前UIScrollView显示的索引值
 */
@property (nonatomic, assign) NSInteger showIndex;

/**
 *  所有显示图片的数组
 */
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end
