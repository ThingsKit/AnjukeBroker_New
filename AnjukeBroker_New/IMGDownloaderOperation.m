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
//                  @"http://www.aidatu.com/wp-content/uploads/2014/05/20131230155017907-500x590.jpg"];
    self.networkRequest = [ASIHTTPRequest requestWithURL:url];
    self.networkRequest.tag = _lastRequestID;
//    self.networkRequest.requestID = _lastRequestID;
    NSString *downloadPath = self.filePath;
//    @"/Users/jianzhongliu/Library/Application Support/iPhone Simulator/7.1/Applications/DF075D6E-3FDB-4C5C-9C70-1DD8D4D3597A/Library/asi.jpg";
    //当request完成时，整个文件会被移动到这里
    [self.networkRequest setDownloadDestinationPath:downloadPath];
    //这个文件已经被下载了一部分
    [self.networkRequest setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@.download", self.filePath]];
//     @"/Users/jianzhongliu/Library/Application Support/iPhone Simulator/7.1/Applications/DF075D6E-3FDB-4C5C-9C70-1DD8D4D3597A/Library/asi.jpg.download"];
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
