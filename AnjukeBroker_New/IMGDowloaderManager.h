//
//  IMGDowloaderManager.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMGDownloaderOperation.h"

@interface IMGDowloaderManager : NSObject <IMGDownloaderOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, copy) void(^successBlock)(NSString *);
@property (nonatomic, copy) void(^faildBlock)(NSString *);

- (void)cancelAllRequest;
- (void)dowloadIMGWithImgURL:(NSURL *)url successBlock:(void(^)(NSString *))successBlock fialedBlock:(void(^)(NSString *))failedBlock;

@end
