//
//  定义使用URL打开本地页面的协议
//
//  Created by wuzhen on 16/1/12.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#define kURLAttribute1 @"extra1"
#define kURLAttribute2 @"extra2"
#define kURLAttribute3 @"extra3"

// TODO Deprecated
@protocol HandleUrlProtocol <NSObject>

@required
/**
 * 用于传递 URL 中的值。子类重写该方法处理 URL 启动 Controller 的逻辑。
 */
- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3;

@end

@protocol UrlOpenNativeAppDelegate <NSObject>

/**
 * URL传递的值。
 */
- (id)initWithURLAttributes:(NSDictionary *)attrs;

@end

@interface NSObject (Delegate)

@end
