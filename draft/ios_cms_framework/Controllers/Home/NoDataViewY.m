//
//  nodataViewY.m
//  KoMovie
//
//  Created by avatar on 14-12-26.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "NoDataViewY.h"

@implementation NoDataViewY

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIImageView *v = [[UIImageView alloc]
        initWithFrame:CGRectMake((kCommonScreenWidth - 65) * 0.5, 0, 65, 65)];
    v.image = [UIImage imageNamed:@"failure"];
    [self addSubview:v];
    self.alertView = v;
    UILabel *lbl =
        [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(v.frame),
                                                  kCommonScreenWidth - 15 * 2, 20)];
    lbl.numberOfLines = 0;
    lbl.textColor = [UIColor grayColor];
    lbl.text = @"亲，还没有你要找的信息，请稍候~";
    lbl.font = [UIFont boldSystemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [UIColor clearColor];
    [self addSubview:lbl];
    self.alertLabel = lbl;
  }
  return self;
}

- (void)setAlertLabelText:(NSString *)alertLabelText {
  _alertLabelText = alertLabelText;
}

- (void)layoutSubviews {
  CGSize s = [self.alertLabelText
           sizeWithFont:[UIFont systemFontOfSize:14]
      constrainedToSize:CGSizeMake(kCommonScreenWidth - 15 * 2, MAXFLOAT)
          lineBreakMode:NSLineBreakByTruncatingTail];
  self.alertLabel.frame =
      CGRectMake(15, CGRectGetMaxY(self.alertView.frame) + 8,
                 kCommonScreenWidth - 15 * 2, s.height);
  self.alertLabel.text = self.alertLabelText;
}
@end
