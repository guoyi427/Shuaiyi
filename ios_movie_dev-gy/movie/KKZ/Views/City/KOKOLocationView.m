//
//  KOKOLocationView.m
//  KoMovie
//
//  Created by renzc on 16/9/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KOKOLocationView.h"
#import "XMLampText.h"

#define locationLabelFont 15

#define locationViewWidth ((screentWith - 158) * 0.5 - 10)

#define locationLabelWidth (locationViewWidth - 30)

#define accountTitleLabelBgWidth (locationViewWidth - 30)

#define locationIconImageViewLeft (10 + accountTitleLabelBgWidth + 5)

/****************定位城市名称********************/


const static CGFloat locationLabelHeight = 15.0f;

/****************定位城市名称Bg********************/

const static CGFloat accountTitleLabelBgLeft = 10.0f;

const static CGFloat accountTitleLabelBgTop = 14.0f;

const static CGFloat accountTitleLabelBgHeight = 15.0f;

/****************定位的Icon********************/

//const static CGFloat locationIconImageViewLeft = 68.0f;

const static CGFloat locationIconImageViewTop = 19.5f;

const static CGFloat locationIconImageViewWidth = 8.0f;

const static CGFloat locationIconImageViewHeight = 4.5f;



@implementation KOKOLocationView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        
        [self addSubview:self.accountTitleLabelBg];
        [self addSubview:self.locationIconImageView];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    
    
    UITapGestureRecognizer  *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];
    
    
    return self;
}


-(void)setCityText:(NSString *)cityText
{
    _cityText = cityText;
    
    _locationLabel.lampText = _cityText;
    
    self.motionWidth = accountTitleLabelBgWidth;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:locationLabelFont];
    attributes[NSForegroundColorAttributeName] = appDelegate.kkzBlue;
    
    CGSize s = [_locationLabel.lampText sizeWithAttributes:attributes];
    
    CGFloat accountTitleLabelLeft = 0;
    
    if (s.width + 5 > accountTitleLabelBgWidth) {
        _locationLabel.frame = CGRectMake(accountTitleLabelLeft, 0, s.width + 5, locationLabelHeight);
        _locationIconImageView.frame = CGRectMake(locationIconImageViewLeft, locationIconImageViewTop, locationIconImageViewWidth, locationIconImageViewHeight);
    } else {
        _locationLabel.frame = CGRectMake(accountTitleLabelLeft, 0, s.width + 5, locationLabelHeight);
        _locationIconImageView.frame = CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 15, locationIconImageViewTop, locationIconImageViewWidth, locationIconImageViewHeight);
    }
    
    
}

-(void)setMotionWidth:(CGFloat)motionWidth
{
    _motionWidth = motionWidth;
    
    _locationLabel.motionWidth = motionWidth;
    
}


#pragma mark - lazy load
/**
 *  定位城市名称Bg
 */
- (UIView *)accountTitleLabelBg {
    if (!_accountTitleLabelBg) {
        _accountTitleLabelBg = [[UIView alloc] initWithFrame:CGRectMake(accountTitleLabelBgLeft, accountTitleLabelBgTop, accountTitleLabelBgWidth, accountTitleLabelBgHeight)];
        [_accountTitleLabelBg addSubview:self.locationLabel];
        _accountTitleLabelBg.backgroundColor = [UIColor clearColor];
        _accountTitleLabelBg.userInteractionEnabled = NO;
        _accountTitleLabelBg.clipsToBounds = YES;
    }
    return _accountTitleLabelBg;
}

/**
 *  定位城市名称
 */
- (XMLampText *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[XMLampText alloc] initWithFrame:CGRectMake(0, 0, locationLabelWidth, locationLabelHeight)];
        _locationLabel.lineBreakMode = NSLineBreakByClipping;
        _locationLabel.motionWidth = accountTitleLabelBgWidth;
        _locationLabel.lampFont = [UIFont systemFontOfSize:locationLabelFont];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.userInteractionEnabled = NO;
        _locationLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _locationLabel;
}

/**
 *  定位的Icon
 */
- (UIImageView *)locationIconImageView {
    if (!_locationIconImageView) {
        _locationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(locationIconImageViewLeft, locationIconImageViewTop, locationIconImageViewWidth, locationIconImageViewHeight)];
        _locationIconImageView.image = [UIImage imageNamed:@"whiteDownArrow"];
        _locationIconImageView.userInteractionEnabled = YES;
        [_locationIconImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _locationIconImageView;
}



-(void)handleSingleTapFrom{
    if ([self.delegate respondsToSelector:@selector(changeCityBtnClicked:)]) {
        [self.delegate changeCityBtnClicked:self];
    }
}



@end
