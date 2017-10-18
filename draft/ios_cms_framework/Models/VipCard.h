//
//  VipCard.h
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "CardDetail.h"

@interface VipCard : MTLModel<MTLJSONSerializing>

//@property (nonatomic, copy)NSString *balance;
@property (nonatomic, copy)NSNumber *businessType;
@property (nonatomic, copy)NSString *businessTypeName;
@property (nonatomic, copy)NSString *cardNo;
@property (nonatomic, copy)NSString *cardNoView;
//@property (nonatomic, copy)NSString *cardRule;//
//@property (nonatomic, copy)NSString *cardStatus;
@property (nonatomic, copy)NSNumber *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSNumber *codeType;
@property (nonatomic, copy)NSString *codeTypeName;
@property (nonatomic, copy)NSNumber *createTime;
@property (nonatomic, copy)NSString *expireDate;//
//@property (nonatomic, copy)NSString *idNum;
//@property (nonatomic, copy)NSString *levelCode;//
//@property (nonatomic, copy)NSString *levelName;//
@property (nonatomic, copy)NSString *mobilePhone;//
@property (nonatomic, copy)NSString *productLogo;
@property (nonatomic, copy)NSString *productName;
//@property (nonatomic, copy)NSString *score;//
@property (nonatomic, copy)NSNumber *useType;
@property (nonatomic, copy)NSString *useTypeName;
@property (nonatomic, copy)NSString *targetAccountName;
@property (nonatomic, strong) CardDetail * cardDetail;


//@property (nonatomic, copy)NSString *userName;

@end
