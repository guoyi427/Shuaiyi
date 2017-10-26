//
//  电影详情页面的周边Cell
//
//  Created by KKZ on 15/11/4.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class MovieHobbyModel;
@interface MovieHobbyViewCell : UITableViewCell {

    UIImageView *hobbyImgV;
    UILabel *hobbyTitleLbl, *hobbyPriceLbl, *hobbyPromotionPriceLbl, *checkDetial, *hobbyPriceLblY;
    UIView *lineCenter;
}

//@property (nonatomic, strong) NSString *hobbyPicUrl;
//@property (nonatomic, strong) NSString *hobbyPrice;
//@property (nonatomic, strong) NSString *hobbyPromotionPrice;
//@property (nonatomic, strong) NSString *hobbyTitle;
//@property (nonatomic, strong) NSString *hobbyUrl;

@property (nonatomic,strong) MovieHobbyModel *hobbyModel;


- (void)updateMovieHobbyCell;

@end
