//
//  WebImageVIew.h
//  KoFashion
//
//  Created by zhoukai on 12/23/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void ( ^ImageShowCompleteBlock )();

//@protocol UIImageViewWebURLDelegate <NSObject>
//
//-(void)imageShowComplete;
//
//@end


@interface UIImageView (WebURL)

//@property (nonatomic,assign)id<UIImageViewWebURLDelegate> delegate;
//@property (nonatomic, copy) ImageShowCompleteBlock finishBlock;

-(id)initWithFrame:(CGRect)frame withURL:(NSString*)path andSize:(ImageSize)size;



//---------loadimage方法-------------
-(void)loadImageWithURL:(NSString *)path andSize:(ImageSize)size;
/**
 * @param
 *     defaultPath 默认系统图片的路径，不是url。
 *     加载前或者失败时候显示。
 * @return
 *
 */
-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size defaultImagePath:(NSString*)defaultPath;

-(void)loadImageWithURL:(NSString *)path andSize:(ImageSize)size finished:(ImageShowCompleteBlock)block;

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator;
-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator finished:(ImageShowCompleteBlock)block;
/**
 *  <#Description#>
 *
 *  @param url        <#url description#>
 *  @param size       <#size description#>
 *  @param indicator  要显示的加载圆圈，可以为nil
 *  @param isCompress 是否压缩
 *  @param block      <#block description#>
 */
-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator isCompress:(BOOL)isCompress finished:(ImageShowCompleteBlock)block;
-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size imgNameDefault:(NSString*)imgNameDefault;

@end
