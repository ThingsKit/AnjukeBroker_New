//
//  AXMessageApiConfiguration.h
//  Anjuke2
//
//  Created by casa on 14-3-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#ifndef Anjuke2_AXMessageApiConfiguration_h
#define Anjuke2_AXMessageApiConfiguration_h

#import "ASIHttpRequest.h"
#import "ASIHTTPRequest+ExtraMethods.h"
#import "NSString+AppendURLCommonParams.h"

/*  ===== Public Configuration Start ===== */

//static NSString * const kAXConnectManagerLinkParamHost = @"https://dev.aifang.com:8043";
static NSString * const kAXConnectManagerLinkParamHost = @"https://push10.anjuke.com:443";
static NSString * const kAXConnectManagerLinkAppName = @"i-broker2";


/*  ===== Private Configuration Start ===== */

//这些MessageManager相关的常量本来是应该放到LongLinkManager里面的，但是LongLinkManager将来有可能是基于socket去实现。
//为了将来实现新的manager的方便，所以把这些常量提出来放到这个公共配置文件里面来。
//而且有些情况下外界也是需要这些定义的，所以也放到这个公共配置文件来

static NSString * const kAXMessageManagerLongLinkDeviceUserId = @"0";

//建立长连接的时候使用的超时时间
static NSTimeInterval const kAXMessageManagerLongLinkTimeout = 350;
//心跳包间隔时间
static NSTimeInterval const kAXMessageManagerLongLinkHeartBeatingInterval = 300;
//断开连接和心跳包请求的超时时间
static NSTimeInterval const kAXMessageManagerDefaultRequestTimeOutInterval = 20;


typedef NS_ENUM(NSUInteger, AXMessageAPILongLinkSignal)
{
    AXMessageAPILongLinkSignalInited, //连接建立
    AXMessageAPILongLinkSignalBye,
    AXMessageAPILongLinkSignalDuplicateQuit,
    AXMessageAPILongLinkSignalSelfClose,
    AXMessageAPILongLinkSignalTimeOut,
    AXMessageAPILongLinkSignalQuit, //被T出
    AXMessageAPILongLinkSignalHasNewMessage, //有新消息
    AXMessageAPILongLinkSignalHasNewPush
};

typedef NS_ENUM(NSUInteger, AXMessageAPILongLinkUserType)
{
    AXMessageAPILongLinkUserTypeDevice,
    AXMessageAPILongLinkUserTypeUser
};

typedef NS_ENUM(NSUInteger, AXMessageAPILongLinkStatus)
{
    AXMessageAPILongLinkStatusLoading,
    AXMessageAPILongLinkStatusSuccessLinked,
    AXMessageAPILongLinkStatusNoLink
};

#endif
