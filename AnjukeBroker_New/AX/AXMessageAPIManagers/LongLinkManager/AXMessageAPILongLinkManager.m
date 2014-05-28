//
//  AXMessageAPIBuildLink.m
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessageAPILongLinkManager.h"
#import "AXMessageAPIHeartBeatingManager.h"
#import "AXMessageAPIBreakLinkManager.h"

//test
#import "AppDelegate.h"
#import "DiscoverViewController.h"

@interface AXMessageAPILongLinkManager () <AXMessageAPIHeartBeatingManagerParamSource>

@property (nonatomic, strong) NSMutableArray *linkPool;

@property (nonatomic, copy, readwrite) NSString *currentLoggedUserId;
@property (nonatomic, assign, readwrite) AXMessageAPILongLinkUserType currentUserType;
@property (nonatomic, assign) BOOL shouldKeepLinking;

@property (nonatomic, strong) AXMessageAPIHeartBeatingManager *heartBeatingManager;
@property (nonatomic, strong) AXMessageAPIBreakLinkManager *breakLinkManager;

@end

@implementation AXMessageAPILongLinkManager

#pragma mark - getters and setters
- (NSMutableArray *)linkPool
{
    if (_linkPool == nil) {
        _linkPool = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _linkPool;
}

- (AXMessageAPIHeartBeatingManager *)heartBeatingManager
{
    if (_heartBeatingManager == nil) {
        _heartBeatingManager = [[AXMessageAPIHeartBeatingManager alloc] init];
        _heartBeatingManager.paramSource = self;
    }
    return _heartBeatingManager;
}

- (AXMessageAPIBreakLinkManager *)breakLinkManager
{
    if (_breakLinkManager == nil) {
        _breakLinkManager = [[AXMessageAPIBreakLinkManager alloc] init];
    }
    return _breakLinkManager;
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldKeepLinking = YES;
    }
    return self;
}

#pragma mark - public methods
- (void)connectAsDevice
{
    [self connectAsUserWithUserid:kAXMessageManagerLongLinkDeviceUserId];
}

- (void)connectAsUserWithUserid:(NSString *)userId
{
    self.shouldKeepLinking = YES;
    if ([self shouldBuildLinkWithUserId:userId]) {
        NSString *registerUrlString = [NSString stringWithFormat:@"%@/register/%@/%@/%@/", kAXConnectManagerLinkParamHost, [[UIDevice currentDevice] udid], kAXConnectManagerLinkAppName, userId];
        ASIHTTPRequest *request = [self buildRequestWithURL:[NSURL URLWithString:[registerUrlString appendURLCommonParams]] userId:userId tryCount:0];
        [self.linkPool addObject:request];
        [self.delegate manager:self willConnectToServerAsUserType:[self userTypeWithUserId:userId] userId:userId];
        [request startAsynchronous];
        DLog(@"REGISTER URL IS ====== %@",request.url);
    }
}

- (void)breakLink
{
    self.shouldKeepLinking = NO;
    for (ASIHTTPRequest *request in self.linkPool) {
        if (request.AXLongLink_isLinked) {
            [self.breakLinkManager breakLinkWithUserId:request.AXLongLink_userId];
        } else if (request.AXLongLink_isLoading) {
            request.AXLongLink_isLoading = NO;
            [request cancel];
        }
    }
    [self.heartBeatingManager stopHeartBeat];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    /*
     长链接断了以后实际上就是请求结束。需要根据断掉的原因做不同的处理。

     正常情况：
     1.app主动要求断开
     2.被其他设备踢出
     正常情况下断开之前长链接都会有通知，因此，如果断开之前服务器有通知过，那这里就什么都不做。

     非正常情况
     1.服务器重启
     2.网络在建立链接的时候是好的，但是后来断掉了
     非正常情况需要启动重连机制。

     区分正常情况和非正常情况的方法就是看这个对象的isLinked属性是不是YES
     如果是YES，就表示是意外断开的，属于非正常情况。

     正常情况的断开需要把这个连接从连接池里删除。

     */
    
    request.AXLongLink_isLoading = NO;
    if (request.AXLongLink_isLinked) {
        [self retryBuildLinkWithRequest:request];
    } else {
        [self removeRequestFromLinkPool:request];
    }
    [self.heartBeatingManager stopHeartBeat];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    /*
     这里的连接失败是因为长链接无法建立。
     还有可能是长连接超时断开了（代码追下来发现的，没有经过TIMEOUT的通知。）
     长链接断开的情况是长链接已经建立后来断开了。
     前者的情况会跑到这里，后者的情况则跑到 -(void)requestFinished:(ASIHTTPRequest *)request
     */
    request.AXLongLink_isLoading = NO;
    request.AXLongLink_isLinked = NO;
    
    if (request.isCancelled) {
        [self.linkPool removeObject:request];
    } else {
        [self retryBuildLinkWithRequest:request];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    request.AXLongLink_isLoading = NO;
    request.AXLongLink_isLinked = YES;
    request.AXLongLink_tryCount = 0;
    
    NSString *receivedJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *receivedJSONStringArray = [receivedJsonString componentsSeparatedByString:@"\n"];
    
    for (NSString *lonlLinkCommandString in receivedJSONStringArray) {
        
        // validation
        if ([lonlLinkCommandString length] == 0) {
            continue;
        }
        __autoreleasing NSError *error;
        NSDictionary *receivedCommand = [NSJSONSerialization JSONObjectWithData:[lonlLinkCommandString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        DLog(@"LongLinkRecevedCommand: %@", receivedCommand);
        
        //#############################################################
        
        NSString* type = [[receivedCommand objectForKey:@"result"] objectForKey:@"msgType"];
        if ([@"push" isEqualToString:type]) {
            AppDelegate* delegate = [UIApplication sharedApplication].delegate;
            delegate.propertyUnreadCount++; //房源消息未读数自增

            [delegate.tabController setDiscoverBadgeValueWithValue:[NSString stringWithFormat:@"%d", delegate.propertyUnreadCount]]; //tabbarItem 的badge计数器
            //设置抢房源委托后的badge
            DiscoverViewController* disc = [[DiscoverViewController alloc] init];
            [disc setBadgeValue:delegate.propertyUnreadCount];
            
        }
        
  
        //#############################################################
        
        
        
        // command dispatch
        if ([receivedCommand[@"result"] isKindOfClass:[NSString class]]) {
            [self handleLongLinkStatusWithReceivedCommand:receivedCommand withRequest:request];
        }
        
        if ([receivedCommand[@"result"] isKindOfClass:[NSDictionary class]]) {
            [self handleLongLinkNotificationWithReceivedCommand:receivedCommand withRequest:request];
        }
    }
}

#pragma mark - AXMessageAPIHeartBeatingManagerParamSource
- (NSString *)userIdForHeartBeatingManager:(id)manager
{
    return self.currentLoggedUserId;
}

#pragma mark - private methods
- (void)handleLongLinkStatusWithReceivedCommand:(NSDictionary *)command withRequest:(ASIHTTPRequest *)request
{
    request.AXLongLink_isLoading = NO;
    if ([command[@"result"] isEqualToString:@"INITED"]) {
        DLog(@"INITED");
        request.AXLongLink_isLinked = YES;
        request.AXLongLink_tryCount = 0;
        
        self.currentLoggedUserId = request.AXLongLink_userId;
        self.currentUserType = [self userTypeWithUserId:request.AXLongLink_userId];

        [self.heartBeatingManager startHeartBeat];
        [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalInited userType:self.currentUserType userId:self.currentLoggedUserId userInfo:command];
    }

    if ([command[@"result"] isEqualToString:@"Bye"]) {
        //服务器主动断开连接，宋说这个可以忽略，那就当正常断开什么都不做就好了。
        DLog(@"BYE");
        request.AXLongLink_isLinked = NO;
        if ([self shouldAlertForQuitWithRequest:request]) {
            [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalBye userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
        }
    }

    if ([command[@"result"] isEqualToString:@"DUPLICATE_QUIT"]) {
        //自己把自己T出了，把这个被T出的request扔掉
        DLog(@"DUPLICATE_QUIT");
        request.AXLongLink_isLinked = NO;
        if ([self shouldAlertForQuitWithRequest:request]) {
            [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalDuplicateQuit userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
        }
    }
    
    if ([command[@"result"] isEqualToString:@"SELF_CLOSE"]) {

        //只有在主动发送断开连接的请求的时候才会收到SELF_CLOSE
        //在切换用户的时候是不会发送主动断开连接的请求的
        //因此进入这个函数只有应用切入后台这一种情况，所以不需要再建立连接了。
        
        DLog(@"SELF_CLOSE");
        request.AXLongLink_isLinked = NO;
        self.shouldKeepLinking = NO;
        if ([self shouldAlertForQuitWithRequest:request]) {
            [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalSelfClose userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
        }
    }
    
    if ([command[@"result"] isEqualToString:@"TIMEOUT"]) {
        //服务器很久没有收到ping，此时需要重新连接，作为事故处理，因此isLinked为YES
        DLog(@"TIMEOUT");
        request.AXLongLink_isLinked = YES;
        if ([self shouldAlertForQuitWithRequest:request]) {
            [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalTimeOut userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
        }
    }
    
    if ([command[@"result"] isEqualToString:@"QUIT"]) {
        //被别的用户T出了
        DLog(@"QUIT");
        request.AXLongLink_isLinked = NO;
        if ([self shouldAlertForQuitWithRequest:request]) {
            // 在用户端，这个委托方法会立刻建立基于设备的连接
            // 在经纪人端，这个委托方法应该禁止后面的容错处理函数去建立连接
            [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalQuit userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
        }
    }
}

- (void)handleLongLinkNotificationWithReceivedCommand:(NSDictionary *)command withRequest:(ASIHTTPRequest *)request
{
    request.AXLongLink_isLoading = NO;
    request.AXLongLink_isLinked = YES;
    [self.delegate manager:self didReceiveSignal:AXMessageAPILongLinkSignalHasNewMessage userType:[self userTypeWithUserId:request.AXLongLink_userId] userId:request.AXLongLink_userId userInfo:command];
}

- (AXMessageAPILongLinkUserType)userTypeWithUserId:(NSString *)userId
{
    AXMessageAPILongLinkUserType result;
    if ([userId isEqualToString:kAXMessageManagerLongLinkDeviceUserId]) {
        result = AXMessageAPILongLinkUserTypeDevice;
    } else {
        result = AXMessageAPILongLinkUserTypeUser;
    }
    return result;
}

#pragma mark - private methods - link pool related methods
- (void)retryBuildLinkWithRequest:(ASIHTTPRequest *)request
{
    if (!self.shouldKeepLinking) {
        return;
    }

    ASIHTTPRequest *newRequest = [self buildRequestWithURL:request.url userId:request.AXLongLink_userId tryCount:request.AXLongLink_tryCount + 1];
    newRequest.AXLongLink_isLoading = YES;
    newRequest.AXLongLink_isLinked = NO;
    [self.linkPool removeObject:request];
    [self.linkPool addObject:newRequest];
    DLog(@"LONGLINK RETRY:%@", newRequest.url);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([request waitTimeForRetry] * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [newRequest startSynchronous];
    });
}

- (BOOL)shouldAlertForInitedWithRequest:(ASIHTTPRequest *)request
{
    BOOL result = NO;
    
    if ([self.linkPool count] == 1) {
        result = YES;
    }
    
    return result;
}

- (BOOL)shouldAlertForQuitWithRequest:(ASIHTTPRequest *)request
{
    BOOL result = NO;
    
    if ([self.linkPool count] == 1) {
        result = YES;
    }
    
    if (!result) {
        result = YES;
        for (ASIHTTPRequest *storedRequest in self.linkPool) {
            if (storedRequest == request) {
                continue;
            } else {
                if (storedRequest.AXLongLink_isLoading || storedRequest.AXLongLink_isLinked) {
                    if (storedRequest.AXLongLink_isLinked) {
                        self.currentLoggedUserId = storedRequest.AXLongLink_userId;
                        self.currentUserType = [self userTypeWithUserId:self.currentLoggedUserId];
                    }
                    result = NO;
                }
            }
        }
    }
    
    return result;
}

- (BOOL)shouldBuildLinkWithUserId:(NSString *)userId
{
    //相同的设备ID号建立连接的时候，服务器会自动关闭前面的一个连接。
    //因此本地只需要检查是不是同一个userId发出的连接请求。
    //重复的请求不会建立连接。

    BOOL result = YES;
    for (ASIHTTPRequest *storedRequest in self.linkPool) {
        if ([storedRequest.AXLongLink_userId isEqualToString:userId]) {
            result = NO;
            
            //如果同一个userId的请求不处于连接状态，那就让它连接
            if (!storedRequest.AXLongLink_isLoading && !storedRequest.AXLongLink_isLinked) {
                [self retryBuildLinkWithRequest:storedRequest];
            }
        }
    }
    return result;
}

- (void)removeRequestFromLinkPool:(ASIHTTPRequest *)request
{
    
    if (self.shouldKeepAtLeastOneLink) {
        
        // 如果是用户端，则需要做一系列容错，要保证至少有一个连接
        if ([self.linkPool count] > 1) {
            [self.linkPool removeObject:request];
            [self checkLinkPoolStatus];
        } else {
            // 进入这里的前提条件：isLinked = NO , requestFinished
            // 在这里不能用checkLinkPoolStatus来做容错，会跑到这里只有两个情况：
            // 1.request是第一次发起的
            // 2.当前唯一的一个可用连接，变成不可用了(服务器断电或者重启)
            //因此此处需要进行的是重试操作，checkLinkPoolStatus进行的是重新创建request的操作。
            [self retryBuildLinkWithRequest:request];
        }
    } else {
        
        //如果是经纪人端，则不需要至少保持一个连接。
        [self.linkPool removeObject:request];
    }
}

//这个函数的目的是用来判断当前是否有链接，如果没有连接，就建立，总之就是要保证一定要有一个连接。
- (void)checkLinkPoolStatus
{
    BOOL shouldBuildNewLink = YES;

    for (ASIHTTPRequest *request in self.linkPool) {
        if (request.AXLongLink_isLoading || request.AXLongLink_isLinked) {
            shouldBuildNewLink = NO;
            break;
        }
    }
    
    if (shouldBuildNewLink) {
        [self.linkPool removeAllObjects];
        if (self.shouldKeepLinking) {
            [self connectAsUserWithUserid:self.currentLoggedUserId];
        }
    }
}

//这里传入的urlString必须是已经添加过公共参数的string了。
- (ASIHTTPRequest *)buildRequestWithURL:(NSURL *)url userId:(NSString *)userId tryCount:(NSInteger)tryCount
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.AXLongLink_tryCount = tryCount;
    request.AXLongLink_userId = userId;
    request.validatesSecureCertificate = NO;
    request.delegate = self;
    request.timeOutSeconds = kAXMessageManagerLongLinkTimeout;
    request.AXLongLink_isLoading = YES;
    request.AXLongLink_isLinked = NO;
    return request;
}

@end
