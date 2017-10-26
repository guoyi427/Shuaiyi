//
//  PostInformViewController.h
//  KoMovie
//
//  Created by KKZ on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@interface PostInformViewController : CommonViewController<UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *holder;
    //提示语数组
    NSArray *remindWordArr;
    //最后一个词条的最大X值
    CGFloat lastMaxX;
    //最后一个词条的最大Y值
    CGFloat lastMaxY;
    //选中的词组
    NSMutableArray *selectedRemindWordArr;
    //举报输入框
    UITextView *remindTextView;
    //举报框的提示信息
    UILabel *remindTextViewPlaceHolder;
    
    UILabel *remindTextNum;
}

@property(nonatomic,assign)NSInteger articleId;
@property(nonatomic,copy)NSString *typeId;

@end
