//
//  排期列表页面的影院通知View
//
//  Created by 艾广华 on 16/4/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface CinemaNoticeView : UIView

/**
 *   影院通知的字符串
 */
@property (nonatomic, strong) NSString *noticeString;

/**
 *  更新页面布局
 */
- (void)updateLayout;

@end
