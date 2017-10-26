//
//  电影详情页面列表Cell的Header
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol MovieDetailHeaderDelegate <NSObject>

- (void)MovieDetailShowMore:(NSInteger)sectionNum;

@end

@interface MovieDetailHeader : UIView {

    UIImageView *headerLogoImg;
    UILabel *titleLabel;
    UIButton *moreBtn;
    UIView *bottomLine;
}

@property (nonatomic, assign) id<MovieDetailHeaderDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) BOOL BtnHidden;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, assign) BOOL isBtmlineHidden;

- (void)updateLayout;

@end
