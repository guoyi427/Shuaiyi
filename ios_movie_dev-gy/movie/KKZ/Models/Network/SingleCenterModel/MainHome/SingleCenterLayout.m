//
//  SingleCenterLayout.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "SingleCenterLayout.h"
#import "KKZUtility.h"

@implementation SingleCenterLayout

- (void)updateLayoutModel:(SingleCenterModel *)model {
    
    //头像
    CGFloat iconOriginX = 15.0f;
    CGFloat iconOriginY = 10.0f;
    CGFloat iconWidth = 30.0f;
    self.iconFrame = CGRectMake(iconOriginX, iconOriginY, iconWidth, iconWidth);
    
    //箭头
    CGFloat arrowRight = 15.0f;
    self.arrowImg = [UIImage imageNamed:@"arrowRightGray"];
    self.arrowFrame = CGRectMake(kCommonScreenWidth - arrowRight - self.arrowImg.size.width,
                                 (TABLEVIEW_CELL_HEIGHT - self.arrowImg.size.height)/2.0f,
                                 self.arrowImg.size.width,
                                 self.arrowImg.size.height);
    
    //标题的尺寸
    CGFloat titleLeft = 20.0f;
    CGFloat titleOriginY = 18.0f;
    CGFloat titleHeight = 14.0f;
    CGFloat titleRight = 50.0f;
    CGFloat titleOriginX = CGRectGetMaxX(self.iconFrame) + titleLeft;
    CGFloat titleWidth = kCommonScreenWidth - titleOriginX - arrowRight - CGRectGetWidth(self.arrowFrame) - titleRight;
    self.titleLabelFrame =  CGRectMake(titleOriginX, titleOriginY,titleWidth,titleHeight);
    
    //标题的计算
    self.titleFont = [UIFont systemFontOfSize:14.0f];
    CGSize titleFrame = [KKZUtility customTextSize:self.titleFont
                                              text:model.name
                                              size:self.titleLabelFrame.size];
    
    //长度太长了或者长度太短了
    if (titleFrame.width <= 2.0f && titleFrame.height <= 2.0f) {
        titleFrame = CGSizeMake(titleWidth, titleHeight);
    }
    
    //重新设置名字的尺寸
    CGRect titleRect = self.titleLabelFrame;
    titleRect.size.width = titleFrame.width;
    self.titleLabelFrame = titleRect;
    
    //分割线的尺寸
    self.sepLineFrame = CGRectMake(CGRectGetMinX(self.titleLabelFrame), TABLEVIEW_CELL_HEIGHT - 1,kCommonScreenWidth - CGRectGetMinX(self.titleLabelFrame), 0.3);
    
    //个数的尺寸
    CGFloat countLabelWidth = 14.0f;
    CGFloat countLabelOriginY = 14.0f;
    self.countLabelFont = [UIFont systemFontOfSize:10.0f];
    self.countLabelFrame = CGRectMake(CGRectGetMaxX(self.titleLabelFrame) + 3,countLabelOriginY, countLabelWidth, countLabelWidth);
    
    //如果个数大于0
    if (model.waitEvalueCount > 0) {
        CGRect countRect = self.countLabelFrame;
        if (model.waitEvalueCount > 99) {
            countRect.size.width = 28.0f;
        }else {
            countRect.size.width = countLabelWidth;
        }
        self.countLabelFrame = countRect;
    }
    
}

@end
