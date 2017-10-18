//
//  WelcomeView.h
//
//  Created by abc on 15/8/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol WelcomeViewDelegate <NSObject>

- (void) returnBackButtonClick;

@end
@interface WelcomeView : UIView<UIScrollViewDelegate>
{
    
}
@property (nonatomic, weak) id <WelcomeViewDelegate> delegate;

@end
