//
//  影院详情显示特色信息的详细信息蒙层
//
//  Created by gree2 on 14/12/17.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface CinemaSpecialInfoView : UIView {

    UILabel *infoLabel;
    UIControl *_overlayView;
}

@property (nonatomic, strong) NSString *cinemaInfo;

- (id)initWithFrame:(CGRect)frame withInfo:(NSString *)cinemaInfo;
- (void)show;
- (void)dismiss;

@end
