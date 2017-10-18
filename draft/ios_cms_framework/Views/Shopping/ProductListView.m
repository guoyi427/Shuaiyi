//
//  ProductListView.m
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductListView.h"
#import "Product.h"

@implementation ProductListView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0.5)];
        upLine.backgroundColor = [UIColor colorWithHex:@"#b2b2b2"];
        [self addSubview:upLine];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text= @"最惠套餐";
        tipLabel.textColor = [UIColor colorWithHex:@"#333333"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(35));
            make.top.equalTo(@(20));
            make.width.equalTo(@(100));
            make.height.equalTo(@(15));
        }];
        
        _selectProductList = [[NSMutableArray alloc] initWithCapacity:0];
//        [_productList addObject:@"1"];
//        [_productList addObject:@"1"];
//        [_productList addObject:@"1"];
//        [_productList addObject:@"1"];
//        [_productList addObject:@"1"];

        productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kCommonScreenWidth, 270) style:UITableViewStylePlain];
        productTableView.backgroundColor = [UIColor colorWithHex:@"ffffff"];
        productTableView.delegate = self;
        productTableView.dataSource = self;
        productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:productTableView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(18));
            make.right.equalTo(@(-35));
            make.width.height.equalTo(@(20));
        }];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [confirmBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom);
        }];

        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = .5;
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
    
}




- (void)updateLayout{
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
            [self.selectProductList removeObject:string];

        }else{
            
        }
    }
    NSArray *array = [numberDict componentsSeparatedByString:@"#"];

    if ([[array objectAtIndex:1] integerValue] <= 0) {
        
    }else{
        [self.selectProductList addObject:numberDict];
    }
    
}

- (void)confirmOrderClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ProductListViewDicts:)]) {
        if (self.selectProductList.count > 5) {
            [[CIASAlertCancleView new] show:@"提示" message:@"最多只能选择5种卖品！" cancleTitle:@"好的" callback:^(BOOL confirm) {
            }];
        } else {
            [self.delegate ProductListViewDicts:self.selectProductList];
            [self fadeOut];
        }
    }
    
}


#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeTranslation(0, 35);
    [UIView animateWithDuration:0.6 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(1.0,1.0);
        self.alpha = 1;
        
    }];

//    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 1;
//        self.transform = CGAffineTransformMakeScale(1, 1);
//    }];
    
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.1, 0.1);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    [self fadeIn];
}

- (void)dismiss
{
    [self.selectProductList removeAllObjects];
    [self fadeOut];
}



#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    Product *product = [self.productList objectAtIndex:indexPath.row];
    cell.aProduct = product;
    cell.indexPathRow = indexPath.row;
    cell.indexOfNumberString = @"0";
    for (int i=0; i<self.selectProductList.count; i++) {
        //里面存的是 object=1#3(index#number) 对应的key=index
        NSString *string = [self.selectProductList objectAtIndex:i];
        NSArray *array = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[array objectAtIndex:0] integerValue];
        if (indexPath.row==indexNum) {
            cell.indexOfNumberString = [array objectAtIndex:1];
        }
    }

    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

@end
