//
//  海报列表的Cell
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol MovieStillsCellDelegate <NSObject>

- (void)didSelectedStillWithIndex:(int)index;

@end

@interface MovieStillsCell : UITableViewCell {

    UIImageView *image1, *image2, *image3, *image4;
    UIView *line, *whiteBg;
}

@property (nonatomic, assign) id<MovieStillsCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *stills;
@property (nonatomic, assign) BOOL isMovie;

- (void)updateLayout;

@end
