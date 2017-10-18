//
//  ArticleList.h
//  CIASMovie
//
//  Created by avatar on 2017/4/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ArticleList : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *articleId;
@property (nonatomic, copy)NSNumber *columnId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSNumber *hits;
@property (nonatomic, copy)NSNumber *status;
@property (nonatomic, copy)NSString *publisher;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *frontendTime;

@end
