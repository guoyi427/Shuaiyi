//
//  ClubPostHeadViewText.h
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubCellBottom;
@class ClubPost;

@protocol ClubPostHeadViewTextDelegate <NSObject>

- (void)addTableViewHeaderWithClubPostHeadViewHeight:(CGFloat)height;

@end

@interface ClubPostHeadViewText : UIView {
    //用户信息
    ClubCellBottom *userInfoView;
    //帖子文本内容
    UILabel *postText;
    //clubTableView的headerView
    UIView *clubHeaderView;
}

/**
 *  帖子图片数组
 */
@property (nonatomic, strong) NSMutableArray *clubPhotos;

@property (nonatomic, weak) id<ClubPostHeadViewTextDelegate> delegate;
@property (nonatomic, assign) NSInteger articleId;

@property (nonatomic, strong) ClubPost *clubPost;

- (void)uploadData;
@end
