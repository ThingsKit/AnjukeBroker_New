//
//  AXDownLoadModule.m
//  Anjuke2
//
//  Created by 杨 志豪 on 4/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXDownLoadModule.h"
#import "AXDownLoadRequestElement.h"
#import "ASIFormDataRequest.h"
#import "RTDataService.h"

@interface AXDownLoadModule () <ASIHTTPRequestDelegate>
@property (nonatomic, strong) NSOperationQueue *downLoadQueue;
@property (nonatomic, strong) NSOperation *currentOperation;
@property (nonatomic, strong) NSMutableDictionary *dispatchElemetnDictionary;
@property (nonatomic, strong) void(^compeletionBlock)(AJKDownLoadModuleDownLoadStatus status,id responseData);
@property (nonatomic, strong) NSMutableDictionary *operationDic;
@end

@implementation AXDownLoadModule

+ (instancetype)shareInstance
{
    static AXDownLoadModule *downLoadModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoadModule = [[AXDownLoadModule alloc] init];
    });
    return downLoadModule;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cancleAllRequest
{
    [self.downLoadQueue cancelAllOperations];
    [self.dispatchElemetnDictionary removeAllObjects];
}

- (NSUInteger)currentCountOfOperations
{
    return [self.downLoadQueue operationCount];
}

- (void)cancleOperationWithIdentify:(NSString *)identify
{
    NSOperation *cancleOperation = self.operationDic[identify];
    if (!cancleOperation) {
        return;
    }
    if (![cancleOperation isExecuting]) {
        [cancleOperation cancel];
    }
}
#pragma mark - getters and setters

- (NSOperationQueue *)downLoadQueue
{
    if (!_downLoadQueue) {
        _downLoadQueue = [[NSOperationQueue alloc] init];
        _downLoadQueue.maxConcurrentOperationCount = 1;
    }
    return _downLoadQueue;
}

- (NSMutableDictionary *)dispatchElemetnDictionary
{
    if (!_dispatchElemetnDictionary) {
        _dispatchElemetnDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dispatchElemetnDictionary;
}

- (NSMutableDictionary *)operationDic
{
    if (!_operationDic) {
        _operationDic = [[NSMutableDictionary alloc] init];
    }
    return _operationDic;
}
#pragma mark - DownLoad Method
- (void)downLoadWithHostAddress:(NSString *)api methodName:(NSString *)methodName isCheck:(BOOL)isCheck identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type
{
    [self addRequestElementWithIdentify:identify callBackSEL:callBack target:target];
    NSDictionary *headersAndUrl = [self getRequestHeadersAndRequestUrlWithHostApi:api MethodName:methodName isCheck:isCheck];
    [self downLoadWithUrlString:headersAndUrl[@"requestURL"] headers:headersAndUrl[@"headers"] identify:identify downLoadType:type];
}

- (void)downLoadWithUrlString:(NSURL *)url identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type
{
    [self addRequestElementWithIdentify:identify callBackSEL:callBack target:target];
    [self downLoadWithUrlString:url headers:nil identify:identify downLoadType:type];
}

- (void)downLoadWithUrlString:(NSURL *)url headers:(NSDictionary *)headers identify:(NSString *)identify downLoadType:(AJKDownLoadModuleDownLoadType)type
{
    ASIHTTPRequest *downLoadRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    downLoadRequest.delegate = self;
    downLoadRequest.userInfo = @{@"identify": identify};
    downLoadRequest.tag = type;
    
    if (headers) {
        NSArray *keys = [headers allKeys];
        for (NSString *key in keys) {
            if ([[NSNull null] isEqual:[headers objectForKey:key]] || [@"" isEqualToString:[headers objectForKey:key]])
                continue;
            [downLoadRequest addRequestHeader:key value:[headers objectForKey:key]];
        }

    }
    [self.downLoadQueue addOperation:downLoadRequest];
    self.operationDic[identify] = downLoadRequest;
}

#pragma mark - Upload Method
- (void)upLoadWithHostAddress:(NSString *)api postData:(id)postData methodName:(NSString *)methodName isCheck:(BOOL)isCheck identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type
{
    [self addRequestElementWithIdentify:identify callBackSEL:callBack target:target];
    NSDictionary *headersAndUrl = [self getRequestHeadersAndRequestUrlWithHostApi:api MethodName:methodName isCheck:YES];
    [self upLoadWithUrlString:headersAndUrl[@"requestURL"] postData:postData headers:headersAndUrl[@"headers"] identify:identify upLoadType:type];
}

- (void)upLoadWithUrlString:(NSURL *)url postData:(id)postData identify:(id )identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type
{
    [self addRequestElementWithIdentify:identify callBackSEL:callBack target:target];
    [self upLoadWithUrlString:url postData:postData headers:nil identify:identify upLoadType:type];
}

- (void)upLoadWithUrlString:(NSURL *)url postData:(id)postData headers:(NSDictionary *)headers identify:(NSString *)identify upLoadType:(AJKDownLoadModuleDownLoadType)type
{
    ASIFormDataRequest *downLoadRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    downLoadRequest.delegate = self;
    downLoadRequest.userInfo = @{@"identify": identify};
    downLoadRequest.tag = type;
    [downLoadRequest setRequestMethod:@"POST"];
    if (type == AJKDownLoadModuleUpLoadTypeImage) {
        [downLoadRequest addFile:postData forKey:@"file"];
    }else {
        [downLoadRequest appendPostData:postData];
    }
    if (headers) {
        NSArray *keys = [headers allKeys];
        for (NSString *key in keys) {
            if ([[NSNull null] isEqual:[headers objectForKey:key]] || [@"" isEqualToString:[headers objectForKey:key]])
                continue;
            [downLoadRequest addRequestHeader:key value:[headers objectForKey:key]];
        }
        
    }
    [self.downLoadQueue addOperation:downLoadRequest];
}


#pragma self-method

- (NSDictionary *)getRequestHeadersAndRequestUrlWithHostApi:(NSString *)api MethodName:(NSString *)methodName isCheck:(BOOL)isCheck
{
    RTDataService *service = [[RTDataService alloc] init];
    service.privateKey = kHttpHeadersPrivateKey;
    service.publicKey = kHttpHeadersPublicKey;
    service.appName = kHttpHeadersAppName;
    service.apiVersion = @"";
    service.apiSite = api;
    NSDictionary *commParams = [NSDictionary dictionaryWithDictionary:[service deviceInfoDictREST]];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:commParams];
    [allParams addEntriesFromDictionary:@{}];
    
    NSURL *requestURL = [service buildRESTGetURLWithMethod:methodName params:allParams];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[service commRESTHeaders]];
    if (isCheck) {
        [headers setValue:[service signRESTGetForRequestMethod:methodName commParams:commParams apiParams:@{}] forKey:@"sig"];
    }
    return @{@"headers": headers,@"requestURL":requestURL};
}

- (AXDownLoadRequestElement *)checkRequestElementByIdentify:(NSString *)identify
{
    __block AXDownLoadRequestElement *dictionary = [[AXDownLoadRequestElement alloc] init];
    [self.dispatchElemetnDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]] && [key isEqualToString:identify]) {
            dictionary = self.dispatchElemetnDictionary[key];
        }
 
    }];
    return dictionary;
}
- (void)addRequestElementWithIdentify:(NSString *)identify callBackSEL:(NSString *)callBackSel target:(id)target
{
    AXDownLoadRequestElement *element = [[AXDownLoadRequestElement alloc] init];
    element.callback = callBackSel;
    element.identify = identify;
    element.target = target;
    [self.dispatchElemetnDictionary addEntriesFromDictionary:@{identify: element}];
}

- (AXDownLoadRequestResponse *)successResponseWithIdentify:(NSString *)identify responseData:(NSData *)data requestType:(AJKDownLoadModuleDownLoadType )type
{
    AXDownLoadRequestResponse *response = [[AXDownLoadRequestResponse alloc] init];
    response.status = AXDownLoadRequestResponseStatusSuccessful;
    response.identify = identify;
    response.responseData = data;
    response.type = type;
    
    return response;
}

- (AXDownLoadRequestResponse *)FailedResponseWithIdentify:(NSString *)identify responseData:(NSData *)data requestType:(AJKDownLoadModuleDownLoadType )type
{
    AXDownLoadRequestResponse *response = [[AXDownLoadRequestResponse alloc] init];
    response.status = AXDownLoadRequestResponseStatusFailed;
    response.identify = identify;
    response.responseData = data;
    response.type = type;
    
    return response;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *identify = request.userInfo[@"identify"];
    AXDownLoadRequestElement *element = self.dispatchElemetnDictionary[identify];
    if (element && [request responseData]) {
        [self downLoadSuccessRequest:request withIdentify:element.identify responseData:[request responseData] requestElement:element];
    }else{
        [self downLoadFailedRequest:request withIdentify:element.identify responseData:[request responseData] requestElement:element];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *identify = request.userInfo[@"identify"];
    AXDownLoadRequestElement *element = self.dispatchElemetnDictionary[identify];
    [self downLoadFailedRequest:request withIdentify:element.identify responseData:[request responseData] requestElement:element];
}

- (void)downLoadFailedRequest:(ASIHTTPRequest *)request withIdentify:(NSString *)identify responseData:(NSData *)responseData requestElement:(AXDownLoadRequestElement *)element
{
    NSString *callBack = [element callback];
    SEL callBackSEL = NSSelectorFromString(callBack);
    id target = [element target];
    if (target && [target respondsToSelector:callBackSEL]) {
        [target performSelector:NSSelectorFromString(callBack) withObject:[self FailedResponseWithIdentify:identify responseData:responseData requestType:request.tag] afterDelay:0];
    }
    [self.dispatchElemetnDictionary removeObjectForKey:identify];

}

- (void)downLoadSuccessRequest:(ASIHTTPRequest *)request withIdentify:(NSString *)identify responseData:(NSData *)responseData requestElement:(AXDownLoadRequestElement *)element
{
    NSString *callBack = [element callback];
    SEL callBackSEL = NSSelectorFromString(callBack);
    id target = [element target];
    if (target && [target respondsToSelector:callBackSEL]) {
        [target performSelector:NSSelectorFromString(callBack) withObject:[self successResponseWithIdentify:identify responseData:responseData requestType:request.tag] afterDelay:0];
    }
    [self.dispatchElemetnDictionary removeObjectForKey:identify];

}

@end
