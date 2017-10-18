//
//  WelcomeView.m
//
//  Created by abc on 15/8/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "WelcomeView.h"

@implementation WelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHex:@"#f3d747"];
        NSArray *array = [[NSArray alloc] init];
        UIImage *iosImage = [UIImage imageNamed:@"iOS"];
#if K_XINGYI
        array = @[iosImage];
#elif K_ZHONGDU
        array = @[iosImage];
#elif K_HUACHEN
        array = @[iosImage];
#elif K_BAOSHAN
        array = @[iosImage];
#elif K_HENGDIAN

        UIImage *iosImage1 = [UIImage imageNamed:@"iOS1"];
        UIImage *iosImage2 = [UIImage imageNamed:@"iOS2"];
        UIImage *iosImage3 = [UIImage imageNamed:@"iOS3"];
        array = @[iosImage, iosImage1, iosImage2, iosImage3];
#else
        array = @[@"Welcome0.jpg",@"Welcome1.jpg",@"Welcome2.jpg",@"Welcome3.jpg"];
#endif
        
        int count = (int)array.count;
        
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
        scrollview.pagingEnabled = YES;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator   = NO;
        scrollview.delegate = self;
        
        for (int i = 0; i < count; i ++)
        {
            UIImage *image = nil;
            #if K_XINGYI
                image  = array[i];
            #elif K_HENGDIAN
                image  = array[i];
//            NSString *name = array[i];
//            image  = [UIImage imageNamed:name];

            #elif K_ZHONGDU
                image  = array[i];
            #elif K_HUACHEN
                image  = array[i];
            #elif K_BAOSHAN
                image  = array[i];
            #else
                NSString *name = array[i];
                image  = [UIImage imageNamed:name];
            #endif
            
            CGFloat width = (kCommonScreenHeight/image.size.height)*image.size.width;
            
            CGFloat offsetX = (kCommonScreenWidth-width)/2;
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kCommonScreenWidth + offsetX, 0, width, kCommonScreenHeight)];
            imgView.image = image;
    
            [scrollview addSubview:imgView];
        }
        
        CGFloat x = (count - 1)*kCommonScreenWidth;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + (kCommonScreenWidth - 200)/2, kCommonScreenHeight - 200, 200, 200)];
//        [btn setTitle:@"" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.borderWidth = 1.0f;
//        btn.layer.borderColor = [UIColor colorWithHex:@"#333333"].CGColor;
        [scrollview addSubview:btn];
   
        scrollview.contentSize = CGSizeMake(count * kCommonScreenWidth, kCommonScreenHeight);
        
        [self addSubview:scrollview];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetX = scrollView.contentOffset.x;
    if (offsetX > (kCommonScreenWidth*3)) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnBackButtonClick)]) {
            [self.delegate returnBackButtonClick];
        }
    }
}

- (void)close
{
    [UIView animateWithDuration:1.0 animations:^
     {
         self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
         self.alpha = 0.0f;
     }
     completion:^(BOOL finished)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(returnBackButtonClick)]) {
             [self.delegate returnBackButtonClick];
         }
     }];
}


@end




























