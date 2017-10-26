//
//  CustomAlertView.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/14.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CustomAlertView.h"
#import "KKZUtility.h"
#import "UIColor+Hex.h"
#import "ACustomButton.h"

typedef enum : NSUInteger {
    baseButtonTag = 1000,
} allButtonTag;

@interface CustomAlertView ()
{
    //白色圆角视图
    UIView *whiteView;
}

@property (nonatomic, strong) ClickBlock myBlock;
@end

@implementation CustomAlertView

- (id)initWithTitle:(NSString *)titleString
        detailTitle:(NSString *)detailString
       cancelButton:(NSString *)cancelString
         clickBlock:(ClickBlock)block
  otherButtonTitles:(NSString *)otherButtonTitles,...
{
    CGFloat width = 270.0f;
    CGFloat height = 130.0f;
    CGFloat var_screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat var_screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0,0,var_screenWidth, var_screenHeight)];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.myBlock = block;
        
        //设置白色圆角视图
        whiteView = [[UIView alloc] initWithFrame:CGRectMake((var_screenWidth - width)/2.0f,(var_screenHeight - height)/2.0f, width, height)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 6.0f;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        
        //子标题的尺寸
        CGRect detailFrame = CGRectZero;
        UIFont *detailFont = [UIFont systemFontOfSize:12.0f];
        
        //主标题的尺寸
        CGRect titleFrame = CGRectZero;
        UIFont *titleFont = [UIFont systemFontOfSize:15.0f];
        
        //如果主标题是空
        if ([KKZUtility stringIsEmpty:titleString]) {
            if (![KKZUtility stringIsEmpty:detailString]) {
                CGFloat maxWidth = width - 20.0f;
                detailFrame = CGRectMake(10, 18, maxWidth, 20);
                CGSize customSize = [KKZUtility customTextSize:detailFont
                                                          text:detailString
                                                          size:CGSizeMake(maxWidth, 45.0f)];
                detailFrame.size.height = customSize.height;
            }else {
                detailFrame = CGRectMake(10, 18, 0, 0);
            }
        }else {
            if (![KKZUtility stringIsEmpty:detailString]) {
                
                //设置主标题
                CGFloat titleMaxWidth = width - 20.0f;
                titleFrame = CGRectMake(10, 18, titleMaxWidth, 14.0f);
                
                //设置副标题
                CGFloat detailMaxWidth = width - 20.0f;
                CGSize customSize = [KKZUtility customTextSize:detailFont
                                                          text:detailString
                                                          size:CGSizeMake(detailMaxWidth, 45.0f)];
                detailFrame = CGRectMake(10,CGRectGetMaxY(titleFrame) + 12.0f, detailMaxWidth, customSize.height);
                
            }else {
                
                //设置主标题
                CGFloat titleMaxWidth = width - 20.0f;
                CGSize customSize = [KKZUtility customTextSize:titleFont
                                                          text:titleString
                                                          size:CGSizeMake(titleMaxWidth, 45.0f)];
                titleFrame = CGRectMake(10, 18, titleMaxWidth, customSize.height);
                
                
                //设置副标题
                CGFloat detailMaxWidth = width - 20.0f;
                detailFrame = CGRectMake(10,CGRectGetMaxY(titleFrame), detailMaxWidth,0);
            }
        }
        
        //副标题
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:detailFrame];
        detailLbl.font = detailFont;
        [detailLbl setTextAlignment:NSTextAlignmentCenter];
        detailLbl.numberOfLines = 0;
        [detailLbl setTextColor:[UIColor colorWithHex:@"#999999"]];
        detailLbl.text = detailString;
        detailLbl.lineBreakMode = NSLineBreakByClipping;
        detailLbl.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:detailLbl];
        
        //主标题
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:titleFrame];
        [titleLbl setTextColor:[UIColor colorWithHex:@"#333333"]];
        [titleLbl setTextAlignment:NSTextAlignmentCenter];
        titleLbl.text = titleString;
        titleLbl.font = titleFont;
        titleLbl.numberOfLines = 0;
        [whiteView addSubview:titleLbl];
        
        //分割线
        UIView *seperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailFrame) + 18.0f, width, 1)];
        seperateLine.backgroundColor = [UIColor colorWithHex:@"#c8c8c8"];
        [whiteView addSubview:seperateLine];
        
        //创建按钮数组
        NSMutableArray *argsArray = [[NSMutableArray alloc] initWithObjects:cancelString,nil];
        
        va_list params;
        va_start(params, otherButtonTitles);
        id arg;
        if (otherButtonTitles) {
            id prev = otherButtonTitles;
            [argsArray addObject:prev];
            
            while (arg == va_arg(params, id)) {
                if (arg) {
                    [argsArray addObject:arg];
                }
            }
            
            //置空
            va_end(params);
        }
        
        int i=0;
        
        for (NSString *title in argsArray) {
            
            //获取每个按钮的宽度
            CGFloat btnWidth = width / argsArray.count;
            
            //创建点击按钮
            ACustomButton *btn = [ACustomButton buttonWithType:0];
            [btn setTitle:title
                 forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHex:@"#008cff"]
                      forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            btn.frame = CGRectMake(i * btnWidth, CGRectGetMaxY(seperateLine.frame), btnWidth, 45.0f);
            btn.tag = baseButtonTag + i;
            [btn addTarget:self
                    action:@selector(hideView:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHex:@"#eeeeee"]
                           forState:UIControlStateHighlighted];
            [whiteView addSubview:btn];
            
            //重新计算视图尺寸
            CGFloat finalHeight = CGRectGetMaxY(btn.frame);
            whiteView.frame = CGRectMake((var_screenWidth - width)/2.0f,(var_screenHeight - finalHeight)/2.0f, width, finalHeight);
            
            //每两个按钮之间的分割线
            if (i >= 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(btn.frame))];
                line.backgroundColor = [UIColor colorWithHex:@"#c8c8c8"];
                [btn addSubview:line];
            }
            
            //偏移量
            i++;
        }
    }
    return self;
}

- (void)hideView:(UIButton *)sender{
    if (self.myBlock) {
        self.myBlock(sender.tag - baseButtonTag);
    }
    [self removeFromSuperview];
}

- (void)show {
    
    //AppDelegate UIWindow的对象
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow addSubview:self];
    
    //创建关键帧动画(继承于CAPropertyAnimation)
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.2f;
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    //创建动画变化参数
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    anim.values = values;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [whiteView.layer addAnimation:anim
                      forKey:@""];
    
}

@end
