//
//  SingleCenterControllerModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "SingleCenterControllerModel.h"

@implementation SingleCenterControllerModel

+ (NSArray *)getSettingCellTitleString {
    return  @[@"修改个人资料", @"第三方授权管理", @"清除数据缓存", @"意见反馈", @"给抠电影评价", @"拨打客服热线：400-030-1053"];
}

+ (NSArray *)getSettingCellDetailShowOrHiden{
    return @[@FALSE, @FALSE, @FALSE, @FALSE, @FALSE, @FALSE];
}

+ (NSArray *)getSettingCellArrowShowOrHiden {
    return @[@TRUE, @TRUE, @FALSE, @TRUE, @FALSE, @FALSE];
}

+ (NSArray *)getSettingCellSectionShowOrHiden {
    return @[@TRUE, @FALSE, @FALSE, @FALSE, @FALSE, @FALSE];
}

+ (NSArray *)getSettingCellSectionTitleString {
    return @[@"其它设置", @"", @"", @"", @"", @""];
}

+ (NSArray *)getSettingCellRightTitleShowOrHiden {
    return @[@FALSE, @FALSE, @TRUE, @FALSE, @FALSE, @FALSE];
}

+ (NSArray *)getSettingCellSeprateLineShowOrHiden {
    return @[@FALSE, @TRUE, @TRUE, @TRUE, @TRUE, @FALSE];
}

@end
