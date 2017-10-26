//
//  ClubPostReportWord.h
//  KoMovie
//
//  Created by KKZ on 16/3/4.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "Model.h"

@interface ClubPostReportWord : Model
@property(nonatomic,assign)NSInteger typeId;
@property(nonatomic,copy)NSString *typeName;
+ (ClubPostReportWord *)getClubPostReportWordWithId:(NSUInteger)typeId;
@end
