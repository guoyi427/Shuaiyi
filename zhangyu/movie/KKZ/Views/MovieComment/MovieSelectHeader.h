/*页面的选择评论类型*/
typedef enum : NSUInteger {
    chooseTypeImageAndWord,
    chooseTypeAudio,
} chooseType;

/*页面的所有按钮的tag值*/
typedef enum : NSUInteger {
    kkzBackButtonTag = 1000,
    imageAndWordButtonTag,
    audioButtonTag,
    clickAudioButton,
    clickTakePicButton,
    switchCameraButton,
    submitButtonTag,
    MovieCommentCloseButtonTag,
    redCenterViewTag,
    chooseAlbumButtonTag,
    againVideoButtonTag,
    againRecordButtonTag,
    flashAutoButtonTag,
    flashOnButtonTag,
    flashOffButtonTag,
    flashChooseButtonTag,
    flashSwitchButtonTag,
} allButtonTag;

typedef enum : NSUInteger {
    videoRotate90,
    videoRotate180,
    videoRotate270,
    videoRotate0
} videoRotateDegress;

/*动画时间*/
#define DURATION 0.7f

/*定义视频的存储路径*/
#define outputFilePath [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"]

/*定义音频的存储路径*/
#define audioOutputPath [NSTemporaryDirectory() stringByAppendingString:@"myAudio"]
#define audioTemporarySavePath NSTemporaryDirectory()

/*评论成功页面点击完成按钮通知*/
static NSString *movieCommentSuccessCompleteNotification = @"movieCommentSuccessCompleteNotification";

/*图片截取视图点击选择按钮的通知*/
static NSString *cameraEditorChooseButtonNotification = @"cameraEditorChooseButtonNotification";




