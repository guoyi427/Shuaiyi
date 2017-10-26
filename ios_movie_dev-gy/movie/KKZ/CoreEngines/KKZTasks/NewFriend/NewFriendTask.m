//
//  NewFriendTask.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "NewFriendTask.h"
#import "AddressBook.h"
#import "DataManager.h"
#import "KKZUser.h"
#import "DataEngine.h"
#import "friendRecommendModel.h"
#import "KKZGetContactList.h"
#import "KKZUtility.h"

@interface NewFriendTask ()

/**
 *  用户好友手机号
 */
@property (nonatomic, strong) NSString *usernames;

/**
 *  请求的第几页
 */
@property (nonatomic, assign) int pageNum;

/**
 *  每页请求的个数
 */
@property (nonatomic ,assign) int pageSize;

/**
 *  纬度
 */
@property (nonatomic, strong) NSString *latitude;

/**
 *  精度
 */
@property (nonatomic, strong) NSString *longitude;

@end

@implementation NewFriendTask

-(id)initWithPhoneUser:(NSString *)usernames
              finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.finishBlock = block;
        self.usernames = usernames;
        self.taskType = TaskTypeRecommendFriend;
    }
    return self;
}

-(id)initWithActivityPageNum:(int)pageNum
                withPageSize:(int)pageSize
                    finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.finishBlock = block;
        self.pageNum = pageNum;
        self.pageSize = pageSize;
        self.taskType = TaskTypeActivityUser;
    }
    return self;
}

-(id)initWithNearByLatitude:(NSString *)latitude
              withLongitude:(NSString *)longitude
               withPageSize:(int)pageSize
                   finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.finishBlock = block;
        self.pageSize = pageSize;
        self.latitude = latitude;
        self.longitude = longitude;
        self.taskType = TaskTypeNearByUser;
    }
    return self;
}

- (void)getReady {
    if (self.taskType == TaskTypeRecommendFriend) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/import_friend_by_mobile.chtml", kKSSBaseUrl,KKSSPKota]];
        [self addParametersWithValue:self.usernames forKey:@"usernames"];
        [self setRequestMethod:@"POST"];
    }else if (self.taskType == TaskTypeActivityUser) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/queryActiveCommentUsers.chtml",kKSSBaseUrl,KKSSPKota]];
        [self setRequestMethod:@"GET"];
        NSString *pageNum = [NSString stringWithFormat:@"%d",self.pageNum];
        [self addParametersWithValue:pageNum
                              forKey:@"pageNum"];
        NSString *pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
        [self addParametersWithValue:pageSize
                              forKey:@"pageSize"];
    }else if (self.taskType == TaskTypeNearByUser) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/queryNearbyUsers.chtml",kKSSBaseUrl, KKSSPKota]];
        [self setRequestMethod:@"GET"];
        NSString *pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
        [self addParametersWithValue:pageSize
                              forKey:@"pageSize"];
        [self addParametersWithValue:self.latitude forKey:@"latitude"];
        [self addParametersWithValue:self.longitude forKey:@"longitude"];
    }
}

/**
 *  请求成功
 *
 *  @param result
 */
- (void)requestSucceededWithData:(id)result {
        
    if (self.taskType == TaskTypeRecommendFriend) {
    
        //遍历手机号请求结果
        NSArray *phoneNumsData = [result objectForKey:@"result"];
        
        //用户信息
        KKZUser *user = [KKZUser getUserWithId:[DataEngine sharedDataEngine].userId.intValue];
        
        //用户数据源
        NSMutableArray *dataSource = [KKZGetContactList sharedEngine].dataSource;
        
        //用户新的数据源
        NSMutableArray *newDataSource = [[NSMutableArray alloc] init];
        
        //遍历请求回来的数组
        for (int i = 0; i< dataSource.count; i++) {
            
            //得到每个用户的手机详情
            NSDictionary *phoneData = phoneNumsData[i];
            
            //获取用户手机号
            NSString *mobile = [phoneData kkz_stringForKey:@"username"];
            
            //获取排序好的数据
            AddressBook *address = [dataSource objectAtIndex:i];
            
            //判断手机号
            if ([address.tel isEqualToString:mobile] //有号码，并且不是自己
                && ![address.tel isEqualToString:user.username]){
                
                //创建model对象
                friendRecommendModel *model = [[friendRecommendModel alloc] init];
                model.modelType = modelTypePhoneUser;
                model.avatarUrl = [phoneData kkz_stringForKey:@"headImg"];
                model.status = [[phoneData kkz_stringForKey:@"status"] intValue];
                model.uid = [phoneData kkz_stringForKey:@"uid"];
                model.nickname = address.name;
                model.phone = address.tel;
                model.namePY = address.namePY;
                [newDataSource addObject:model];
            }
        }
        
        //[[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES],
        NSArray *arr = @[[[NSSortDescriptor alloc] initWithKey:@"namePY" ascending:YES]];
        
        [newDataSource sortUsingDescriptors:arr];
        //回调完成函数
        [self doCallBack:YES
                    info:@{requestDataSource:newDataSource}];
        
    }else if (self.taskType == TaskTypeActivityUser) {
        
        //遍历用户请求结果
        NSArray *userNumsData = [result objectForKey:@"users"];
        
        //总页数
        int total = [[result valueForKey:@"total"] intValue];
        
        //用户新的数据源
        NSMutableArray *newDataSource = [[NSMutableArray alloc] init];
        
        //遍历用户数组
        for (int i=0; i < userNumsData.count; i++) {
            
            //得到每个用户的手机详情
            NSDictionary *userData = userNumsData[i];
            
            //初始化model
            if (userData !=nil && ![userData isEqual:[NSNull null]]) {
                friendRecommendModel *model = [[friendRecommendModel alloc] init];
                model.modelType = modelTypeActivityUser;
                model.avatarUrl = [userData kkz_stringForKey:@"headImg"];
                model.nickname = [userData kkz_stringForKey:@"nickName"];
                model.namePY = [userData kkz_stringForKey:@"pinyin"];
                model.uid = [userData kkz_stringForKey:@"userId"];
                model.isFriend = [[userData valueForKey:@"isFriend"] boolValue];
                
                //评论结果
                NSDictionary *commentResult = [userData valueForKey:@"commentResult"];
                NSString *content;
                if (commentResult !=nil && ![commentResult isEqual:[NSNull null]]) {
                    content = [commentResult kkz_stringForKey:@"content"];
                }
                if ([KKZUtility stringIsEmpty:content]) {
                    model.userDetail = nil;
                }else {
                    model.userDetail = content;
                }
                [newDataSource addObject:model];
            }
        }
        
        //回调完成函数
        [self doCallBack:YES
                    info:@{requestDataSource:newDataSource,
                           requestDataTotal:[NSNumber numberWithInt:total]}];
        
    }else if (self.taskType == TaskTypeNearByUser) {
        
        //遍历用户请求结果
        NSArray *userNumsData = [result objectForKey:@"users"];

        //用户新的数据源
        NSMutableArray *newDataSource = [[NSMutableArray alloc] init];

        //遍历用户数组
        for (int i=0; i < userNumsData.count; i++) {

            //得到每个用户的手机详情
            NSDictionary *userData = userNumsData[i];

            //初始化model
            friendRecommendModel *model = [[friendRecommendModel alloc] init];
            model.modelType = modelTypeNearByUser;
            model.avatarUrl = [userData kkz_stringForKey:@"headImg"];
            model.nickname = [userData kkz_stringForKey:@"nickName"];
            model.namePY = [userData kkz_stringForKey:@"pinyin"];
            model.uid = [userData kkz_stringForKey:@"userId"];
            model.isFriend = [[userData valueForKey:@"isFriend"] boolValue];
            CGFloat latitude = [[userData valueForKey:@"latitude"] floatValue];
            CGFloat longitude = [[userData valueForKey:@"longitude"] floatValue];
            CLLocation *orig = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
            CLLocation *dist = [[CLLocation alloc] initWithLatitude:[USER_LATITUDE floatValue]
                                                          longitude:[USER_LONGITUDE floatValue]];
            CLLocationDistance kilometers = [orig distanceFromLocation:dist];
            model.distance = kilometers;
            
            NSDictionary *commentResult = [userData valueForKey:@"commentResult"];
            if (commentResult == nil || [commentResult isEqual:[NSNull null]]) {
                model.userDetail = nil;
            }else {
                model.userDetail = [commentResult kkz_stringForKey:@"content"];
            }
            [newDataSource addObject:model];
        }
        
        //进行数组的排序
        NSArray *originalArr = [NSArray arrayWithArray:newDataSource];
        NSArray *finalArr = [originalArr sortedArrayUsingComparator:^NSComparisonResult(friendRecommendModel *obj1, friendRecommendModel *obj2) {
            NSComparisonResult result =
            [[NSNumber numberWithFloat:obj1.distance] compare:[NSNumber numberWithFloat:obj2.distance]];
            return result;
        }];
        [newDataSource removeAllObjects];
        [newDataSource addObjectsFromArray:finalArr];
        //回调完成函数
        [self doCallBack:YES
                    info:@{requestDataSource:newDataSource}];
    }
}

/**
 *  请求失败
 *
 *  @param error
 */
- (void)requestFailedWithError:(NSError *)error {
    if (self.taskType == TaskTypeRecommendFriend) {
        [self doCallBack:NO info:nil];
    }else if (self.taskType == TaskTypeActivityUser) {
        [self doCallBack:NO info:nil];
    }else if (self.taskType == TaskTypeNearByUser) {
        [self doCallBack:NO info:nil];
    }
}

@end
