//
//  ProductCell.m
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductCell.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import <DateEngine_KKZ/DateEngine.h>
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKZTextUtility.h"

@implementation ProductCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLabel];
        
        contentLabel = [UILabel new];
        contentLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:contentLabel];
        
        describeLabel = [UILabel new];
        describeLabel.textColor = [UIColor colorWithHex:@"0xb2b2b2"];
        describeLabel.textAlignment = NSTextAlignmentLeft;
        describeLabel.font = [UIFont systemFontOfSize:11];
        describeLabel.numberOfLines = 0;
        [self addSubview:describeLabel];
        
        priceLabel = [UILabel new];
        priceLabel.textColor = [UIColor colorWithHex:@"#333333"];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        [self addSubview:priceLabel];
        
        productPosterImage = [UIImageView new];
        productPosterImage.backgroundColor = [UIColor clearColor];
        productPosterImage.clipsToBounds = YES;
        productPosterImage.layer.cornerRadius = 3;
        productPosterImage.image = [UIImage imageNamed:@"home_goods_pic"];
        productPosterImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:productPosterImage];
        
        [productPosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(35));
            make.top.equalTo(@(20.5));
            make.width.equalTo(@(105));
            make.height.equalTo(@(105));
            
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.top.equalTo(@(20.5));
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@(15));
            
        }];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.top.equalTo(titleLabel.mas_bottom).offset(4);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@(12));
            
        }];
        
        [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.right.equalTo(self).offset(-15);
            if (kCommonScreenWidth>320) {
                make.top.equalTo(contentLabel.mas_bottom).offset(4);
                make.bottom.equalTo(productPosterImage.mas_bottom).offset(-35);
            }else{
                make.top.equalTo(contentLabel.mas_bottom).offset(2);
                make.height.equalTo(@(12));
            }
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.bottom.equalTo(productPosterImage.mas_bottom);
            make.width.equalTo(@(100));
            make.height.equalTo(@(15));
            
        }];
        selectNumView = [[PSNumberView alloc] initWithFrame:CGRectMake(0, 0, 108, 30)];
        selectNumView.backgroundColor = [UIColor clearColor];
        selectNumView.delegate = self;
        [self addSubview:selectNumView];
        selectNumView.isCancelTap = self.isCancelTap;
        if (kCommonScreenWidth>320) {
            [selectNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-35));
                make.width.equalTo(@(108));
                make.height.equalTo(@(30));
                make.bottom.equalTo(productPosterImage.mas_bottom);
            }];

        }else{
            [selectNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(productPosterImage.mas_right).offset(15);
                make.width.equalTo(@(108));
                make.height.equalTo(@(30));
                make.top.equalTo(describeLabel.mas_bottom).offset(4);
            }];

        }
        self.maxNumber = 5;
        selectNumView.minNumber = self.maxNumber;

        UIView *downLine = [UIView new];
        downLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(35));
            make.height.equalTo(@(0.5));
            make.width.equalTo(@(kCommonScreenWidth-35));
            make.top.equalTo(self.mas_bottom);
        }];
        

    }
    return self;
}


- (void)updateLayout{
    self.maxNumber = 5>[self.aProduct.saleLimit integerValue] ? [self.aProduct.saleLimit integerValue]:5;

    CGSize couponNameSize = [KKZTextUtility measureText:self.aProduct.couponName font:[UIFont systemFontOfSize:13]];
    NSInteger couponNameLabelnum = couponNameSize.width>(kCommonScreenWidth-170) ? 2:1;
    titleLabel.numberOfLines = couponNameLabelnum;
    if (couponNameLabelnum==1) {
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.top.equalTo(@(20.5));
            make.width.equalTo(@(kCommonScreenWidth-170));
            make.height.equalTo(@(15));
            
        }];
    }else{
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productPosterImage.mas_right).offset(15);
            make.top.equalTo(@(20.5));
            make.width.equalTo(@(kCommonScreenWidth-170));
            make.height.equalTo(@(35));
            
        }];

    }

    
    selectNumView.minNumber = self.maxNumber;
    selectNumView.isCancelTap = self.isCancelTap;
    selectNumView.goodsNumString = self.indexOfNumberString;
    selectNumView.index = self.indexPathRow;
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"home_goods_pic"] newSize:CGSizeMake(105, 105) bgColor:[UIColor whiteColor]];
    
    [productPosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.aProduct.showPictureUrl] placeholderImage:placeHolderImage];
    
    titleLabel.text= self.aProduct.couponName;
    describeLabel.text = self.aProduct.couponBrief;
    
    contentLabel.text= [NSString stringWithFormat:@"%@至%@", [self.aProduct.saleChannel kkz_stringForKey:@"effectiveStart"], [self.aProduct.saleChannel kkz_stringForKey:@"effectiveEnd"]]
    ;
    priceLabel.text= [NSString stringWithFormat:@"￥%.2f", [[self.aProduct.saleChannel kkz_stringForKey:@"salePrice"] floatValue]];
    [selectNumView updateLayout];

}

- (void)PSTextFieldNumber:(NSString *)number indexPath:(NSInteger)index{
    //"112#3,408#2"
    DLog(@"PSTextFieldNumber == %@", number);
    NSString *str = [NSString stringWithFormat:@"%ld#%ld",index,[number integerValue]];
    //里面存的是 object=112#3(index#number)
    if (self.delegate && [self.delegate respondsToSelector:@selector(ProductCellNumber:indexPath:)]) {
        [self.delegate ProductCellNumber:str indexPath:self.indexPathRow];
    };
}


@end
