//
//  SellPickUpCell.m
//  cias
//
//  Created by cias on 2017/4/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "SellPickUpCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SellPickUpCell ()
{
    CGFloat unfoldHeight;
    CGFloat foldHeight;
    CGFloat erWeiMaH;
    NSIndexPath *_indexPath;
    NSDictionary *dataDic;
}
@end
@implementation SellPickUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDic:(NSDictionary *)dic withIndex:(NSIndexPath *)indexPath {
    dataDic = dic;
    NSDictionary *dict = [dic kkz_objForKey:@"data"];
    _indexPath = indexPath;
        //名字、图片、单价、数量
    self.sellProductName.text = [dict kkz_stringForKey:@"goodsName"];
    [self.sellProductImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:[dict kkz_stringForKey:@"goodsThumbnailUrl"]]];
    self.sellProductPrice.text = [NSString stringWithFormat:@"%.2f",[[dict kkz_stringForKey:@"unitPrice"] floatValue]/100];
    self.sellProductNUmber.text = [dict kkz_stringForKey:@"count"];
    self.describeLabel.text = [dict kkz_stringForKey:@"desc"];//@"这是一条测试数据哦，可乐鸡翅爆米花，啤酒饮料矿泉水。这是一条测试数据哦，可乐鸡翅爆米花，啤酒饮料矿泉水。这是一条测试数据哦，可乐鸡翅爆米花，啤酒饮料矿泉水。";//

    //创建二维码  默认显示
    NSString *goodsCouponsCode = [dict kkz_stringForKey:@"goodsCouponsCode"];
    NSArray *tmpArr = [goodsCouponsCode componentsSeparatedByString:@"|"];
    NSString *codeStr = [tmpArr componentsJoinedByString:@""];
    if (codeStr.length>0) {
        NSMutableArray *erweimaArr = [NSMutableArray arrayWithArray:tmpArr];
        CGFloat originY = 15;
        CGFloat imageHeight = 125*Constants.screenWidthRate;
        CGFloat sepY = 15;
        for (int i = 0; i < erweimaArr.count; i++) {
            UIImageView *erweiMaImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, originY + i * (sepY * 2 + imageHeight), imageHeight, imageHeight)];
            erweiMaImage.image = [self encodeQRImageWithContent:[erweimaArr objectAtIndex:i] size:CGSizeMake(imageHeight, imageHeight)];
            [self.erWeiMaView addSubview:erweiMaImage];
            
            UILabel *pickUpCode = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(erweiMaImage.frame) + 25*Constants.screenWidthRate, CGRectGetMinY(erweiMaImage.frame) + (imageHeight-41)/2, 70, 13)];
            pickUpCode.text = @"取货码";
            pickUpCode.textColor = [UIColor colorWithHex:@"#b2b2b2"];
            pickUpCode.font = [UIFont systemFontOfSize:13];
            [self.erWeiMaView addSubview:pickUpCode];
            
            UILabel *pickUpCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(pickUpCode.frame), CGRectGetMaxY(pickUpCode.frame) + 10, kCommonScreenWidth - CGRectGetMaxX(erweiMaImage.frame) - 25*Constants.screenWidthRate -15, 18)];
            pickUpCodeLabel.text = [erweimaArr objectAtIndex:i];
            pickUpCodeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            pickUpCodeLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [self.erWeiMaView addSubview:pickUpCodeLabel];
            
            if (i != erweimaArr.count - 1) {
                UILabel *lineLbel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(erweiMaImage.frame), CGRectGetMaxY(erweiMaImage.frame) + 14.5, kCommonScreenWidth - CGRectGetMinX(erweiMaImage.frame), 0.5)];
                lineLbel.backgroundColor = [UIColor colorWithHex:@"#e5e5e5"];
                [self.erWeiMaView addSubview:lineLbel];
                
            }
        }
        //二维码的背景高度
        erWeiMaH = erweimaArr.count * (imageHeight + 2 * sepY);
    } else {
        //二维码的背景高度
        erWeiMaH = 0;
    }
    
    //分割线的top值 (紧贴着erWeiMaView)
    foldHeight = 173 + 10 ;
    unfoldHeight = 173 + 10 + erWeiMaH;
    
    //默认隐藏
    if ([[dataDic valueForKey:@"fold"] integerValue] == 0) {
        self.unfoldBtn.selected = NO;
        self.erWeiMaView.hidden = YES;
        self.erWeiMaHeight.constant = 0;
        self.lineTop.constant = 15;
        self.cellHeight = foldHeight+10;
    } else {
        self.unfoldBtn.selected = YES;
        self.erWeiMaView.hidden = NO;
        self.erWeiMaHeight.constant = erWeiMaH;
        self.lineTop.constant = 15;
        self.cellHeight = unfoldHeight+10;
    }
    
}
- (IBAction)unfoldAction:(UIButton *)sender {
    if (sender.selected == NO) {
        
        self.unfoldBtn.selected = YES;
        self.erWeiMaView.hidden = NO;
        self.lineTop.constant = 15;
        self.erWeiMaHeight.constant = erWeiMaH;
        self.cellHeight = unfoldHeight+10;
        [dataDic setValue:@"1" forKey:@"fold"];
    } else {
        self.unfoldBtn.selected = NO;
        self.erWeiMaView.hidden = YES;
        self.lineTop.constant = 15;
        self.erWeiMaHeight.constant = 0;
        self.cellHeight = foldHeight+10;
        [dataDic setValue:@"0" forKey:@"fold"];
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreashCellHeight:withIndex:)]) {
        [self.delegate refreashCellHeight:self.cellHeight withIndex:_indexPath];
    }
    
}


- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    return codeImage;
}

@end
