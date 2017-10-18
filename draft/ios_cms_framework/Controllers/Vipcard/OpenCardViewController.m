//
//  OpenCardViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OpenCardViewController.h"
#import "CodeResendView.h"
#import "VipCardRequest.h"
#import "DataEngine.h"
#import "UserDefault.h"
#import "KKZTextUtility.h"
#import "DataEngine.h"
#import "VipCardRechargeOrderController.h"
#import "OrderRequest.h"
#import "Order.h"


#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define  ACCOUNT_MAX_CHARS    16
#define  NICKNAME_MAX_CHARS    20

@interface OpenCardViewController ()<UITextFieldDelegate>
{
    UILabel        *titleLabel,*cardTitleLabelOfTop,*cardValueLabelOfTop,*cardTypeLabelOfTop,*cardBalanceValueLabelOfTop,*cardValidTimeLabelOfTop;
    UIView         *topView,*centerView,*bottomView,*line1View,*line2View;
    UIImageView    *cardImageViewOfTop,*cardBackImageViewOfTop,*cardLogoImageViewOfTop;
    
    CodeResendView *codeTitleView;
    UIImageView    *codeImageView;
    NSString       *codeTitleStr;
    UIImageView    *firstImageViewOfCenter,*secondImageViewOfCenter,*thirdImageViewOfCenter;
    UILabel        *firstLabelOfCenter,*secondLabelOfCenter,*thirdLabelOfCenter;
    
    
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    
    
}
@property (nonatomic, strong) UIView  *titleViewOfBar;
@property (nonatomic, strong) UIView  *cardViewOfTop;
@property (nonatomic, strong) UIView  *codeViewOfTop;
@property (nonatomic, strong) UIView  *firstViewOfCenter;
@property (nonatomic, strong) UIView  *secondViewOfCenter;
@property (nonatomic, strong) UIView  *thirdViewOfCenter;
@property (nonatomic, strong) UIView  *inputViewOfBottom;
@property (nonatomic, strong) UITextField    *passwordFieldSet,*passwordField,*codeField;
@property (nonatomic, strong) UILabel        *codeFieldLabel;


@end

@implementation OpenCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    self.hideNavigationBar = NO;
    self.hideBackBtn = YES;
    [self setUpNavBar];
    titleLabel.text = [NSString stringWithFormat:@"开通%@会员卡", self.cinemaName];
    
    //MARK: 添加顶部view
    topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(251*Constants.screenHeightRate));
    }];
    
    
    [topView addSubview:self.cardViewOfTop];//cardViewOfTop、codeViewOfTop看情况添加，或者添加了先隐藏
    
    line1View = [[UIView alloc] init];
    [self.view addSubview:line1View];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    if (kCommonScreenHeight <= 568) {
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(topView.mas_bottom).offset(-50*Constants.screenHeightRate);
            make.height.equalTo(@1);
        }];
    } else {
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(topView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
    }
    
    //MARK: 添加中部view
    centerView = [[UIView alloc] init];
    [self.view addSubview:centerView];
    centerView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line1View.mas_bottom).offset(0);
        make.height.equalTo(@(40*Constants.screenHeightRate));
    }];
    //MARK: 添加中部三个状态的展示
    [centerView addSubview:self.firstViewOfCenter];
    [self initFisrtViewOfCenterWithTitleStr:@"设置密码" andWithStatus:@"input"];
    
    [centerView addSubview:self.secondViewOfCenter];
    [self initSecondViewOfCenterWithTitleStr:@"确认密码" andWithStatus:@"unInput"];
    
    [centerView addSubview:self.thirdViewOfCenter];
    [self initThirdViewOfCenterWithTitleStr:@"验证码" andWithStatus:@"unInput"];
    
    line2View = [[UIView alloc] init];
    [self.view addSubview:line2View];
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(centerView.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
    //MARK: 添加底部view
    [self.view addSubview:self.inputViewOfBottom];
    [self.inputViewOfBottom addSubview:self.passwordFieldSet];
    
    [self.passwordFieldSet becomeFirstResponder];
    
}





//MARK: 初始化方法集中
- (UIView *)cardViewOfTop {
    if (!_cardViewOfTop) {
        _cardViewOfTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 251*Constants.screenHeightRate)];
        _cardViewOfTop.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
        
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            //卡图片
            UIImage *cardImage = nil;
            if (self.cardTypeDetail.cardType.intValue == 1 || self.cardTypeDetail.cardType.intValue == 3) {
                cardImage = [UIImage imageNamed:@"membercard_xc_1"];
            } else {
                cardImage = [UIImage imageNamed:@"membercard_xc_2"];
            }
            cardImageViewOfTop = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2, 25*Constants.screenHeightRate, cardImage.size.width*Constants.screenWidthRate, cardImage.size.height*Constants.screenHeightRate)];
            cardImageViewOfTop.image = cardImage;
            cardImageViewOfTop.contentMode = UIViewContentModeScaleAspectFit;
            [_cardViewOfTop addSubview:cardImageViewOfTop];
            
            //卡背景图
            UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
            cardBackImageViewOfTop = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - cardBackImage.size.width*Constants.screenWidthRate)/2, 10*Constants.screenHeightRate, cardBackImage.size.width*Constants.screenWidthRate, cardBackImage.size.height*Constants.screenHeightRate)];
            cardBackImageViewOfTop.image = cardBackImage;
            cardBackImageViewOfTop.contentMode = UIViewContentModeScaleAspectFit;
            [_cardViewOfTop addSubview:cardBackImageViewOfTop];
            
            
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            //        WithFrame:CGRectMake(35, 25, cardLogoImage.size.width, cardLogoImage.size.height)];
            cardLogoImageViewOfTop = [[UIImageView alloc] init];
            [cardBackImageViewOfTop addSubview:cardLogoImageViewOfTop];
            [cardLogoImageViewOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageViewOfTop.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageViewOfTop.image = cardLogoImage;
            cardLogoImageViewOfTop.hidden = YES;
            //
            NSString *cardValueStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc];
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardValueLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardValueLabelOfTop];
            cardValueLabelOfTop.text = cardValueStr;
            cardValueLabelOfTop.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabelOfTop.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardValueLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageViewOfTop.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardImage.size.width - 35, cardValueStrSize.height));
            }];
            //卡图片上的卡号
            NSString *cardTitleStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName];
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardTitleLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardTitleLabelOfTop];
            cardTitleLabelOfTop.text = cardTitleStr;
            cardTitleLabelOfTop.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabelOfTop.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardTitleLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardValueLabelOfTop.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            
            
            NSString *cardValidTimeStr = nil;
            if (([self.cardTypeDetail.expireDate containsString:@"天"] || [self.cardTypeDetail.expireDate containsString:@"月"] ||[self.cardTypeDetail.expireDate containsString:@"年"])&&(!([self.cardTypeDetail.expireDate containsString:@"有效期"])))  {
                cardValidTimeStr = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
            } else {
                cardValidTimeStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
            }
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardValidTimeLabelOfTop];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabelOfTop.hidden = NO;
            cardValidTimeLabelOfTop.text = cardValidTimeStr;
            cardValidTimeLabelOfTop.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabelOfTop.textColor = [UIColor colorWithHex:@"#cccccc"];
            cardValidTimeLabelOfTop.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardValidTimeLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageViewOfTop.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageViewOfTop.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"";
            //        if (self.cardTypeDetail.cardType.intValue == 1 || self.cardTypeDetail.cardType.intValue == 3) {
            //            cardBalanceValueStr = [NSString stringWithFormat:@"充值:%.2f元",self.cardTypeDetail.rechargeMoney.floatValue];
            //        } else {
            cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.cardTypeDetail.saleMoney.floatValue];
            //        }
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            
            cardBalanceValueLabelOfTop = [[UILabel alloc] init];
            cardBalanceValueLabelOfTop.textAlignment = NSTextAlignmentRight;
            [cardBackImageViewOfTop addSubview:cardBalanceValueLabelOfTop];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabelOfTop.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageViewOfTop.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardValidTimeLabelOfTop.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabelOfTop.hidden = NO;
            
            
            
            
        }
        if([kIsCMSStandardCardStyle  isEqualToString:@"1"]) {
            //卡图片
            UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
            cardImageViewOfTop = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2, 25*Constants.screenHeightRate, cardImage.size.width*Constants.screenWidthRate, cardImage.size.height*Constants.screenHeightRate)];
            cardImageViewOfTop.image = cardImage;
            cardImageViewOfTop.contentMode = UIViewContentModeScaleAspectFit;
            [_cardViewOfTop addSubview:cardImageViewOfTop];
            
            //卡背景图
            UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
            cardBackImageViewOfTop = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - cardBackImage.size.width*Constants.screenWidthRate)/2, 10*Constants.screenHeightRate, cardBackImage.size.width*Constants.screenWidthRate, cardBackImage.size.height*Constants.screenHeightRate)];
            cardBackImageViewOfTop.image = cardBackImage;
            cardBackImageViewOfTop.contentMode = UIViewContentModeScaleAspectFit;
            [_cardViewOfTop addSubview:cardBackImageViewOfTop];
            
            
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            //        WithFrame:CGRectMake(35, 25, cardLogoImage.size.width, cardLogoImage.size.height)];
            cardLogoImageViewOfTop = [[UIImageView alloc] init];
            [cardBackImageViewOfTop addSubview:cardLogoImageViewOfTop];
            [cardLogoImageViewOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageViewOfTop.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageViewOfTop.image = cardLogoImage;
            
#if K_ZHONGDU
            cardLogoImageViewOfTop.hidden = YES;
#endif
            //
            //卡图片上的卡号
            NSString *cardTitleStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName];
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardTitleLabelOfTop];
            cardTitleLabelOfTop.text = cardTitleStr;
            cardTitleLabelOfTop.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabelOfTop.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardLogoImageViewOfTop.mas_bottom).offset(32*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            NSString *cardValueStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc];
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardValueLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardValueLabelOfTop];
            cardValueLabelOfTop.text = cardValueStr;
            cardValueLabelOfTop.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabelOfTop.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [cardValueLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardTitleLabelOfTop.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardImage.size.width - 35, cardValueStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"";
            //        if (self.cardTypeDetail.cardType.intValue == 1 || self.cardTypeDetail.cardType.intValue == 3) {
            //            cardBalanceValueStr = [NSString stringWithFormat:@"充值:%.2f元",self.cardTypeDetail.rechargeMoney.floatValue];
            //        } else {
            cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.cardTypeDetail.saleMoney.floatValue];
            //        }
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            
            cardBalanceValueLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardBalanceValueLabelOfTop];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabelOfTop.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageViewOfTop.mas_left).offset(35*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageViewOfTop.mas_bottom).offset(-23*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabelOfTop.hidden = NO;
            
            NSString *cardValidTimeStr = nil;
            if (([self.cardTypeDetail.expireDate containsString:@"天"] || [self.cardTypeDetail.expireDate containsString:@"月"] ||[self.cardTypeDetail.expireDate containsString:@"年"])&&(!([self.cardTypeDetail.expireDate containsString:@"有效期"])))  {
                cardValidTimeStr = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
            } else {
                cardValidTimeStr = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
            }
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabelOfTop = [[UILabel alloc] init];
            [cardBackImageViewOfTop addSubview:cardValidTimeLabelOfTop];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabelOfTop.hidden = NO;
            cardValidTimeLabelOfTop.text = cardValidTimeStr;
            cardValidTimeLabelOfTop.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabelOfTop.textColor = [UIColor colorWithHex:@"#cccccc"];
            cardValidTimeLabelOfTop.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardValidTimeLabelOfTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageViewOfTop.mas_right).offset(-25*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageViewOfTop.mas_bottom).offset(-23*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
        }
        
    }
    return _cardViewOfTop;
}



- (UIView *)codeViewOfTop {
    if (!_codeViewOfTop) {
        NSString *codeViewStr = @"已向手机号138****4567";
        CGSize codeViewStrSize = [KKZTextUtility measureText:codeViewStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
        
        NSString *codeViewStr2 = @"已向手机号137****4567\n发送了验证码";
        //        NSString *codeViewStr2 = @"        验证码已超时\n请点击重新发送验证码";
        CGSize codeViewStr2Size = [KKZTextUtility measureText:codeViewStr2 size:CGSizeMake(codeViewStrSize.width, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
        UIImage *codeImage = [UIImage imageNamed:@"phone2"];
        
        _codeViewOfTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 251*Constants.screenHeightRate)];
        _codeViewOfTop.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
        
        codeTitleView = [[CodeResendView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-codeViewStrSize.width-20)/2, 20*Constants.screenHeightRate, codeViewStrSize.width+20, codeViewStr2Size.height+20)];
        [_codeViewOfTop addSubview:codeTitleView];
        codeTitleView.backgroundColor = [UIColor clearColor];
        codeTitleView.textAlignment = NSTextAlignmentCenter;
        codeTitleView.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
        //        codeTitleStr = codeViewStr2;
        // 设置文字
        //        codeTitleView.text = codeViewStr2;
        // 设置其中的一段文字有下划线，下划线的颜色为黄色，点击下划线文字有相关的点击效果
        // 迭代法可以更改本身的内容和状态
        //        [self codeTitleViewWithStr:codeViewStr2 andIsTimeOut:YES];
        
        codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-codeImage.size.width*Constants.screenWidthRate)/2, 100*Constants.screenHeightRate, codeImage.size.width*Constants.screenWidthRate, codeImage.size.height*Constants.screenHeightRate)];
        [_codeViewOfTop addSubview:codeImageView];
        codeImageView.image = codeImage;
        
    }
    return _codeViewOfTop;
}


- (UIView *)firstViewOfCenter {
    if (!_firstViewOfCenter) {
        _firstViewOfCenter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth/3, 40*Constants.screenHeightRate)];
    }
    return _firstViewOfCenter;
}

- (void) initFisrtViewOfCenterWithTitleStr:(NSString*)titleStr andWithStatus:(NSString *)viewStatus {
    if (!firstImageViewOfCenter) {
        firstImageViewOfCenter = [[UIImageView alloc] init];
    }
    if (!firstLabelOfCenter) {
        firstLabelOfCenter = [[UILabel alloc] init];
    }
    UIImage *firstImage = [UIImage imageNamed:@"stepdot1"];
    CGSize firstLabelStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    [self.firstViewOfCenter addSubview:firstImageViewOfCenter];
    [self.firstViewOfCenter addSubview:firstLabelOfCenter];
    [firstImageViewOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstViewOfCenter.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.firstViewOfCenter.mas_top).offset((40-firstImage.size.height)/2*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(firstImage.size.width*Constants.screenWidthRate, firstImage.size.height*Constants.screenHeightRate));
    }];
    [firstLabelOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstImageViewOfCenter.mas_right).offset(5);
        make.top.equalTo(self.firstViewOfCenter.mas_top).offset((40*Constants.screenHeightRate-firstLabelStrSize.height)/2);
        make.size.mas_equalTo(CGSizeMake(firstLabelStrSize.width+5, firstLabelStrSize.height));
    }];
    firstLabelOfCenter.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    firstLabelOfCenter.text = titleStr;
    if ([viewStatus isEqualToString:@"unInput"]) {
        firstImageViewOfCenter.image = nil;
        firstLabelOfCenter.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    } else if ([viewStatus isEqualToString:@"input"]) {
        firstImageViewOfCenter.image = [UIImage imageNamed:@"stepdot1"];
        firstLabelOfCenter.textColor = [UIColor colorWithHex:@"#ff9900"];
    } else if ([viewStatus isEqualToString:@"finished"]) {
        firstImageViewOfCenter.image = [UIImage imageNamed:@"stepdot2"];
        firstLabelOfCenter.textColor = [UIColor colorWithHex:@"#333333"];
    }
}

- (UIView *)secondViewOfCenter {
    if (!_secondViewOfCenter) {
        _secondViewOfCenter = [[UIView alloc] initWithFrame:CGRectMake(kCommonScreenWidth/3, 0, kCommonScreenWidth/3, 40*Constants.screenHeightRate)];
    }
    return _secondViewOfCenter;
}



- (UIView *)inputViewOfBottom {
    if (!_inputViewOfBottom) {
        if (kCommonScreenHeight <= 568) {
            _inputViewOfBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 243*Constants.screenHeightRate, kCommonScreenWidth, 91*Constants.screenHeightRate)];
        } else {
            _inputViewOfBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 293*Constants.screenHeightRate, kCommonScreenWidth, 91*Constants.screenHeightRate)];
        }
        
        _inputViewOfBottom.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _inputViewOfBottom;
}

- (UITextField *)passwordFieldSet {
    if (!_passwordFieldSet) {
        NSString *strOfPasswordField = @"622245535354";
        CGSize strOfPasswordFieldSize = [KKZTextUtility measureText:strOfPasswordField size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:30*Constants.screenWidthRate]];
        _passwordFieldSet = [[UITextField alloc] initWithFrame:CGRectMake(50*Constants.screenWidthRate, (91*Constants.screenHeightRate - strOfPasswordFieldSize.height)/2, kCommonScreenWidth - 50*Constants.screenWidthRate, strOfPasswordFieldSize.height)];
        _passwordFieldSet.textColor = [UIColor colorWithHex:@"#333333"];
        _passwordFieldSet.font = [UIFont systemFontOfSize:30*Constants.screenWidthRate];
        _passwordFieldSet.textAlignment = NSTextAlignmentCenter;
        _passwordFieldSet.layer.borderColor = [UIColor whiteColor].CGColor;
        _passwordFieldSet.keyboardType = UIKeyboardTypePhonePad;
        _passwordFieldSet.secureTextEntry = NO;
        _passwordFieldSet.delegate = self;
        _passwordFieldSet.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        
        [self setRightViewWithTextField:_passwordFieldSet andTag:251314 imageName:@"password_unview2" imageNameOfSelected:@"password_view2"];
        [_passwordFieldSet addTarget:self action:@selector(codeFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordFieldSet;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        NSString *strOfPasswordField = @"622245535354";
        CGSize strOfPasswordFieldSize = [KKZTextUtility measureText:strOfPasswordField size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:30*Constants.screenWidthRate]];
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50*Constants.screenWidthRate, (91*Constants.screenHeightRate - strOfPasswordFieldSize.height)/2, kCommonScreenWidth - 50*Constants.screenWidthRate, strOfPasswordFieldSize.height)];
        _passwordField.textColor = [UIColor colorWithHex:@"#333333"];
        _passwordField.font = [UIFont systemFontOfSize:30*Constants.screenWidthRate];
        _passwordField.textAlignment = NSTextAlignmentCenter;
        _passwordField.layer.borderColor = [UIColor whiteColor].CGColor;
        _passwordField.keyboardType = UIKeyboardTypePhonePad;
        _passwordField.secureTextEntry = NO;
        _passwordField.delegate = self;
        _passwordField.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        
        [self setRightViewWithTextField:_passwordField andTag:251315 imageName:@"password_unview2" imageNameOfSelected:@"password_view2"];
        [_passwordField addTarget:self action:@selector(codeFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}

//- (UILabel *)passwordFieldLabel {
//    if (!_passwordFieldLabel) {
//        _passwordFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(50*Constants.screenWidthRate, 0, kCommonScreenWidth - 50*Constants.screenWidthRate*2, 91*Constants.screenHeightRate)];
//        _passwordFieldLabel.textAlignment = NSTextAlignmentCenter;
//        _passwordFieldLabel.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
//        _passwordFieldLabel.userInteractionEnabled = NO;
//        _passwordFieldLabel.attributedText = [[NSAttributedString alloc] initWithString:@"______" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#b2b2b2"],NSKernAttributeName:@12,NSFontAttributeName:[UIFont systemFontOfSize:30*Constants.screenWidthRate]}];
//    }
//    return _passwordFieldLabel;
//}

/**
 *  给UITextField设置右侧的图片
 *
 *  @param textField UITextField
 *  @param imageName 图片名称
 */
-(void)setRightViewWithTextField:(UITextField *)textField andTag:(int) fieldTag imageName:(NSString *)imageName imageNameOfSelected:(NSString *)imageNameOfSelected{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    UIButton *rightBtnOfTextField = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtnOfTextField.tag = fieldTag;
    [rightBtnOfTextField setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtnOfTextField setImage:[UIImage imageNamed:imageNameOfSelected] forState:UIControlStateSelected];
    [rightBtnOfTextField addTarget:self action:@selector(rightBtnOfTextFieldClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtnOfTextField.selected = YES;
    rightBtnOfTextField.frame = CGRectMake(0, 0, 20, 20);
    rightBtnOfTextField.contentMode = UIViewContentModeCenter;
    [rightView addSubview:rightBtnOfTextField];
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void) rightBtnOfTextFieldClick:(UIButton *)sender {
    UIButton *secureBtn = (UIButton *)[self.view viewWithTag:sender.tag];
    secureBtn.selected = !secureBtn.selected;
    if (secureBtn.selected) {
        if (secureBtn.tag == 251314) {
            self.passwordFieldSet.secureTextEntry = NO;
        } else if (secureBtn.tag == 251315) {
            self.passwordField.secureTextEntry = NO;
        }
        
    } else {
        if (secureBtn.tag == 251314) {
            self.passwordFieldSet.secureTextEntry = YES;
        } else if (secureBtn.tag == 251315) {
            self.passwordField.secureTextEntry = YES;
        }
        
        
    }
}


- (UITextField *)codeField {
    if (!_codeField) {
        NSString *strOfCodeField = @"622245";
        CGSize strOfCodeFieldSize = [KKZTextUtility measureText:strOfCodeField size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:30*Constants.screenWidthRate]];
        _codeField = [[UITextField alloc] initWithFrame:CGRectMake(0, (91*Constants.screenHeightRate - strOfCodeFieldSize.height)/2, kCommonScreenWidth, strOfCodeFieldSize.height)];
        _codeField.textColor = [UIColor colorWithHex:@"#333333"];
        _codeField.font = [UIFont systemFontOfSize:30*Constants.screenWidthRate];
        _codeField.delegate = self;
        _codeField.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        _codeField.textAlignment = NSTextAlignmentCenter;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.layer.borderColor = [UIColor whiteColor].CGColor;
        [_codeField addTarget:self action:@selector(codeFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeField;
}

- (UILabel *)codeFieldLabel {
    if (!_codeFieldLabel) {
        
        _codeFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 91*Constants.screenHeightRate)];
        _codeFieldLabel.textAlignment = NSTextAlignmentCenter;
        _codeFieldLabel.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        _codeFieldLabel.userInteractionEnabled = NO;
        _codeFieldLabel.attributedText = [[NSAttributedString alloc] initWithString:@"______" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#b2b2b2"],NSKernAttributeName:@12,NSFontAttributeName:[UIFont systemFontOfSize:30*Constants.screenWidthRate]}];
    }
    return _codeFieldLabel;
}

- (void)codeFieldEditingChanged:(UITextField *)textField
{
    if (textField == self.passwordFieldSet && [self.passwordFieldSet isEditing]) {
//        cardValueLabelOfTop.text = self.cardField.text;
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
            
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
    }
    if (textField == self.passwordField && [self.passwordField isEditing]) {
        //        self.passwordFieldLabel.attributedText = [self setBalance:self.passwordField.text];
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
    }
    if (textField == self.codeField && [self.codeField isEditing]) {
        self.codeFieldLabel.attributedText = [self setBalance:self.codeField.text];
        
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
        
    }
    
}

-(NSMutableAttributedString *)setBalance:(NSString *)balance{
    NSString *str = nil;
    if (balance.length >= 1 && balance.length < 6) {
        str = balance;
        for (NSUInteger i = balance.length; i < 6; i++) {
            str = [str stringByAppendingString:@"_"];
        }
    } else if (balance.length == 6) {
        str = balance;
    } else if(balance.length == 0){
        str = @"______";
    }
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#b2b2b2"],NSKernAttributeName:@12, NSFontAttributeName:[UIFont systemFontOfSize:30*Constants.screenWidthRate]}];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#333333"] range:NSMakeRange(0,balance.length)]; //设置数字颜色
    
    return vAttrString;
}


- (void) initSecondViewOfCenterWithTitleStr:(NSString*)titleStr andWithStatus:(NSString *)viewStatus {
    if (!secondImageViewOfCenter) {
        secondImageViewOfCenter = [[UIImageView alloc] init];
    }
    if (!secondLabelOfCenter) {
        secondLabelOfCenter = [[UILabel alloc] init];
    }
    
    UIImage *secondImage = [UIImage imageNamed:@"stepdot1"];
    CGSize secondLabelStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    [self.secondViewOfCenter addSubview:secondImageViewOfCenter];
    [self.secondViewOfCenter addSubview:secondLabelOfCenter];
    [secondImageViewOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondViewOfCenter.mas_left).offset((kCommonScreenWidth/3 -secondImage.size.width*Constants.screenWidthRate-secondLabelStrSize.width-5-5)/2);
        make.top.equalTo(self.secondViewOfCenter.mas_top).offset((40-secondImage.size.height)/2*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(secondImage.size.width*Constants.screenWidthRate, secondImage.size.height*Constants.screenHeightRate));
    }];
    [secondLabelOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondImageViewOfCenter.mas_right).offset(5);
        make.top.equalTo(self.secondViewOfCenter.mas_top).offset((40*Constants.screenHeightRate-secondLabelStrSize.height)/2);
        make.size.mas_equalTo(CGSizeMake(secondLabelStrSize.width+5, secondLabelStrSize.height));
    }];
    secondLabelOfCenter.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    secondLabelOfCenter.text = titleStr;
    if ([viewStatus isEqualToString:@"unInput"]) {
        secondImageViewOfCenter.image = nil;
        secondLabelOfCenter.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    } else if ([viewStatus isEqualToString:@"input"]) {
        secondImageViewOfCenter.image = [UIImage imageNamed:@"stepdot1"];
        secondLabelOfCenter.textColor = [UIColor colorWithHex:@"#ff9900"];
    } else if ([viewStatus isEqualToString:@"finished"]) {
        secondImageViewOfCenter.image = [UIImage imageNamed:@"stepdot2"];
        secondLabelOfCenter.textColor = [UIColor colorWithHex:@"#333333"];
    }
}

- (UIView *)thirdViewOfCenter {
    if (!_thirdViewOfCenter) {
        _thirdViewOfCenter = [[UIView alloc] initWithFrame:CGRectMake(kCommonScreenWidth/3*2, 0, kCommonScreenWidth/3, 40*Constants.screenHeightRate)];
    }
    return _thirdViewOfCenter;
}

- (void) initThirdViewOfCenterWithTitleStr:(NSString*)titleStr andWithStatus:(NSString *)viewStatus {
    if (!thirdImageViewOfCenter) {
        thirdImageViewOfCenter = [[UIImageView alloc] init];
    }
    if (!thirdLabelOfCenter) {
        thirdLabelOfCenter = [[UILabel alloc] init];
    }
    UIImage *thirdImage = [UIImage imageNamed:@"stepdot1"];
    CGSize thirdLabelStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    DLog(@"验证码文字宽：%f", thirdLabelStrSize.width);
    [self.thirdViewOfCenter addSubview:thirdImageViewOfCenter];
    [self.thirdViewOfCenter addSubview:thirdLabelOfCenter];
    [thirdImageViewOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thirdViewOfCenter.mas_right).offset(-(15+5+5+thirdLabelStrSize.width));
        make.top.equalTo(self.thirdViewOfCenter.mas_top).offset((40-thirdImage.size.height)/2*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(thirdImage.size.width*Constants.screenWidthRate, thirdImage.size.height*Constants.screenHeightRate));
    }];
    [thirdLabelOfCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdImageViewOfCenter.mas_right).offset(5);
        make.top.equalTo(self.thirdViewOfCenter.mas_top).offset((40*Constants.screenHeightRate-thirdLabelStrSize.height)/2);
        make.size.mas_equalTo(CGSizeMake(thirdLabelStrSize.width+30, thirdLabelStrSize.height));
    }];
    thirdLabelOfCenter.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    thirdLabelOfCenter.text = titleStr;
    if ([viewStatus isEqualToString:@"unInput"]) {
        thirdImageViewOfCenter.image = nil;
        thirdLabelOfCenter.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    } else if ([viewStatus isEqualToString:@"input"]) {
        thirdImageViewOfCenter.image = [UIImage imageNamed:@"stepdot1"];
        thirdLabelOfCenter.textColor = [UIColor colorWithHex:@"#ff9900"];
    } else if ([viewStatus isEqualToString:@"finished"]) {
        thirdImageViewOfCenter.image = [UIImage imageNamed:@"stepdot2"];
        thirdLabelOfCenter.textColor = [UIColor colorWithHex:@"#333333"];
    }
}

- (void)codeTitleViewWithStr:(NSString *)codeStr andIsTimeOut:(BOOL) isTimeOut {
    codeTitleView.text = codeStr;
    if (isTimeOut) {
        NSRange range1 = [codeStr rangeOfString:@"重新发送"];
        __weak __typeof(self) weakSelf = self;
        
        [codeTitleView setUnderlineTextWithRange:range1 withUnderlineColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] withClickCoverColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] withBlock:^(NSString *clickText) {
            //MARK: 重新发送验证码请求
            VipCardRequest *request = [[VipCardRequest alloc] init];
            [[UIConstants sharedDataEngine] loadingAnimation];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
            //MARK: 发送验证码接口
            [params setValue:[DataEngine sharedDataEngine].userName forKey:@"mobilePhone"];
            [params setValue:weakSelf.cinemaId forKey:@"cinemaId"];
            [request requestOpenCardCodeParams:params success:^(NSDictionary * _Nullable data) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                if ([data isKindOfClass:[NSDictionary class]]&&data) {
                    if ([[data kkz_stringForKey:@"status"] isEqualToString:@"0"]) {
                        DLog(@"手机号是否被用了：%@",data);
                        [weakSelf codeTitleViewWithStr:[NSString stringWithFormat:@"已向手机号%@\n        发送了验证码",[[DataEngine sharedDataEngine].userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]] andIsTimeOut:NO];
                        //MARK: 发送验证码接口,在验证码发送成功后，添加
                        timeCountOfBind = 60;
                        weakSelf.timerOfBind = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(beforeActivityMethodInBind:) userInfo:nil repeats:YES];
                        [[CIASAlertCancleView new] show:@"温馨提示" message:@"验证码已发送" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                        }];
                    }
                }
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showMyAlertViewForTaskInfo:err];
            }];
            
        }];
    } else {
        
    }
    
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    self.title = [NSString stringWithFormat:@"开通%@会员卡", self.cinemaName];
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_close"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width, leftBarImage.size.height);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSString *btnStr = @"下一步";
    CGSize btnStrSize = [KKZTextUtility measureText:btnStr size:CGSizeMake(50, 500) font:[UIFont systemFontOfSize:13]];
    rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn sizeToFit];
    rightBarBtn.frame = CGRectMake(0, 0, btnStrSize.width, btnStrSize.height);
    [rightBarBtn setTitle:btnStr forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBarBtn.userInteractionEnabled = YES;
    [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
    rightBarBtn.backgroundColor = [UIColor clearColor];
    [rightBarBtn addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = mapItem;
//    self.navigationItem.titleView = self.titleViewOfBar;
}

- (void)rightBarBtnClick:(id)sender {
    //MARK: 逻辑处理中心
    __weak __typeof(self) weakSelf = self;
    if (self.passwordFieldSet.text.length > 0) {
        if (self.passwordField.text.length > 0) {
            if (self.codeField.text.length > 0) {
                //
                VipCardRequest *request = [[VipCardRequest alloc] init];
                [[UIConstants sharedDataEngine] loadingAnimation];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                //MARK: 开卡成功前
                [params setValue:[DataEngine sharedDataEngine].userName forKey:@"memberMobile"];
                [params setValue:self.passwordField.text forKey:@"cardPW"];
                [params setValue:@"5" forKey:@"type"];
//                [params setValue:@"18940852010" forKey:@"mobilePhone"];
                [params setValue:[DataEngine sharedDataEngine].userName forKey:@"mobilePhone"];
                [params setValue:[NSString stringWithFormat:@"%d", self.cardTypeDetail.cardId.intValue] forKey:@"cardProductId"];
                [params setValue:self.codeField.text forKey:@"checkCode"];

                [params setValue:self.cinemaId forKey:@"cinemaId"];
                //
                [request requestVipCardOpenOrderParams:params success:^(NSDictionary * _Nullable data) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    if ([data isKindOfClass:[NSDictionary class]]&&data) {
                        if ([[data kkz_stringForKey:@"status"] isEqualToString:@"0"]) {
                            DLog(@"会员卡开卡：%@",data);
                            //成功的话，跳转开卡订单确认页面,离开页面先干掉定时器
                            if (weakSelf.timerOfBind.isValid) {
                                [weakSelf.timerOfBind invalidate];
                                weakSelf.timerOfBind = nil;
                            }
                            //获取订单号
                            weakSelf.orderNo = [NSString stringWithFormat:@"%@",[data kkz_stringForKey:@"data"]];
                            VipCardRechargeOrderController *openOrderVC = [[VipCardRechargeOrderController alloc] init];
                            openOrderVC.cinemaId = weakSelf.cinemaId;
                            openOrderVC.cinemaName = weakSelf.cinemaName;
                            openOrderVC.orderNo = weakSelf.orderNo;
                            openOrderVC.cardTypeDetail = weakSelf.cardTypeDetail;
                            [weakSelf.navigationController pushViewController:openOrderVC animated:YES];
                            
                        }
                    }
                } failure:^(NSError * _Nullable err) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                }];
            } else {
                //用会员卡密码和确认密码进行比较
                //用会员卡密码和确认密码进行比较
                if ([self.passwordFieldSet.text isEqualToString:self.passwordField.text]) {
                        //MARK: 发送验证码
                    VipCardRequest *request = [[VipCardRequest alloc] init];
                    [[UIConstants sharedDataEngine] loadingAnimation];
                    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                    //MARK: 发送验证码接口
                    [params setValue:[DataEngine sharedDataEngine].userName forKey:@"mobilePhone"];
                    [params setValue:weakSelf.cinemaId forKey:@"cinemaId"];
                    [request requestOpenCardCodeParams:params success:^(NSDictionary * _Nullable data) {
                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                        if ([data isKindOfClass:[NSDictionary class]]&&data) {
                            if ([[data kkz_stringForKey:@"status"] isEqualToString:@"0"]) {
                                DLog(@"手机号是否被用了：%@",data);
                                //MARK: 发送验证码接口,在验证码发送成功后，添加
                                timeCountOfBind = 60;
                                weakSelf.timerOfBind = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(beforeActivityMethodInBind:) userInfo:nil repeats:YES];
                                [topView addSubview:self.codeViewOfTop];
                                [weakSelf codeTitleViewWithStr:[NSString stringWithFormat:@"已向手机号%@\n发送了验证码",[[DataEngine sharedDataEngine].userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]] andIsTimeOut:NO];
                                [weakSelf initFisrtViewOfCenterWithTitleStr:@"设置密码" andWithStatus:@"finished"];
                                [weakSelf.passwordFieldSet resignFirstResponder];
                                [weakSelf.passwordField resignFirstResponder];
                                [weakSelf initSecondViewOfCenterWithTitleStr:@"确认密码" andWithStatus:@"finished"];
                                [weakSelf initThirdViewOfCenterWithTitleStr:@"验证码" andWithStatus:@"input"];
                                [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
                                [weakSelf.inputViewOfBottom addSubview:weakSelf.codeField];
                                [weakSelf.inputViewOfBottom addSubview:weakSelf.codeFieldLabel];
                                [weakSelf.codeField becomeFirstResponder];
                                [[CIASAlertCancleView new] show:@"温馨提示" message:@"验证码已发送" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                                }];
                            }
                        }
                    } failure:^(NSError * _Nullable err) {
                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                    }];
//                    [topView addSubview:self.codeViewOfTop];
//                    [weakSelf codeTitleViewWithStr:[NSString stringWithFormat:@"已向手机号%@\n发送了验证码",[[DataEngine sharedDataEngine].userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]] andIsTimeOut:NO];
//                    [weakSelf initFisrtViewOfCenterWithTitleStr:@"设置密码" andWithStatus:@"finished"];
//                    [weakSelf.passwordFieldSet resignFirstResponder];
//                    [weakSelf.passwordField resignFirstResponder];
//                    [weakSelf initSecondViewOfCenterWithTitleStr:@"确认密码" andWithStatus:@"finished"];
//                    [weakSelf initThirdViewOfCenterWithTitleStr:@"验证码" andWithStatus:@"input"];
//                    [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
//                    [weakSelf.inputViewOfBottom addSubview:weakSelf.codeField];
//                    [weakSelf.inputViewOfBottom addSubview:weakSelf.codeFieldLabel];
//                    [weakSelf.codeField becomeFirstResponder];
                    
                } else {
                    [[CIASAlertCancleView new] show:@"温馨提示" message:@"设置密码和确认密码不一致，请仔细核对" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                    }];
                }
            }
        } else {
            [self initFisrtViewOfCenterWithTitleStr:@"设置密码" andWithStatus:@"finished"];
            [self.passwordFieldSet resignFirstResponder];

            [self initSecondViewOfCenterWithTitleStr:@"确认密码" andWithStatus:@"input"];
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            [self initThirdViewOfCenterWithTitleStr:@"验证码" andWithStatus:@"unInput"];
            [self.inputViewOfBottom addSubview:weakSelf.passwordField];
            [self.passwordField becomeFirstResponder];
        }
        
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请设置会员卡密码" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    }
}

- (void)beforeActivityMethodInBind:(NSTimer *)time {
    timeCountOfBind--;
    if (timeCountOfBind ==  0) {
        [self codeTitleViewWithStr:@"        验证码已超时\n请点击重新发送验证码" andIsTimeOut:YES];
        //改变验证码显示加上倒计时
        [self initThirdViewOfCenterWithTitleStr:@"验证码" andWithStatus:@"input"];
        [self.timerOfBind invalidate];
        self.timerOfBind = nil;
        
    }else {
        [self initThirdViewOfCenterWithTitleStr:[NSString stringWithFormat:@"验证码%d\"",timeCountOfBind] andWithStatus:@"input"];
    }
}

//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth - 60*2, 20)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}

- (void) cancelViewController {
    if (self.timerOfBind.isValid) {
        [self.timerOfBind invalidate];
        self.timerOfBind = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //kNumbers
    if (textField == self.passwordFieldSet) {
        int length = (int)textField.text.length;
        if (length >= 6  &&  string.length >0)
        {
            return  NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
        
    }
    
    if (textField == self.passwordField) {
        
        int length = (int)textField.text.length;
        if (length >= 6  &&  string.length >0)
        {
            return  NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    if (textField == self.codeField) {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        int length = (int)textField.text.length;
        if (length >= 6 && string.length > 0) {
            
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (kCommonScreenHeight < 667) {
        [UIView animateWithDuration:.2
                         animations:^{
                             
                             self.cardViewOfTop.frame = CGRectMake(0, -25, kCommonScreenWidth, 251*Constants.screenHeightRate);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
    if (textField == self.passwordFieldSet){
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
            
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
    } else if (textField == self.passwordField) {
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
            
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
    } else if (textField == self.codeField) {
        if (textField.text.length > 0) {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = YES;
            
        } else {
            [rightBarBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
            rightBarBtn.userInteractionEnabled = NO;
        }
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (kCommonScreenHeight < 667) {
        [UIView animateWithDuration:.2
                         animations:^{
                             
                             self.cardViewOfTop.frame = CGRectMake(0, 0, kCommonScreenWidth, 251*Constants.screenHeightRate);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
