//
//  ShareContent.h
//  KoMovie
//
//  Created by Albert on 9/6/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ShareContent : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSString *shareContent;

@property(nonatomic, copy) NSString *sharePicUrl;

@property(nonatomic, copy) NSString *shareUrl;

@property(nonatomic, copy) NSString *title;

@end
