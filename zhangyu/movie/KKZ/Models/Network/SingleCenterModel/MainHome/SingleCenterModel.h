//
//  SingleCenterModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SingleCenterModel : MTLModel <MTLJSONSerializing>

/**
 *  组ID
 */
@property (nonatomic, copy) NSNumber *groupId;

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  IOS页面跳转
 */
@property (nonatomic, copy) NSString *iosUrl;

/**
 *  名字
 */
@property (nonatomic, copy) NSString *name;



/**
 *   是不是每个Section下的最后一个Cell
 */
@property (nonatomic, assign) BOOL isLast;

//--------

/**
 *  待评价个数
 */
@property (nonatomic, assign) int waitEvalueCount;

@end
