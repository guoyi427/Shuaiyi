//
//  GPS定位信息的View
//
//  Created by KKZ on 15/12/11.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "GPSLocationView.h"

#import "LocationEngine.h"
#import "UIColor+Hex.h"

@interface GPSLocationView () {

    UILabel *locationLal;
}

@end

@implementation GPSLocationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;

        UIButton *content = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        content.backgroundColor = AHEX(0.9, @"#E9E9E9");
        [content addTarget:self action:@selector(searchCurrentGPSLocation) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:content];

        UIButton *locationImgV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height, height)];
        [locationImgV setImage:[UIImage imageNamed:@"locationGray"] forState:UIControlStateNormal];
        [locationImgV setImageEdgeInsets:UIEdgeInsetsMake(8, 15, 8, 5)];
        [content addSubview:locationImgV];

        UIButton *relocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - height, 0, height, height)];
        [relocationBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 3, 9, 15)];
        [relocationBtn setImage:[UIImage imageNamed:@"relocationGray1"] forState:UIControlStateNormal];
        [relocationBtn addTarget:self action:@selector(searchCurrentGPSLocation) forControlEvents:UIControlEventTouchUpInside];
        [content addSubview:relocationBtn];

        CGRect locationRect = CGRectMake(height + 4, 0, width - height - height - 20, height);
        locationLal = [[UILabel alloc] initWithFrame:locationRect];
        locationLal.font = [UIFont systemFontOfSize:13];
        locationLal.text = @"正在定位，请稍候...";
        locationLal.textColor = HEX(@"#999999");
        locationLal.backgroundColor = [UIColor clearColor];
        [content addSubview:locationLal];
    }
    return self;
}

- (void)searchCurrentGPSLocation {
    locationLal.text = @"正在定位，请稍候...";
    [[LocationEngine sharedLocationEngine] start];
}

- (void)setCurrentAddress:(NSString *)currentAddress {
    _currentAddress = currentAddress;
    locationLal.text = currentAddress;
}

@end
