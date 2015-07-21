//
//  MPHomeCollectionCell.m
//  MobilePrint
//
//  Created by guoyi on 15/6/8.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPHomeCollectionCell.h"

//  View
#import "Masonry.h"

//  Model
#import "MPMobileShellModel.h"

@interface MPHomeCollectionCell ()
{
    //  Data
    
    //  UI
    UILabel * _nameLabel;
}

@end

@implementation MPHomeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _prepareData];
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareData {
    
}

- (void)_prepareUI {
    
    self.contentView.backgroundColor = [UIColor yellowColor];
    
    //  名字标签
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    
    __weak UIView * weakContentView = self.contentView;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakContentView);
        make.top.equalTo(weakContentView);
    }];
}

#pragma mark - Set & Get

/// 更新单元格数据
- (void)setModel:(MPMobileShellModel *)model {
    if (!model) {
        return;
    }
    
    _nameLabel.text = model.name;
}

@end
