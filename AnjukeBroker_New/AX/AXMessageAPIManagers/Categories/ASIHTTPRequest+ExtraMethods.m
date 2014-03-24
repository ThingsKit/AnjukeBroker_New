//
//  ASIHTTPRequest+ExtraMethods.m
//  Anjuke2
//
//  Created by casa on 14-3-19.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "ASIHTTPRequest+ExtraMethods.h"
#import "RTLogger.h"
#import <objc/runtime.h>

static void *AXRequestIsLinkedKey;
static void *AXRequestIsLoadingKey;
static void *AXRequestUserIDKey;
static void *AXRequestTryCount;

@implementation ASIHTTPRequest (ExtraMethods)

- (void)setAXLongLink_isLinked:(BOOL)AXLongLink_isLinked
{
    objc_setAssociatedObject(self, &AXRequestIsLinkedKey, [NSNumber numberWithBool:AXLongLink_isLinked], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)AXLongLink_isLinked
{
    NSNumber *isLinked = objc_getAssociatedObject(self, &AXRequestIsLinkedKey);
    return [isLinked boolValue];
}

- (void)setAXLongLink_isLoading:(BOOL)AXLongLink_isLoading
{
    objc_setAssociatedObject(self, &AXRequestIsLoadingKey, [NSNumber numberWithBool:AXLongLink_isLoading], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)AXLongLink_isLoading
{
    NSNumber *isLoading = objc_getAssociatedObject(self, &AXRequestIsLoadingKey);
    return [isLoading boolValue];
}

- (void)setAXLongLink_userId:(NSString *)AXLongLink_userId
{
    objc_setAssociatedObject(self, &AXRequestUserIDKey, AXLongLink_userId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)AXLongLink_userId
{
    NSString *userId = objc_getAssociatedObject(self, &AXRequestUserIDKey);
    return userId;
}

- (NSInteger)AXLongLink_tryCount
{
    NSNumber *tryCount = objc_getAssociatedObject(self, &AXRequestTryCount);
    return [tryCount integerValue];
}

- (void)setAXLongLink_tryCount:(NSInteger)AXLongLink_tryCount
{
    objc_setAssociatedObject(self, &AXRequestTryCount, [NSNumber numberWithInteger:AXLongLink_tryCount], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)waitTimeForRetry
{
    NSInteger result = 0;
    if (self.AXLongLink_tryCount && self.AXLongLink_tryCount > 0) {
        result = (NSInteger) pow(2, self.AXLongLink_tryCount % 8 + 1);
        if (result > 30) {
            result = 0;
            self.AXLongLink_tryCount = 0;
        }
    } else {
        self.AXLongLink_tryCount = 0;
    }
    return result;
}

@end
