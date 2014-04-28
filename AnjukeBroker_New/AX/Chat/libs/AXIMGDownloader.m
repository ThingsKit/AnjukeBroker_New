//
//  AXIMGDownloader.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "AXIMGDownloader.h"

@implementation AXIMGDownloader

- (void)cancellRequest {
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}
- (void)dealloc {
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}
- (void)dowloadIMGWithURL:(NSURL *)url resultBlock:(void(^)(RTNetworkResponse *))resultBlock{
    self.resultBlock = resultBlock;
    int requestId = [[RTRequestProxy sharedInstance] fetchImage:url target:self action:@selector(resultForDownloadIMG:)];
    RTNetworkResponse *response = [[RTNetworkResponse alloc] init];
    response.requestID = requestId;
    response.status = 1;//willDownloadIMG
    self.resultBlock(response);
}

- (void)resultForDownloadIMG:(RTNetworkResponse *)response {
    response.status = 2;//didDownloadIMG
    self.resultBlock(response);
}

@end
