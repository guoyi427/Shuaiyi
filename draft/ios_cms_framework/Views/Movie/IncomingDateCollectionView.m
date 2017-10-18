//
//  IncomingDateCollectionView.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "IncomingDateCollectionView.h"

@implementation IncomingDateCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self=[super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        dateLabel = [UILabel new];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor colorWithHex:@"#454648"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        dateLabel.text = @"";
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@(15));
        }];

    }
    return self;
}

- (void)updateLayout{
    dateLabel.text = self.dateString;

}

@end
