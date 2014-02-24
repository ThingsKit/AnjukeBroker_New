//
//  AJKBaseManager.m
//  Anjuke2
//
//  Created by casa on 13-12-2.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"
#import "Reachability.h"

@interface RTAPIBaseManager ()

@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, strong, readwrite) NSDictionary *fetchedRawData;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) RTAPIManagerErrorType errorType;

@end

@implementation RTAPIBaseManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _isLoading = NO;
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = RTAPIManagerErrorTypeDefault;
        _requestType = RTAPIManagerRequestTypeGet;
    }
    return self;
}

- (void)dealloc
{
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

#pragma mark - self method
- (void)cancelAllRequests
{
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

//判断网络状况
- (BOOL)isReachable
{
    BOOL isReachability = [[Reachability reachabilityForInternetConnection] isReachable];
    if (!isReachability) {
        self.errorType = RTAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (id)fetchDataWithReformer:(id<RTAPIManagerCallbackDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - calling api
- (void)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    [self loadDataWithParams:params];
}

- (void)loadDataWithParams:(NSDictionary *)params
{
    NSDictionary *apiParams = [self reformParams:params];
    self.isLoading = NO;
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            if ([self isReachable]) {
                self.isLoading = YES;
                NSUInteger requestId = 0;
                switch (self.requestType) {
                    case RTAPIManagerRequestTypeGet:
                    {
                        requestId = [[RTRequestProxy sharedInstance] asyncGetWithServiceID:self.serviceType methodName:self.methodName params:apiParams target:self action:@selector(apiCallBack:)];
                    }
                        break;
                    case RTAPIManagerRequestTypePost:
                    {
                        requestId = [[RTRequestProxy sharedInstance] asyncPostWithServiceID:self.serviceType methodName:self.methodName params:apiParams target:self action:@selector(apiCallBack:)];
                    }
                        break;
                    case RTAPIManagerRequestTypeRestGet:
                    {
                        requestId = [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:self.serviceType methodName:self.methodName params:apiParams target:self action:@selector(apiCallBack:)];
                    }
                        break;
                    case RTAPIManagerRequestTypeRestPost:
                    {
                        requestId = [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:self.serviceType methodName:self.methodName params:apiParams target:self action:@selector(apiCallBack:)];
                    }
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:apiParams];
                params[kRTAPIBaseManagerRequestID] = [NSNumber numberWithInteger:requestId];
                
                [self afterCallingAPIWithParams:params];
                
            } else {
                self.isLoading = NO;
                [self failedOnCallingAPI:nil withErrorType:RTAPIManagerErrorTypeNoNetWork];
            }
        } else {
            self.isLoading = NO;
            [self failedOnCallingAPI:nil withErrorType:RTAPIManagerErrorTypeParamsError];
        }
    }
}

#pragma mark - api callbacks
- (void)apiCallBack:(RTNetworkResponse *)response
{
    self.isLoading = NO;
    if (response.status == RTNetworkResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:RTAPIManagerErrorTypeTimeout];
    }
}

- (void)successedOnCallingAPI:(RTNetworkResponse *)response
{
    self.fetchedRawData = [response.content copy];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:RTAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(RTNetworkResponse *)response withErrorType:(RTAPIManagerErrorType)errorType
{
    self.errorType = errorType;
    [self beforePerformFailWithResponse:response];
    [self.delegate managerCallAPIDidFailed:self];
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for override
//用于给继承的类做重载，相当于拦截器。在通知delegate之前再做一些事情。比如翻页相关的api需要控制页数之类的。
- (void)beforePerformSuccessWithResponse:(RTNetworkResponse *)response
{
    self.errorType = RTAPIManagerErrorTypeSuccess;
}

- (void)afterPerformSuccessWithResponse:(RTNetworkResponse *)response
{
}

//用于给继承的类做重载，相当于拦截器。在通知delegate之前再做一些事情。比如翻页相关的api需要控制页数之类的。
- (void)beforePerformFailWithResponse:(RTNetworkResponse *)response
{
}

- (void)afterPerformFailWithResponse:(RTNetworkResponse *)response
{
}

//用于给继承的类做重载，相当于拦截器。在访问API连接之前可以下断点或者做一些其它的事情。
//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    return YES;
}

//用于给继承的类做重载，相当于拦截器。在访问API连接之前可以下断点或者做一些其它的事情。
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
}

//用于给继承的类做重载
- (void)cleanData
{
}

//用于给继承的类做重载，如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return params;
}

@end