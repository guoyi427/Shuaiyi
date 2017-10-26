//
//  我的 - 待评价 列表Cell
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ClubPostPictureViewController.h"
#import "EvalueTableViewCell.h"
#import "KKZUtility.h"
#import "PublishPostView.h"
#import "UIColor+Hex.h"
#import <DateEngine_KKZ/DateEngine.h>

/*****************顶部黄色视图*******************/
static const CGFloat topViewHeight = 10.0f;

/*****************待评价按钮*******************/
static const CGFloat attentionBtnOriginY = 8.0f;
static const CGFloat attentionBtnHeight = 25.0f;
static const CGFloat attentionBtnWidth = 60.0f;
static const CGFloat attentionBtnRight = 15.0f;

/*****************电影名称*******************/
static const CGFloat nameLabelOriginX = 15.0f;
static const CGFloat nameLabelOriginY = 15.0f;
static const CGFloat nameLabelHeight = 14.0f;
static const CGFloat nameLabelRight = 50.0f;

/*****************分割线*******************/
static const CGFloat lineOriginTop = 12.0f;
static const CGFloat lineOriginX = 15.0f;

/*****************影院名称*******************/
static const CGFloat cinemaOriginX = 15.0f;
static const CGFloat cinemaTop = 12.0f;
static const CGFloat cinemaHeight = 12.0f;

/*****************评论时间*******************/
static const CGFloat timeLabelTop = 10.0f;
static const CGFloat timeLabelHeight = 12.0f;

/*****************奖励积分*******************/
static const CGFloat bonusLabelTop = 34.0f;
static const CGFloat bonusLabelHeight = 10.0f;

@interface EvalueTableViewCell () {
    //关注按钮
    UIButton *attentionButton;

    //分割线
    UIView *line;

    //时间格式化
    NSDateFormatter *formatter;
}

/**
 *  电影名称
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  影院名称
 */
@property (nonatomic, strong) UILabel *cinemaLabel;

/**
 *  评论时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *  奖励积分
 */
@property (nonatomic, strong) UILabel *bonusLabel;

/**
 *  帖子类型
 */
@property (nonatomic, assign) int postType;

@end

@implementation EvalueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        //设置背景颜色
        self.backgroundColor = [UIColor whiteColor];

        //顶部视图
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, topViewHeight)];
        topView.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
        [self addSubview:topView];

        //待评价按钮
        attentionButton = [UIButton buttonWithType:0];
        attentionButton.frame = CGRectMake(CGRectGetWidth(self.frame) - attentionBtnWidth - attentionBtnRight, attentionBtnOriginY + CGRectGetHeight(topView.frame), attentionBtnWidth, attentionBtnHeight);
        [attentionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [attentionButton addTarget:self
                            action:@selector(attention:)
                  forControlEvents:UIControlEventTouchUpInside];
        attentionButton.layer.cornerRadius = 3.0f;
        attentionButton.layer.borderWidth = 1.0f;
        [self addSubview:attentionButton];

        //电影名称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, nameLabelOriginY + CGRectGetHeight(topView.frame), CGRectGetWidth(self.frame) - nameLabelOriginX - attentionBtnWidth - attentionBtnRight - nameLabelRight, nameLabelHeight)];
        _nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];

        //分割线
        line = [[UIView alloc] initWithFrame:CGRectMake(lineOriginX, CGRectGetMaxY(_nameLabel.frame) + lineOriginTop, self.frame.size.width - lineOriginX - attentionBtnRight, 0.3f)];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];

        //影院名称
        _cinemaLabel = [[UILabel alloc] initWithFrame:CGRectMake(cinemaOriginX, CGRectGetMaxY(line.frame) + cinemaTop, CGRectGetWidth(line.frame), cinemaHeight)];
        _cinemaLabel.textColor = [UIColor colorWithHex:@"#666666"];
        _cinemaLabel.backgroundColor = [UIColor clearColor];
        _cinemaLabel.font = [UIFont boldSystemFontOfSize:12];
        _cinemaLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_cinemaLabel];

        //评论时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cinemaOriginX, CGRectGetMaxY(_cinemaLabel.frame) + timeLabelTop, CGRectGetWidth(line.frame) * 2 / 3.0f, timeLabelHeight)];
        _timeLabel.textColor = [UIColor colorWithHex:@"#666666"];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timeLabel];

        //奖励积分
        _bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeLabel.frame), bonusLabelTop + CGRectGetMaxY(line.frame), CGRectGetWidth(line.frame) / 3.0f, bonusLabelHeight)];
        _bonusLabel.font = [UIFont systemFontOfSize:11.0f];
        [_bonusLabel setTextColor:[UIColor colorWithHex:@"#ff6900"]];
        [_bonusLabel setTextAlignment:NSTextAlignmentRight];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_bonusLabel];
    }
    return self;
}

/**
 *  更新视图
 */
- (void)layoutSubviews {

    //关注按钮
    attentionButton.frame = CGRectMake(CGRectGetWidth(self.frame) - attentionBtnWidth - attentionBtnRight, attentionBtnOriginY + topViewHeight, attentionBtnWidth, attentionBtnHeight);

    //电影名字
    _nameLabel.frame = CGRectMake(nameLabelOriginX, nameLabelOriginY + topViewHeight, CGRectGetWidth(self.frame) - nameLabelOriginX - attentionBtnWidth - attentionBtnRight - nameLabelRight, nameLabelHeight);

    //分割线
    line.frame = CGRectMake(lineOriginX, CGRectGetMaxY(_nameLabel.frame) + lineOriginTop, self.frame.size.width - lineOriginX - attentionBtnRight, 0.3f);

    //影院名称
    _cinemaLabel.frame = CGRectMake(cinemaOriginX, CGRectGetMaxY(line.frame) + cinemaTop, CGRectGetWidth(line.frame), cinemaHeight);

    //评论时间
    _timeLabel.frame = CGRectMake(cinemaOriginX, CGRectGetMaxY(_cinemaLabel.frame) + timeLabelTop, CGRectGetWidth(line.frame) * 2 / 3.0f, timeLabelHeight);

    //积分奖励
    _bonusLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame), bonusLabelTop + CGRectGetMaxY(line.frame), CGRectGetWidth(line.frame) / 3.0f, bonusLabelHeight);
}

/**
 *  关注按钮
 *
 *  @param sender
 */
- (void)attention:(UIButton *)sender {

    if (self.dataSource.commentOrder) {
        CommonViewController *controller = [KKZUtility getRootNavagationLastTopController];
        ClubPostPictureViewController *club = [[ClubPostPictureViewController alloc] init];
        club.articleId = self.dataSource.commentOrder.commentId;
        [controller pushViewController:club
                             animation:CommonSwitchAnimationBounce];
    } else {
        PublishPostView *publishPostV = [[PublishPostView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        publishPostV.orderId = self.dataSource.orderId;
        publishPostV.movieId =  [self.dataSource.plan.movie.movieId unsignedIntValue];
        publishPostV.click_block = ^(NSObject *o) {
            self.postType = [(NSString *) o intValue];
        };
        publishPostV.movieName = self.dataSource.plan.movie.movieName;
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:publishPostV];
    }
}

- (void)updateLayout {
    _nameLabel.text = self.dataSource.plan.movie.movieName;
    _cinemaLabel.text = [NSString stringWithFormat:@"影院：%@", self.dataSource.plan.cinema.cinemaName];
    
    _timeLabel.text = [NSString stringWithFormat:@"时间：%@", [[DateEngine sharedDateEngine] stringFromDateY:self.dataSource.plan.movieTime]];
    UIColor *changeColor;
    NSString *titleStr;
    if (self.dataSource.commentOrder) {
        changeColor = [UIColor colorWithHex:@"#ff6900"];
        titleStr = @"查看";
        if (self.dataSource.commentOrder.integral.integerValue > 0) {
            _bonusLabel.text = [NSString stringWithFormat:@"奖励%@积分", self.dataSource.commentOrder.integral.stringValue];
        } else {
            _bonusLabel.text = @"";
        }
    } else {
        changeColor = [UIColor colorWithHex:@"#008cff"];
        titleStr = @"待评价";
        _bonusLabel.text = @"";
    }
    [attentionButton setTitleColor:changeColor
                          forState:UIControlStateNormal];
    attentionButton.layer.borderColor = changeColor.CGColor;
    [attentionButton setTitle:titleStr
                     forState:UIControlStateNormal];
}

- (void)setDataSource:(CommentOrder *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    [self updateLayout];
}

@end
