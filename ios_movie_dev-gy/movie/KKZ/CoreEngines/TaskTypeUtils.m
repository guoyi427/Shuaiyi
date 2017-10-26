//
//  TaskTypeUtils.m
//  KoMovie
//
//  Created by zhoukai on 13-12-2.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "TaskTypeUtils.h"

@implementation TaskTypeUtils

+ (void)printCGRect:(CGRect)rect {
    [TaskTypeUtils printCGRect:rect withString:@""];
}
+ (void)printCGRect:(CGRect)rect withString:(NSString *)str {
    if (str == nil) {
        str = @"";
    }
    DLog(@"打印frame-%@:(%1.f,%1.f,%1.f,%1.f)", str, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}
+ (void)printCGPoint:(CGPoint)point {
    [TaskTypeUtils printCGPoint:point withString:@""];
}
+ (void)printCGPoint:(CGPoint)point withString:(NSString *)str {
    if (str == nil) {
        str = @"";
    }
    DLog(@"打印Point-%@:(%1.f,%1.f)", str, point.x, point.y);
}

+ (NSString *)stringWithTaskType:(TaskType)taskType {
    NSArray *arr = @[
        @"TaskTypeDefault",
        @"TaskTypeHeartbeat",

        /*--network task--*/
        //----------KSSP----------
        @"TaskTypeLogin",
        @"TaskTypeGetVerificationCode",
        @"TaskTypeRegister",
        @"TaskTypeNewRegister",
        @"TaskTypeRegisterDetail",
        @"TaskTypeModifyInfo",
        @"TaskTypeForgetPassword",
        @"TaskTypeQueryBalance",
        @"TaskTypeAddImprestOrder", // 账户充值
        @"TaskTypeBindWeibo",
        @"TaskTypeUnbindWeibo",

        //system related
        @"TaskTypeLatestVersion",
        @"TaskTypeStatistic",
        @"TaskTypeFeedback",
        @"TaskTypeAppList",
        @"TaskTypeSplashImage",

        //order related
        @"TaskTypeQueryOrderTickets",
        @"TaskTypeQueryOrderCoupons",

        @"TaskTypeQueryOrderDetail",
        @"TaskTypeGetOrderOffPrice",

        @"TaskTypeBuyTicket",
        @"TaskTypeBuyWebTicket",
        @"TaskTypeBuyCoupon",
        @"TaskTypeBid",

        @"TaskTypePayOrder",
        @"TaskTypeRepayOrder",
        @"TaskTypeSOSOrder",
        @"TaskTypeGetPayType",
        @"TaskTypeCheckECard",

        @"TaskTypeCancelOrder",

        //seat related
        //    TaskTypeLockSeat",
        //    TaskTypeUnlockSeat",
        @"TaskTypeSeatList",
        @"TaskTypeSeatWeb",
        //bid related
        @"TaskTypeMovieShowtime",
        @"TaskTypeMovieScreenType",
        @"TaskTypeMovieBidPrice",

        //movie list related
        @"TaskTypeMovieList",
        @"TaskTypeSaleMovieList",
        @"TaskTypeCinemaMovieList",
        @"TaskTypeActivityCinemaMovieList",
        @"TaskTypeIncomingList",

        //movie info related
        @"TaskTypeMovieInfo",
        @"TaskTypeMoviePoster",
        @"TaskTypeMediaTrailer",

        //cinema list related
        @"TaskTypeCinemaList",
        @"TaskTypeActivityCinemaList",
        @"TaskTypeMovieCinemaList",
        @"TaskTypeCouponCinemas",
        @"TaskTypeSearchMovieCinema",

        //cinema info releated
        @"TaskTypeCinemaDetail",

        //coupon
        @"TaskTypeVipCardCheck",
        @"TaskTypeCouponPrice",
        @"TaskTypeCinemaCoupon",
        @"TaskTypeActivityCoupon",

        //ticket list
        @"TaskTypeTicketList",
        @"TaskTypeTicketDetail",

        //rate related
        @"TaskTypeRateCinema",
        @"TaskTypeRateMovie",

        //fav related
        @"TaskTypeFavCinemasList",
        @"TaskTypeFavMoviesList",

        @"TaskTypeCinemaFavStatus",
        @"TaskTypeAddCinemaFav",
        @"TaskTypeRemoveCinemaFav",

        @"TaskTypeMovieFavStatus",
        @"TaskTypeAddMovieFav",
        @"TaskTypeRemoveMovieFav",

        @"TaskTypeMovieFansList",
        @"TaskTypeCinemaFansList",

        //location related
        @"TaskTypeGetCityList",
        @"TaskTypeGetIPCity",

        //image related
        @"TaskTypeImageUpload",
        @"TaskTypeImageDownload",

        //sound task
        @"TaskTypeSoundDownload",

        //Comment task
        @"TaskTypeQueryComment",
        @"TaskTypeQueryCommentSound",
        @"TaskTypeQueryCommentKo",
        @"TaskTypeQueryCommentTuCao",
        @"TaskTypeCommentOperating",
        @"TaskTypeCommentRelation",
        @"TaskTypeCommentDelete",
        @"TaskTypeQueryCommentScore", //查询官方ko测评列表，可能为空。
        @"TaskTypeCommentUploadAudio",
        @"TaskTypeCommentUploadText",
        @"TaskTypeQueryCommentMovie",
        @"TaskTypeQueryCommentMan",

        //----------SINA----------
        @"TaskTypeSinaTopicGet",
        @"TaskTypeSinaCommentGet",
        @"TaskTypeNewSinaFeed",
        @"TaskTypeNewSinaComment",
        @"TaskTypeNewSinaRepost",

        @"TaskTypeSinaFollowersList",
        @"TaskTypeSinaFollowingList",
        @"TaskTypeSinaFriendsList",

        @"TaskTypeFriendshipQuery",
        @"TaskTypeFriendshipCreate",
        @"TaskTypeFriendshipDestroy",

        @"TaskTypeSinaUserInfoQuery",
        @"TaskTypeQuerySelfSinaInfo",

        //----------geocoding----------
        @"TaskTypeGetKeywordLatlng",

        //movie info（news）related
        @"TaskTypeNewsSummary",
        @"TaskTypeMovieInfoList",
        @"TaskTypeMovieInfoDetail",
        @"TaskTypeNewsBanner",

        //activity info related
        @"TaskTypeActivityList",
        @"TaskTypeActivityDetail",
        @"TaskTypeActivityRegist",
        @"TaskTypeActivityWeb",

        //kota related
        @"TaskTypeKotaShareFilm",
        @"TaskTypeKotaShareList",

        @"TaskTypeKotaUserDetail",
        @"TaskTypeModifyHomeBackground",
        @"TaskTypeKotaShareApply",
        @"TaskTypeKotaResponse",
        @"TaskTypeKotaUserRelation",

        //image related

        //  ---push notification
        @"TaskTypePushNotification",
        @"TaskTypeKotaPushNotification",
        @"TaskTypeRemotePush",
        @"TaskTypeQueryAliPush",
        @"TaskTypeConfigAliPush",

        //friend  related
        @"TaskTypeFansList",
        @"TaskTypeFollowingList",
        @"TaskTypeSearchFriends",
        @"TaskTypeFavoriteList",
        @"TaskTypeAddFriend",
        @"TaskTypeInvitedFriend",
        @"TaskTypeDelFriend",
        @"TaskTypeSinaWeiboFriendList",
        @"TaskTypeQQWeiboFriendList",
        @"TaskTypeIdentifyPhoneNum",

        //MovieDB related
        @"TaskTypeMovieActorList",
        @"TaskTypeActorDetail",
        @"TaskTypeActorMovieList",
        @"TaskTypeSimilarMovieList",
        @"TaskTypeMovieCategoryList",
        @"TaskTypeMovieCategoryItemsList",
        @"TaskTypeMovieSongList",
        @"TaskTypeMovieDialogueList",
        @"TaskTypeMovieProductList",
        @"TaskTypeMovieMatchList",
        @"TaskTypeMovieProductBanner",
        @"TaskTypeMovieSearch",
        @"TaskTypeQueryMovieFav",
        @"TaskTypeQueryMovieStatus",
        @"TaskTypeUserMessage",

        //share related
        @"TaskTypeShareMovieRelate",
        //GroupBuy
        @"TaskTypeGroupBuyList",
        @"TaskTypeCinemaGroupBuyList",
        @"TaskTypeMovieGroupBuyList",
        @"TaskTypePlanGroupBuyList"
    ];
    return (NSString *) [arr objectAtIndex:taskType];
}
@end
