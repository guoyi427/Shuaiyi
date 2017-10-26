//
//  PublishPostView.h
//  KoMovie
//
//  Created by KKZ on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol PublishPostViewDelegate <NSObject>
//-(void)removePresentEffe;
//@end

typedef void(^PublishPostView_CAll_BACK)(NSObject *o);

@interface PublishPostView : UIView<UIGestureRecognizerDelegate>{
    //毛玻璃效果
    
    
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@property (nonatomic, strong) UIVisualEffectView * effe;
#else
@property (nonatomic, strong) UIView * effe;
#endif

//@property(nonatomic,weak)id<PublishPostViewDelegate>delegate;

@property(nonatomic,assign)unsigned int movieId;
/**
 *  订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 *  导航ID
 */
@property (nonatomic, assign) NSInteger navId;

/**
 *  电影名称
 */
@property (nonatomic, strong) NSString *movieName;

/**
 *  影院名称
 */
@property (nonatomic, strong) NSString *cinemaName;

/**
 *  影院ID
 */
@property (nonatomic, strong) NSString *cinemaId;

/**
 *  点击图文,视频,音频
 */
@property (nonatomic, strong) PublishPostView_CAll_BACK click_block;

@end
