//
//  SingleCenterHandleUrl.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+scheme.h"
//#import "commonv"

@interface SingleCenterHandleUrl : NSObject

/**
 *  处理传过来的URL
 *
 *  @param url        url对象
 *  @param name       controller的标题
 *  @param controller Controller对象
 */
+(void)handleWithUrl:(NSURL *)url
            withName:(NSString *)name
       withResponder:(CommonViewController *)controller;

@end
