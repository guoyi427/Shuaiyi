//
//  AppTemplate.h
//  CIASMovie
//
//  Created by cias on 2017/2/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HomeConfig.h"

@interface AppTemplate : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSDictionary *all;
/*
 all =         {
 color = "#09C200"; color全局背景色
 };
*/

@property (nonatomic, strong)HomeConfig *home;//首页配置

@property (nonatomic, strong)NSDictionary *list;//列表页配置
/*
 newsShowType文章列表显示形式
 filmShowType电影列表显示形式
 cinemaShowType影院列表显示形式
 pageSize文章单页显示数量
 thumbnailSize影院单页显示数量
 */

@property (nonatomic, strong)NSDictionary *detail;//详情页配置
/*
 aboutFilmTitle相关电影标题
 aboutFilmCount相关电影显示数量
 seatIcon1座位图1
 seatIcon2座位图2
 seatIcon3座位图3
 seatIcon4座位图4
 */
@property (nonatomic, strong)NSNumber *AppTemplateNum;//template模板编号
@property (nonatomic, strong)NSNumber *tenantId;//租户Id
@property (nonatomic, strong)NSNumber *type;//渠道类型APP

@end
