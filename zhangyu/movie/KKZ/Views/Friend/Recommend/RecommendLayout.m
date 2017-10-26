//
//  RecommendLayout.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/31.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "RecommendLayout.h"
#import "KKZUtility.h"

@implementation RecommendLayout

- (void)calculateCellLayout:(friendRecommendModel *)model {

    //距离的文字
    NSString *distanStr = model.estimateDistance;

    //距离标签的高度
    CGFloat distanHeight = 18.0f;

    //记录标签的尺寸
    CGSize distanSize = [KKZUtility customTextSize:self.distanceLabelFont
                                              text:distanStr
                                              size:CGSizeMake(60, distanHeight)];

    //名字的X坐标
    CGFloat nameOriginX = nameLabelLeft + avatarOriginX + avatarWidth;

    //名字的最大距离
    NSString *nickName = model.nickname;
    CGFloat maxWidth = kCommonScreenWidth - whiteBgOriginX * 2 - attentionBtnWidth - nameOriginX - attentionBtnRight - nameLabeRight - distanSize.width;
    CGSize nameSize = [KKZUtility customTextSize:self.nameLabelFont
                                            text:nickName
                                            size:CGSizeMake(maxWidth,
                                                            distanHeight)];
    if (nameSize.width == 0 && nickName.length > 3) {
        nameSize = CGSizeMake(maxWidth, distanHeight);
    }

    //名字的尺寸
    self.nameLabelRect = CGRectMake(nameOriginX, nameLabelOriginY, nameSize.width, nameLabelHeight);

    //距离的尺寸
    self.distanceRect = CGRectMake(nameLabeRight / 2.0f + CGRectGetMaxX(self.nameLabelRect), nameLabelOriginY + 3, distanSize.width + 2, distanHeight);
}

- (UIFont *)nameLabelFont {
    if (!_nameLabelFont) {
        _nameLabelFont = [UIFont systemFontOfSize:15];
    }
    return _nameLabelFont;
}

- (UIFont *)distanceLabelFont {
    if (!_distanceLabelFont) {
        _distanceLabelFont = [UIFont systemFontOfSize:10.0f];
    }
    return _distanceLabelFont;
}

@end
