//
//  ClubNavTab.h
//  KoMovie
//
//  Created by KKZ on 16/2/29.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ClubNavTab : MTLModel <MTLJSONSerializing>

/**
 *  导航id
 */
@property (nonatomic, copy) NSNumber *navId;
/**
 *  导航名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  1.原生 2.网页
 */
@property (nonatomic, copy) NSNumber *type;

/**
 *  导航url
 */
@property (nonatomic, copy) NSString *url;

/**
 *  字体颜色
 */
@property (nonatomic, copy) NSString *fontColor;

/**
 *  排序
 */
@property (nonatomic, copy) NSNumber *sort;

@property (nonatomic, copy) NSString *tag;

//-----------------------------

/**
 *  当前页
 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 *  当前的url
 */
@property (nonatomic, copy) NSString *currentUrl;

/**
 *  当前的url状态
 */
@property (nonatomic, copy) NSString *search_state;

/**
 *  当前的本地页面
 */
@property (nonatomic, copy) NSString *currentCtr;

/**
 *  当前的本地页面
 */
@property (nonatomic, assign) BOOL currentUrlChanged;

/**
 *  第一页请求的地址
 */
@property (nonatomic, copy) NSString *firstPageUrl;

/**
 处理数据
 */
- (void)handleDate;



@end
