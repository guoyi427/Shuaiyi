//
//  Song.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

/**
 *  歌曲文件
 */
@property (nonatomic, strong) NSString *songFile;

/**
 *  电影Id
 */
@property (nonatomic, strong) NSString *movieId;


- (Song*)initWithDict:(NSDictionary *)dict;

@end
