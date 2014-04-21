//
//  FaceScrollView.h
//  WeiboDemo1
//
//  Created by leo.zhu on 14-2-8.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

//发送按钮点击
typedef void(^SendButtonClickBlock) (void);

@interface FaceScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, copy) SendButtonClickBlock sendButtonClick;
@property (nonatomic, retain) FaceView* faceView;
@property (nonatomic, strong) UIButton* sendButton;

@end
