//
//  ClubPost.m
//  KoMovie
//
//  Created by KKZ on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPost.h"

#import "Constants.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation PostFile

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @1 : @(KKZPostFileTypeImage),
        @2 : @(KKZPostFileTypeAudio),
        @3 : @(KKZPostFileTypeVideo),
        @4 : @(KKZPostFileTypeSubscriptionCount),
    }];
}

@end

@implementation ClubPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)shareJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Share class]];
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[KKZAuthor class]];
}

+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PostFile class]];
}

+ (instancetype)getClubPostWithArticleId:(NSNumber *)articleId fromArray:(NSArray *)posts {
    if (posts == nil || [posts count] <= 0) {
        return nil;
    }

    __block ClubPost *model = nil;
    [posts enumerateObjectsUsingBlock:^(ClubPost *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([articleId isEqualToNumber:obj.articleId]) {
            model = obj;
        }
    }];

    return model;
}

/**
 根据文件类型 整理出文件地址列表

 @param type 文件类型

 @return 文件地址列表
 */
- (NSArray *)filesOf:(KKZPostFileType)type {
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:self.images.count];

    [self.images enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        PostFile *file = obj;
        if (file.type == type && file.files.count > 0) {
            [files addObjectsFromArray:file.files];
        }
    }];

    return [files copy];
}

- (NSArray *)filesImage {
    return [self filesOf:KKZPostFileTypeImage];
}

- (NSArray *)filesAudio {
    return [self filesOf:KKZPostFileTypeAudio];
}

- (NSArray *)filesVideo {
    return [self filesOf:KKZPostFileTypeVideo];
}

@end
