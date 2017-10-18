//
//  OrderListViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderListViewController.h"
#import "GFTitleButton.h"
#import "OrderCancelViewController.h"
#import "OrderCompleteViewController.h"
#import "OrderNeedsPayViewController.h"
#import "KKZTextUtility.h"
#import "UIView+XLExtension.h"

#define kNaviViewHeight 69

@interface OrderListViewController ()<UIScrollViewDelegate>
{
    UILabel     * titleLabel;
    UIImageView * titleImageView;
    UIButton    * titleBtn,*allOrderBtn,*movieOrderBtn,*productOrderBtn,*vipcardOrderBtn;
    
}
@property (nonatomic, strong) UIView      * naviView;
@property (nonatomic, strong) UIButton    * backBtn;
@property (nonatomic, strong) UIView      * titleViewOfBar,*chooseAlertView;


/*当前选中的Button*/
@property (weak ,nonatomic) GFTitleButton *selectTitleButton;
/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView ;

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*标题栏*/
@property (weak ,nonatomic) UIView *titleView;

@end

@implementation OrderListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    //MARK: 记录选择的订单类型
    
    //设置导航条
    [self setUpNavBar];

    //设置未完成，已完成，已取消的页面
    //MARK: 添加选择项视图
    [self setUpChildViewControllers];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    //添加默认自控制器View
    [self addChildViewControllers];
    
}
-(void)setUpChildViewControllers
{
    //待付款订单
    OrderNeedsPayViewController *orderNeedsPayVc = [[OrderNeedsPayViewController alloc] init];
    [self addChildViewController:orderNeedsPayVc];
    
    //已完成
    OrderCompleteViewController *orderCompleteVc = [[OrderCompleteViewController alloc] init];
    [self addChildViewController:orderCompleteVc];
    
    //已取消订单
    OrderCancelViewController *orderCancelVc = [[OrderCancelViewController alloc] init];
    [self addChildViewController:orderCancelVc];
    
}

/**
 添加scrollView
 */
-(void)setUpScrollView
{
    
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.mj_w * self.childViewControllers.count, 0);
}

/**
 添加标题栏View
 */
-(void)setUpTitleView
{
    UIView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.backgroundColor = [UIColor colorWithHex:@"#333333"];
    titleView.frame = CGRectMake(0, 0 , self.view.mj_w, 35);
    [self.view addSubview:titleView];
    
    NSArray *titleContens = @[@"待付款",@"已完成",@"已取消"];
    NSInteger count = titleContens.count;
    
    CGFloat titleButtonW = titleView.mj_w / count;
    CGFloat titleButtonH = titleView.mj_h;
    
    for (NSInteger i = 0;i < count; i++) {
        GFTitleButton *titleButton = [GFTitleButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.tag = i; //绑定tag
        [titleButton addTarget:self action:@selector(titelClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titleContens[i] forState:UIControlStateNormal];
        CGFloat titleX = i * titleButtonW;
        titleButton.frame = CGRectMake(titleX, 0, titleButtonW, titleButtonH);
        
        [titleView addSubview:titleButton];
        
    }
    //按钮选中颜色
    if (self.selectedIndex > titleContens.count - 1) {
        self.selectedIndex = titleContens.count - 1;
    }
    GFTitleButton *firstTitleButton = [titleView.subviews objectAtIndex:self.selectedIndex];
    //底部指示器
    UIView *indicatorView = [[UIView alloc] init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
    
    indicatorView.mj_h = 3;
    indicatorView.mj_y = titleView.mj_h - indicatorView.mj_h;
    
    [titleView addSubview:indicatorView];
    
    //默认选择第一个全部TitleButton
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.mj_w = firstTitleButton.titleLabel.mj_w;
    indicatorView.xl_centerX = firstTitleButton.xl_centerX;
    [self titelClick:firstTitleButton];
}
/**
 标题栏按钮点击
 */
-(void)titelClick:(GFTitleButton *)titleButton
{
    if (self.selectTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GFTitleButtonDidRepeatShowClickNotificationCenter object:nil];
    }
    
    //控制状态
    self.selectTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectTitleButton = titleButton;
    
    //指示器
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.xl_width = titleButton.titleLabel.xl_width;
        self.indicatorView.xl_centerX = titleButton.xl_centerX;
    }];
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.xl_width * titleButton.tag;
    [self.scrollView setContentOffset:offset animated:YES];
}


#pragma mark - 添加子控制器View
-(void)addChildViewControllers
{
    //在这里面添加自控制器的View
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.xl_width;
    //取出自控制器
    if (index == 0) {
        OrderNeedsPayViewController *orderNeedsPayVc  = self.childViewControllers[index];
        orderNeedsPayVc.orderSelectedArr = self.btnSelectArr;
        if (orderNeedsPayVc.view.superview) return; //判断添加就不用再添加了
        orderNeedsPayVc.view.frame = CGRectMake(index * self.scrollView.xl_width, 35, self.scrollView.xl_width, self.scrollView.xl_height);
        [self.scrollView addSubview:orderNeedsPayVc.view];
    } else if (index == 1) {
        OrderCompleteViewController *orderCompleteVc  = self.childViewControllers[index];
        orderCompleteVc.orderSelectedArr = self.btnSelectArr;
        if (orderCompleteVc.view.superview) return; //判断添加就不用再添加了
        orderCompleteVc.view.frame = CGRectMake(index * self.scrollView.xl_width, 35, self.scrollView.xl_width, self.scrollView.xl_height);
        [self.scrollView addSubview:orderCompleteVc.view];
    } else if (index == 2) {
        OrderCancelViewController *orderCancelVc  = self.childViewControllers[index];
        orderCancelVc.orderSelectedArr = self.btnSelectArr;
        if (orderCancelVc.view.superview) return; //判断添加就不用再添加了
        orderCancelVc.view.frame = CGRectMake(index * self.scrollView.xl_width, 35, self.scrollView.xl_width, self.scrollView.xl_height);
        [self.scrollView addSubview:orderCancelVc.view];
    }    
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
/**
 点击动画后停止调用
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    [self addChildViewControllers];
}


/**
 人气拖动的时候，滚动动画结束时调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //点击对应的按钮

    NSInteger index = scrollView.contentOffset.x / scrollView.xl_width;
    GFTitleButton *titleButton = self.titleView.subviews[index];
    
    [self titelClick:titleButton];
    
    [self addChildViewControllers];
}


#pragma mark - 设置导航条
-(void)setUpNavBar
{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"titlebar_back1"] WithHighlighted:[UIImage imageNamed:@"titlebar_back1"] Target:self action:@selector(cancelViewController)];
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_back1"];
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
//    [self.naviView addSubview:self.backBtn];
    //添加电影名称title
//    [self.naviView addSubview:self.titleViewOfBar];
    //add view
//    [self.view addSubview:self.naviView];
    //TitieView
    self.navigationItem.titleView = self.titleViewOfBar;
    //添加返回按钮
    //TitieView
}

- (void) titleViewBtnClick:(UIButton *)sender {
//    DLog(@"尽情弹框吧");
    sender.selected = !sender.selected;
    if (sender.selected) {
        //MARK: 这里的图片暂时代替的，后面要改动的
        titleImageView.image = [UIImage imageNamed:@"home_uparrow2"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.chooseAlertView];
    } else {
        if (_chooseAlertView) {
//            titleBtn.selected = !titleBtn.selected;
            titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
            [_chooseAlertView removeFromSuperview];
            _chooseAlertView = nil;
        }
    }
}
- (void) allOrderBtnClick:(UIButton *)sender {
    sender.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10010];
    btn.selected = !btn.selected;
    movieOrderBtn.selected = NO;
    vipcardOrderBtn.selected = NO;
    #if K_HUACHEN || K_HENGDIAN
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"1"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"0"];
    #else
        productOrderBtn.selected = NO;
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"1"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:3 withObject:@"0"];
    #endif
    

    [self updateTitleLabelOfChooseAlertView:@"全部订单"];
    
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.btnSelectArr forKey:@"btnSelectArr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskTypeOrderChooseNotification object:nil userInfo:dic];
//    DLog(@"全部订单");
}
- (void) movieOrderBtnClick:(UIButton *)sender {
    sender.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10010];
    btn.selected = !btn.selected;
    allOrderBtn.selected = NO;
    vipcardOrderBtn.selected = NO;
#if K_HUACHEN || K_HENGDIAN
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"1"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"0"];
    #else
        productOrderBtn.selected = NO;
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"1"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:3 withObject:@"0"];
    #endif
    

    [self updateTitleLabelOfChooseAlertView:@"电影票"];
    
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.btnSelectArr forKey:@"btnSelectArr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskTypeOrderChooseNotification object:nil userInfo:dic];
//    DLog(@"电影票订单");
}
- (void) productOrderBtnClick:(UIButton *)sender {
    sender.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10010];
    btn.selected = !btn.selected;
    movieOrderBtn.selected = NO;
    allOrderBtn.selected = NO;
    vipcardOrderBtn.selected = NO;
    [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"0"];
    [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"0"];
    [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"1"];
    [self.btnSelectArr replaceObjectAtIndex:3 withObject:@"0"];
    
    [self updateTitleLabelOfChooseAlertView:@"商品"];
    
    
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.btnSelectArr forKey:@"btnSelectArr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskTypeOrderChooseNotification object:nil userInfo:dic];
//    DLog(@"商品订单");
}
- (void) vipcardOrderBtnClick:(UIButton *)sender {
    sender.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10010];
    btn.selected = !btn.selected;
    movieOrderBtn.selected = NO;
    allOrderBtn.selected = NO;
    #if K_HUACHEN || K_HENGDIAN
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"1"];
    #else
        productOrderBtn.selected = NO;
        [self.btnSelectArr replaceObjectAtIndex:0 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:1 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:2 withObject:@"0"];
        [self.btnSelectArr replaceObjectAtIndex:3 withObject:@"1"];
    #endif
    
    if ([kIsHaveOpencard isEqualToString:@"1"]) {
        [self updateTitleLabelOfChooseAlertView:@"开卡/充值"];
    } else {
        [self updateTitleLabelOfChooseAlertView:@"充值"];
    }
    
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        titleImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.btnSelectArr forKey:@"btnSelectArr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskTypeOrderChooseNotification object:nil userInfo:dic];
//    DLog(@"开卡/充值订单");
}

//MARK: 更新ChooseAlertView约束
- (void) updateTitleLabelOfChooseAlertView:(NSString *)titleLabelStr {
    
    CGSize titleStrSize = [KKZTextUtility measureText:titleLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
    [titleLabel setFrame:CGRectMake((kCommonScreenWidth-80*2-titleStrSize.width-10-5)/2, 0, titleStrSize.width, 15)];
//    UIImage *titleImage = [UIImage imageNamed:@"home_downarrow2"];
    [titleImageView setFrame:CGRectMake((kCommonScreenWidth-80*2-titleStrSize.width-10-5)/2+titleStrSize.width+5, 0, 10, 15)];

//
//    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width - titleImage.size.width)/2);
//        make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
//    }];
//    [titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width - titleImage.size.width)/2);
//        make.size.mas_offset(CGSizeMake(titleStrSize.width+5+5+titleImage.size.width, titleStrSize.height));
//    }];
    titleLabel.text = titleLabelStr;
}


- (void) cancelViewController {
    if (_chooseAlertView) {
        titleBtn.selected = !titleBtn.selected;
        [_chooseAlertView removeFromSuperview];
        _chooseAlertView = nil;
    }
    if (self.isBackFirst) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UIView *)chooseAlertView {
    if (!_chooseAlertView) {
    #if K_HUACHEN || K_HENGDIAN
            _chooseAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.04*kCommonScreenWidth, 56, kCommonScreenWidth - 2*0.04*kCommonScreenWidth, 157)];
        #else
            _chooseAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.04*kCommonScreenWidth, 56, kCommonScreenWidth - 2*0.04*kCommonScreenWidth, 210)];
        #endif
        
        _chooseAlertView.backgroundColor = [UIColor clearColor];
        UIImageView *imageViewOfAlertView = [[UIImageView alloc] init];
        [_chooseAlertView addSubview:imageViewOfAlertView];
        imageViewOfAlertView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *alertImage = [UIImage imageNamed:@"titlepop_triangle"];
        imageViewOfAlertView.image = alertImage;
        [imageViewOfAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_chooseAlertView.mas_left).offset((kCommonScreenWidth - 2*0.04*kCommonScreenWidth - alertImage.size.width)/2);
            make.top.equalTo(_chooseAlertView.mas_top);
            make.size.mas_equalTo(CGSizeMake(alertImage.size.width, alertImage.size.height));
        }];
        UIView *choseView = [[UIView alloc] init];
        choseView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        choseView.alpha = 0.9;
        choseView.layer.cornerRadius = 3.5;
        choseView.clipsToBounds = YES;
        [_chooseAlertView addSubview:choseView];
        [choseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.width.equalTo(_chooseAlertView);
            make.top.equalTo(imageViewOfAlertView.mas_bottom);
            #if K_HUACHEN || K_HENGDIAN
                make.height.equalTo(@155);
            #else
                make.height.equalTo(@200);
            #endif
            
        }];
        //创建4个button，进行帅选
        allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        movieOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        #if K_HUACHEN || K_HENGDIAN
        #else
            productOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        #endif
        
        vipcardOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView *line1View = [[UIView alloc] init];
        UIView *line2View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#333333"];
        line2View.backgroundColor = [UIColor colorWithHex:@"#333333"];
        #if K_HUACHEN || K_HENGDIAN
        
        #else
            UIView *line3View = [[UIView alloc] init];
            line3View.backgroundColor = [UIColor colorWithHex:@"#333333"];
        #endif
        

        [choseView addSubview:allOrderBtn];
        [choseView addSubview:line1View];
        [choseView addSubview:movieOrderBtn];
        [choseView addSubview:line2View];
        
        #if K_HUACHEN || K_HENGDIAN
        #else
            [choseView addSubview:productOrderBtn];
            [choseView addSubview:line3View];
        #endif
        
        [choseView addSubview:vipcardOrderBtn];
        allOrderBtn.selected = [[self.btnSelectArr objectAtIndex:0] isEqualToString:@"1"]? YES:NO;
        if (allOrderBtn.selected) {
            titleLabel.text = @"全部订单";
        }
        movieOrderBtn.selected = [[self.btnSelectArr objectAtIndex:1] isEqualToString:@"1"]? YES:NO;
        if (movieOrderBtn.selected) {
            titleLabel.text = @"电影票";
        }
        #if K_HUACHEN || K_HENGDIAN
            vipcardOrderBtn.selected = [[self.btnSelectArr objectAtIndex:2] isEqualToString:@"1"]? YES:NO;
            if (vipcardOrderBtn.selected) {
                if ([kIsHaveOpencard isEqualToString:@"1"]) {
                    titleLabel.text = @"开卡/充值";
                } else {
                    titleLabel.text = @"充值";
                }
            }
        #else
            productOrderBtn.selected = [[self.btnSelectArr objectAtIndex:2] isEqualToString:@"1"]? YES:NO;
            if (productOrderBtn.selected) {
                titleLabel.text = @"商品";
            }
            vipcardOrderBtn.selected = [[self.btnSelectArr objectAtIndex:3] isEqualToString:@"1"]? YES:NO;
            if (vipcardOrderBtn.selected) {
                if ([kIsHaveOpencard isEqualToString:@"1"]) {
                    titleLabel.text = @"开卡/充值";
                } else {
                    titleLabel.text = @"充值";
                }
            }
        #endif
        
        [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(choseView);
            make.left.width.right.equalTo(choseView);
            make.height.equalTo(@50);
        }];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(allOrderBtn.mas_bottom).offset(0);
            make.left.width.right.equalTo(choseView);
            make.height.equalTo(@1);
        }];
        [movieOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(0);
            make.left.width.right.equalTo(choseView);
            make.height.equalTo(@50);
        }];

        [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(movieOrderBtn.mas_bottom).offset(0);
            make.left.width.right.equalTo(choseView);
            make.height.equalTo(@1);
        }];
        
        #if K_HUACHEN || K_HENGDIAN
            [vipcardOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line2View.mas_bottom).offset(0);
                make.left.width.right.equalTo(choseView);
                make.height.equalTo(@50);
            }];
        #else
            [productOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line2View.mas_bottom).offset(0);
                make.left.width.right.equalTo(choseView);
                make.height.equalTo(@50);
            }];
            [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(productOrderBtn.mas_bottom).offset(0);
                make.left.width.right.equalTo(choseView);
                make.height.equalTo(@1);
            }];
            [vipcardOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line3View.mas_bottom).offset(0);
                make.left.width.right.equalTo(choseView);
                make.height.equalTo(@50);
            }];
        #endif
        
        
        [allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [allOrderBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [allOrderBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateSelected];
        allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [allOrderBtn addTarget:self action:@selector(allOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [movieOrderBtn setTitle:@"电影票" forState:UIControlStateNormal];
        [movieOrderBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [movieOrderBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateSelected];
        movieOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [movieOrderBtn addTarget:self action:@selector(movieOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];

#if K_HUACHEN || K_HENGDIAN
        #else
            [productOrderBtn setTitle:@"商品" forState:UIControlStateNormal];
            [productOrderBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
            [productOrderBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateSelected];
            productOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            [productOrderBtn addTarget:self action:@selector(productOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        #endif
        
        if ([kIsHaveOpencard isEqualToString:@"1"]) {
            [vipcardOrderBtn setTitle:@"开卡/充值" forState:UIControlStateNormal];
        } else {
            [vipcardOrderBtn setTitle:@"充值" forState:UIControlStateNormal];
        }
        
        [vipcardOrderBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [vipcardOrderBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateSelected];
        vipcardOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [vipcardOrderBtn addTarget:self action:@selector(vipcardOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _chooseAlertView;
}

//MARK: 初始化naviView
- (UIView *) naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kNaviViewHeight)];
        _naviView.backgroundColor = [UIColor colorWithHex:@"#333333"];
        _naviView.alpha = 1.0;
    }
    return _naviView;
}
//MARK: 初始化backBtn
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15, 29, 30, 30);
        [_backBtn setImage:[UIImage imageNamed:@"titlebar_back1"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr1 = @"";//计算宽高的，不用管
        if ([[self.btnSelectArr objectAtIndex:0] isEqualToString:@"1"]) {
            titleStr1 = @"全部订单";
        }
        if ([[self.btnSelectArr objectAtIndex:1] isEqualToString:@"1"]) {
            titleStr1 = @"电影票";
        }
        
#if K_HUACHEN || K_HENGDIAN
        if ([[self.btnSelectArr objectAtIndex:2] isEqualToString:@"1"]) {
            if ([kIsHaveOpencard isEqualToString:@"1"]) {
                titleStr1 = @"开卡/充值";
            } else {
                titleStr1 = @"充值";
            }
        }
        
#else
        if ([[self.btnSelectArr objectAtIndex:2] isEqualToString:@"1"]) {
            titleStr1 = @"商品";
        }
        if ([[self.btnSelectArr objectAtIndex:3] isEqualToString:@"1"]) {
            if ([kIsHaveOpencard isEqualToString:@"1"]) {
                titleStr1 = @"开卡/充值";
            } else {
                titleStr1 = @"充值";
            }
        }
#endif
        
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr1 size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:18]];

        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth-80*2, 15)];
        _titleViewOfBar.backgroundColor = [UIColor clearColor];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kCommonScreenWidth-80*2-titleStrSize.width-10-5)/2, 0, titleStrSize.width, 15)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-80*2-titleStrSize.width-10-5)/2+titleStrSize.width+5, 0, 10, 15)];
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(0, 0, kCommonScreenWidth-90*2, 15);
        [_titleViewOfBar addSubview:titleLabel];
        [_titleViewOfBar addSubview:titleImageView];
        [_titleViewOfBar addSubview:titleBtn];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr1;
        titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIImage *titleImage = [UIImage imageNamed:@"home_downarrow2"];
        titleImageView.image = titleImage;
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;

        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.selected = NO;
        titleBtn.tag = 10010;
        [titleBtn addTarget:self action:@selector(titleViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        #if K_BAOSHAN
            titleImageView.hidden = YES;
            titleBtn.userInteractionEnabled = NO;
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
//                make.top.bottom.equalTo(_titleViewOfBar);
//                make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
//            }];
        #else
            titleImageView.hidden = NO;
            titleBtn.userInteractionEnabled = YES;
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width - titleImage.size.width)/2);
//                make.top.bottom.equalTo(_titleViewOfBar);
//                make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
//            }];
//            [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(titleLabel.mas_right).offset(0);
//                make.top.bottom.equalTo(_titleViewOfBar);
//                make.size.mas_equalTo(CGSizeMake(titleImage.size.width, titleImage.size.height));
//            }];
//            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width - titleImage.size.width)/2);
//                make.top.bottom.equalTo(_titleViewOfBar);
//                make.size.mas_offset(CGSizeMake(titleStrSize.width+5+5+titleImage.size.width, titleStrSize.height));
//            }];
        #endif
        
    }
    return _titleViewOfBar;
}

- (NSMutableArray *)btnSelectArr {
    if (!_btnSelectArr) {
    #if K_HUACHEN || K_HENGDIAN
        _btnSelectArr = [[NSMutableArray alloc] initWithObjects:@"1",@"0",@"0", nil];

    #else
        _btnSelectArr = [[NSMutableArray alloc] initWithObjects:@"1",@"0",@"0",@"0", nil];
    #endif
        
    }
    return _btnSelectArr;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
