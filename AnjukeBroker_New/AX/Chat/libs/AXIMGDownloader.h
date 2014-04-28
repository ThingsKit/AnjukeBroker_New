//
//  AXIMGDownloader.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXNetWorkResponse.h"

@interface AXIMGDownloader : NSObject
@property (nonatomic, strong) void(^resultBlock)(RTNetworkResponse *);
- (void)cancellRequest;
- (void)dowloadIMGWithURL:(NSURL *)url resultBlock:(void(^)(RTNetworkResponse *))resultBlock;
@end
