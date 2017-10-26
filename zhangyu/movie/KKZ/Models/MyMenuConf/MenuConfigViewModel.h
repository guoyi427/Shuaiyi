//
//  MenuConfigViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuConfigViewModel : NSObject

/**
 *  通过传进来的字典来构建数据个人中心的配置
 *
 *  @param dataDic
 *
 *  @return
 */
+(NSMutableArray *)getMenuModelCollectionByDic:(NSDictionary *)dataDic;


@end
