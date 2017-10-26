//
//  GPS定位信息的View
//
//  Created by KKZ on 15/12/11.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface GPSLocationView : UIView

@property (nonatomic, copy) NSString *currentAddress;

- (void)searchCurrentGPSLocation;

@end
