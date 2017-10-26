//
//  ThumbView.h
//
//  Created by zhang da on 10-10-20.
//  Copyright 2010 Ariadne’s Thread Co., Ltd All rights reserved.
//

@interface ThumbView : UIView

/**
 * Index。
 */
@property (nonatomic, assign) NSInteger index;

/**
 * 图片地址
 */
@property (nonatomic, strong) NSString *imagePath;

/**
 * 更新页面。
 */
- (void)updateLayout;

@end
