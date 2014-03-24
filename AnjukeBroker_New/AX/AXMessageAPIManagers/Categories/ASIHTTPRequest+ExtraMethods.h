//
//  ASIHTTPRequest+ExtraMethods.h
//  Anjuke2
//
//  Created by casa on 14-3-19.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "AXMessageApiConfiguration.h"

@interface ASIHTTPRequest (ExtraMethods)

@property (nonatomic, assign) BOOL AXLongLink_isLoading;
@property (nonatomic, assign) BOOL AXLongLink_isLinked;
@property (nonatomic, strong) NSString *AXLongLink_userId;
@property (nonatomic, assign) NSInteger AXLongLink_tryCount;

- (NSInteger)waitTimeForRetry;

@end
