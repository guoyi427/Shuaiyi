//
//  VideoPostInfoView.m
//  KoMovie
//
//  Created by KKZ on 16/3/6.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "VideoPostInfoView.h"
#import "ClubCellBottom.h"
#import "ClubPost.h"
#import "KKZUser.h"

#define bottomHeight 33
#define cellMarginY 15
#define cellMarginX 15
#define postInfoFont 14

@implementation VideoPostInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundColor:[UIColor whiteColor]];

        //帖子信息
        postInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX * 2, postInfoFont)];
        postInfoLbl.numberOfLines = 0;
        postInfoLbl.textColor = [UIColor blackColor];
        postInfoLbl.font = [UIFont systemFontOfSize:postInfoFont];
        [self addSubview:postInfoLbl];

        //用户信息
        clubCellBottom = [[ClubCellBottom alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(postInfoLbl.frame) + cellMarginY, screentWith, bottomHeight)];
        [clubCellBottom setBackgroundColor:[UIColor clearColor]];
        [self addSubview:clubCellBottom];

        bottomView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(clubCellBottom.frame), screentWith, 15)];
        [bottomView1 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView1];

        bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomView1.frame), screentWith, 10)];
        [bottomView2 setBackgroundColor:[UIColor r:242 g:242 b:242]];
        [self addSubview:bottomView2];
    }
    return self;
}

-(void)upLoadData{

    postInfoLbl.text = self.clubPost.content;
    CGSize s = [self.clubPost.content sizeWithFont:[UIFont systemFontOfSize:postInfoFont] constrainedToSize:CGSizeMake(screentWith - cellMarginX * 2, CGFLOAT_MAX)];
    
    if (self.clubPost.content.length) {
         postInfoLbl.frame = CGRectMake(cellMarginX, cellMarginY, screentWith - cellMarginX* 2, s.height);
    }else{
         postInfoLbl.frame = CGRectMake(cellMarginX, 0, screentWith - cellMarginX* 2, s.height);
    }

    //用户信息
    clubCellBottom.clubPost = self.clubPost;
    [clubCellBottom upLoadData];

    clubCellBottom.frame = CGRectMake(0, CGRectGetMaxY(postInfoLbl.frame) + cellMarginY, screentWith, bottomHeight);
    bottomView1.frame = CGRectMake(0, CGRectGetMaxY(clubCellBottom.frame), screentWith, 15);
    bottomView2.frame = CGRectMake(0, CGRectGetMaxY(bottomView1.frame), screentWith, 10);

    self.frame = CGRectMake(0, 0, screentWith, CGRectGetMaxY(bottomView2.frame));

    if (self.delegate && [self.delegate respondsToSelector:@selector(addTableViewHeaderWithVideoPostInfoViewHeight:)]) {
        [self.delegate addTableViewHeaderWithVideoPostInfoViewHeight:self.frame.size.height];
    }
}
@end
