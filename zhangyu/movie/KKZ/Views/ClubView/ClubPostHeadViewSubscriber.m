//
//  ClubPostHeadViewSubscriber.m
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubCellBottom.h"
#import "ClubPostHeadViewSubscriber.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "KKZCommonWebView.h"

NSString *const UIWebViewContentSize = @"contentSize";

//用户头像和标题之间的距离
#define marginTitleY 20
//用户头像和标题之间的距离
#define marginHeadImgToTitle 17
//用户头像和文字之间的距离
#define marginHeadImgToWord 20

#define userInfoViewHeight 33

#define postTitleFont 22

#define marginX 15
#define marginY 15

@interface ClubPostHeadViewSubscriber () <IMYWebViewDelegate>

/**
 *  网页视图
 */
@property (nonatomic, strong) KKZCommonWebView *webView;

/**
 *  线条的视图
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  正在监听网页的内容尺寸
 */
@property (nonatomic, assign) BOOL listenWebContentSize;

/**
 *  网页加载完成
 */
@property (nonatomic, assign) BOOL webRequestFinished;

/**
 *  设置网页视图的高度最大值
 */
@property (nonatomic, assign) BOOL webMaxHeight;

/**
 *  网页的顶部距离
 */
@property (nonatomic, assign) NSInteger webInsetTop;

@end

@implementation ClubPostHeadViewSubscriber

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载标题
        [self loadTitle];
        //加载用户信息
        [self loadUserInfoView];
    }
    return self;
}

/**
 * 加载标题
 */
- (void)loadTitle {
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(marginX, marginTitleY, screentWith - marginX * 2, postTitleFont)];
    titleLbl.numberOfLines = 0;
    [titleLbl setTextColor:[UIColor blackColor]];
    //    titleLbl.font = [UIFont systemFontOfSize:postTitleFont];
    [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:postTitleFont]];
    [self addSubview:titleLbl];
}

/**
 *  加载用户信息
 */
- (void)loadUserInfoView {

    userInfoView = [[ClubCellBottom alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + marginHeadImgToTitle, screentWith, userInfoViewHeight)];
    //加载用户信息
    [userInfoView setBackgroundColor:[UIColor clearColor]];
}

/**
 *  加载数据
 */
- (void)uploadData {
    titleLbl.text = self.clubPost.title;

    //    CGSize s = [self.clubPost.title sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:postTitleFont] constrainedToSize:CGSizeMake(screentWith - marginX * 2, CGFLOAT_MAX)];

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:postTitleFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };

    CGFloat contentW = screentWith - marginX * 2;

    CGRect tmpRect =
            [titleLbl.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];

    CGSize s = tmpRect.size;

    titleLbl.frame = CGRectMake(marginX, marginTitleY, contentW, s.height);

    titleLbl.attributedText = [[NSAttributedString alloc] initWithString:titleLbl.text
                                                              attributes:attributes];

    userInfoView.clubPost = self.clubPost;
    userInfoView.supportNum = self.clubPost.upNum;
    userInfoView.commentNum = self.clubPost.replyNum;
    userInfoView.postDate = self.clubPost.publishTime;
    userInfoView.postId = [self.clubPost.articleId intValue];
    [userInfoView upLoadData];

    userInfoView.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + marginHeadImgToTitle, screentWith, userInfoViewHeight);

    //加载帖子内容
    [self loadPostContent];
}

- (void)loadPostContent {

    //添加网页视图
    [self addSubview:self.webView];
    [self addSubview:userInfoView];

    //先移除监听，再添加监听
    if (self.listenWebContentSize) {
        self.listenWebContentSize = NO;
    }
    self.listenWebContentSize = YES;
    [self.webView loadHTMLString:self.content
                         baseURL:nil];
}

- (void)webViewDidFinishLoad:(KKZCommonWebView *)webView {
    NSLog(@"网页记载完成");
    self.webRequestFinished = YES;
}

- (void)webViewDidStartLoad:(KKZCommonWebView *)webView {
    NSLog(@"网页开始加载 ");
    self.webRequestFinished = NO;
}

- (void)webView:(KKZCommonWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"网页加载失败");
    self.webRequestFinished = YES;
}

- (KKZCommonWebView *)webView {
    if (!_webView) {
        _webView = [[KKZCommonWebView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 1)];
        UIScrollView *scroll = _webView.scrollView;
        CGFloat top = self.webInsetTop;
        scroll.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
        [scroll setBounces:NO];
        scroll.scrollEnabled = NO;
        [scroll setAlwaysBounceHorizontal:NO];
        [scroll setAlwaysBounceVertical:NO];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.userInteractionEnabled = NO;
    }
    return _webView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(marginX, self.frame.size.height - 1, screentWith - marginX * 2, 1)];
        [self addSubview:_lineView];

        //画线条
        [KKZUtility drawDashLine:_lineView
                      lineLength:3
                     lineSpacing:1
                       lineColor:[UIColor r:235 g:235 b:235]];
    }
    return _lineView;
}

- (NSInteger)webInsetTop {
    return CGRectGetMaxY(userInfoView.frame) + marginY;
}

- (void)drawLineWithViewHeight:(CGFloat)viewHeight {
    //修改线条的尺寸
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.y = viewHeight - 1;
    self.lineView.frame = lineFrame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    if ([UIWebViewContentSize isEqualToString:keyPath]) {

        //修改表头视图的尺寸
        CGFloat height = _webView.scrollView.contentSize.height;

        CGFloat maxHeight = kCommonScreenHeight - 64.0f - 46.0f;

        //修改视图的尺寸
        CGRect headerFrame = self.frame;
        headerFrame.size.height = ceil(height) + self.webInsetTop;
        self.frame = headerFrame;

        CGRect frameWeb = _webView.frame;
        frameWeb.size.height = height;
        _webView.frame = frameWeb;

        //判断变量是否已经设置过最大值
        if (!self.webMaxHeight) {
            if (height > maxHeight) {
                CGRect webFrame = self.webView.frame;
                webFrame.size.height = maxHeight;
                self.webView.frame = webFrame;
                self.webMaxHeight = TRUE;
            }
        }

        //绘制线条
        [self drawLineWithViewHeight:CGRectGetHeight(self.frame)];

        //通知代理对象重新赋值表头视图
        if (self.delegate && [self.delegate respondsToSelector:@selector(addTableViewHeader)]) {
            [self.delegate addTableViewHeader];
        }

        //去除内容加载的监听
        //        if (self.webRequestFinished) {
        //            self.webRequestFinished = FALSE;
        //            self.listenWebContentSize = FALSE;
        //        }
    }
}

- (void)scrollViewDidScroll:(CGFloat)contentY {
    //先判断滑没滑到底
    NSInteger offsetY = (NSInteger) contentY - self.webInsetTop;
    if (contentY + CGRectGetHeight(self.webView.frame) <= CGRectGetHeight(self.frame)) {
        CGRect webFrame = self.webView.frame;
        webFrame.origin.y = contentY;
        _webView.frame = webFrame;
        [_webView.scrollView setContentOffset:CGPointMake(self.webView.scrollView.contentOffset.x, offsetY)
                                     animated:NO];
    } else {
        CGRect webFrame = self.webView.frame;
        webFrame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(self.webView.frame);
        _webView.frame = webFrame;
        CGFloat maxOffset = self.webView.scrollView.contentSize.height - CGRectGetHeight(self.webView.frame);
        [_webView.scrollView setContentOffset:CGPointMake(self.webView.scrollView.contentOffset.x, maxOffset)
                                     animated:NO];
    }
}

- (void)setListenWebContentSize:(BOOL)listenWebContentSize {
    _listenWebContentSize = listenWebContentSize;
    UIScrollView *scroll = _webView.scrollView;
    if (_listenWebContentSize) {
        [scroll addObserver:self
                 forKeyPath:UIWebViewContentSize
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    } else {
        [scroll removeObserver:self
                    forKeyPath:UIWebViewContentSize
                       context:nil];
    }
}

- (void)dealloc {
    if (self.listenWebContentSize) {
        UIScrollView *scroll = _webView.scrollView;
        [scroll removeObserver:self
                    forKeyPath:UIWebViewContentSize
                       context:nil];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
