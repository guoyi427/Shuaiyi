//
//  TypeOnePostThumbnailContentView.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "TypeOnePostThumbnailContentView.h"

#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "MovieStillScrollViewController.h"
#import "NSStringExtra.h"
#import "UIConstants.h"
#import "WebViewController.h"

#define cellMarginY 0
#define cellMarginX 15

#define postImgWith 122
#define postImgHeight 85
#define marginImgToWord 10
#define wordTopMargin 5

#define wordFont 17
#define wordHeight 75

#define videoIconWith 25
#define audioIconWith 25

@implementation TypeOnePostThumbnailContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载帖子内容
        [self loadPost];
    }
    return self;
}

/**
 *  帖子内容
 */
- (void)loadPost {

    //帖子中的图片缩略图 音频
    [self addAudioView];

    //帖子中的图片缩略图 视频
    [self addVideoView];

    //帖子中的图片缩略图 图文
    [self addTextView];

    //帖子中的文字
    [self addPostText];
}

- (void)addPostText {
    postWordLbl = [[UILabel alloc]
            initWithFrame:CGRectMake((cellMarginX + postImgWith + marginImgToWord),
                                     wordTopMargin,
                                     screentWith - (cellMarginX + postImgWith +
                                                    marginImgToWord) -
                                             cellMarginX,
                                     wordHeight)];
    postWordLbl.numberOfLines = 0;
    postWordLbl.textColor = [UIColor blackColor];
    postWordLbl.font = [UIFont systemFontOfSize:wordFont];

    [self addSubview:postWordLbl];
}

- (void)addAudioView {
    postImgViewAudio = [[UIImageView alloc]
            initWithFrame:CGRectMake(cellMarginX, cellMarginY, postImgWith,
                                     postImgHeight)];
    [postImgViewAudio setBackgroundColor:[UIColor clearColor]];
    postImgViewAudio.contentMode = UIViewContentModeScaleAspectFill;
    postImgViewAudio.layer.cornerRadius = 2;
    postImgViewAudio.clipsToBounds = YES;
    [self addSubview:postImgViewAudio];

    audioPostImgViewCover =
            [[UIButton alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY,
                                                       postImgHeight, postImgHeight)];
    [self addSubview:audioPostImgViewCover];
    [audioPostImgViewCover setImage:[UIImage imageNamed:@"HeadImgCover"]
                           forState:UIControlStateNormal];
    audioPostImgViewCover.hidden = YES;
    [audioPostImgViewCover addTarget:self
                              action:@selector(audioBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];

    audioIcon = [[UIImageView alloc]
            initWithFrame:CGRectMake((postImgHeight - audioIconWith) * 0.5,
                                     (postImgHeight - audioIconWith) * 0.5,
                                     audioIconWith, audioIconWith)];
    audioIcon.image = [UIImage imageNamed:@"audioIcon"];
    [audioPostImgViewCover addSubview:audioIcon];
    audioIcon.userInteractionEnabled = NO;
    audioIcon.hidden = YES;

    audioPostImgViewCover.frame =
            CGRectMake(cellMarginX + (postImgWith - postImgHeight) * 0.5, cellMarginY,
                       postImgHeight, postImgHeight);
    postImgViewAudio.frame =
            CGRectMake(cellMarginX + (postImgWith - postImgHeight) * 0.5, cellMarginY,
                       postImgHeight, postImgHeight);
    postImgViewAudio.layer.cornerRadius = postImgHeight * 0.5;
    audioPostImgViewCover.layer.cornerRadius = postImgHeight * 0.5;

    UIView *v = [[UIView alloc]
            initWithFrame:CGRectMake(0, 0, postImgHeight, postImgHeight)];
    [v setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.3]];
    v.layer.cornerRadius = postImgHeight * 0.5;
    v.userInteractionEnabled = NO;
    [audioPostImgViewCover addSubview:v];
}

- (void)addVideoView {
    postImgViewVideo = [[UIImageView alloc]
            initWithFrame:CGRectMake(cellMarginX, cellMarginY, postImgWith,
                                     postImgHeight)];
    [postImgViewVideo setBackgroundColor:[UIColor clearColor]];
    postImgViewVideo.contentMode = UIViewContentModeScaleAspectFill;
    postImgViewVideo.layer.cornerRadius = 2;
    postImgViewVideo.clipsToBounds = YES;
    [self addSubview:postImgViewVideo];

    videoPostImgViewCover =
            [[UIButton alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY,
                                                       postImgHeight, postImgHeight)];
    [self addSubview:videoPostImgViewCover];
    videoPostImgViewCover.hidden = YES;
    videoPostImgViewCover.clipsToBounds = YES;
    [videoPostImgViewCover addTarget:self
                              action:@selector(videoBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];

    videoIcon = [[UIImageView alloc]
            initWithFrame:CGRectMake((postImgWith - audioIconWith) * 0.5,
                                     (postImgHeight - audioIconWith) * 0.5,
                                     videoIconWith, videoIconWith)];
    videoIcon.image = [UIImage imageNamed:@"videoStopIcon"];
    [videoPostImgViewCover addSubview:videoIcon];
    videoIcon.userInteractionEnabled = NO;
    videoIcon.hidden = YES;

    videoPostImgViewCover.frame =
            CGRectMake(cellMarginX, cellMarginY, postImgWith, postImgHeight);
    videoPostImgViewCover.backgroundColor = [UIColor r:0 g:0 b:0 alpha:0.5];
    postImgViewVideo.frame =
            CGRectMake(cellMarginX, cellMarginY, postImgWith, postImgHeight);
    postImgViewVideo.layer.cornerRadius = 2;
    videoPostImgViewCover.layer.cornerRadius = 2;
}

- (void)addTextView {
    //帖子中的图片缩略图 图文
    postImgViewText = [[UIImageView alloc]
            initWithFrame:CGRectMake(cellMarginX, cellMarginY, postImgWith,
                                     postImgHeight)];
    [postImgViewText setBackgroundColor:[UIColor clearColor]];
    postImgViewText.contentMode = UIViewContentModeScaleAspectFill;
    postImgViewText.layer.cornerRadius = 2;
    postImgViewText.clipsToBounds = YES;
    [self addSubview:postImgViewText];

    photoPostImgViewCover =
            [[UIButton alloc] initWithFrame:CGRectMake(cellMarginX, cellMarginY,
                                                       postImgHeight, postImgHeight)];
    [self addSubview:photoPostImgViewCover];
    photoPostImgViewCover.hidden = YES;
    photoPostImgViewCover.clipsToBounds = YES;
    photoPostImgViewCover.userInteractionEnabled = NO;
    [photoPostImgViewCover addTarget:self
                              action:@selector(photoBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];

    postImgViewText.frame =
            CGRectMake(cellMarginX, cellMarginY, postImgWith, postImgHeight);
    postImgViewText.layer.cornerRadius = 2;
}

- (void)videoBtnClicked:(UIButton *)btn {

    if (self.post.url && self.post.url.length) {

        WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];

        [ctr loadURL:self.post.url];

        CommonViewController *parentCtr =
                [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];

    } else {
        ClubPostPictureViewController *postDetail =
                [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = self.post.articleId;
        postDetail.postType = self.post.type.integerValue;
        postDetail.articleId = self.post.articleId;
        CommonViewController *parentCtr =
                [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:postDetail
                            animation:CommonSwitchAnimationBounce];
    }
}

- (void)audioBtnClicked:(UIButton *)btn {

    if (self.post.url && self.post.url.length) {

        WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];

        [ctr loadURL:self.post.url];

        CommonViewController *parentCtr =
                [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];

    } else {
        ClubPostPictureViewController *postDetail =
                [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = self.post.articleId;
        postDetail.postType = self.post.type.integerValue;
        postDetail.articleId = self.post.articleId;
        CommonViewController *parentCtr =
                [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:postDetail
                            animation:CommonSwitchAnimationBounce];
    }
}

- (void)photoBtnClicked:(UIButton *)btn {
    DLog(@"photoBtnClicked");

    if (self.postImgPath.length && self.postImgPath) {
        MovieStillScrollViewController *ctr =
                [[MovieStillScrollViewController alloc] init];
        ctr.isMovie = NO;
        ctr.index = 0;
        NSArray *photoArr = [NSArray arrayWithObject:self.postImgPath];
        ctr.gallerys = [NSMutableArray arrayWithArray:photoArr];
        CommonViewController *parentCtr =
                [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
}

/**
 *  更新用户信息
 */
- (void)UpLoadData {
    postImgViewVideo.hidden = YES;
    postImgViewAudio.hidden = YES;
    postImgViewText.hidden = YES;

    if (self.post.type.integerValue == 3) { //视频
        postImgViewVideo.hidden = NO;
        postImgViewAudio.hidden = YES;
        postImgViewText.hidden = YES;

        //加载帖子图片缩略图
        [postImgViewVideo loadImageWithURL:self.postImgPath
                                   andSize:ImageSizeTiny
                            imgNameDefault:@"clubPostImage"];
        photoPostImgViewCover.hidden = YES;
        audioPostImgViewCover.hidden = YES;
        videoPostImgViewCover.hidden = NO;
        videoIcon.hidden = NO;
        audioIcon.hidden = YES;
    } else if (self.post.type.integerValue  == 2) { //音乐
        postImgViewVideo.hidden = YES;
        postImgViewAudio.hidden = NO;
        postImgViewText.hidden = YES;

        photoPostImgViewCover.hidden = YES;
        audioPostImgViewCover.hidden = NO;
        videoPostImgViewCover.hidden = YES;
        videoIcon.hidden = YES;
        audioIcon.hidden = NO;
        
        if (self.postImgPath == nil) {
            //如果没有帖子图片，则显示post作者头像
            self.postImgPath = self.post.author.head;
        }

        NSString *url =
                [NSString stringWithFormat:@"typeonepost%@", self.postImgPath];

        UIImage *newImg = [[ImageEngineNew sharedImageEngineNew]
                getImageFromDiskForURL:[url MD5String]
                               andSize:ImageSizeOrign];

        if (newImg) {
            postImgViewAudio.image = newImg;
        } else {
            NSThread *myThread = [[NSThread alloc] initWithTarget:self
                                                         selector:@selector(newImage)
                                                           object:nil];
            [myThread start];
        }
    } else if (self.post.type.integerValue  == 1 || self.post.type.integerValue  == 4) { //图片
        postImgViewVideo.hidden = YES;
        postImgViewAudio.hidden = YES;
        postImgViewText.hidden = NO;

        //加载帖子图片缩略图
        [postImgViewText loadImageWithURL:self.postImgPath
                                  andSize:ImageSizeTiny
                           imgNameDefault:@"clubPostImage"];
        photoPostImgViewCover.hidden = NO;
        audioPostImgViewCover.hidden = YES;
        videoPostImgViewCover.hidden = YES;
        videoIcon.hidden = YES;
        audioIcon.hidden = YES;
    }

    //加载帖子文字内容
    postWordLbl.text = self.postWord;

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };
    NSString *postword = postWordLbl.text;
    if ((postword)) {
        postWordLbl.attributedText =
                [[NSAttributedString alloc] initWithString:postword
                                                attributes:attributes];
    }
}

- (void)newImage {
    //设置背景图片
    NSURL *postImageUrl = [NSURL URLWithString:self.postImgPath];
    NSData *data = [NSData dataWithContentsOfURL:postImageUrl];
    UIImage *img = [UIImage imageWithData:data];
    CGSize finalSize = CGSizeMake(postImgHeight, postImgHeight);
    UIImage *newImg = [KKZUtility resibleImage:img toSize:finalSize];
    UIImage *blureImg = [self blureImage:newImg withInputRadius:1.0f];
    postImgViewAudio.image = blureImg;

    NSString *url =
            [NSString stringWithFormat:@"typeonepost%@", self.postImgPath];
    [[ImageEngineNew sharedImageEngineNew] saveImage:blureImg
                                              forURL:[url MD5String]
                                             andSize:ImageSizeOrign
                                                sync:NO
                                           fromCache:YES];

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        postImgViewAudio.image = blureImg;
    });
}

- (UIImage *)blureImage:(UIImage *)originImage
        withInputRadius:(CGFloat)inputRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = originImage.CGImage;
    CIImage *image = [CIImage imageWithCGImage:cgImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGSize finalSize = CGSizeMake(postImgHeight, postImgHeight);

    CGFloat width = finalSize.width;
    CGFloat height = finalSize.height;

    CGImageRef outImage =
            [context createCGImage:result
                          fromRect:CGRectMake(0, 0, width, height)];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

@end
