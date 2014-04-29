//
//  IMGDowloaderManager.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 4/28/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMGDownloaderOperation.h"
#import "BrokerResponder.h"

@interface IMGDowloaderManager : NSObject <IMGDownloaderOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, copy) void(^successBlock)(BrokerResponder *);
@property (nonatomic, copy) void(^faildBlock)(BrokerResponder *);

- (void)cancelAllRequest;
- (void)dowloadIMGWithImgURL:(NSString *)url identify:(NSString *) identify successBlock:(void(^)(BrokerResponder *))successBlock fialedBlock:(void(^)(BrokerResponder *))failedBlock;

@end
