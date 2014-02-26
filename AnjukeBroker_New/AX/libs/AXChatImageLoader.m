//
//  ImageCenter.m
//  WolfTeeth
//
//  Created by luochenhao on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AXChatImageLoader.h"
#import "ASIDownloadCache.h"

static AXChatImageLoader *shareCenter;

@implementation AXChatImageLoader

@synthesize imageQueue = _imageQueue;

- (id)init
{
    self = [super init];
    if (self) {
        _imageQueue = [[ASINetworkQueue alloc] init];
        [self setDelegate:self];
        [_imageQueue go];
    }
    return self;
}

#pragma mark self method

+ (id)shareCenter
{
    @synchronized(self) {
        if (shareCenter == nil) {
            shareCenter = [[AXChatImageLoader alloc] init];
        }
    }
    return shareCenter;
}

- (void)setDelegate:(id<AXChatImageCenterDelegate>)delegate
{
    [self.imageQueue setDelegate:delegate];
    if ([delegate respondsToSelector:@selector(imageLoadFinish:)]) {
        self.imageQueue.requestDidFinishSelector = @selector(imageLoadFinish:);
    }
    if ([delegate respondsToSelector:@selector(imageLoadFail:)]) {
        self.imageQueue.requestDidFailSelector = @selector(imageLoadFail:);
    }
}

- (void)addImageRequestWithRequest:(ASIHTTPRequest *)request
{
    ;
}

- (void)autoLoadImageWithURL:(NSURL *)imageURL toImageView:(UIImageView *)imageView
{
    if ([[imageURL absoluteString] length] < 1) { //空字符串url
        return;
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    NSString *downloadPath = [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request];
    
    [request setDownloadDestinationPath:downloadPath];
    [request setSecondsToCache:60*60*24*3];
    NSDictionary *params = @{@"imageView": imageView};
    [request setUserInfo:params];
    [_imageQueue addOperation:request];
}

- (UIImage *)getImageIfExisted:(NSURL *)imageURL
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:imageURL];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    NSString *downloadPath = [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request];
    UIImage *urlImage = [UIImage imageWithContentsOfFile:downloadPath];
    
    if (urlImage) {
        return urlImage;
    } else {
        return nil;
    }
}

- (void)startQueue
{
    [_imageQueue setSuspended:NO];
}

- (void)stopQueue
{
    [_imageQueue cancelAllOperations];
    [_imageQueue setSuspended:YES];
}

- (void)canelAllRequest
{
    [_imageQueue cancelAllOperations];
}

#pragma mark ImageCenterDelegate

- (void)imageLoadFinish:(ASIHTTPRequest *)request
{
    UIImageView *imageView = (request.userInfo)[IMAGE_VIEW];
    UIImage *image = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
    if (image.size.width > 0 && image.size.height > 0) { //实际情况，图片服务器不一定正常
        [imageView setImage:image];
    }
}

- (void)imageLoadFail:(ASIHTTPRequest *)request
{
    
}

@end
