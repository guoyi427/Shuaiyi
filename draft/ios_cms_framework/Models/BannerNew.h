//
//  BannerNew.h
//  CIASMovie
//
//  Created by avatar on 2017/7/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BannerNew : MTLModel<MTLJSONSerializing>




@property (nonatomic, copy)NSString *slideImg;
@property (nonatomic, copy)NSString *slideUrl;
@property (nonatomic, copy)NSString *slideTitle;



@end
