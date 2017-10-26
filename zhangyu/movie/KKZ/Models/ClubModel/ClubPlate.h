//
//  ClubPlate.h
//  KoMovie
//
//  Created by KKZ on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "Model.h"
@interface ClubPlate : NSObject
/**
 *  版块儿id
 */
@property(nonatomic,assign)NSInteger plateId;

/**
 *  评论数
 */
@property(nonatomic,copy)NSString *commentNum;
/**
 *  文章数
 */
@property(nonatomic,copy)NSString *articleNum;
/**
 *  标题
 */
@property(nonatomic,copy)NSString *plateName;

/**
 *  Icon
 */
@property(nonatomic,copy)NSString *icon;

@end
