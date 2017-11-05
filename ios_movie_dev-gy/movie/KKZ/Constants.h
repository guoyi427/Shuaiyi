//========渠道信息========
#define kChannelId @"1" //渠道ID
#define kChannelName @"App Store" //渠道名称，不同渠道的包，传相应的字符串


//========友盟统计========
#define kUMengAppKey @"4eda21de5270150da7000027"
#define kUMengChannelId @"App Store"


//========第三方平台 + ShareSDK========
//ShareSDK
#define kShareSDKAppKey @"28192292cb6e"

//新浪微博
#define kSinaKey @"1767451078"
#define kSinaSecret @"16fc6e9f24b8507cb1824570b40b7fba"
#define kSinaCallback @"http://m.kokozu.net/kologin/callback.php"

//微信
#define kWeixinKey @"wx74c15f9950ca03b1"
#define kWeixinSecret @"c57280b55fbd08f7d88491818326faa5"

//QQ空间
#define kQzoneAPIKey @"100450653"
#define kQzoneSecretKey @"5240f1c1d93e3a894767f72609f30ffa"

//腾讯微博
//TODO：DELETE
#define kQQWeiBoAPIKey @"801361296"
#define kQQWeiBoSecretKey @"fda1bb86b15e5e0c4d7b7a05ec0027aa"
#define kQQWeiBoCallback @"http://www.komovie.cn"

//分享内容的链接
#define kAppShareHTML5Url @"http://m.komovie.cn/?m=share"

//========其他信息========
//官网下载APP链接
#define kAppHTML5Url @"http://www.komovie.cn/download"

//AppStore应用的下载链接
#define kAppUrl @"https://itunes.apple.com/cn/app/id485584268?mt=8"

//客服电话
#define kHotLine @"4000009666"

//keychain related
//TODO：DELETE
#define kKCSessionId @"kokozu_session"
#define kKCSessionIdTimestamp @"kokozu_session_timestamp"
#define kKCUserId @"kokozu_userid"
#define kKCUserName @"kokozu_username"
#define kKeyChainServiceName @"kokozu_movie"
#define kKCHuanXinPwd @"kokozu_huanXinPwd"

// http request part
//TODO：原网络请求框架，待删除
#define HttpRequestErrorDomain @"HttpRequestErrorDomain"
#define kHttpRequestTimeout 15.0f // Time out seconds.
#define kHttpCommonErrorKey @"CommonError"
#define kHttpLogicErrorKey @"LogicError"
#define timeOutErrorKey @"isTimeOut"


//========加密的信息========
#define kKsspKey @"123456"//@"abcdYzx" //MD5的key
#define kKDesKey @"jkh7887k" //DES的key
#define kKDesLogKey @"koMovie1" //用户客户端错误日志DES加密的key

//==========银联的支付环境==========
#define UPPayMode @"00" //银联

//==========支付宝的Scheme==========
#define kAlipayScheme @"ZhangYu"

//==========测试环境==========
/*
//BaseURL 由于之前都是不一样的，后来测试环境统一了，但是真是环境不统一，暂时先保持这三个定义
//后期正式环境统一BaseURL后再合并
#define kKSSBaseUrl @"http://newtest.komovie.cn"
#define USER_SERVE @"http://newtest.komovie.cn"
#define KKSSMediaServerBase @"http://newtest.komovie.cn"
//----
//数据服务器地址
#define kKSSPDataServer @"data/service"
//KOTA服务器地址
#define KKSSPKota @"kota/ajax"
#define KKSSPKotaPath(path) [NSString stringWithFormat:@"%@/%@",KKSSPKota,path]
//电影相关接口服务器地址
#define kKSSPServer @"api_movie/service"
#define kKSSPServerPath(path) [NSString stringWithFormat:@"%@/%@",kKSSPServer,path]
//红包服务器地址
#define KKSSPRED @"http://newtest.komovie.cn/movie/receiveredenvelop/"
//社区服务器地址
#define KKSSClubSeverBase @"http://dev.admin.kokozu.net"
#define KKSSClubSeverPath(path) [NSString stringWithFormat:@"sns-api/%@",path]
//路径拼接好的 社区服务器地址，全部task请求重构后，删除KKSSClubSeverAPI
#define KKSSClubSeverAPI [NSString stringWithFormat:@"%@/sns-api/",KKSSClubSeverBase]
//媒体库服务器地址
#define KKSSMediaServerPath(path) [NSString stringWithFormat:@"data-api/%@",path]
//task请求重构后，删除KKSSMediaServerAPI
#define KKSSMediaServerAPI @"http://newtest.komovie.cn/data-api/"
//
#define USER_SERVE_API_PATH(path) [NSString stringWithFormat:@"user-api/%@", path]
//统计服务器地址
#define StatisticsSever @"http://newtest.komovie.cn/access-web/access/data/report"
//二维码服务器地址
#define kKSSPQRServer @"http://newtest.komovie.cn/api_movie/qr"
//影迷卡主机
#define kKSSPCinphileServerBaseURL @"http://test.api.mad.komovie.cn" //非用户中心
*/


////==========正式环境==========

////TODO: 合并BaseURL
#define kKSSBaseUrl @"http://47.95.148.114:8082"//@"http://newapi.komovie.cn"
#define USER_SERVE @"http://api.release.komovie.cn"
#define KKSSMediaServerBase @"http://api.release.komovie.cn"
#define KKSSClubSeverBase @"http://api.release.komovie.cn"
//数据服务器地址
#define kKSSPDataServer @"data/service"
//KOTA服务器地址
#define KKSSPKota @"kota/ajax"
#define KKSSPKotaPath(path) [NSString stringWithFormat:@"%@/%@",KKSSPKota,path]
//电影相关接口服务器地址
#define kKSSPServer @"movie/service"
#define kKSSPServerPath(path) [NSString stringWithFormat:@"%@/%@",kKSSPServer,path]
//红包服务器地址
#define KKSSPRED @"http://redenvelope.komovie.cn/movie/receiveredenvelop/"
//社区服务器地址
#define KKSSClubSeverPath(path) [NSString stringWithFormat:@"sns/%@",path]
//路径拼接好的 社区服务器地址，全部task请求重构后，删除KKSSClubSeverAPI
#define KKSSClubSeverAPI [NSString stringWithFormat:@"%@/sns/",KKSSClubSeverBase]
//媒体库服务器地址
#define KKSSMediaServerPath(path) [NSString stringWithFormat:@"data/%@",path]
//task请求重构后，删除KKSSMediaServerAPI
#define KKSSMediaServerAPI @"http://api.release.komovie.cn/data/"
//
#define USER_SERVE_API_PATH(path) [NSString stringWithFormat:@"user/%@", path]
//统计服务器地址
#define StatisticsSever @"http://api.release.komovie.cn/access-web/access/data/report"
//二维码服务器地址
#define kKSSPQRServer @"http://newapi.komovie.cn/movie/qr"
//影迷卡主机
#define kKSSPCinphileServerBaseURL @"http://api.mad.komovie.cn" //非用户中心



//=====================================================================================

#define KNET_FAULT_MSG @"网络好像有点问题, 稍后再试吧"

#define kAPPBackgroundColor [UIColor whiteColor]
#define kMainColor [UIColor whiteColor]
#define kBgColor \
    [UIColor clearColor]

//  地图信息


// task run in other thread
typedef enum {
    TaskTypeDefault = 0,
    TaskTypeHeartbeat,

    /*--network task--*/
    //----------KSSP----------
    TaskTypeLogin, //本系统登陆
    TaskTypeLoginPlatForm, //平台登陆
    TaskTypeGetVerificationCode,
    TaskTypeRegister,
    TaskTypeNewRegister,
    TaskTypeRegisterDetail,
    TaskTypeModifyInfo,
    TaskTypeSignout,
    TaskTypeForgetPassword,
    TaskTypeQueryBalance,
    TaskTypeAddImprestOrder, // 账户充值
    TaskTypeBindWeibo,
    TaskTypeUnbindWeibo,

    // system related
    TaskTypeLatestVersion,
    TaskTypeStatistic,
    TaskTypeFeedback,
    //    TaskTypeAppList,
    TaskTypeSplashImage,

    // order related
    TaskTypeQueryOrderTickets,
    TaskTypeQueryOrderCoupons,

    TaskTypeQueryOrderDetail,
    TaskTypeGetOrderOffPrice,
    TaskTypeQueryOrderWarning,
    TaskTypeQueryUserMobile,

    TaskTypeBuyTicket,
    TaskTypeBuyWebTicket,
    TaskTypeBuyCoupon,
    TaskTypeBid,

    TaskTypePayOrder,
    TaskTypePayEcshopOrder,
    TaskTypeRepayOrder,
    TaskTypeSOSOrder,
    TaskTypeGetPayType,
    TaskTypeCheckECard,
    TaskTypeBindingECard,
    TaskTypeOrderCoupons,
    TaskTypeCancelOrder,

    TaskTypeResendOrder,

    // seat related
    //    TaskTypeLockSeat,
    //    TaskTypeUnlockSeat,
    TaskTypeSeatList,
    TaskTypeSeatWeb,
    TaskTypeCinemaSeatList, //影院厅图
    TaskTypeSoldSeatList, //影院已售座位图
    // bid related
    TaskTypeMovieShowtime,
    TaskTypeMovieScreenType,
    TaskTypeMovieBidPrice,

    // movie list related
    TaskTypeMovieList,
    TaskTypeCinemaMovieList,
    TaskTypeCinemaPlanMovieList,
    TaskTypeActivityCinemaMovieList,
    TaskTypeIncomingList,
    TaskTypeKotaMovieList,

    // movie info related
    TaskTypeMovieCinemasPlanList, //查询一个电影所有影院的上映日期
    TaskTypeMovieInfo, //查询电影信息
    TaskTypeMoviePoster, //查询电影海报
    TaskTypeMediaTrailer, //查询电影的预告片
    TaskTypeCinemaPoster, //查询影院
    TaskTypeMovieSupport, //查询影片点赞情况
    TaskTypeSupportMovie, //对该影片点赞或者不喜欢
    TaskTypeMovieTrailerList, //电影的预告片儿列表
    TaskTypeMovieSongsList, //电影的歌曲列表
    TaskTypeMovieGallaryList, //电影的剧照列表

    // cinema list related
    TaskTypeCinemaList,
    TaskTypeMovieCinemaList, //获得相关电影的影院列表
    TaskTypeCouponCinemas,
    TaskTypeSearchMovieCinema,
    TaskTypeCollectCinemaList, //获得收藏的影院列表
    TaskTypeSearchCinemaList,
    TaskTypeCinemaActivityInfo, //获取具体某个影院是否有活动

    // cinema info releated
    TaskTypeCinemaDetail,
    TaskTypeCinemaStills,
    //    TaskTypeCinemaSpecialInfo,
    // coupon
    TaskTypeVipCardCheck,
    TaskTypeCouponPrice,
    TaskTypeCinemaCoupon,
    TaskTypeActivityCoupon,

    // ticket list
    TaskTypeTicketList,
    TaskTypeTicketDetail,

    // planDate
    TaskTypeQueryPlanDate,

    // rate related
    TaskTypeRateCinema,
    TaskTypeRateMovie,

    // fav related
    TaskTypeFavCinemasList,
    TaskTypeFavMoviesList,

    TaskTypeCinemaFavStatus,
    TaskTypeAddCinemaFav,
    TaskTypeRemoveCinemaFav,

    TaskTypeMovieFavStatus,
    TaskTypeAddMovieFav,

    TaskTypeQueryFavNum, //查询多少人评价了一部电影
    TaskTypeQuerySucceedNum,
    TaskTypeMovieFansList,
    TaskTypeCinemaFansList,

    // location related
    TaskTypeGetCityList,
    TaskTypeGetIPCity,

    // image related
    TaskTypeImageUpload,
    TaskTypeImageDownload,

    // sound task
    TaskTypeSoundDownload,

    // Comment task
    TaskTypeQueryComment,
    TaskTypeQueryCommentNew, //查询影评
    TaskTypeQueryFriendComments, //查询好友影评
    TaskTypeQueryCommentFromHomePage, //查询影评

    TaskTypeQueryCommentKo,
    TaskTypeQueryCommentTuCao,
    TaskTypeCommentOperating,
    TaskTypeCommentRelation,
    TaskTypeCommentDelete,
    TaskTypeQueryCommentScore, //查询官方ko测评列表，可能为空。

    TaskTypeCommentUploadAudio, //上传语音评论
    TaskTypeCommentUploadText, //上传文字评论
    TaskTypeCommentMessageUploadAudio, //上传语音私信
    TaskTypeCommentMessageUploadText, //上传文字私信
    TaskTypeKotaMessageUploadText, //上传约电影信息
    TaskTypeKotaApplyForMessageUploadText, //上传约电影信息

    //----------SINA----------
    TaskTypeSinaTopicGet,
    TaskTypeSinaCommentGet,
    TaskTypeNewSinaFeed,
    TaskTypeNewSinaComment,
    TaskTypeNewSinaRepost,

    TaskTypeSinaFollowersList,
    TaskTypeSinaFollowingList,
    TaskTypeSinaFriendsList,

    TaskTypeFriendshipQuery,
    TaskTypeFriendshipCreate,
    TaskTypeFriendshipDestroy,

    TaskTypeSinaUserInfoQuery,
    TaskTypeQuerySelfSinaInfo,

    //----------geocoding----------
    TaskTypeGetKeywordLatlng,

    // movie info（news）related
    TaskTypeNewsBanner,

    // activity info related
    //    TaskTypeActivityList,
    TaskTypeActivityDetail,
    //    TaskTypeActivityRegist,
    //    TaskTypeActivityWeb,
    //    TaskTypeActivityCinemaList,

    // kota related
    TaskTypeKotaShareFilm,
    TaskTypeKotaShareNearUser,
    TaskTypeKotaShareList,
    TaskTypeByMovieKotaShareList,
    TaskTypeMyAppointment,
    TaskTypeAcceptMyAppointment,
    TaskTypeKotaUserDetail,
    TaskTypeModifyHomeBackground,
    TaskTypeKotaShareApply,
    TaskTypeKotaResponse,
    TaskTypeKotaUserRelation,
    TaskTypeKotaShareUsers,
    TaskTypeKotaFriendUserDetail,

    // image related

    //  ---push notification
    //    TaskTypePushNotification,
    TaskTypeKotaPushNotification,
    //    TaskTypeRemotePush,
    //    TaskTypeQueryAliPush,
    //    TaskTypeConfigAliPush,

    // friend  related
    TaskTypeFavoriteList,
    TaskTypeFollowingList,
    TaskTypeFriendList,

    TaskTypeSearchFriends, //没用
    TaskTypeSearchFriendMovie,
    TaskTypeAddFriend,
    TaskTypeInvitedFriend,
    TaskTypeDelFriend,
    TaskTypeSinaWeiboFriendList,
    TaskTypeQQWeiboFriendList,
    TaskTypeIdentifyPhoneNum,

    // MovieDB related
    TaskTypeMovieActorList,
    TaskTypeMovieHobby,
    TaskTypeActorDetail,
    TaskTypeActorMovieList,
    TaskTypeSimilarMovieList,
    TaskTypeMovieCategoryList,
    TaskTypeMovieCategoryItemsList,
    TaskTypeMovieSongList,
    TaskTypeMovieDialogueList,
    TaskTypeMovieProductList,
    TaskTypeMovieMatchQuery,
    TaskTypeMovieMatchSearch,
    TaskTypeMovieProductBanner,
    TaskTypeMovieSearch,
    TaskTypeQueryMovieFav, //查询收藏的电影（已评论的电影）
    TaskTypeQueryMovieStatus, //查询电影状态，是否有dialogue，match，product，song
    TaskTypeQueryMovieSummary, //沙勋电影状态，新接口
    TaskTypeUserMessage,
    TaskTypeUserFriendHomeList,
    TaskTypeUserMyHomeList,

    // share related
    TaskTypeShareMovieRelate,
    // GroupBuy
    TaskTypeGroupBuyList,
    TaskTypeCinemaGroupBuyList,
    TaskTypeMovieGroupBuyList,
    TaskTypePlanGroupBuyList,

    //私信
    TaskTypeQueryMessageOne, //查询和某人的私信
    TaskTypeQueryMessageList, //查询私信列表
    TaskTypeQueryMessageUserInfoList, //查询私信列表用户信息
    TaskTypeAppointmentMessageList, //查询约电影列表
    TaskTypeQueryWantWatch, //查询是否想看
    TaskTypeClickWantWatch, //点击想看
    TaskTypeQueryWantWatchNum, //查询想看数量
    TaskTypeDeleteMessage,
    TaskTypeAppointmentDeleteMessage,

    //获取用户待处理消息数量
    TaskTypeQueryUserMessageCount,
    //添加喜欢
    TaskTypeAddLike,

    //添加喜欢
    TaskTypeAddKotaLike,

    TaskTypeFavoriteMovieList, //查询收藏
    TaskTypeRemoveMovieFav, //移除收藏

    TaskTypeFavoriteWantLookList, //查询想看
    TaskTypeRemoveWantLook, //移除想看

    // statistics统计
    TaskTypeStatisticShare, //分享
    TaskTypeHostAchieve,
    TaskTypeStatisticClub, //社区

    //红包
    TaskTypeRedCouponFee,
    TaskTypeRedCouponFeeList,
    TaskTypeRedAccounts,

    // PassBook
    TaskTypePassBook,

    //购票成功积分查询
    TaskTypeRewardScore,

    // SimplePlayer
    TaskTypeSimplePlayer,

    //验证码
    TaskTypeVerificationCode,
    TaskTypeResetVerificationCode,

    //用户错误日志
    TaskTypeUserLog,

    //好友推荐
    TaskTypeRecommendFriend,

    //活跃用户
    TaskTypeActivityUser,

    //附近的人
    TaskTypeNearByUser,

    //邀请成功
    TaskTypeInventSuccess,

    //菜单配置
    TaskTypeMenuConfig,

    //待评价
    TaskTypeEvalue,

    //账号绑定列表
    TaskTypeAccountBindList,

    //账号绑定
    TaskTypeAccountBind,

    //解除绑定
    TaskTypeRemoveAccountBind,

    //获取手机号绑定验证码
    TaskTypeGetBindPhoneCode,

    /**
   *  社区
   */
    //社区首页帖子列表
    TaskTypeGetClubHomePagePostList,
    //社区导航
    TaskTypeGetClubHomePageNavTabsList,
    //我发表的帖子
    TaskTypeGetClubMinePublishedPostList,
    //我回复的帖子
    TaskTypeGetClubMineReplyPostList,
    //我收藏的帖子
    TaskTypeGetClubMineCollectionPostList,
    //我的订阅号
    TaskTypeGetClubMineSubscribers,
    //帖子详情
    TaskTypeGetClubPostDetail,
    //获取最近点赞列表
    TaskTypeGetSupportList,
    //获取最近点赞列表
    TaskTypePostUserSupport,

    //帖子回复列表
    TaskTypePostReplyList,
    //回复帖子
    TaskTypeReplyPost,
    //收藏帖子
    TaskTypeCollectionPost,
    //删除帖子
    TaskTypeDeletePost,
    //删除回复帖子
    TaskTypeDeleteReplyPost,
    //是否赞过该贴
    TaskTypeHasedUpPost,
    //给回复点赞
    TaskTypeHasUpPostReply,
    //举报帖子的提醒词汇列表
    TaskTypePostReportList,
    //举报帖子内容
    TaskTypePostReportContent,
    //电影详情 热门吐槽
    TaskTypeMovieHotComment,
    //电影详情 帖子板块儿
    TaskTypeMoviePostPlate,
    //某版块的帖子列表
    TaskTypePlatePostList,
    //我的订阅号
    TaskTypeMySubscribeList,

    //订阅号主页的帖子列表
    TaskTypeSubscriberPostList,
    //我发表的帖子数
    TaskTypeMyPublishPostNum,

} TaskType;

//
//
// enum DPodRecordType{
//	DPodRecordTypeA = 0,
//	DPodRecordTypeCNAME,
//	DPodRecordTypeMX,
//	DPodRecordTypeTXT,
//	DPodRecordTypeNS,
//	DPodRecordTypeAAAA,
//	DPodRecordTypeSRV,
//	DPodRecordTypeURL
//};
// typedef enum DPodRecordType DPodRecordType;
// const NSArray *___DPodRecordType;
//// 创建初始化函数。等于用宏创建一个getter函数
//#define cDPodRecordTypeGet (___DPodRecordType == nil ? ___DPodRecordType = [[NSArray alloc] initWithObjects:\
//@"A",\
//@"CNAME",\
//@"MX",\
//@"TXT",\
//@"NS",\
//@"AAAA",\
//@"SRV",\
//@"URL", nil] : ___DPodRecordType)
//// 枚举 to 字串
//#define cDPodRecordTypeString(type) ([cDPodRecordTypeGet objectAtIndex:type])
//// 字串 to 枚举
//#define cDPodRecordTypeEnum(string) ([cDPodRecordTypeGet
//indexOfObject:string])
//
//

/*  NSNotificationCenter 相关  */
#define TaskFinishedNotification @"TaskFinishedNotification"
#define UserGPSCityGetNotification @"UserGPSCityGetNotification"
#define kNotificationAudioStop @"kNotificationAudioStop"
//刷新影院列表
#define KNotificationRefreshCinemaList @"KNotificationRefreshCinemaList"

#import <Foundation/Foundation.h>

extern NSString *const ImageReadyNotification;
extern NSString *const SoundReadyNotification;

// image size
typedef enum {
    ImageSizeTiny = 0,
    ImageSizeSmall = 1,
    ImageSizeMiddle = 2,
    ImageSizeLarge = 3,
    ImageSizeOrign = 4 //默认大小
} ImageSize;

#define kImageTinyWidth 90
#define kImageSmallWidth 150
#define kImageMiddleWidth 320
#define kImageLargeWidth 600

typedef enum {
    PayMethodNone = -3,
    PayMethodCoupon = -2, //兑换码是否可用
    PayMethodAliMoblie = 1, //支付宝支付
    PayMethodUnionpay = 3, //银联支付
    PayMethodAliWeb = 4,
    PayMethodWeiXin = 38, //微信支付
    PayMethodCode = 99,
    PayMethodVip = -1, //余额
    PayMethodYiZhiFu = 45, //翼支付
    PayMethodJingDong = 48, //京东支付
    PayMethodPuFa = 51 //浦发银行支付
} PayMethod;

typedef enum {
    CellStateDefault = 0,
    CellStateExpand,
} CellState;

typedef enum {
    TargetTypeNone = 0,
    TargetTypeMovie = 1,
    TargetTypeUser = 2,
    TargetTypeMovieActor = 3,
    TargetTypeMovieRelate = 4,

} TargetType;

typedef enum {
    /// password
    SiteTypeKKZ = 1,
    /// valid code
    SiteTypeKKZValidcode,// = 26,
    SiteTypeQQ,
    SiteTypeWX,// = 12,
    SiteTypeTaobao,
    SiteTypeAliPay = 9,
    SiteTypeQQSpace,
    SiteTypeSina,
} SiteType;

typedef enum {
    ShareFriendMovie = 0, //
    ShareFriendSong, //
    ShareFriendDialogue, //
} ShareFriendType; //分享给朋友的类型

typedef enum {
    PopViewAnimationNone = 0,
    PopViewAnimationBounce, //弹出

    PopViewAnimationSwipeL2R, //左到右
    PopViewAnimationSwipeR2L, //右到左
    PopViewAnimationSwipeD2U, //下到上
    PopViewAnimationSwipeU2D, //上到下
    PopViewAnimationActionSheet,
    PopViewAnimationFade
} PopViewAnimation;

//统计相关
typedef enum {
    StatisticsTypeCinema = 1, //影院
    StatisticsTypeMovie = 2, //电影
    StatisticsTypeOrder = 3, //订单
    StatisticsTypePrivilege = 4, //活动
    StatisticsTypeSnsPoster = 5, //社区帖子
    StatisticsTypeSubscriber = 6 //订阅号
} StatisticsType;

//验证码类型：短信/语音
typedef enum {
    SMSValidcode = 0, //短信验证码
    VoiceValidcode = 1, //语音验证码
} ValidcodeType;
