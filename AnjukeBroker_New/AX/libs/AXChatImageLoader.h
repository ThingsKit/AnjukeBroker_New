//
//  ImageCenter.h
//  WolfTeeth
//
//  Created by luochenhao on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#define IMAGE_VIEW @"imageView" //用于提取request.userInfo里的相关imageView的信息

@protocol AXChatImageCenterDelegate <NSObject>

@optional
- (void)imageLoadFinish:(ASIHTTPRequest *)request;
- (void)imageLoadFail:(ASIHTTPRequest *)request;

@end

@interface AXChatImageLoader : NSObject <AXChatImageCenterDelegate>

@property (nonatomic, strong) ASINetworkQueue *imageQueue;

+ (id)shareCenter;

- (void)setDelegate:(id<AXChatImageCenterDelegate>)delegate;

- (void)addImageRequestWithRequest:(ASIHTTPRequest *)request;
- (void)autoLoadImageWithURL:(NSURL *)imageURL toImageView:(UIImageView *)imageView;
- (UIImage *)getImageIfExisted:(NSURL *)imageURL; //返回图片如果已经存在的话

- (void)startQueue;
- (void)stopQueue;

- (void)canelAllRequest;

@end
