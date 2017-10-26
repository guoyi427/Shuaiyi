//
//  EvaluationViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationViewModel : NSObject

/**
 *  获取待评价的Model对象
 *
 *  @param originArr
 *
 *  @return
 */
+(NSMutableArray *)getEvalueModelByArray:(NSMutableArray *)originArr;

@end
