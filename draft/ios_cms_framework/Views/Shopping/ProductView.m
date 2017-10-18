//
//  ProductView.m
//  CIASMovie
//
//  Created by cias on 2017/1/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductView.h"
#import "KKZTextUtility.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "Product.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ProductView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0.5)];
        upLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:upLine];

        UILabel *tipLabel = [UILabel new];
        tipLabel.text= @"最惠套餐";
        tipLabel.textColor = [UIColor colorWithHex:@"#333333"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        
        totalNumLabel = [self getFlagLabelWithFont:10 withBgColor:@"#fc9a27" withTextColor:@"#FFFFFF"];
        [self addSubview:totalNumLabel];
        
        arrowImageView = [UIImageView new];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.clipsToBounds = YES;
        arrowImageView.image = [UIImage imageNamed:@"home_more"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:arrowImageView];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(35));
            make.top.equalTo(@(20));
            make.width.equalTo(@(100));
            make.height.equalTo(@(14));
        }];

        CGSize numberSize = [KKZTextUtility measureText:@"0个卖品可选" font:[UIFont systemFontOfSize:10]];
        totalNumLabel.text = @"0个卖品可选";
        [totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-35));
            make.top.equalTo(@(20));
            make.width.equalTo(@(numberSize.width+8));
            make.height.equalTo(@(14));
        }];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-14));
            make.top.equalTo(@(21));
            make.width.equalTo(@(8));
            make.height.equalTo(@(12));
            
        }];
        _productList = [[NSMutableArray alloc] initWithCapacity:0];
        _selectProductList = [[NSMutableArray alloc] initWithCapacity:0];

        productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 33, kCommonScreenWidth, 145) style:UITableViewStylePlain];
        productTableView.backgroundColor = [UIColor colorWithHex:@"ffffff"];
        productTableView.delegate = self;
        productTableView.dataSource = self;
        productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:productTableView];
        
        productPriceLabel = [UILabel new];
        productPriceLabel.backgroundColor = [UIColor clearColor];
        productPriceLabel.textColor = [UIColor colorWithHex:@"#333333"];
        productPriceLabel.textAlignment = NSTextAlignmentRight;
        productPriceLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:productPriceLabel];
        [productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-35));
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.width.equalTo(@(100));
            make.height.equalTo(@(14));
        }];

        
        showProductListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showProductListBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:showProductListBtn];
        [showProductListBtn addTarget:self action:@selector(showProductListBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [showProductListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kCommonScreenWidth/2));
            make.top.equalTo(@(0));
            make.width.equalTo(@(kCommonScreenWidth/2));
            make.height.equalTo(@(50));
        }];

        UIView *downLine = [UIView new];
        downLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.height.equalTo(@(0.5));
            make.bottom.equalTo(self.mas_bottom).offset(0.5);
        }];
    }
    return self;
}

- (void)updateLayout{
    showProductListBtn.hidden = NO;
    arrowImageView.hidden = NO;
    totalNumLabel.hidden = NO;

    if (self.isFromConfirm) {
        productTableView.userInteractionEnabled = NO;
        showProductListBtn.hidden = YES;
        arrowImageView.hidden = YES;
        totalNumLabel.hidden = YES;
    }
    if (self.selectProductList.count) {
        [productTableView setFrame:CGRectMake(0, 33, kCommonScreenWidth, 145*self.selectProductList.count)];
    } else {
        [productTableView setFrame:CGRectMake(0, 33, kCommonScreenWidth, 145)];
    }

    totalNumLabel.text = [NSString stringWithFormat:@"%ld个卖品可选", self.productList.count];
    
    float productPrice = 0.0f;
    for (int i=0; i<self.selectProductList.count; i++) {

        NSString *string = [self.selectProductList objectAtIndex:i];
        NSArray *arr = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
        
        Product *aproduct = [self.productList objectAtIndex:indexNum];
        productPrice = productPrice+[[aproduct.saleChannel kkz_stringForKey:@"salePrice"] floatValue]*[[arr objectAtIndex:1] integerValue];
        
    }
    productPriceLabel.text = [NSString stringWithFormat:@"小计:￥%.2f", productPrice];

    [productTableView reloadData];

}

- (void)ProductCellNumber:(NSString *)numberDict indexPath:(NSInteger)index{
    //取出来数组里面的字典，如果此字典的 key 已经存在说明数据会重复加，就把之前的存的字典删除，把最新的字典存进去
    
    for (int i=0; i<self.selectProductList.count; i++) {
        //字典里面存的是 object=112#3(id#number) 对应的key=index
        NSString *string = [self.selectProductList objectAtIndex:i];
        NSArray *arr = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
        
        if (indexNum==index) {
            [self.selectProductList replaceObjectAtIndex:i withObject:numberDict];
            
        }else{

        }
    }
    if (self.selectProductList.count<=0) {
        [self.selectProductList addObject:numberDict];
    }
    float productPrice = 0.0f;
    for (int i=0; i<self.selectProductList.count; i++) {
        
        NSString *string = [self.selectProductList objectAtIndex:i];
        NSArray *arr = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
        
        Product *aproduct = [self.productList objectAtIndex:indexNum];
        productPrice = productPrice+[[aproduct.saleChannel kkz_stringForKey:@"salePrice"] floatValue]*[[arr objectAtIndex:1] integerValue];
        
    }
    productPriceLabel.text = [NSString stringWithFormat:@"小计:￥%.2f", productPrice];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ProductViewDicts:)]) {
        [self.delegate ProductViewDicts:self.selectProductList];
    }

    
}

- (void)showProductListBtnClick{
    if (self.productList.count>1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(delegateShowProductListView)]) {
            [self.delegate delegateShowProductListView];
        }
    }
}



#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.isCancelTap = self.isFromConfirm;
    cell.delegate = self;
    Product *product = nil;
    if (self.selectProductList.count>0) {
        NSString *string = [self.selectProductList objectAtIndex:indexPath.row];
        NSArray *arr = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
        product = [self.productList objectAtIndex:indexNum];
        cell.indexOfNumberString = [arr objectAtIndex:1];
        cell.indexPathRow = indexNum;

    } else {
        product = [self.productList objectAtIndex:0];
        cell.indexOfNumberString = @"0";
        cell.indexPathRow = 0;
    }
    cell.aProduct = product;
    
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectProductList.count>0) {
        return self.selectProductList.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.5f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}



@end
