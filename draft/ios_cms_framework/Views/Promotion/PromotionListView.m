//
//  PromotionListView.m
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PromotionListView.h"
#import "PromotionCell.h"
#import "VipCard.h"
#import "Activity.h"
#import "ActivityRequest.h"
//#import <Category_KKZ/NSDictionaryExtra.h>

@implementation PromotionListView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0.5)];
        upLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:upLine];
        
        UIView *upLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 54.5, kCommonScreenWidth, 0.5)];
        upLine1.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:upLine1];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text= @"影票优惠";
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
        
        _promotionList = [[NSMutableArray alloc] initWithCapacity:0];
        _discountCardList = [[NSMutableArray alloc] initWithCapacity:0];
        
        promotionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kCommonScreenWidth, 75.5*3) style:UITableViewStylePlain];
        promotionTableView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        promotionTableView.delegate = self;
        promotionTableView.dataSource = self;
        promotionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:promotionTableView];
        
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
        
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor blackColor];
                _overlayView.alpha = 0.8;
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [confirmBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom);
        }];

    }
    return self;
    
}




- (void)updateLayout{
    self.lastSelectedNum = self.selectedNum;
    lastSame = isSame;
    [promotionTableView reloadData];
}

- (void)confirmOrderClick{
    
    [self requestUseActivity];

}



#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeTranslation(0, 35);
    [UIView animateWithDuration:0.6 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(1.0,1.0);
        self.alpha = 1;
        
    }];

//    self.transform = CGAffineTransformMakeTranslation(0.1, 0.1);
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 1;
//        self.transform = CGAffineTransformMakeTranslation(1, 1);
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
    [self fadeOut];
}



#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PromotionCell";
    PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth-55, 17, 20, 20)];
    if (self.selectedNum == indexPath.row && !isSame) {
        cell.isSelectCell = YES;
        imageView.image = [UIImage imageNamed:@"list_selected_icon"];
    }else if(self.selectedNum == indexPath.row){
        cell.isSelectCell = YES;
        imageView.image = [UIImage imageNamed:@"list_selected_icon"];
    }else{
        cell.isSelectCell = NO;
        imageView.image = [UIImage imageNamed:@""];
    }

    Activity *activity = [self.promotionList objectAtIndex:indexPath.row];
    cell.leftTitle = activity.activityTypeName;
    cell.rightTitle = activity.activityName;
    cell.detail = activity.label;
    [cell updateLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectCouponsList.count>0) {
        [CIASPublicUtility showAlertViewForTitle:@"" message:@"不可与优惠券同时使用" cancelButton:@"知道了"];
        return;
    }
    if (self.selectedNum == indexPath.row) {
        isSame = !isSame;
    }else{
        isSame = NO;
    }
    
    if (!isSame) {
        self.selectedNum = indexPath.row;
    }else{
        self.selectedNum = -1;
    }

//    if (self.delegate && [self.delegate respondsToSelector:@selector(PromotionListViewDidCell:)]) {
//        [self.delegate PromotionListViewDidCell:self.selectedNum];
//    }
    [promotionTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.promotionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.5;
}



//使用活动获取活动价格
- (void)requestUseActivity{
    if (self.selectedNum == self.lastSelectedNum) {
        [self dismiss];
        return;
    }
    [[UIConstants sharedDataEngine] loadingAnimation];

    if (self.promotionList.count>0) {
        NSString *activityType = @"";
        NSString *selectActivityId = @"";


        if (self.selectedNum==-1) {
            selectActivityId = @"0";
            
        }else{
            Activity *activity = [self.promotionList objectAtIndex:self.selectedNum];
            selectActivityId = activity.activityId;
            activityType = activity.activityType;
        }
        //self.selectProductIds.length?self.selectProductIds:@"", @"goods",
        NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", selectActivityId,@"activityId", activityType, @"activityType", nil];
        
        ActivityRequest *requtest = [[ActivityRequest alloc] init];
        [requtest requestUseActivityParams:pagrams success:^(NSDictionary * _Nullable data) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];

            NSDictionary *dict = [data kkz_objForKey:@"data"];
            self.promotionDict = dict;
            self.lastSelectedNum = self.selectedNum;
            lastSame = isSame;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(PromotionListViewDidCell:withData:)]) {
                [self.delegate PromotionListViewDidCell:self.selectedNum withData:self.promotionDict];
            }
            [promotionTableView reloadData];

            [self dismiss];

        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];

            [CIASPublicUtility showAlertViewForTaskInfo:err];
            self.selectedNum = self.lastSelectedNum;
            isSame = lastSame;
            [promotionTableView reloadData];
        }];
        
    }
}

@end
