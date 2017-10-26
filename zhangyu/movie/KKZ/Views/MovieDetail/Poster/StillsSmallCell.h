//
//  剧照海报列表的Cell
//
//  Created by gree2 on 14/11/20.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class MyStillUnit;

@interface StillsSmallCell : UITableViewCell {

    MyStillUnit *unit1, *unit2, *unit3, *unit4;
}

@property (nonatomic, strong) NSMutableArray *stills;
@property (nonatomic, assign) BOOL isMovie;

@property (nonatomic, assign) NSInteger stillIndex1;
@property (nonatomic, assign) NSInteger stillIndex2;
@property (nonatomic, assign) NSInteger stillIndex3;
@property (nonatomic, assign) NSInteger stillIndex4;

@property (nonatomic, assign) NSInteger myIndex;

@property (nonatomic, strong) NSString *imagePath1;
@property (nonatomic, strong) NSString *imagePath2;
@property (nonatomic, strong) NSString *imagePath3;
@property (nonatomic, strong) NSString *imagePath4;

@property (nonatomic, strong) NSString *myImagePath;

- (void)updateImagePath;
- (void)preparePicImg;
- (void)updateLayout;

@end
