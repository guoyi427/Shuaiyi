//
//  PayTypeHeaderView.m
//  CIASMovie
//
//  Created by cias on 2017/2/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PayTypeHeaderView.h"
#import "KKZTextUtility.h"

@implementation PayTypeHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        tipLabel = [UILabel new];
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(@(35));
            make.width.equalTo(@(60));
            make.height.equalTo(@(16));
        }];
        payTypeLabel = [UILabel new];
        payTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        payTypeLabel.textAlignment = NSTextAlignmentLeft;
        payTypeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payTypeLabel];
        [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.width.equalTo(@(100));
            make.height.equalTo(@(16));
        }];
        
        selectImageView = [UIImageView new];
        [self addSubview:selectImageView];
        selectImageView.hidden = YES;
        [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-35));
            make.top.equalTo(@(13));
            make.width.height.equalTo(@(20));
        }];
        selectImageView.image = [UIImage imageNamed:@"list_selected_icon"];
        
        arrowImageView = [UIImageView new];
        [self addSubview:arrowImageView];
        arrowImageView.hidden = YES;
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.top.equalTo(@(21));
            make.width.equalTo(@(10));
            make.height.equalTo(@(6));
        }];
        arrowImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:addBtn];
        addBtn.hidden = YES;
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-10);
            make.top.equalTo(@(9));
            make.width.equalTo(@(50));
            make.height.equalTo(@(28));
        }];
        addBtn.layer.cornerRadius = 3;
        addBtn.layer.borderWidth = 0.5;
        addBtn.layer.borderColor = [UIColor colorWithHex:@"#b2b2b2"].CGColor;
        addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [addBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        [addBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        showListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:showListBtn];
        showListBtn.hidden = YES;
        showListBtn.backgroundColor = [UIColor clearColor];
        [showListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(@(0));
            make.width.equalTo(@(30));
            make.bottom.equalTo(self.mas_bottom);
        }];
        [showListBtn addTarget:self action:@selector(showListBtnClick) forControlEvents:UIControlEventTouchUpInside];

        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}


- (void)updateLayout{
    if (self.isSelectHeader) {
        payTypeLabel.textAlignment = NSTextAlignmentRight;
        payTypeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payTypeLabel];
        [payTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.right.equalTo(@(-35));
            make.height.equalTo(@(16));
        }];

    }else{
        payTypeLabel.textAlignment = NSTextAlignmentLeft;
        payTypeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payTypeLabel];
        [payTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.width.equalTo(@(100));
            make.height.equalTo(@(16));
        }];

    }
    CGSize cardNameSize = [KKZTextUtility measureText:self.payTypeNum==0?@"会员卡支付":@"其他支付 "  font:[UIFont systemFontOfSize:13]];
    [tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(35));
        make.width.equalTo(@(cardNameSize.width));
        make.height.equalTo(@(16));
    }];
    payTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];

    if (self.payTypeNum==0) {
        selectImageView.hidden = YES;
        addBtn.hidden = NO;
        arrowImageView.hidden = NO;
        showListBtn.hidden = NO;
        if (self.isSelectHeader) {
            
        }else{
            payTypeLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
        }

        tipLabel.text = @"会员卡支付";
        payTypeLabel.text = self.headTitle;
        
    }else if (self.payTypeNum==1){
        selectImageView.hidden = NO;
        addBtn.hidden = YES;
        arrowImageView.hidden = YES;
        showListBtn.hidden = YES;

        tipLabel.text = @"其他支付";
        payTypeLabel.text = @"在线支付";
    }else if (self.payTypeNum==2){
        selectImageView.hidden = YES;
        addBtn.hidden = NO;
        arrowImageView.hidden = NO;
        showListBtn.hidden = NO;
                
        tipLabel.text = @"劵码";
        payTypeLabel.text = @"已选中2张劵码";
    }

    if (self.isSelectHeader) {
        selectImageView.hidden = YES;
        addBtn.hidden = YES;
        arrowImageView.hidden = YES;
        showListBtn.hidden = YES;

    }else{
        
    }

}

- (void)addBtnClick{
//  绑定会员卡
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindStoreVipCard)]) {
        [self.delegate bindStoreVipCard];
    }
}

- (void)showListBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showViewListWithIndex:)]) {
        [self.delegate showViewListWithIndex:self.payTypeNum];
    }

}

- (void)handleTap:(UIGestureRecognizer*)gesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showViewListWithIndex:)]) {
        [self.delegate showViewListWithIndex:self.payTypeNum];
    }    
}

- (void)isSelected:(BOOL)isSelected {
    
    if (isSelected) {
        if (self.payTypeNum==1) {
            selectImageView.image = [UIImage imageNamed:@"list_selected_icon"];

        } else {
            arrowImageView.image = [UIImage imageNamed:@"home_uparrow2"];

        }
    }else {
        if (self.payTypeNum==1) {
            selectImageView.image = [UIImage imageNamed:@""];

        } else {
            arrowImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        }
    }
}


@end
