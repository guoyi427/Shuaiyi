//
//  输入自定义内容的分享预览页面
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>

#import "CommonViewController.h"

@interface InputContentShareViewController : CommonViewController <UITextViewDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *sUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) int movieId;
@property (nonatomic, assign) int mediaType;
@property (nonatomic, assign) ShareType shareType;

/**
 * 初始化。
 */
- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
              image:(UIImage *)image
                url:(NSString *)url
               sUrl:(NSString *)sUrl
          mediaType:(int)mediaType
          shareType:(ShareType)shareType;

@end
