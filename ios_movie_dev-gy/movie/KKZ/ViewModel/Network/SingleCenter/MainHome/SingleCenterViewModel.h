//
//  SingleCenterViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/21.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleCenterViewModel : NSObject

/**
 *  通过个人中心的数组来重新处理数据
 *
 *  @param originArr
 *
 *  @return
 */
+ (NSMutableArray *)getMenuModelCollectionByArray:(NSArray *)originArr;

@end
