//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "AXPhotoView.h"
#import "AXPhotoManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AXPhotoBrowser : UIViewController <UIScrollViewDelegate, AXPhotoViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 显示
- (void)show;
@end
