//
//  IMGDownloaderOperation.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "IMGDownloaderOperation.h"

#define RT_MIN_REQUESTID 1
#define RT_MAX_REQUESTID UINT_MAX 

@implementation IMGDownloaderOperation

- (id)init
{
    self = [super init];
    if (self) {
        self.cancelLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)start
{
    [self.cancelLock lock];
    if (![self isCancelled]) {
        [self main];
    }
    [self.cancelLock unlock];
}

- (void)main
{
    if (++_lastRequestID >= RT_MAX_REQUESTID)
        _lastRequestID = RT_MIN_REQUESTID;
    
    NSURL *url = [NSURL URLWithString:self.requestString];
    self.networkRequest = [ASIHTTPRequest requestWithURL:url];
    //当request完成时，整个文件会被移动到这里
    [self.networkRequest setDownloadDestinationPath:self.filePath];
    //这个文件已经被下载了一部分
    [self.networkRequest setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@.download", self.filePath]];
    [self.networkRequest setAllowResumeForFileDownloads:YES];//yes表示支持断点续传
    self.networkRequest.delegate = self;
    [self.networkRequest startAsynchronous];
    
}

- (void)cancel
{
    [self.cancelLock lock];
    [self.networkRequest cancel];
    [self.cancelLock unlock];
    [super cancel];
}

#pragma mark -- ASIHttpRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request{
    self.lastRequestID = [request.requestID intValue];
    if ([_delegate respondsToSelector:(@selector(requestStarted:))]) {
        [_delegate performSelector:@selector(requestStarted:)withObject:request];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{

}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([_delegate respondsToSelector:(@selector(requestFinished:))]) {
        [_delegate performSelector:@selector(requestFinished:)withObject:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    if ([_delegate respondsToSelector:(@selector(requestFailed:))]) {
        [_delegate performSelector:@selector(requestFailed:)withObject:request];
    }
}

- (void)requestRedirected:(ASIHTTPRequest *)request{
    
}

@end
