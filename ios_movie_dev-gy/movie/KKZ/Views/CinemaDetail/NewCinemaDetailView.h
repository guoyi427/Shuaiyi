//
//  影院详情页面
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaTableView.h"

@protocol NewCinemaDetailViewDelegate <NSObject>

/**
 *  TableView滚动条开始滚动的时候
 *
 *  @param listScrollView
 */
- (void)listTableDidScroll:(UIScrollView *)listScrollView;

/**
 *  下拉刷新请求网络
 */
- (void)pullRefreshBeginRequest;

/**
 *  TableView滚动条停止滚动的时候
 *
 *  @param listScrollView
 */
- (void)listTableDidEndScroll:(UIScrollView *)listScrollView;

@end

typedef enum : NSUInteger {
  specialInfoRequestType = 1000,
  cinemaImageRequestType,
} RequestType;

/****************增加评论****************************/
static NSString *reciveAddComment = @"addComment";
static NSString *updateCommentSection = @"updateComment";

@interface NewCinemaDetailView : UIView

/**
 *  表视图
 */
@property(nonatomic, strong) CinemaTableView *listTable;

/**
 *  影院名字
 */
@property(nonatomic, strong) NSString *cinemaName;

/**
 *  影院特色信息 <CinemaFeature>
 */
@property(nonatomic, strong) NSArray *cinemaSpecialInfo;

/**
 *  页面的代理对象
 */
@property(nonatomic, assign) id<NewCinemaDetailViewDelegate> detailDelegate;

/**
 *  初始化视图
 *
 *  @param frame
 *  @param cinemaId
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame withCinemaId:(NSInteger)cinemaId;

/**
 *  设置表头视图
 *
 *  @param tableHeader
 */
- (void)setTableHeader:(id)tableHeader;

/**
 *  开始请求数据
 */
- (void)beginRequestNet;

/**
 *  影院标签信息
 */
- (void)loadCinemaLabelList;

@end
