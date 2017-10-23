//
//  城市列表的Cell的HeaderView
//
//  Created by zhang da on 14-4-29.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CityCellHeaderView.h"

#import "UIConstants.h"

@interface CityCellHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CityCellHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth - 40, 0.5)];
        divideLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];//kDividerColor;
        [self addSubview:divideLine];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, kCommonScreenWidth, 26)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];//appDelegate.kkzBlue;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc {
    self.titleLabel = nil;
    self.title = nil;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
