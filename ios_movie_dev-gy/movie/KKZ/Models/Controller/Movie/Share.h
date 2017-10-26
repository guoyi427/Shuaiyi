//
//  Share.h
//  KoMovie
//
//  Created by renzc on 16/9/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Share : MTLModel <MTLJSONSerializing>

@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;

@end
