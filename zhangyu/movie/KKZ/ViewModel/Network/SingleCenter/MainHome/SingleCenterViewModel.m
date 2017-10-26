//
//  SingleCenterViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/21.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "SingleCenterViewModel.h"
#import "SingleCenterModel.h"

@implementation SingleCenterViewModel

+(NSMutableArray *)getMenuModelCollectionByArray:(NSArray *)originArr{
    
    NSString *errorMessage;
    NSMutableArray *finalArr = [[NSMutableArray alloc] init];
    @try {
        
        //初始化一个数组源字典
        NSMutableDictionary *allDic = [[NSMutableDictionary alloc] init];
        
        //循环遍历数据
        for (int i=0; i < originArr.count; i++) {
            
            //获取数组里的每个model
            SingleCenterModel *model = originArr[i];
            
            //获取组Id
            NSString *groupId = [model.groupId stringValue];
            
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
        
        //重新遍历数组
        NSMutableArray *allKeyMutableArr = [NSMutableArray arrayWithArray:[allDic allKeys]];
        NSArray *allKeyArr = [allKeyMutableArr sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in allKeyArr) {
            NSMutableArray *array = allDic[key];
            SingleCenterModel *model = [array lastObject];
            model.isLast = TRUE;
            [finalArr addObjectsFromArray:array];
        }
        
    }
    @catch (NSException *exception) {
        errorMessage = [exception reason];
    }
    
    //错误信息提示
    if (!errorMessage) {
        
    }
    return finalArr;
}

@end
