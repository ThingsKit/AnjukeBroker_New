//
//  FaceImageView.h
//  WeiboDemo1
//
//  Created by leo.zhu on 14-2-1.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FaceClickBlock) (NSString*);

@interface FaceView : UIView

@property (nonatomic, copy) FaceClickBlock faceClickBlock;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSString* selectedItemName;

- (NSArray*)emojis;

@end
