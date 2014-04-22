//
//  AXDownLoadRequestResponse.h
//  Anjuke2
//
//  Created by 杨 志豪 on 4/3/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, AXDownLoadRequestResponseStatus)
{
    AXDownLoadRequestResponseStatusSuccessful,
    AXDownLoadRequestResponseStatusFailed,
    AXDownLoadRequestResponseStatusJsonError
};

typedef NS_ENUM(NSUInteger, AJKDownLoadModuleDownLoadType)
{
    AJKDownLoadModuleDownLoadTypeNSData = 1,
    AJKDownLoadModuleDownLoadTypeImage = 2,
    AJKDownLoadModuleDownLoadTypeVoice = 3,
    AJKDownLoadModuleUpLoadTypeNSData = 4,
    AJKDownLoadModuleUpLoadTypeImage = 5,
    AJKDownLoadModuleUpLoadTypeVoice = 6
};

@interface AXDownLoadRequestResponse : NSObject
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSString *identify;
@property (nonatomic) AJKDownLoadModuleDownLoadType type;
@property (nonatomic) AXDownLoadRequestResponseStatus status;
@end
