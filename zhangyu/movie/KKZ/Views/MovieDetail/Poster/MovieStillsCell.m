//
//  海报列表的Cell
//
//  Created by gree2 on 14/11/18.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieStillsCell.h"

#import "Gallery.h"
#import "UIConstants.h"
#import "UIImageView+WebCache.h"

#define kMarginX 15

@interface MovieStillsCell () {

    //图片的宽度
    CGFloat imageW;

    //当前显示几个cell
    NSInteger showCountCell;

    //白色背景视图
    UIView *whiteView;
}

/**
 *  所有显示的视图数组
 */
@property (nonatomic, strong) NSMutableArray *showViewArray;

@end

@implementation MovieStillsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        //添加白色背景视图
        whiteView = [[UIView alloc] initWithFrame:CGRectZero];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];

        //判断当前cell里显示4个还是3个
        if (screentWith >= 414) {
            imageW = (screentWith - 10 * 3 - kMarginX * 2) / 4;
            showCountCell = 4;
        } else {
            imageW = (screentWith - 10 * 2 - kMarginX * 2) / 3;
            showCountCell = 3;
        }

        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 1)];
        line.backgroundColor = kDividerColor;
        [self addSubview:line];

        _stills = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)layoutSubviews {

    //修改分割线的坐标
    CGRect lineFrame = line.frame;
    lineFrame.origin.y = self.frame.size.height - 1;
    line.frame = lineFrame;

    //修改白色背景视图颜色
    whiteView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {

    UIImageView *imageView = (UIImageView *) gesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedStillWithIndex:)]) {
        int index = (int) [self.showViewArray indexOfObject:imageView];
        [self.delegate didSelectedStillWithIndex:index];
    }
}

/**
 *  初始化UIImageView对象
 *
 *  @param imageFrame
 *
 *  @return
 */
- (UIImageView *)getImageFrameWithOriginWithRect:(CGRect)imageFrame {
    UIImageView *newImgV = [[UIImageView alloc] initWithFrame:imageFrame];
    newImgV.contentMode = UIViewContentModeScaleAspectFill;
    newImgV.clipsToBounds = YES;
    newImgV.userInteractionEnabled = YES;
    newImgV.backgroundColor = [UIColor clearColor];
    [self addSubview:newImgV];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [newImgV addGestureRecognizer:tap];

    return newImgV;
}

/**
 *  根据索引值得到图片的路径
 *
 *  @param i 索引值
 *
 *  @return
 */
- (NSString *)imagePathByInputImageIndex:(NSInteger)i {

    NSString *imagePath = @"";
    if (self.isMovie) {
        Gallery *still = [self.stills objectAtIndex:i];
        imagePath = still.imageSmall;
    } else {
        imagePath = [self.stills objectAtIndex:i];
    }
    return imagePath;
}

/**
 *  初始化UIImageView的Frame
 *
 *  @param
 */
- (void)initImageViewWithIndex:(NSInteger)i {
    UIImageView *newImgV = [self getImageFrameWithOriginWithRect:CGRectMake(kMarginX + (imageW + 10) * i, 15, imageW, 70)];
    [newImgV sd_setImageWithURL:[NSURL URLWithString:[self imagePathByInputImageIndex:i]]];
    [self.showViewArray addObject:newImgV];
}

- (void)updateLayout {

    if (self.stills.count > showCountCell) {
        NSInteger count = self.stills.count - showCountCell;
        [self.stills removeObjectsInRange:NSMakeRange(showCountCell, count)];
    }

    if (self.showViewArray.count < self.stills.count && self.showViewArray.count) {

        int i;
        for (i = 0; i < self.showViewArray.count; i++) {
            UIImageView *newImgV = self.showViewArray[i];
            newImgV.frame = CGRectMake(kMarginX + (imageW + 10) * i, 15, imageW, 70);
        }

        for (; i < self.stills.count; i++) {
            [self initImageViewWithIndex:i];
        }

    } else if (self.showViewArray.count > self.stills.count && self.showViewArray.count) {

        int i;
        for (i = 0; i < self.stills.count; i++) {
            UIImageView *newImgV = self.showViewArray[i];
            newImgV.frame = CGRectMake(kMarginX + (imageW + 10) * i, 15, imageW, 70);
        }

        for (; i < self.showViewArray.count; i++) {
            UIImageView *newImgV = self.showViewArray[i];
            [newImgV removeFromSuperview];
            [self.showViewArray removeObject:newImgV];
        }

    } else if (self.showViewArray.count == self.stills.count) {
        for (int i = 0; i < self.showViewArray.count; i++) {
            UIImageView *newImgV = self.showViewArray[i];
            newImgV.frame = CGRectMake(kMarginX + (imageW + 10) * i, 15, imageW, 70);
        }
    } else if (!self.showViewArray.count) {
        for (int i = 0; i < self.stills.count; i++) {
            [self initImageViewWithIndex:i];
        }
    }
}

- (void)setStills:(NSMutableArray *)stills {
    _stills = [stills mutableCopy];
}

- (NSMutableArray *)showViewArray {

    if (!_showViewArray) {
        _showViewArray = [[NSMutableArray alloc] init];
    }
    return _showViewArray;
}

@end
