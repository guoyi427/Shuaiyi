//
//  CPTabBarView.m
//  Cinephile
//
//  Created by Albert on 7/7/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "CPTabBarView.h"
#import "CPTabItemView.h"
#import "UIColor+Hex.h"

@interface CPTabBarView ()
@property (nonatomic, strong) CPTabItemView *itemHome;
@property (nonatomic, strong) CPTabItemView *itemTicket;
@property (nonatomic, strong) CPTabItemView *itemVipcard;
@property (nonatomic, strong) CPTabItemView *itemMe;

@property (nonatomic, strong) CPTabItemView *itemMall;
@property (nonatomic, strong) CPTabItemView *itemDiscover;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index);
@end

#define K_TAB_TAG_BASE 100

@implementation CPTabBarView

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
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];//[UIColor colorWithHex:@"0x434343"];
    __weak __typeof(self) weakSelf = self;
    
#if kIsXinchengTmpTabbarStyle
    void (^select)(CPTabItemView *item) = ^void (CPTabItemView *item) {
        NSInteger index = 0;
        switch (item.tag) {
            case 100:
                index = 0;
                break;
            case 101:
                index = 1;
                break;
            case 102:
                index = 2;
                break;
            case 103:
                index = 3;
                break;
                //            case 104:
                //                index = 4;
                //                break;
            default:
                break;
        }
        
        [self selectAtIndex:index];
        
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(index);
        }
    };
    
    self.itemHome = [CPTabItemView itemWith:@"首页"
                                       icon:[UIImage imageNamed:@"tab_home_default"]
                              highlightIcon:[UIImage imageNamed:@"tab_home_focus"]point:@"1"];
    self.itemHome.tag = K_TAB_TAG_BASE;
    [self.itemHome didSelect:select];
    
    [self addSubview:self.itemHome];
    
    
    self.itemTicket = [CPTabItemView itemWith:@"购票"
                                         icon:[UIImage imageNamed:@"tab_ticket_default"]
                                highlightIcon:[UIImage imageNamed:@"tab_ticket_focus"]point:@"2"];
    
    self.itemTicket.tag = K_TAB_TAG_BASE + 1;
    [self.itemTicket didSelect:select];
    [self addSubview:self.itemTicket];
    
    self.itemVipcard = [CPTabItemView itemWith:@"资讯"
                                          icon:[UIImage imageNamed:@"tab_news_default"]
                                 highlightIcon:[UIImage imageNamed:@"tab_news_focus"]point:@"3"];
    
    self.itemVipcard.tag = K_TAB_TAG_BASE + 2;
    [self.itemVipcard didSelect:select];
    [self addSubview:self.itemVipcard];
    
    
    self.itemMe = [CPTabItemView itemWith:@"我的"
                                     icon:[UIImage imageNamed:@"tab_mine_default"]
                            highlightIcon:[UIImage imageNamed:@"tab_mine_focus"]point:@"4"];
    self.itemMe.tag = K_TAB_TAG_BASE + 3;
    [self.itemMe didSelect:select];
    [self addSubview:self.itemMe];
    
    //    self.itemMall = [CPTabItemView itemWith:@""
    //                                       icon:[UIImage imageNamed:@"tab_home_default"]
    //                              highlightIcon:[UIImage imageNamed:@"tab_home_focus"]];
    //    self.itemMall.tag = K_TAB_TAG_BASE + 2;
    //    [self.itemMall didSelect:select];
    //    [self addSubview:self.itemMall];
    //
    //    self.itemDiscover = [CPTabItemView itemWith:@"发现"
    //                                     icon:[UIImage imageNamed:@"home"]
    //                            highlightIcon:[UIImage imageNamed:@"home_highlight"]];
    //    self.itemDiscover.tag = K_TAB_TAG_BASE + 3;
    //    [self.itemDiscover didSelect:select];
    //    [self addSubview:self.itemDiscover];
    
    
    float tabGapW = (kCommonScreenWidth-44*4)/4;
    
    [self.itemHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(tabGapW/2));
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    [self.itemTicket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemHome.mas_right).offset(tabGapW);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    [self.itemVipcard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemTicket.mas_right).offset(tabGapW);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    [self.itemMe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(tabGapW/2));
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    //    [self.itemMall mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.mas_centerX);
    //        make.top.bottom.equalTo(@0);
    //        make.width.equalTo(@44);
    //
    //    }];
    //    [self.itemDiscover mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.itemMall.mas_right).offset(tabGapW);
    //        make.top.bottom.equalTo(@0);
    //        make.width.equalTo(@44);
    //
    //    }];
    
    
    
    
    //MARK: 默认选中项
    self.itemHome.isHighlight = YES;
    self.selectedIndex = 0;
    
#endif
    
#if kIsHuaChenTmpTabbarStyle
    void (^select)(CPTabItemView *item) = ^void (CPTabItemView *item) {
        NSInteger index = 0;
        switch (item.tag) {
            case 100:
                index = 0;
                break;
            case 101:
                index = 1;
                break;
            case 102:
                index = 2;
                break;
            default:
                break;
        }
        
        [self selectAtIndex:index];
        
        if (weakSelf.selectBlock) {
            weakSelf.selectBlock(index);
        }
    };
    
    self.itemHome = [CPTabItemView itemWith:@"首页"
                                       icon:[UIImage imageNamed:@"tab_home_default"]
                              highlightIcon:[UIImage imageNamed:@"tab_home_focus"]
                                      point:@"1"];
    self.itemHome.tag = K_TAB_TAG_BASE;
    [self.itemHome didSelect:select];
    [self addSubview:self.itemHome];
    
    self.itemTicket = [CPTabItemView itemWith:@"购票"
                                         icon:[UIImage imageNamed:@"tab_ticket_default"]
                                highlightIcon:[UIImage imageNamed:@"tab_ticket_focus"]
                                        point:@"2"];
    
    self.itemTicket.tag = K_TAB_TAG_BASE + 1;
    [self.itemTicket didSelect:select];
    [self addSubview:self.itemTicket];
    
    
    
    self.itemMe = [CPTabItemView itemWith:@"我的"
                                     icon:[UIImage imageNamed:@"tab_mine_default"]
                            highlightIcon:[UIImage imageNamed:@"tab_mine_focus"]
                                    point:@"3"];
    self.itemMe.tag = K_TAB_TAG_BASE + 2;
    [self.itemMe didSelect:select];
    [self addSubview:self.itemMe];
    
    
    float tabGapW = (kCommonScreenWidth-44*3)/3;
    
    [self.itemHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(tabGapW/2));
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    [self.itemTicket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);;
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    [self.itemMe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(tabGapW/2));
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@44);
        
    }];
    
    
    //MARK: 默认选中项
    self.itemHome.isHighlight = YES;
    self.selectedIndex = 0;

#endif
    
    #if kIsSingleCinemaTabbarStyle
    
        void (^select)(CPTabItemView *item) = ^void (CPTabItemView *item) {
            NSInteger index = 0;
            switch (item.tag) {
                case 100:
                    index = 0;
                    break;
                case 101:
                    index = 1;
                    break;
                case 102:
                    index = 2;
                    break;
                default:
                    break;
            }
            
            [self selectAtIndex:index];
            
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(index);
            }
        };
        
        self.itemHome = [CPTabItemView itemWith:@"影片"
                                           icon:[UIImage imageNamed:@"tab_movie_default"]
                                  highlightIcon:[UIImage imageNamed:@"tab_movie_focus"]
                                          point:@"1"];
        self.itemHome.tag = K_TAB_TAG_BASE;
        [self.itemHome didSelect:select];
        [self addSubview:self.itemHome];
        
        self.itemTicket = [CPTabItemView itemWith:@"影院"
                                             icon:[UIImage imageNamed:@"tab_cinema_default"]
                                    highlightIcon:[UIImage imageNamed:@"tab_cinema_focus"]
                                            point:@"2"];
        
        self.itemTicket.tag = K_TAB_TAG_BASE + 1;
        [self.itemTicket didSelect:select];
        [self addSubview:self.itemTicket];
        
        
        
        self.itemMe = [CPTabItemView itemWith:@"我的"
                                         icon:[UIImage imageNamed:@"tab_mine_default"]
                                highlightIcon:[UIImage imageNamed:@"tab_mine_focus"]
                                        point:@"3"];
        self.itemMe.tag = K_TAB_TAG_BASE + 2;
        [self.itemMe didSelect:select];
        [self addSubview:self.itemMe];
        
        
        float tabGapW = (kCommonScreenWidth-44*3)/3;
        
        [self.itemHome mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemTicket mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);;
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemMe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        
        //MARK: 默认选中项
        self.itemHome.isHighlight = YES;
        self.selectedIndex = 0;
    
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        void (^select)(CPTabItemView *item) = ^void (CPTabItemView *item) {
            NSInteger index = 0;
            switch (item.tag) {
                case 100:
                    index = 0;
                    break;
                case 101:
                    index = 1;
                    break;
                case 102:
                    index = 2;
                    break;
                case 103:
                    index = 3;
                    break;
                case 104:
                    index = 4;
                    break;
                default:
                    break;
            }
            
            [self selectAtIndex:index];
            
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(index);
            }
        };
        
        self.itemTicket = [CPTabItemView itemWith:@"购票"
                                             icon:[UIImage imageNamed:@"tab_ticket_default"]
                                    highlightIcon:[UIImage imageNamed:@"tab_ticket_focus"]
                                            point:@"1"];
        
        self.itemTicket.tag = K_TAB_TAG_BASE;
        [self.itemTicket didSelect:select];
        [self addSubview:self.itemTicket];
        
        self.itemMall = [CPTabItemView itemWith:@"商城"
                                           icon:[UIImage imageNamed:@"tab_shop_default"]
                                  highlightIcon:[UIImage imageNamed:@"tab_shop_focus"]
                                          point:@"2"];
        self.itemMall.tag = K_TAB_TAG_BASE + 1;
        [self.itemMall didSelect:select];
        [self addSubview:self.itemMall];
    
        self.itemHome = [CPTabItemView itemWith:@""
                                           icon:[UIImage imageNamed:@"tab_home_default_xc"]
                                  highlightIcon:[UIImage imageNamed:@"tab_home_focus_xc"]
                                          point:@"3"];
        self.itemHome.tag = K_TAB_TAG_BASE + 2;
        [self.itemHome didSelect:select];
        [self addSubview:self.itemHome];
        

        self.itemDiscover = [CPTabItemView itemWith:@"资讯"
                                              icon:[UIImage imageNamed:@"tab_news_default"]
                                     highlightIcon:[UIImage imageNamed:@"tab_news_focus"]
                                              point:@"4"];
        
        self.itemDiscover.tag = K_TAB_TAG_BASE + 3;
        [self.itemDiscover didSelect:select];
        [self addSubview:self.itemDiscover];
        
        
        self.itemMe = [CPTabItemView itemWith:@"我的"
                                         icon:[UIImage imageNamed:@"tab_mine_default"]
                                highlightIcon:[UIImage imageNamed:@"tab_mine_focus"]
                                        point:@"5"];
        self.itemMe.tag = K_TAB_TAG_BASE + 4;
        [self.itemMe didSelect:select];
        [self addSubview:self.itemMe];
        
        
        //
        //    self.itemDiscover = [CPTabItemView itemWith:@"发现"
        //                                     icon:[UIImage imageNamed:@"home"]
        //                            highlightIcon:[UIImage imageNamed:@"home_highlight"]];
        //    self.itemDiscover.tag = K_TAB_TAG_BASE + 3;
        //    [self.itemDiscover didSelect:select];
        //    [self addSubview:self.itemDiscover];
        
        
        float tabGapW = (kCommonScreenWidth-44*5)/5;
        
        
        
        [self.itemTicket mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemMall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemTicket.mas_right).offset(tabGapW);
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemHome mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);;
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        

        [self.itemDiscover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemHome.mas_right).offset(tabGapW);
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemMe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        //        [self.itemVipcard mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.itemTicket.mas_right).offset(tabGapW);
        //            make.top.bottom.equalTo(@0);
        //            make.width.equalTo(@44);
        //
        //        }];
        
        //MARK: 默认选中项
        self.itemHome.isHighlight = YES;
        self.selectedIndex = 2;
    }
    
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        void (^select)(CPTabItemView *item) = ^void (CPTabItemView *item) {
            NSInteger index = 0;
            switch (item.tag) {
                case 100:
                    index = 0;
                    break;
                case 101:
                    index = 1;
                    break;
                case 102:
                    index = 2;
                    break;
                case 103:
                    index = 3;
                    break;
                    //            case 104:
                    //                index = 4;
                    //                break;
                default:
                    break;
            }
            
            [self selectAtIndex:index];
            
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(index);
            }
        };
        
        self.itemHome = [CPTabItemView itemWith:@"首页"
                                           icon:[UIImage imageNamed:@"tab_home_default"]
                                  highlightIcon:[UIImage imageNamed:@"tab_home_focus"]point:@"1"];
        self.itemHome.tag = K_TAB_TAG_BASE;
        [self.itemHome didSelect:select];
        
        [self addSubview:self.itemHome];
        
        
        self.itemTicket = [CPTabItemView itemWith:@"购票"
                                             icon:[UIImage imageNamed:@"tab_ticket_default"]
                                    highlightIcon:[UIImage imageNamed:@"tab_ticket_focus"]point:@"2"];
        
        self.itemTicket.tag = K_TAB_TAG_BASE + 1;
        [self.itemTicket didSelect:select];
        [self addSubview:self.itemTicket];
        
        self.itemVipcard = [CPTabItemView itemWith:@"会员卡"
                                              icon:[UIImage imageNamed:@"tab_vipcard_default"]
                                     highlightIcon:[UIImage imageNamed:@"tab_vipcard_focus"]point:@"3"];
    
        self.itemVipcard.tag = K_TAB_TAG_BASE + 2;
        [self.itemVipcard didSelect:select];
        [self addSubview:self.itemVipcard];
        
        
        self.itemMe = [CPTabItemView itemWith:@"我的"
                                         icon:[UIImage imageNamed:@"tab_mine_default"]
                                highlightIcon:[UIImage imageNamed:@"tab_mine_focus"]point:@"4"];
        self.itemMe.tag = K_TAB_TAG_BASE + 3;
        [self.itemMe didSelect:select];
        [self addSubview:self.itemMe];
        
        //    self.itemMall = [CPTabItemView itemWith:@""
        //                                       icon:[UIImage imageNamed:@"tab_home_default"]
        //                              highlightIcon:[UIImage imageNamed:@"tab_home_focus"]];
        //    self.itemMall.tag = K_TAB_TAG_BASE + 2;
        //    [self.itemMall didSelect:select];
        //    [self addSubview:self.itemMall];
        //
        //    self.itemDiscover = [CPTabItemView itemWith:@"发现"
        //                                     icon:[UIImage imageNamed:@"home"]
        //                            highlightIcon:[UIImage imageNamed:@"home_highlight"]];
        //    self.itemDiscover.tag = K_TAB_TAG_BASE + 3;
        //    [self.itemDiscover didSelect:select];
        //    [self addSubview:self.itemDiscover];
        
        
        float tabGapW = (kCommonScreenWidth-44*4)/4;
        
        [self.itemHome mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemTicket mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemHome.mas_right).offset(tabGapW);
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        [self.itemVipcard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemTicket.mas_right).offset(tabGapW);
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        [self.itemMe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-(tabGapW/2));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            
        }];
        
        //    [self.itemMall mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.mas_centerX);
        //        make.top.bottom.equalTo(@0);
        //        make.width.equalTo(@44);
        //        
        //    }];
        //    [self.itemDiscover mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.itemMall.mas_right).offset(tabGapW);
        //        make.top.bottom.equalTo(@0);
        //        make.width.equalTo(@44);
        //        
        //    }];
        
        
        
        
        //MARK: 默认选中项
        self.itemHome.isHighlight = YES;
        self.selectedIndex = 0;
    }
    
    
}


- (void) didSelec:(void (^)(NSInteger index))block
{
    self.selectBlock = [block copy];
}

-(void)selectAtIndex:(NSInteger)index
{
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        if (_selectedIndex == index || index <0 || index > 4) {
            return;
        }
    }
    
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        if (_selectedIndex == index || index <0 || index > 3) {
            return;
        }
    }
    
    #if kIsHuaChenTmpTabbarStyle
        if (_selectedIndex == index || index <0 || index > 2) {
            return;
        }
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        if (_selectedIndex == index || index <0 || index > 2) {
            return;
        }
    #endif
    
    #if kIsXinchengTmpTabbarStyle
        if (_selectedIndex == index || index <0 || index > 3) {
            return;
        }
    #endif
    
    CPTabItemView *tabPre = [self tabAtIndex:_selectedIndex];
    tabPre.isHighlight = NO;
    
    CPTabItemView *tabNew = [self tabAtIndex:index];
    tabNew.isHighlight = YES;
    
    _selectedIndex = index;
}

- (CPTabItemView *) tabAtIndex:(NSInteger) index
{
    UIView *item = [self viewWithTag:K_TAB_TAG_BASE + index];
    if ([item isKindOfClass:[CPTabItemView class]]) {
        CPTabItemView *tab = (CPTabItemView *)item;
        return tab;
    }
    
    return nil;
}


@end
