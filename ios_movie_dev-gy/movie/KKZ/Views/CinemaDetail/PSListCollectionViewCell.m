//
//  影院详情的特色信息Cell横向滚动的View
//
//  Created by 艾广华 on 15/12/9.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PSListCollectionViewCell.h"

#import "KKZUtility.h"
#import "UIColor+Hex.h"

@implementation PSListCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //图标
        _icomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
        [self addSubview:_icomImgV];

        //文字
        _iconLbel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2 + CGRectGetMaxY(_icomImgV.frame), CGRectGetWidth(frame), 20.0f)];
        [_iconLbel setFont:[UIFont systemFontOfSize:10.0f]];
        [_iconLbel setTextAlignment:NSTextAlignmentCenter];
        [_iconLbel setTextColor:[UIColor colorWithHex:@"#333333"]];
        _iconLbel.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconLbel];
    }
    return self;
}

@end
