//
//  Category.h
//  KoMovie
//
//  Created by XuYang on 13-8-7.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Model.h"

//电影专题
@interface Category0 : Model

@property (nonatomic, assign) unsigned int listId;
@property (nonatomic, retain) NSNumber * hot;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * categoryIntro;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * categoryImg;

+ (Category0 *)getCategoryWithId:(unsigned int)listId;

@end
