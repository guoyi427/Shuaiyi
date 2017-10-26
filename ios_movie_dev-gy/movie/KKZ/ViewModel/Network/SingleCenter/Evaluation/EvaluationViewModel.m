//
//  EvaluationViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EvaluationViewModel.h"
#import "EvalueModel.h"
#import "EvaluationModel.h"

@implementation EvaluationViewModel

+(NSMutableArray *)getEvalueModelByArray:(NSMutableArray *)originArr
{
    //解析错误信息
    NSString *errorMessage;
    
    //初始化数据源数组
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    @try {
        //循环遍历数组
        for (int i=0; i < originArr.count; i++) {
            
            //网络请求解析数据
            EvaluationModel *originModel = originArr[i];
            
            //循环遍历数据源
            EvalueModel *model = [[EvalueModel alloc] init];
            
            //订单Id
            model.orderID = originModel.orderId;
            
            //影院名字
            model.cinemaName = originModel.plan.cinema.cinemaName;
            
            //排期时间
            model.featureTime = originModel.plan.featureTime;
            
            //电影名称
            model.movieName = originModel.plan.movie.movieName;
            
            //电影ID
            model.movieId = [originModel.plan.movieId intValue];
        
            //是否已经待评价
            if (originModel.commentOrder) {
                model.isEvaluation = TRUE;
                model.commentId = originModel.commentOrder.commentId;
                model.integral = originModel.commentOrder.integral;
                model.url = originModel.commentOrder.url;
                model.type = originModel.commentOrder.type;
            }
            [dataSource addObject:model];
        }
    }
    @catch (NSException *exception) {
        errorMessage = [exception reason];
    }
    
    //错误信息提示
    if (errorMessage) {
        
    }
    return dataSource;
}

@end
