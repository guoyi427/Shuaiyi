//
//  CPTabItemView.m
//  Cinephile
//
//  Created by Albert on 7/7/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPTabItemView.h"
#import <Category_KKZ/UIColor+Hex.h>
#import "UserDefault.h"
#import "UIConstants.h"

@interface CPTabItemView ()
{
    int itemCount;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *highlightIcon;
@property (nonatomic, copy) void(^selectBlock)(CPTabItemView *item);
@end

@implementation CPTabItemView
#define K_BAR_TEXT_COLOR [UIColor colorWithHex:[UIConstants sharedDataEngine].tabNonSelectedColor]
//[UIColor colorWithHex:@"#979797"]
#define K_BAR_TEXT_COLOR_HIGHLIGHT [UIColor redColor]

+ (instancetype) itemWith:(NSString *)title icon:(UIImage *) icon highlightIcon:(UIImage *)highlightIcon point:(NSString *)loc
{
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        APP_TABBAR_LOC_WRITE(loc);
    }
    
//    #if kIsHuaChenTmpTabbarStyle
//        APP_TABBAR_LOC_WRITE_HC(loc);
//    #endif
    
    CPTabItemView *item = [[CPTabItemView alloc] init];
    item.titleLabel.text = title;
    item.icon = icon;
    item.highlightIcon = highlightIcon;

    return item;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = K_BAR_TEXT_COLOR;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.titleLabel];
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        NSString *tabbar_loc = APP_TABBAR_LOC;
//        DLog(@"第%@个", tabbar_loc);
        if ([tabbar_loc isEqualToString:@"3"]) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.bottom.equalTo(self.mas_bottom).offset(-4);
                make.height.equalTo(@0);
            }];
            
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.bottom.equalTo(self.mas_bottom).offset(-5);
                make.centerX.equalTo(self);
            }];
        } else {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.bottom.equalTo(self.mas_bottom).offset(-4);
                make.height.equalTo(@15);
            }];
            
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@6);
                make.left.right.equalTo(@0);
                make.bottom.equalTo(self.titleLabel.mas_top).offset(-3);
                make.centerX.equalTo(self);
            }];
        }
    }
    
    #if kIsHuaChenTmpTabbarStyle
    
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom).offset(-4);
            make.height.equalTo(@15);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@6);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-3);
            make.centerX.equalTo(self);
        }];
    
    
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom).offset(-4);
            make.height.equalTo(@15);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@6);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-3);
            make.centerX.equalTo(self);
        }];
        
        
    #endif
    
    
    #if kIsXinchengTmpTabbarStyle
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom).offset(-4);
            make.height.equalTo(@15);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@6);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-3);
            make.centerX.equalTo(self);
        }];
    #endif
    
    
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.mas_bottom).offset(-4);
            make.height.equalTo(@15);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@6);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-3);
            make.centerX.equalTo(self);
        }];
    }
    
    
    
    UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler)];
    [self addGestureRecognizer:tapGestrue];
    
}

- (void) setIcon:(UIImage *)icon
{
    _icon = icon;
    self.iconView.image = icon;
}


- (void)setHighlight:(BOOL)heighlight
{
    if (_isHighlight == heighlight) {
        return;
    }
    
    _isHighlight = heighlight;
    
    if (heighlight == YES) {
        self.iconView.image = self.highlightIcon;
        self.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tabSelectedColor];
    }else{
        self.iconView.image = self.icon;
        self.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tabNonSelectedColor];
    }
    
}


- (void) tapHandler
{
    if (self.selectBlock) {
        __weak __typeof(self) weakSelf = self;
        self.selectBlock(weakSelf);
    }
}

/**
 *  选中回调
 *
 *  @param block 回调
 */
- (void) didSelect:(void (^)(CPTabItemView *item))block
{
    self.selectBlock = [block copy];
}

@end
