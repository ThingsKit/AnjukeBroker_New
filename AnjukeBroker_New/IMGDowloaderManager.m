//
//  IMGDowloaderManager.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "IMGDowloaderManager.h"

@implementation IMGDowloaderManager

- (NSOperationQueue *)requestQueue {
    if (_requestQueue == nil) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 5;
    }
    return _requestQueue;
}

- (void)dealloc {
    if (self.requestQueue) {
        [self.requestQueue cancelAllOperations];
        self.requestQueue = nil;
    }
}

- (void)cancelAllRequest {
    if (self.requestQueue) {
        [self.requestQueue cancelAllOperations];
        self.requestQueue = nil;
    }
}

- (void)dowloadIMGWithImgURL:(NSString *)url successBlock:(void(^)(NSString *))successBlock fialedBlock:(void(^)(NSString *))failedBlock{
    self.successBlock = successBlock;
    self.faildBlock = failedBlock;
    IMGDownloaderOperation *requestOperation = [[IMGDownloaderOperation alloc] init];
    requestOperation.requestString = url;
    requestOperation.delegate = self;
    requestOperation.filePath = [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempImgForder"] stringByAppendingPathExtension:[[url componentsSeparatedByString:@"/"] lastObject]];
    [self.requestQueue addOperation:requestOperation];
}

- (void)requestStarted:(ASIHTTPRequest *)request {
    

}

- (void)requestFinished:(ASIHTTPRequest *)request {

}

-(void)requestFailed:(ASIHTTPRequest *)request {

}

@end
