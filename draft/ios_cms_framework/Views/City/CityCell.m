//
//  CityCell.m
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
//        self.bgView = [UIView new];
//        [self addSubview:self.bgView];
//        self.bgView.backgroundColor = [UIColor yellowColor];
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        
        cityNameLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:cityNameLabel];
        
        selectedImageView = [UIImageView new];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.clipsToBounds = YES;
        selectedImageView.hidden = YES;
        selectedImageView.image = [UIImage imageNamed:@"list_selected_icon"];
        selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:selectedImageView];
        
        [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(0));
            make.width.equalTo(@(kCommonScreenWidth-30));
            make.height.equalTo(@(40));
            
        }];
        
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.width.equalTo(@(kCommonScreenWidth-15));
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];

    }
    return self;
}

- (void)updateLayout{
    
    cityNameLabel.text = self.cityName;
    if (self.isSelected) {
        selectedImageView.hidden = NO;
    }else{
        selectedImageView.hidden = YES;
    }
}

@end
