//
//  CinemaHelper.m
//  KoMovie
//
//  Created by Albert on 9/9/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaHelper.h"

#import "CinemaDetail.h"

@implementation CinemaHelper

/**
 *  将两个电影列表合并，过滤重复
 *
 *  @param cinemas      影院列表<CineamDetail>
 *  @param a_cinemas    另外一个影院列表<CineamDetail>在a_cinemas移除重复的影院
 *
 *  @return 合并后全部影院<CineamDetail>
 */
+ (NSArray *)combineAndFileterDuplicateCinemas:(NSArray *)cinemas
                                  atherCinemas:(NSArray *)a_cinemas {

  if (cinemas.count == 0) {
    return a_cinemas;
  }

  if (a_cinemas.count == 0) {
    return cinemas;
  }

  NSMutableArray *m_a_cinemas = [NSMutableArray arrayWithArray:a_cinemas];

  [cinemas enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                        BOOL *_Nonnull stop) {
    CinemaDetail *cinema = obj;
    //根据cinemaId移除重复对象
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"cinemaId = %@", cinema.cinemaId];
    NSArray *result = [m_a_cinemas filteredArrayUsingPredicate:predicate];
    if (result.count > 0) {
      [m_a_cinemas removeObjectsInArray:result];
    }

  }];

  //    NSMutableArray *all  = [NSMutableArray arrayWithArray:cinemas];
  [m_a_cinemas addObjectsFromArray:cinemas];

  //去除重复
  //    NSArray *resultsArray = [all
  //    valueForKeyPath:@"@distinctUnionOfObjects.self"];

  return [m_a_cinemas copy];
}

/**
 *  处理影院别表（将去过、收藏的影院后合并到cinemaList，去除重复影院，再按距离排序）
 *
 *  @param cinemaList    影院列表
 *  @param ticketCinemas 去过的影院
 *  @param favorCinemas  收藏的影院
 *
 *  @return 处理好的影院列表
 */
+ (NSArray *)cinemaListFrom:(NSArray *)cinemaList
              ticketCinemas:(NSArray *)ticketCinemas
               favorCinemas:(NSArray *)favorCinemas {
    if (ticketCinemas.count > 0) {
        //标记去过
        [ticketCinemas setValue:[NSNumber numberWithBool:YES]
                     forKeyPath:@"isBuy"];
    }
    
    if (favorCinemas.count > 0) {
        //标记收藏
        [favorCinemas setValue:[NSNumber numberWithBool:YES] forKeyPath:@"isCollected"];
    }
    //合并已购票、收藏影院列表，将ticketCinemas里重复的影院移除
    NSArray *headCinemas = [CinemaHelper combineAndFileterDuplicateCinemas:favorCinemas
                                                              atherCinemas:ticketCinemas];
    
    NSArray *allCinemas = [CinemaHelper combineAndFileterDuplicateCinemas:headCinemas
                                                             atherCinemas:cinemaList];
    
    //收藏、去过拍前面，按距离排序
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"isCollected" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"isBuy" ascending:NO];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"distanceMetres" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, sortDescriptor3, nil];
    
    NSArray *sorted = [allCinemas sortedArrayUsingDescriptors:sortDescriptors];
    
    return sorted;
}

/**
 *  根据城区分组
 *
 *  @param cinemas 影院列表
 *  @param finish  完成回调 districts: <NSString> 朝阳区(32家),
 * dictrictsCinemas: [[Cinema, Cinema], [Cinema, Cinema]]
 */
+ (void)groupDistrict:(NSArray *)cinemas
               finish:(void (^)(NSArray *districts,
                                NSArray *districtsCinemas))finish {
  if (cinemas.count == 0) {

    finish(nil, nil);
    return;
  }

  NSArray *allDistricts =
      [cinemas valueForKeyPath:@"@distinctUnionOfObjects.districtName"];

  NSMutableArray *districsCinemas =
      [NSMutableArray arrayWithCapacity:allDistricts.count];

  for (NSInteger i = 0; i < allDistricts.count; i++) {
    //筛选出同城区的影院
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"districtName = %@", allDistricts[i]];
    NSArray *reault = [cinemas filteredArrayUsingPredicate:predicate];
    if (reault) {
      [districsCinemas addObject:reault];
    }
  }

  //按个数排序
  NSSortDescriptor *sortDes =
      [NSSortDescriptor sortDescriptorWithKey:@"@count" ascending:NO];
  NSArray *sorted = [districsCinemas sortedArrayUsingDescriptors:@[ sortDes ]];
  //重新获取排序好的城区名
  NSMutableArray *sortedDistrict =
      [NSMutableArray arrayWithCapacity:sorted.count];
  for (NSInteger i = 0; i < sorted.count; i++) {
    NSArray *cinemasInDistrict = sorted[i];
    NSArray *disName = [cinemasInDistrict
        valueForKeyPath:@"@distinctUnionOfObjects.districtName"];
    if (disName.count > 0) {
      [sortedDistrict addObject:disName[0]];
    }
  }
  if (finish) {
    finish([sortedDistrict copy], sorted);
  }
}
@end
