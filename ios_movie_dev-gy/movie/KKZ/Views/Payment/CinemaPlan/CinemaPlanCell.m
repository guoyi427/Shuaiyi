//
//  排期列表的Cell
//
//  Created by 艾广华 on 16/4/14.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaPlanCell.h"

#import "ACustomButton.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "KKZUtility.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"

/***************开始时间标签************/
static const CGFloat beginTimeLeft = 15.0f;
static const CGFloat beginTimeTop = 15.0f;
static const CGFloat beginTimeWidth = 60.0f;
static const CGFloat beginTimeHeight = 21.0f;
static const CGFloat beginTimeFont = 17.0f;

/***************散场时间标签************/
static const CGFloat endTimeLeft = 15.0f;
static const CGFloat endTimeTop = 5.0f;
static const CGFloat endTimeWidth = 60.0f;
static const CGFloat endTimeHeight = 14.0f;
static const CGFloat endTimeFont = 11.0f;

/***************购票按钮************/
static const CGFloat buyButtonRight = 15.0f;
static const CGFloat buyButtonTop = 26.0f;
static const CGFloat buyButtonWidth = 46.0f;
static const CGFloat buyButtonHeight = 28.0f;
static const CGFloat buyButtonFont = 13.0f;

/***************分割线************/
static const CGFloat lineHeight = 0.3f;


@interface CinemaPlanCell ()

/**
 *  开始时间标签
 */
@property (nonatomic, strong) UILabel *startTimeLabel;

/**
 *  结束时间标签
 */
@property (nonatomic, strong) UILabel *endTimeLabel;

/**
 *  购买按钮
 */
@property (nonatomic, strong) ACustomButton *buyButton;

/**
 *  价钱标签
 */
@property (nonatomic, strong) UILabel *priceLabel;

/**
 *  原价标签
 */
@property (nonatomic, strong) UILabel *standardLabel;

/**
 活动标签
 */
@property (nonatomic, strong) UILabel *promotionLabel;

/**
 *  电影类型
 */
@property (nonatomic, strong) UILabel *movieTypeLabel;

/**
 *  影院厅标签
 */
@property (nonatomic, strong) UILabel *movieHallLabel;

/**
 *  电影是否过场
 */
@property (nonatomic, assign) BOOL expireDate;

/**
 *  分割线视图
 */
@property (nonatomic, strong) UIView *lineView;


/**
 当前场次
 */
@property (nonatomic, strong) UILabel *labelCurrent;

/**
 购票 回调
 */
@property (nonatomic, copy) void (^buyTicketBlock)(Ticket *plan);

@end

@implementation CinemaPlanCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.startTimeLabel];
        [self addSubview:self.endTimeLabel];
        [self addSubview:self.buyButton];
        [self addSubview:self.priceLabel];
        [self addSubview:self.standardLabel];
        [self addSubview:self.movieTypeLabel];
        [self addSubview:self.movieHallLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.promotionLabel];
        
        [self.movieTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@88);
            make.top.equalTo(@18);
        }];
        
        [self.movieHallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.movieTypeLabel);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
    }
    return self;
}

- (void)setModel:(Ticket *)model {

    _model = model;

    //开始时间
    NSString *timeDesc = [[DateEngine sharedDateEngine] shortTimeStringFromDate:_model.movieTime];
    self.startTimeLabel.text = timeDesc;

    //结束时间
    CGFloat movieLength = [model.movieLength intValue] * 60;
    if (model.movieLength.integerValue == 0) {
        movieLength = 90 * 60;//    默认90分钟
    }
    NSDate *endMovieTime = [_model.movieTime dateByAddingTimeInterval:movieLength];
    NSString *endTimeInfo = [[DateEngine sharedDateEngine] shortTimeStringFromDate:endMovieTime];
    NSString *overTime = [NSString stringWithFormat:@"%@散场", endTimeInfo];
    self.endTimeLabel.text = overTime;

    /*
     价格这块展示：
     1、当没有优惠，抠电影原价大于等于水牌价时，只显示抠电影原价；
     抠电影原价小于水牌价时，显示抠电影默认的售票价和水牌价；
     红色为抠电影原价，灰色为水牌价；
     2、当有优惠， 活动价大于等于抠电影原价时， 只显示活动价和活动信息；
     活动价小于抠电影原价时，显示抠电影活动价，抠电影售价和活动标签；
     红色为活动价，灰色为抠电影原价、绿色为活动信息（运营来配置）；
     */
    
    UILabel *topL = nil;
    UILabel *topR = nil;
    UILabel *bottom = nil;
    
    if (model.promotionPrice && [_model.standardPrice isEqualToNumber:model.promotionPrice.toNumber] == NO) {
        // 有活动
        NSNumber *proPrice = [model.promotionPrice toNumber];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [proPrice floatValue]];
        
        if (proPrice.integerValue >= model.vipPrice.integerValue  || proPrice.integerValue  >= model.standardPrice.integerValue ) {
            // 活动价大于抠电影价或水牌价 只显示活动价
            self.standardLabel.hidden = YES;
            topR = self.priceLabel;
        }else{
            [self setStrikethroughTablePrice:model.standardPrice > model.vipPrice ? model.vipPrice : model.standardPrice];
            self.standardLabel.hidden = NO;
            topL = self.priceLabel;
            topR = self.standardLabel;
        }
        self.promotionLabel.text = model.planShortTitle;
        self.promotionLabel.hidden = NO;
        bottom = self.promotionLabel;
    }else{
        // 没活动
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.dealPrice floatValue]];
        
        if (model.vipPrice.integerValue  >= model.standardPrice.integerValue) {
            // 抠电影价 大于等于水牌价 只显示抠电影价
            topR = self.priceLabel;
            self.standardLabel.hidden = YES;
        }else{
            topR = self.priceLabel;
            [self setStrikethroughTablePrice:model.standardPrice];
            bottom = self.standardLabel;
            self.standardLabel.hidden = NO;
        }
        
        self.promotionLabel.hidden = YES;
    }
    
    
    [topR mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-80);
        if (bottom ==nil && topL == nil) {
            make.centerY.equalTo(self);
        }else{
            make.top.equalTo(@19);
        }
    }];
    
    [topL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@17);
        if (topR) {
            make.right.equalTo(topR.mas_left).offset(-5);
        }else{
            make.right.equalTo(self.mas_right).offset(-80);
        }
        
    }];
    
    [bottom setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-80);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
    }];
    
    if (bottom) {
        [_movieHallLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(bottom.mas_left).offset(-10);
        }];
    }
    
    //电影类型
    NSString *screenDesc0 = model.screenType;
    NSString *screenDesc = @"";
    NSString *language = @"";
    if (![KKZUtility stringIsEmpty:model.language]) {
        language = [NSString stringWithFormat:@"/%@", model.language];
    }
    if (![KKZUtility stringIsEmpty:screenDesc0]) {
        screenDesc = [screenDesc0 uppercaseString];
    }
    self.movieTypeLabel.text = [NSString stringWithFormat:@"%@%@", screenDesc, language];

    //电影厅
    NSString *hallStr = @"";
    if (![KKZUtility stringIsEmpty:model.hallName]) {
        hallStr = model.hallName;
    }
    self.movieHallLabel.text = hallStr;

    //设置购买按钮样式
    [self setBuyButtonStyle];
}

/**
 设置划掉价格

 @param pri 价格
 */
- (void) setStrikethroughTablePrice:(NSNumber *)pri
{
    // 比较水牌价和抠电影价，取小的
//    NSNumber *pri = (_model.standardPrice.floatValue > model.vipPrice.floatValue && hasPromotion && model.promotionPrice.floatValue != model.vipPrice.floatValue) ? model.vipPrice : model.standardPrice;
    // 存在优惠，设置原价信息
    NSString *discountString = [NSString stringWithFormat:@"￥%.0f", [pri floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:discountString];
    [str addAttribute:NSStrikethroughStyleAttributeName
                value:@1
                range:NSMakeRange(0, str.length)];
    // ￥会上浮，导致横线分割
    [str addAttribute:NSBaselineOffsetAttributeName
                value:@-0.5
                range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:discountFont]
                range:NSMakeRange(0, str.length)];
    self.standardLabel.attributedText = str;

}

- (void)setBuyButtonStyle {
    //是否是推广
    UIColor *color = appDelegate.kkzPink;//[UIColor colorWithHex:@"#008cff"];
    NSString *title = @"购票";
    if (!_model.supportBuy) {
        title = @"即将开放";
    }
    //不过是特惠还是购票只过场都显示过场信息
    if (_model.expireDate) {
        color = [UIColor colorWithHex:@"#969696"];
        title = @"已过场";
    }
    self.buyButton.highlighted = FALSE;
    [self.buyButton setTitle:title
                    forState:UIControlStateNormal];
    [self.buyButton setTitleColor:color
                         forState:UIControlStateNormal];
    [self.buyButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateHighlighted];
    [self.buyButton setBackgroundColor:color
                              forState:UIControlStateHighlighted];
    [self.buyButton setBackgroundColor:[UIColor clearColor]
                              forState:UIControlStateNormal];
    self.buyButton.layer.borderColor = color.CGColor;
}

- (void) setIsCurrentPlan:(BOOL)isCurrent
{
    if (isCurrent == YES) {
        self.buyButton.hidden = YES;
        if (self.labelCurrent == nil) {
            self.labelCurrent = [[UILabel alloc] init];
            self.labelCurrent.textAlignment = NSTextAlignmentCenter;
            self.labelCurrent.font = [UIFont systemFontOfSize:12];
            self.labelCurrent.text = @"当前场次";
            self.labelCurrent.textColor = [UIColor colorWithHex:@"0x666666"];
            [self addSubview:self.labelCurrent];
            [self.labelCurrent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.buyButton);
            }];
        }
        self.labelCurrent.hidden = NO;
    }else{
        self.buyButton.hidden = NO;
        self.labelCurrent.hidden = YES;
    }
}

- (void)commonBtnClick:(UIButton *)sender {
    [self joinBuyTicketViewController];
}

/**
 跳转选座页面
 */
- (void)joinBuyTicketViewController {
    if (_model.supportBuy && self.buyTicketBlock) {
        
        self.buyTicketBlock(self.model);
        
    }
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(beginTimeLeft, beginTimeTop, beginTimeWidth, beginTimeHeight)];
        _startTimeLabel.font = [UIFont systemFontOfSize:beginTimeFont];
        _startTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _startTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(endTimeLeft, CGRectGetMaxY(self.startTimeLabel.frame) + endTimeTop, endTimeWidth, endTimeHeight)];
        _endTimeLabel.font = [UIFont systemFontOfSize:endTimeFont];
        _endTimeLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _endTimeLabel;
}

- (ACustomButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [ACustomButton buttonWithType:0];
        _buyButton.frame = CGRectMake(kCommonScreenWidth - buyButtonRight - buyButtonWidth, buyButtonTop, buyButtonWidth, buyButtonHeight);
        _buyButton.backgroundColor = [UIColor whiteColor];
        [_buyButton.titleLabel setFont:[UIFont systemFontOfSize:buyButtonFont]];
        [_buyButton setTitle:@"购票"
                    forState:UIControlStateNormal];
        [_buyButton setTitleColor:appDelegate.kkzPink//[UIColor colorWithHex:@"#008cff"]
                         forState:UIControlStateNormal];
        _buyButton.layer.borderColor = appDelegate.kkzPink.CGColor;//[UIColor colorWithHex:@"#008cff"].CGColor;
        _buyButton.layer.borderWidth = K_ONE_PIXEL;
        _buyButton.layer.cornerRadius = buyButtonHeight/2.0;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:priceLabelFont];
        _priceLabel.textColor = appDelegate.kkzPink;//[UIColor colorWithHex:@"#ff6900"];
        _priceLabel.backgroundColor = [UIColor clearColor];
    }
    return _priceLabel;
}

- (UILabel *)standardLabel {
    if (!_standardLabel) {
        _standardLabel = [UILabel new];
        _standardLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _standardLabel.font = [UIFont systemFontOfSize:11];
    }
    return _standardLabel;
}

- (UILabel *) promotionLabel {
    if (!_promotionLabel) {
        _promotionLabel = [UILabel new];
        _promotionLabel.textColor = [UIColor colorWithHex:@"#57c45d"];
        _promotionLabel.font = [UIFont systemFontOfSize:11];
    }
    return _promotionLabel;
}


- (UILabel *)movieTypeLabel {
    if (!_movieTypeLabel) {
        _movieTypeLabel = [UILabel new];
        _movieTypeLabel.font = [UIFont systemFontOfSize:movieTypeFont];
        _movieTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieTypeLabel.backgroundColor = [UIColor clearColor];
        _movieTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieTypeLabel;
}

- (UILabel *)movieHallLabel {
    if (!_movieHallLabel) {
        _movieHallLabel = [UILabel new];
        _movieHallLabel.font = [UIFont systemFontOfSize:movieHallFont];
        _movieHallLabel.textColor = [UIColor colorWithHex:@"#999999"];
        _movieHallLabel.backgroundColor = [UIColor clearColor];
    }
    return _movieHallLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, lineHeight)];
        _lineView.backgroundColor = kDividerColor;
    }
    return _lineView;
}

/**
 点击购票 回调
 
 @param a_block 回调
 */
- (void) buyTicketCallback:(void(^)(Ticket *plan))a_block
{
    self.buyTicketBlock = [a_block copy];
}

@end
