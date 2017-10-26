//
//  PostPlateCell.m
//  KoMovie
//
//  Created by KKZ on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "PostPlateCell.h"
#import "ImageEngineNew.h"

#define marginX 30
#define marginY 15
#define marginTitleTop 40
#define imageWidth 85
#define imageToTitle 37
#define titleToSubTitle 13
#define titleFont 15
#define subTitleFont 12
#define subTitleLblPostWidth 40
#define cellHeight 117

@implementation PostPlateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, imageWidth, imageWidth)];
//        imageV.backgroundColor = [UIColor redColor];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        

        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + imageToTitle,marginTitleTop , screentWith - 15 - (CGRectGetMaxX(imageV.frame) + imageToTitle), titleFont)];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:titleFont];
        [self addSubview:titleLbl];
        
        
        subTitleLblPost = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, subTitleLblPostWidth, subTitleFont)];
        subTitleLblPost.textColor = [UIColor grayColor];
        subTitleLblPost.font = [UIFont systemFontOfSize:subTitleFont];
        [self addSubview:subTitleLblPost];
        subTitleLblPost.text = @"帖子：";
        
        
        
        subTitleLblPostNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subTitleLblPost.frame), CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, subTitleLblPostWidth, subTitleFont)];
        subTitleLblPostNum.textColor = [UIColor grayColor];
        subTitleLblPostNum.font = [UIFont systemFontOfSize:subTitleFont];
        [self addSubview:subTitleLblPostNum];
        
        
        
        
        subTitleLblComment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subTitleLblPostNum.frame) + titleToSubTitle, CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, subTitleLblPostWidth, subTitleFont)];
        subTitleLblComment.textColor = [UIColor grayColor];
        subTitleLblComment.font = [UIFont systemFontOfSize:subTitleFont];
        [self addSubview:subTitleLblComment];
        subTitleLblComment.text = @"回复：";
        
        
        
        subTitleLblCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subTitleLblComment.frame), CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, subTitleLblPostWidth, subTitleFont)];
        subTitleLblCommentNum.textColor = [UIColor grayColor];
        subTitleLblCommentNum.font = [UIFont systemFontOfSize:subTitleFont];
        [self addSubview:subTitleLblCommentNum];
        
        
        UIImageView *arrowGrayV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 30 - 8, (cellHeight - 15.5) * 0.5, 8.5, 15.5)];
        arrowGrayV.image = [UIImage imageNamed:@"arrowGray"];
        [self addSubview:arrowGrayV];
        arrowGrayV.userInteractionEnabled = NO;
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,cellHeight - 1, screentWith - 15, 1)];
        [line setBackgroundColor:[UIColor r:235 g:235 b:235]];
        [self addSubview:line];
    }
    
    return self;
}

-(void)upLoadData
{
    [imageV loadImageWithURL:self.imagePath andSize:ImageSizeOrign];
    
    titleLbl.text = self.title;
    
    subTitleLblPostNum.text = self.postNum;
    
    CGSize s = [self.postNum sizeWithFont:[UIFont systemFontOfSize:subTitleFont]];
    
    subTitleLblPostNum.frame = CGRectMake(CGRectGetMaxX(subTitleLblPost.frame), CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, s.width, subTitleFont);
    
    
    subTitleLblComment.frame = CGRectMake(CGRectGetMaxX(subTitleLblPostNum.frame) + titleToSubTitle, CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, subTitleLblPostWidth, subTitleFont);
    
    subTitleLblCommentNum.text = self.commentNum;
    
    
    CGSize s1 = [self.commentNum sizeWithFont:[UIFont systemFontOfSize:subTitleFont]];
    
    subTitleLblCommentNum.frame = CGRectMake(CGRectGetMaxX(subTitleLblComment.frame), CGRectGetMaxY(titleLbl.frame) + titleToSubTitle, s1.width, subTitleFont);
}
@end
