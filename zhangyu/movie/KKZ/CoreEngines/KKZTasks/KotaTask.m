//
//  KotaTask.m
//  KoMovie
//
//  Created by gree2 on 15/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "KotaTask.h"
#import "Constants.h"
#import "UserDefault.h"
#import "DataEngine.h"
#import "ImageEngine.h"
#import "CacheEngine.h"
#import "KotaShare.h"
#import "UserMessage.h"
#import "KKZUser.h"
#import "Movie.h"
#import "KotaFilmNew.h"
#import "MemContainer.h"
#import "KotaShareMovie.h"
#import "KotaShareUser.h"
#import "DateEngine.h"
#import "kotaComment.h"

#define kCountPerPage 5

@implementation KotaTask

- (int)cacheVaildTime {
    if (taskType == TaskTypeKotaUserDetail) {
        return 60;
    }
    return 0;
}


- (id)initKotaHeadImageListByCityId:(NSString *)cityId page:(int)currentPage finished:(FinishDownLoadBlock)block
{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaShareUsers;
        self.finishBlock = block;
        self.cityId = USER_CITY;
        self.pageNum = currentPage;
    }
    return self;
}

- (id)initKotaNearUserListByCityId:(NSString *)cid page:(int)currentPage finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaShareNearUser;
        self.finishBlock = block;
        self.filter = 2;
        self.cityId = USER_CITY;
        self.pageNum = currentPage;
    }
    return self;
}



- (id)initKotaFilmListByCityId:(NSString *)cid page:(int)currentPage pageSize:(int)pageSize finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaShareFilm;
        self.finishBlock = block;
        //一下并未使用。
        self.cityId = USER_CITY;
        self.pageNum = currentPage;
        self.pageSize = pageSize;
    }
    return self;
}


//获取kota列表筛选
- (id)initKotaListByFilterMode:(KotaListFilterMode)filter  withMovieId:(unsigned int)movieId page:(int)currentPage finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaShareList;
        self.filter = filter;
        self.movieId = [NSString stringWithFormat:@"%u", movieId];
        self.pageNum = currentPage;
        self.finishBlock = block;
    }
    return self;
}



- (id)initKotaListByMovieId:(unsigned int)movieId andType:(NSString *)type page:(NSInteger)currentPage finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        
        
        self.taskType = TaskTypeByMovieKotaShareList;
        self.movieId = [NSString stringWithFormat:@"%u", movieId];
        
        self.pageNum = currentPage;
        self.type = type;
        self.finishBlock = block;
    }
    return self;
}


//我的约会
- (id)initKotaMyAppointmentAndPage:(NSInteger)currentPage finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        
        self.taskType = TaskTypeMyAppointment;
        self.pageNum = currentPage;
        self.finishBlock = block;
    }
    return self;
}



//同意申请、拒绝
- (id)initAcceptMyAppointmentWithKotaId:(NSString *)kotaId andStatus:(int)status andUserId:(NSString *)requesrtUId finished:(FinishDownLoadBlock)block {
    
    self = [super init];
    
    if (self) {
        self.taskType = TaskTypeAcceptMyAppointment;
        self.kotaId = kotaId;
        self.requestUid = requesrtUId;
        self.status = status;
        self.finishBlock = block;
    }
    return self;
    
}



- (id)initUserDetail:(unsigned int)userId finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaUserDetail;
        self.myId = [NSString stringWithFormat:@"%u", userId];
        self.finishBlock = block;
    }
    return self;
    
}



- (id)initFriendUserDetail:(unsigned int)userId finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaFriendUserDetail;
        self.myId = [NSString stringWithFormat:@"%u", userId];
        self.finishBlock = block;
    }
    return self;
    
}

- (id)initModifyHomeBackground:(UIImage *)image finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeModifyHomeBackground;
        self.bgImage = image;
        self.finishBlock = block;
    }
    return self;
}

//申请kota
- (id)initKotaShareApply:(int)kotaId finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaShareApply;
        self.kotaId = [NSString stringWithFormat:@"%d", kotaId];
        self.finishBlock = block;
    }
    return self;
}


//接受或者拒绝kota
- (id)initResponseForKota:(int)kotaId user:(NSString *)userId attitude:(NSString *)attitude finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeKotaResponse;
        self.kotaId = [NSString stringWithFormat:@"%d", kotaId];
        self.requestId = userId;
        self.attitude = attitude;
        self.finishBlock = block;
    }
    return self;
}



- (void)getReady {
    if (taskType == TaskTypeKotaShareFilm) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"queryActiveMovies.chtml"]];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long)self.pageNum] forKey:@"pageNum"];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.pageSize] forKey:@"pageSize"];
        
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        
        
        [self setRequestMethod:@"GET"];
        
    }
    else if (taskType == TaskTypeKotaShareNearUser) {
        
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"queryShareUsers.chtml"]];
        
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.filter] forKey:@"type"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",kCountPerPage] forKey:@"pageSize"];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        
        
        //        http://test.komovie.cn/kota_api_test/ajax/queryShareUsers.chtml?city_id=36
        
        
        if ([USER_LATITUDE length]) {
            [self addParametersWithValue:USER_LATITUDE forKey:@"latitude"];
        }
        if ([USER_LONGITUDE length]) {
            [self addParametersWithValue:USER_LONGITUDE forKey:@"longitude"];
        }
        
        
        [self setRequestMethod:@"GET"];
        
    }
    else if (taskType == TaskTypeKotaShareUsers) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"queryActiveUsers.chtml"]];
        
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        
        
        [self setRequestMethod:@"GET"];
        
    }
    
    else if (taskType == TaskTypeByMovieKotaShareList) {
        
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"query_share_list.chtml"]];
        
        [self addParametersWithValue:self.type forKey:@"type"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",kCountPerPage] forKey:@"pageSize"];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        if (USER_CITY) {
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        }
        
        
        if ([USER_LATITUDE length]) {
            [self addParametersWithValue:USER_LATITUDE forKey:@"latitude"];
        }
        if ([USER_LONGITUDE length]) {
            [self addParametersWithValue:USER_LONGITUDE forKey:@"longitude"];
        }
        
        
        
        if (self.movieId !=  nil && ![self.movieId isEqualToString:@"0"]) {
            [self addParametersWithValue:self.movieId forKey:@"film_id"];
        }
        
        [self setRequestMethod:@"GET"];
        
        
    }//TaskTypeAcceptMyAppointment
    
    else if (taskType == TaskTypeAcceptMyAppointment) {
        
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"update_share_status.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        [self addParametersWithValue:self.kotaId forKey:@"entity.kotaQuoteId"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.status] forKey:@"entity.status"];
        
        [self addParametersWithValue:self.requestUid forKey:@"request_uid"];
        [self setRequestMethod:@"GET"];
        
        
    }
    
    
    
    
    
    else if (taskType == TaskTypeMyAppointment) {
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"queryMyShares.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].userId forKey:@"user_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",kCountPerPage] forKey:@"pageSize"];
        [self setRequestMethod:@"GET"];
        
        
    }
    
    
    else if (taskType == TaskTypeKotaShareList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"query_share_list.chtml"]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.filter] forKey:@"type"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",kCountPerPage] forKey:@"pageSize"];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        if (USER_CITY) {
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"];
        }
        
        if (self.movieId !=  nil && ![self.movieId isEqualToString:@"0"]) {
            [self addParametersWithValue:self.movieId forKey:@"film_id"];
        }
        [self setRequestMethod:@"GET"];
        
        
    }else if (taskType == TaskTypeKotaUserDetail) {
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"query_user_detail.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].userId forKey:@"user_id"];
        [self setRequestMethod:@"GET"];
        
    }
    
    else if (taskType == TaskTypeKotaFriendUserDetail) {
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"query_user_detail.chtml"]];
        [self addParametersWithValue:self.myId forKey:@"user_id"];
        
        [self setRequestMethod:@"GET"];
        
    }
    
    else if (taskType == TaskTypeModifyHomeBackground) {
        
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"UploadUserBgImage"]];
        
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        [self addParametersWithValue:USER_DEVICE_TOKEN forKey:@"pushtoken"];
        [self addParametersWithValue:@"ios" forKey:@"channel"];
        
        if (![NetworkUtil me].isWIFI) {
            if (self.bgImage.size.width >= 600) {
                self.bgImage = [self.bgImage decodedImageToSize:CGSizeMake(640, 0) fill:NO];
            }
            [self setUploadBody:UIImageJPEGRepresentation(self.bgImage, 0.7) withName:@"file" fromFile:@"image.jpg"];
        } else {
            [self setUploadBody:UIImageJPEGRepresentation(self.bgImage, 1) withName:@"file" fromFile:@"image.jpg"];
        }
        [self setRequestMethod:@"POST"];
    }else if (taskType == TaskTypeKotaShareApply) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"user_ask_woman.chtml"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        [self addParametersWithValue:self.kotaId forKey:@"entity.kotaQuoteId"];
        
        [self setRequestMethod:@"GET"];
    }else if (taskType == TaskTypeKotaResponse) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,@"update_share_status.chtml"]];
        [self addParametersWithValue:self.kotaId forKey:@"entity.kotaQuoteId"];
        [self addParametersWithValue:self.requestId forKey:@"request_uid"];
        [self addParametersWithValue:self.attitude forKey:@"entity.status"];
        [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
        
        [self setRequestMethod:@"GET"];
    }
}


#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeKotaShareFilm) {
        NSDictionary *dict = (NSDictionary *)result;
        
        
        DLog(@"TaskTypeKotaShareFilm ...%@", dict);
        NSMutableArray *kotaAll = [[NSMutableArray alloc] init];
        NSArray *jsons = [dict objectForKey:@"result"];
        
        
        if ([jsons count])
        {
            for (int i = 0; i < [jsons count]; i++) {
                NSDictionary *jsonFilm = jsons[i];
                
                NSNumber *man = jsonFilm[@"man"];
                NSNumber *women = jsonFilm[@"women"];
                NSNumber *successCount = jsonFilm[@"successCount"];
                NSDictionary *movie = jsonFilm[@"movie"];
                NSNumber *filmId = movie[@"filmId"];
                NSString *posterPath = movie[@"posterPath"];
                NSString *movieName = movie[@"filmName"];
                
                KotaShareMovie *shareMovie = [[KotaShareMovie alloc] init];
                
                shareMovie.man = man;
                shareMovie.women = women;
                shareMovie.successCount = successCount;
                shareMovie.filmId = [filmId intValue];
                shareMovie.posterPath = posterPath;
                shareMovie.movieName = movieName;
                
                [kotaAll addObject:shareMovie];
            }
            
        } else
        {
            [self deleteCache];
        }
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:kotaAll,@"kotaFilms",
                                   nil]];
        
        
    }
    else if (taskType == TaskTypeKotaShareNearUser) {
        NSDictionary *dict = (NSDictionary *)result;
        
        
        DLog(@"TaskTypeKotaShareNearUser ...%@", dict);
        NSMutableArray *kotaAll = [[NSMutableArray alloc] init];
        NSArray *jsons = [dict objectForKey:@"list"];
        
        
        
        
        if ([jsons count])
        {
            for (int i = 0; i < [jsons count]; i++) {
                NSDictionary *jsonFilm = jsons[i];
                NSNumber *distance = jsonFilm[@"distance"];
                NSNumber *status = jsonFilm[@"status"];
                NSNumber *shareId = jsonFilm[@"shareId"];
                NSString *cinemaName = jsonFilm[@"cinemaName"];
                NSString *filmName = jsonFilm[@"filmName"];
                NSString *shareHeadimg = jsonFilm[@"shareHeadimg"];
                NSString *shareNickname = jsonFilm[@"shareNickname"];
                int screenDegree = [jsonFilm[@"screenDegree"] intValue];
                int screenSize = [jsonFilm[@"screenSize"] intValue];
                NSString *lang = jsonFilm[@"lang"];
                NSDate *createTime = jsonFilm[@"createTime"];
                NSNumber *kotaId = jsonFilm[@"kotaId"];
                
                
                
                KotaShareUser *shareNearUser = [[KotaShareUser alloc] init];
                
                shareNearUser.distance = distance;
                shareNearUser.status = status;
                shareNearUser.shareId = shareId;
                shareNearUser.cinemaName = cinemaName;
                shareNearUser.filmName = filmName;
                shareNearUser.shareHeadimg = shareHeadimg;
                shareNearUser.shareNickname = shareNickname;
                
                shareNearUser.screenDegree = [NSNumber numberWithInt:screenDegree];
                shareNearUser.screenSize = [NSNumber numberWithInt:screenSize];
                shareNearUser.lang = lang;
                shareNearUser.createTime = createTime;
                shareNearUser.kotaId = kotaId;
                
                
                
                [kotaAll addObject:shareNearUser];
            }
            
        } else
        {
            [self deleteCache];
        }
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:kotaAll,@"kotaNearUsers",
                                   nil]];
        
        
    }
    
    
    else if (taskType == TaskTypeKotaShareUsers) {
        NSDictionary *dict = (NSDictionary *)result;
        
        //        int status = [dict[@"status"] intValue];
        DLog(@"TaskTypeKotaShareUsers ...%@", dict);
        NSMutableArray *kotaAll = [[NSMutableArray alloc] init];
        NSArray *jsons = [dict objectForKey:@"result"];
        
        
        if ([jsons count])
        {
            for (int i = 0; i < [jsons count]; i++) {
                NSDictionary *jsonUser = jsons[i];
                
                KKZUser *user = nil;
                if (jsonUser[@"user"]) {
                    if ([jsonUser[@"user"] isKindOfClass:[NSDictionary class]]) {
                        NSNumber *existed = nil;
                        user  = (KKZUser *)[[MemContainer me] instanceFromDict:jsonUser[@"user"]
                                                                         clazz:[KKZUser class]
                                                         updateTypeWhenExisted:UpdateTypeReplace
                                                                         exist:&existed];
                        
                        [kotaAll addObject:user];
                    }
                    
                }

                
                
            }
            
        }
        else{
            
            [self deleteCache];
        }
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:kotaAll,@"kotaUsers",
                                   nil]];
        
        
    }
    
    else if (taskType == TaskTypeByMovieKotaShareList) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaShareList succeded: %@", dict);
        
        
        
        
        NSInteger count = [[dict objectForKey:@"count"] intValue];
        
        NSArray *kotas = [dict objectForKey:@"list"];
        NSMutableArray *kotaList = [[NSMutableArray alloc] init];
        
        
        if ([kotas count])
        {
            for (NSDictionary *aKota in kotas)
            {
                NSString *kotaId = nil;
                if ([aKota objectForKey:@"kotaId"] && [aKota objectForKey:@"kotaId"]!=[NSNull null])
                    kotaId = [NSString stringWithFormat:@"%@", [aKota objectForKey:@"kotaId"]];
                
                NSNumber *existed = nil;
                
                KotaShare *newKota  = (KotaShare *)[[MemContainer me] instanceFromDict:aKota clazz:[KotaShare class] updateTypeWhenExisted:UpdateTypeReplace exist:&existed];
                
                [kotaList addObject:newKota];
                
                
                
                if ([aKota objectForKey:@"movie"] && [aKota objectForKey:@"movie"]!=[NSNull null])
                {
                    Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:aKota error:nil];
                    [[MemContainer me] putObject:movie];
                    newKota.movieId = movie.movieId.intValue;
                }
                
                
                
                if (aKota[@"shareUser"]) {
                    
                    if ([aKota[@"shareUser"] isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *shareUserDic = aKota[@"shareUser"];
                        if ([shareUserDic objectForKey:@"userId"] && [shareUserDic objectForKey:@"userId"]!=[NSNull null]){
                            
                            NSNumber *existed1 = nil;
                            KKZUser *user = (KKZUser *)[[MemContainer me] instanceFromDict:shareUserDic
                                                                                     clazz:[KKZUser class] updateTypeWhenExisted:UpdateTypeReplace
                                                                                     exist:&existed1];
                            
                            
                            newKota.shareUserId = user.userId;
                            
                        }
                        
                    }
                }
                
                
                if (aKota[@"kotaComment"]) {
                    
                    if ([aKota[@"kotaComment"] isKindOfClass:[NSDictionary class]]) {
                        
                        
                        NSDictionary *kotaCommentDic = aKota[@"kotaComment"];
                        
                        
                        if ([kotaCommentDic objectForKey:@"id"] && [kotaCommentDic objectForKey:@"id"]!=[NSNull null]){
                            
                            
                            
                            NSNumber *existed1 = nil;
                            
                            kotaComment *kotaC = (kotaComment *)[[MemContainer me] instanceFromDict:kotaCommentDic
                                                                                              clazz:[kotaComment class] updateTypeWhenExisted:UpdateTypeReplace
                                                                                              exist:&existed1];
                            
                            newKota.kotaCommentId = kotaC.kotaCommentId;
                            
                        }
                    }
                    
                }
                
                
                
            }
            
        } else
        {
            [self deleteCache];
        }
//        kotaList = (NSMutableArray *)[KotaShare filterKotaWithTicketTimeArray:kotaList];
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:(count > kCountPerPage * self.pageNum)], @"hasMore",
                                   [NSNumber numberWithInteger:[kotas count]], @"count", kotaList, @"kotaList", nil]];
    }
    
    
    else if (taskType == TaskTypeAcceptMyAppointment) {
        
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeAcceptMyAppointment succeded: %@", dict);
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObject:dict[@"status"] forKey:@"status"]];
    }
    
    
    
    
    else if (taskType == TaskTypeMyAppointment) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeMyAppointment succeded: %@", dict);
        
        
        
        
        NSInteger count = [[dict objectForKey:@"count"] intValue];
        
        NSArray *kotas = [dict objectForKey:@"list"];
        NSMutableArray *kotaList = [[NSMutableArray alloc] init];
        
        
        if ([kotas count])
        {
            for (NSDictionary *aKota in kotas)
            {
                NSString *kotaId = nil;
                if ([aKota objectForKey:@"kotaId"] && [aKota objectForKey:@"kotaId"]!=[NSNull null])
                    kotaId = [NSString stringWithFormat:@"%@", [aKota objectForKey:@"kotaId"]];
                
                NSNumber *existed = nil;
                KotaShare *newKota  = (KotaShare *)[[MemContainer me] instanceFromDict:aKota
                                                                                 clazz:[KotaShare class]
                                                                                 exist:&existed];
                if ([newKota.distance intValue] == -1) {
                    newKota.distance = [NSNumber numberWithInt:999999999];
                }
                
                [kotaList addObject:newKota];
                
                NSString *uId = [aKota kkz_stringForKey:@"shareId"];
                
                if (uId) {
                    
                    NSNumber *existed1 = nil;
                    KKZUser *newUser  = (KKZUser *)[[MemContainer me] instanceFromDict:aKota
                                                                                 clazz:[KKZUser class]
                                                                                 exist:&existed1];
                    [newUser updateDataFromKotaShare:aKota];
                    if (newUser.sex.intValue) {
                        newKota.userSex = [NSString stringWithFormat:@"%@", newUser.sex];
                    }
                    if (newUser.userName != 0) {
                        newKota.userName = newUser.userName;
                        
                    }
                    if (newUser.avatarPath.length != 0) {
                        newKota.userAvatar = newUser.avatarPath;
                    }
                    if (newUser.followerCount.intValue) {
                        newKota.userFans = newUser.followerCount;
                        
                    }
                }
                
                if ([aKota objectForKey:@"movie"] && [aKota objectForKey:@"movie"]!=[NSNull null])
                {
                    Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:aKota error:nil];
                    [[MemContainer me] putObject:movie];
                    newKota.movieId = movie.movieId.intValue;
                }
                
            }
            
        } else
        {
            [self deleteCache];
        }
        kotaList = (NSMutableArray *)[KotaShare filterKotaWithTicketTimeArray:kotaList];
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:(count > kCountPerPage * self.pageNum)], @"hasMore",
                                   [NSNumber numberWithInteger:[kotas count]], @"count", kotaList, @"kotaList", nil]];
    }
    
    
    
    else if (taskType == TaskTypeKotaShareList) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaShareList succeded: %@", dict);
        
        NSArray *kotas = [dict objectForKey:@"list"];
        NSMutableArray *kotaList = [[NSMutableArray alloc] init];
        
        if ([kotas count])
        {
            for (NSDictionary *aKota in kotas)
            {
                NSString *kotaId = nil;
                if ([aKota objectForKey:@"kotaId"] && [aKota objectForKey:@"kotaId"]!=[NSNull null])
                    kotaId = [NSString stringWithFormat:@"%@", [aKota objectForKey:@"kotaId"]];
                
                NSNumber *existed = nil;
                KotaShare *newKota  = (KotaShare *)[[MemContainer me] instanceFromDict:aKota
                                                                                 clazz:[KotaShare class]
                                                                                 exist:&existed];
                if ([newKota.distance intValue] == -1) {
                    newKota.distance = [NSNumber numberWithInt:999999999];
                }
                newKota.movieId = self.movieId.intValue;
                [kotaList addObject:newKota];
                
                NSString *uId = [aKota kkz_stringForKey:@"shareId"];
                
                if (uId) {
                    
                    NSNumber *existed1 = nil;
                    KKZUser *newUser  = (KKZUser *)[[MemContainer me] instanceFromDict:aKota
                                                                                 clazz:[KKZUser class]
                                                                                 exist:&existed1];
                    [newUser updateDataFromKotaShare:aKota];
                    if (newUser.sex.intValue) {
                        newKota.userSex = [NSString stringWithFormat:@"%@", newUser.sex];
                    }
                    if (newUser.userName != 0) {
                        newKota.userName = newUser.userName;
                        
                    }
                    if (newUser.avatarPath.length != 0) {
                        newKota.userAvatar = newUser.avatarPath;
                    }
                    if (newUser.followerCount.intValue) {
                        newKota.userFans = newUser.followerCount;
                        
                    }
                }
            }
            
        } else
        {
            [self deleteCache];
        }
        kotaList = (NSMutableArray *)[KotaShare filterKotaWithTicketTimeArray:kotaList];
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:([kotas count] >= kCountPerPage)], @"hasMore",
                                   [NSNumber numberWithInteger:[kotas count]], @"count", kotaList, @"kotaList", nil]];
        
        
        
        
    }else if (taskType == TaskTypeKotaUserDetail) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaUserDetail task succeded: %@", dict);
        
        NSDictionary *user = [dict objectForKey:@"user"];
        NSString *uId = nil;
        
        uId = [user kkz_stringForKey:@"uid"];
        KKZUser *newUser = nil;
        if (uId) {
            
            
            NSNumber *existed1 = nil;
            newUser  = (KKZUser *)[[MemContainer me] instanceFromDict:user
                                                                clazz:[KKZUser class]
                                                updateTypeWhenExisted:UpdateTypeReplace
                                                                exist:&existed1];
            [newUser updateDataFromUser:user];
            newUser.userId = uId.intValue;//(int)[user kkz_objForKey:@"uid"];
            newUser.status = [[dict kkz_stringForKey:@"tag"] intValue];//0未完善信息，1完善信息
        }
        
        else
        {
            [self deleteCache];
        }
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [dict kkz_stringForKey:@"tag"], @"accountStatus",
                                   newUser,@"user",nil]];
        
    }
    
    else if (taskType == TaskTypeKotaFriendUserDetail) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaFriendUserDetail task succeded: %@", dict);
        
        NSDictionary *user = [dict objectForKey:@"user"];
        NSString *uId = nil;
        
        uId = [user kkz_stringForKey:@"uid"];
        KKZUser *newUser = nil;
        if (uId) {
            
            
            NSNumber *existed1 = nil;
            newUser  = (KKZUser *)[[MemContainer me] instanceFromDict:user
                                                                clazz:[KKZUser class]
                                                updateTypeWhenExisted:UpdateTypeReplace
                                                                exist:&existed1];
            [newUser updateDataFromUser:user];
            newUser.userId = uId.intValue;//(int)[user kkz_objForKey:@"uid"];
            newUser.status = [[dict kkz_stringForKey:@"tag"] intValue];//0未完善信息，1完善信息
            
            [DataEngine sharedDataEngine].headImg = [newUser avatarPathFinal];
            [DataEngine sharedDataEngine].userName = [newUser nicknameFinal];
            
        }
        
        else
        {
            [self deleteCache];
        }
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [dict kkz_stringForKey:@"tag"], @"accountStatus",
                                   newUser,@"user",nil]];
        
    }else if (taskType == TaskTypeModifyHomeBackground) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"modify info succeded");
        
        NSString *uId = [dict kkz_stringForKey:@"user_id"];
        if (uId) {
            KKZUser *current = [KKZUser getUserWithId:uId.intValue];
            if (current) {
                current.homeImagePath = [dict kkz_stringForKey:@"img"];
            }else{
                
            }
            if (current.homeImagePath) {
                [[ImageEngine sharedImageEngine] saveImage:self.bgImage
                                                    forURL:current.homeImagePath
                                                   andSize:ImageSizeMiddle
                                                      sync:YES];
            }
        }
        
        [self doCallBack:YES info:nil];
        
    }else if (taskType == TaskTypeKotaShareApply) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaShareApply task succeded: %@", dict);
        
        
        if ([dict[@"status"] intValue] == 0) {
            [self doCallBack:YES info:dict];
            
        }else{
            [self doCallBack:NO info:dict];
        }
        
        
    }else if (taskType == TaskTypeKotaResponse) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeKotaResponse task succeded: %@", dict);
        NSString *waitDeleteUser = [dict kkz_stringForKey:@"uid"];
        [self doCallBack:YES info:@{@"user": waitDeleteUser,@"attitude":self.attitude}];
        
    }
}


- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeModifyHomeBackground)
    {
        DLog(@"TaskTypeModifyHomeBackground task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeKotaShareUsers)
    {
        DLog(@"TaskTypeKotaShareUsers task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeKotaShareFilm)
    {
        DLog(@"TaskTypeKotaShareFilm task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeKotaShareNearUser)
    {
        DLog(@"TaskTypeKotaShareNearUser task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeKotaShareList)
    {
        DLog(@"TaskTypeKotaShareList task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeByMovieKotaShareList)
    {
        DLog(@"TaskTypeKotaShareListByMovie task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeAcceptMyAppointment)
    {
        DLog(@"TaskTypeAcceptMyAppointment task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    
    if (taskType == TaskTypeMyAppointment)
    {
        DLog(@"TaskTypeMyAppointment task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeKotaUserDetail)
    {
        DLog(@"TaskTypeKotaUserDetail task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeKotaFriendUserDetail)
    {
//        DLog(@"TaskTypeKotaFriendUserDetail task failed: %@", [error description]);
//        NSLog(@"error==%@",[[error.userInfo valueForKey:@"LogicError"] valueForKey:@"error"]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeKotaShareApply)
    {
        DLog(@"TaskTypeKotaShareApply task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    
    if (taskType == TaskTypeKotaResponse)
    {
        DLog(@"TaskTypeKotaResponse task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

- (void)requestSucceededConnection {
    //if needed do something after connected to net, handle here
}

- (void)operationWillCancel {
    if (taskType == TaskTypeKotaFriendUserDetail)
    {
        [self doCallBack:NO info:nil];
    }
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
    //just for upload task
}


@end
