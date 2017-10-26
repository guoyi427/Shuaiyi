//
//  ClubPostSupportCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostSupportCell.h"
#import "ClubSupportView.h"
#import "UIConstants.h"

#define supportViewHeight 103
#define marginX 15
#define marginY 15
#define postPictureWith (screentWith - marginX * 2)

//marginWordToPicture

@implementation ClubPostSupportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载点赞区域
        [self loadSupportView];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, supportViewHeight - 1, screentWith, 1)];
        [v setBackgroundColor:kUIColorDivider];
        [self addSubview:v];
    }
    return self;
}

/**
 *  加载点赞头像
 */
- (void)loadSupportView {
    supportV = [[ClubSupportView alloc] initWithFrame:CGRectMake(0, 0, screentWith, supportViewHeight)];
    supportV.articleId = self.articleId;
    supportV.clubPost = self.postModel;
    [self addSubview:supportV];
    [supportV setBackgroundColor:[UIColor clearColor]];
}

/**
 *  加载数据
 */
- (void)reloadData {
    supportV.articleId = self.articleId;
    supportV.supportUsers = [NSMutableArray arrayWithArray:self.clubSupportUsers];
    supportV.clubPost = self.postModel;
    [supportV reloadData];
}
@end
