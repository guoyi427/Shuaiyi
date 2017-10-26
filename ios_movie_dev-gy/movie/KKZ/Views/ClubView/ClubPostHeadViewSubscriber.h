//
//  ClubPostHeadViewSubscriber.h
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClubCellBottom;
@class ClubPost;

@protocol ClubPostHeadViewSubscriberDelegate <NSObject>

- (void)addTableViewHeader;

@end

@interface ClubPostHeadViewSubscriber : UIView <UIWebViewDelegate> {
    UILabel *titleLbl;
    ClubCellBottom *userInfoView;
    UIWebView *web;
}

@property (nonatomic, weak) id<ClubPostHeadViewSubscriberDelegate> delegate;

@property (nonatomic, assign) NSInteger articleId;

@property (nonatomic, strong) ClubPost *clubPost;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, copy) NSString *content;

- (void)uploadData;

/**
 *  滚动条垂直方向滚动距离
 *
 *  @param contentY
 */
- (void)scrollViewDidScroll:(CGFloat)contentY;

@end
