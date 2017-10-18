//
//  OrderTicket.h
//  CIASMovie
//
//  Created by cias on 2017/1/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderTicket : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *cinemaAddress;
@property (nonatomic, copy)NSString *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, strong)NSNumber *confimTime;//
@property (nonatomic, copy)NSString *cose;
@property (nonatomic, copy)NSString *count;
@property (nonatomic, strong)NSNumber *createTime;
@property (nonatomic, copy)NSString *filmEnglishName;
@property (nonatomic, copy)NSString *filmId;
@property (nonatomic, copy)NSString *filmName;
@property (nonatomic, copy)NSString *filmVersion;//
@property (nonatomic, copy)NSString *fkOrderCode;
@property (nonatomic, copy)NSString *foreignOrderNo;
@property (nonatomic, copy)NSString *foreignSeatNos;
@property (nonatomic, copy)NSString *language;
@property (nonatomic, copy)NSString *mobile;//
@property (nonatomic, copy)NSString *pkOrderTicket;
@property (nonatomic, strong)NSNumber *planBeginTime;
@property (nonatomic, copy)NSString *planId;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *printTime;//
//@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *scheduleKey;
@property (nonatomic, copy)NSString *screenId;
@property (nonatomic, copy)NSString *screenName;
@property (nonatomic, strong)NSNumber *screenType;
@property (nonatomic, copy)NSString *filmType;
@property (nonatomic, copy)NSString *seatInfo;
@property (nonatomic, copy)NSString *sendMessage;
@property (nonatomic, copy)NSString *sessionId;
@property (nonatomic, copy)NSString *telephoneNumber;//
@property (nonatomic, copy)NSString *thumbnailUrl;
@property (nonatomic, copy)NSString *thumbnailUrlStand;
@property (nonatomic, copy)NSString *validCode;//
@property (nonatomic, copy)NSString *validInfoBak;

@property (nonatomic, copy)NSString *originalPrice;
@property (nonatomic, strong)NSNumber *seatNum;
@property (nonatomic, copy)NSString *serviceMoney;
@property (nonatomic, copy)NSString *systemScreenType;



@end
