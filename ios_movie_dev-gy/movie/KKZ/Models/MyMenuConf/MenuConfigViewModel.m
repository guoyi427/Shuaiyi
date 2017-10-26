///
//  MenuConfigViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "MenuConfigViewModel.h"
#import "SingleCenterModel.h"

@implementation MenuConfigViewModel

+(NSMutableArray *)getMenuModelCollectionByDic:(NSDictionary *)dataDic {
    
    //得到menu数组
    NSArray *originArr = [dataDic valueForKey:@"menues"];
    
    //初始化一个数组源字典
    NSMutableDictionary *allDic = [[NSMutableDictionary alloc] init];
    
    //最终的数据
    NSMutableArray *finalArr = [[NSMutableArray alloc] init];
    
    //循环遍历数据
    for (int i=0; i < originArr.count; i++) {
        
        //得到每个数据源的字典
        NSDictionary *item = originArr[i];
        
        //获取组Id
        NSString *groupId = [NSString stringWithFormat:@"%d",[item[@"groupId"] intValue]];
        
        //个人中心model
        SingleCenterModel *model = [[SingleCenterModel alloc] init];
        
        //解析数据
        NSString *name = item[@"name"];
        NSString *icon = item[@"icon"];
        NSString *iosUrl = item[@"iosUrl"];
        
        //模型数据赋值
        model.name = name;
        model.icon = icon;
        model.iosUrl = iosUrl;
        
        //将组Id添加到索引数组里
        if ([allDic valueForKey:groupId]) {
            NSMutableArray *rowsArr = [allDic objectForKey:groupId];
            [rowsArr addObject:model];
        }else {
            NSMutableArray *rowsArr = [[NSMutableArray alloc] init];
            [rowsArr addObject:model];
            [allDic setObject:rowsArr forKey:groupId];
        }
    }
    
    //将获取到的key值进行排序
    NSMutableArray *allKeyMutableArr = [NSMutableArray arrayWithArray:[allDic allKeys]];
    NSArray *allKeyArr = [allKeyMutableArr sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in allKeyArr) {
        NSMutableArray *array = allDic[key];
        SingleCenterModel *model = [array lastObject];
        model.isLast = TRUE;
        [finalArr addObjectsFromArray:array];
    }
    return finalArr;
}

@end
