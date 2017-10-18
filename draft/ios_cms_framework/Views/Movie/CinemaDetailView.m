//
//  CinemaDetailView.m
//  CHUNDAN
//
//  Created by 唐永廷 on 2017/4/22.
//  Copyright © 2017年 唐永廷. All rights reserved.
//

#import "CinemaDetailView.h"
#import <Category_KKZ/NSDictionaryExtra.h>

@implementation CinemaDetailView
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setViewLabelWithCinema:(Cinema *)cinema {
    UIImage *tmpImage = [UIImage imageNamed:@"imax"];
    CGFloat originY = 10;
    CGFloat originX = 15;
    CGFloat originXOfLabel = 15;

    CGFloat height = 0;
    CGFloat heightOfImageView = tmpImage.size.height;
    CGFloat sep = 4;
    CGFloat sep_label = 8;
    NSArray *screenArr = [NSArray array];
    if (cinema.screenFeatures&&cinema.screenFeatures.length>0) {
        screenArr = [cinema.screenFeatures componentsSeparatedByString:@","];
    }
    for (int i = 0; i < screenArr.count; i++) {
        UIImageView *tipImageView = [[UIImageView alloc] init];
//        1-IMAX 2-巨幕 3-激光 4-2K 5-4K 6-RealD 7-120帧 8-新风系统 9-杜比全景声 10-DBOX 11-4DX
        UIImage *tipImage = nil;
        int screenType = [[screenArr objectAtIndex:i] intValue];
        switch (screenType) {
            case 1:
                tipImage = [UIImage imageNamed:@"imax"];
                break;
            case 2:
                tipImage = [UIImage imageNamed:@"dmax"];
                break;
            case 3:
                tipImage = [UIImage imageNamed:@"laser_dmax"];
                break;
            case 4:
                tipImage = [UIImage imageNamed:@"2K"];
                break;
            case 5:
                tipImage = [UIImage imageNamed:@"4K"];
                break;
            case 6:
                tipImage = [UIImage imageNamed:@"realD"];
                break;
            case 7:
                tipImage = [UIImage imageNamed:@"120frame"];
                break;
            case 8:
                tipImage = [UIImage imageNamed:@"Fresh_air"];
                break;
            case 9:
                tipImage = [UIImage imageNamed:@"dolby_atmos"];
                break;
            case 10:
                tipImage = [UIImage imageNamed:@"DBOX"];
                break;
            case 11:
                tipImage = [UIImage imageNamed:@"4DX"];
                break;
            default:
                break;
        }
        //label 长度应该为 字宽加上 字与边框的间距
        if (originX + tipImage.size.width + 5 + 15 > kCommonScreenWidth) {
            originY += heightOfImageView + sep;
            originX = 15;
        }
        tipImageView.frame = CGRectMake(originX, originY, tipImage.size.width + 5, heightOfImageView);
        tipImageView.image = tipImage;
        originX += tipImage.size.width + 5 + sep;
        [self.labelView addSubview:tipImageView];
    }
    if (screenArr.count > 0) {
        height += originY + heightOfImageView;
    } else {
        height += 0;
    }
    
    if (cinema.serviceFeatures.count > 0) {
        height += 10;
    } else {
        height += 0;
    }
    
    CGFloat widthOfLabel = 0.0;
    for (int i = 0; i < cinema.serviceFeatures.count; i++) {
        NSDictionary *dic = [cinema.serviceFeatures objectAtIndex:i];
        NSString *tipLabelStr = [dic kkz_stringForKey:@"name"];
        CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        if (tipLabelStrSize.width > widthOfLabel) {
            widthOfLabel = tipLabelStrSize.width;
        }
    }
    
    for (int i = 0; i < cinema.serviceFeatures.count; i++) {
        UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel  *tipLabel = [[UILabel alloc] init];
        NSDictionary *dic = [cinema.serviceFeatures objectAtIndex:i];
        NSString *tipLabelStr = [dic kkz_stringForKey:@"name"];
        NSString *tipContentStr = [dic kkz_stringForKey:@"remark"];
        CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        CGSize tipContentStrSize = [KKZTextUtility measureText:tipContentStr size:CGSizeMake((kCommonScreenWidth - widthOfLabel - 5 - 15 - 15 - 10), 500) font:[UIFont systemFontOfSize:13]];
        // 45为暂时的label 长度  实际上 label 长度应该为 字宽加上 字与边框的间距
        
        labelBtn.frame = CGRectMake(originXOfLabel, height, widthOfLabel+5, tipLabelStrSize.height + 5);
        labelBtn.userInteractionEnabled = NO;
        [labelBtn setTitle:tipLabelStr forState:UIControlStateNormal];
        [labelBtn setTitleColor:[UIColor colorWithHex:@"#ff9900"] forState:UIControlStateNormal];
        [labelBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        labelBtn.layer.cornerRadius = 5;
        labelBtn.layer.masksToBounds = YES;
        labelBtn.layer.borderColor = [UIColor colorWithHex:@"#ff9900"].CGColor;
        labelBtn.layer.borderWidth = 0.5;
        
        tipLabel.frame = CGRectMake(originXOfLabel + widthOfLabel + 5 + 10, height, tipContentStrSize.width + 5, tipContentStrSize.height);
        tipLabel.text = tipContentStr;
        tipLabel.numberOfLines = 0;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        
        [self.labelView addSubview:labelBtn];
        [self.labelView addSubview:tipLabel];
        
        if (tipContentStr && tipContentStr.length>0) {
            if (tipContentStrSize.height > tipLabelStrSize.height + 5) {
                height += tipContentStrSize.height + sep_label;
            } else {
                height += tipLabelStrSize.height + 5 + sep_label;
            }
            
        } else {
            height += tipLabelStrSize.height + 5 + sep_label;
        }
    }
    
    self.labelViewHeight.constant = height;

    self.cinemaNameLabel.text = [NSString stringWithFormat:@"%@", cinema.cinemaName];
    self.cinemaAddressLabel.text = [NSString stringWithFormat:@"%@", cinema.address];
    self.cinemaOpenTimeLabel.text = [NSString stringWithFormat:@"%@", cinema.businessHours];
    self.cinemaPhoneLabel.text = [NSString stringWithFormat:@"%@", cinema.telphone];
    self.cinemaIntroduceLabel.text = [NSString stringWithFormat:@"%@", cinema.introduction];
    //这里 高度  实际应该使用代码 求出高度（带有行间距）
    CGSize cinemaIntroduceSize = [KKZTextUtility measureText:cinema.introduction size:CGSizeMake(kCommonScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
    self.viewHeight = self.labelViewHeight.constant + cinemaIntroduceSize.height + 46 + 15 + 12 + 10 + 12 + 15 + 12 + 5;
    self.headerView.frame = CGRectMake(0, 0, kCommonScreenWidth, self.viewHeight);
    self.myTableView.tableHeaderView = self.headerView;
}
- (IBAction)closeAction:(UIButton *)sender {

     [UIView animateWithDuration:0.5
                           delay:0
                         options:UIViewAnimationOptionTransitionFlipFromBottom
                      animations:^{

                          
                          self.frame = CGRectMake(0, 0 - kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
   
}

- (void)reloadData {
    self.myTableView.contentOffset = CGPointMake(0, 0);

}
@end




//for (int i = 0; i < cinema.serviceFeatures.count; i++) {
//    UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UILabel  *tipLabel = [[UILabel alloc] init];
//    NSDictionary *dic = [cinema.serviceFeatures objectAtIndex:i];
//    NSString *tipLabelStr = [dic kkz_stringForKey:@"name"];
//    NSString *tipContentStr = [dic kkz_stringForKey:@"remark"];
//    CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:9]];
//    CGSize tipContentStrSize = [KKZTextUtility measureText:tipContentStr size:CGSizeMake((kCommonScreenWidth - tipLabelStrSize.width - 5 - 15 - 15), 500) font:[UIFont systemFontOfSize:12]];
//    // 45为暂时的label 长度  实际上 label 长度应该为 字宽加上 字与边框的间距
//    if (originX + tipLabelStrSize.width+5 + 15 > kCommonScreenWidth) {
//        originY += height + sep;
//        originX = 15;
//    }
//    labelBtn.frame = CGRectMake(originX, originY, tipLabelStrSize.width+5, height);
//    originX += tipLabelStrSize.width+5 + sep;
//    labelBtn.userInteractionEnabled = NO;
//    [labelBtn setTitle:tipLabelStr forState:UIControlStateNormal];
//    [labelBtn setTitleColor:[UIColor colorWithHex:@"#ffcc00"] forState:UIControlStateNormal];
//    [labelBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
//    labelBtn.layer.cornerRadius = 5;
//    labelBtn.layer.masksToBounds = YES;
//    labelBtn.layer.borderColor = [UIColor colorWithHex:@"#ffcc00"].CGColor;
//    labelBtn.layer.borderWidth = 0.5;
//    [self.labelView addSubview:labelBtn];
//}
