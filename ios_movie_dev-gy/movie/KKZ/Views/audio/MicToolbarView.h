//
//  MicToolbarView.h
//  KoMovie
//
//  Created by zhoukai on 12/18/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordCommentView.h"
#import "Comment.h"

@protocol MicToolBarViewDelegate <NSObject>

@optional
-(void)beforeRecord;
//-(void)afterRecord;
//-(void)cancelRecord;

-(void)uploadCommentFinished:(NSDictionary *)userInfo status:(BOOL)succeeded;

@end

@interface MicToolbarView : UIView <RecordCommentViewDelegate,UITextViewDelegate>

@property (nonatomic, weak) id <MicToolBarViewDelegate> delegate;

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic,strong) UIView *parentView;

//评论相关
@property (nonatomic,assign)int movieId;
@property (nonatomic,strong)NSString *referId;

//私信相关
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,assign)CommentType type;

@property (nonatomic,assign)BOOL isMessage; //是评论还是私信


-(void)hideKeyboard;

@end
