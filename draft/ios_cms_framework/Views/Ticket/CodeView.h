//
//  CodeView.h
//  HengDianMovie
//
//  Created by avatar on 2017/2/10.
//  Copyright © 2017年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZXVerificationCodeView.h"
//添加代理方法
@protocol CodeViewDelegate <NSObject>

- (void) backBtnBeClickWith:(NSString *)codeStr;
- (void) getCodeButtonClick;
- (void) backBtnClickOfCodeView;

@end

@interface CodeView : UIView
{
    int timeCount;
    UIButton *getCodeBtnOfCW;
}
@property (nonatomic, weak) id <CodeViewDelegate> delegate;

@property (nonatomic, strong) UILabel *titleOfCW,*tipTitleOfCW;
@property (nonatomic, strong) PZXVerificationCodeView *pzxView;

@property (nonatomic, strong) UIButton *btnOfCW;
@property (nonatomic, assign) BOOL isWrong;
@property (nonatomic, strong) UILabel *wrongTipsLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy)   NSString *orderNo;


- (id)initWithFrame:(CGRect)frame delegate:(id <CodeViewDelegate>)aDelegate andOrderNo:(NSString *)orderNoStr;


@end
