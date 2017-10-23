//
//  CityCell.m
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (void)dealloc {
    self.leftName = nil;
    self.middleName = nil;
    self.rightName = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat marginY = (kCommonScreenWidth - 320) / 3;
        
        leftRect = CGRectMake(0, 0, 110 + marginY, 46);
        middelRect = CGRectMake(15 + 100 + marginY, 0, 90 + marginY, 46);
        rightRect = CGRectMake(15 + 100 * 2 + marginY * 2, 0, 90 + marginY, 46);
        
        leftLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80 + marginY, 46)];
        leftLable.backgroundColor = [UIColor clearColor];
        leftLable.font = [UIFont systemFontOfSize:15];
        leftLable.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];//appDelegate.kkzTextColor;
        [self addSubview:leftLable];
        
        middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 100 + marginY, 0, 80 + marginY, 46)];
        middleLabel.backgroundColor = [UIColor clearColor];
        middleLabel.font = [UIFont systemFontOfSize:15];
        middleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];//appDelegate.kkzTextColor;
        [self addSubview:middleLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 100 * 2 + marginY * 2, 0, 80 + marginY , 46)];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self addSubview:rightLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateLayout {
    leftLable.text = self.leftName;
    middleLabel.text = self.middleName;
    rightLabel.text = self.rightName;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(leftRect, point)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchWithCityId:withCityName:)]) {
            [self.delegate handleTouchWithCityId:self.leftId
                                    withCityName:self.leftName];
        }
    } else if (CGRectContainsPoint(middelRect, point) && self.middleId != 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchWithCityId:withCityName:)]) {
            [self.delegate handleTouchWithCityId:self.middleId
                                    withCityName:self.middleName];
        }
    } else if (CGRectContainsPoint(rightRect, point) && self.rightId != 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleTouchWithCityId:withCityName:)]) {
            [self.delegate handleTouchWithCityId:self.rightId
                                    withCityName:self.rightName];
        }
    }
}

@end
