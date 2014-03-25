//
//  AXMappedMessage.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AXMessageType)
{
    AXMessageTypeText = 1, // 文本聊天
    AXMessageTypePic = 2,  // 图片
    AXMessageTypeProperty = 3, // 房子
    AXMessageTypePublicCard = 4, // 服务号消息
    AXMessageTypeVoice = 5, // 语音消息
    AXMessageTypeLocation = 6, // 地理位置
    AXMessageTypeMap  = 7,
    
    
    
    AXMessageTypeSystemTime = 100, // 时间
    AXMessageTypeSystemForbid = 101, // 提示拒绝加好友
    AXMessageTypeSettingNotifycation = 102, // 提示打开推送
    AXMessageTypeAddNuckName = 103, // 用户添加备注
    AXMessageTypeAddNote = 104, // 经纪人添加备注
    AXMessageTypeSendProperty = 105, // 提示发送房源
    AXMessageTypeSafeMessage = 106, // 安全提示
};

typedef NS_ENUM(NSUInteger, AXMessagePropertySourceType)
{
    AXMessagePropertySourceErShouFang = 1, // 二手房
    AXMessagePropertySourceZuFang = 2, // 租房
    AXMessagePropertySourceCommunity = 3,
};

typedef NS_ENUM (NSUInteger, AXMessageCenterSendMessageStatus)
{
    AXMessageCenterSendMessageStatusSending = 1,
    AXMessageCenterSendMessageStatusSuccessful = 2,
    AXMessageCenterSendMessageStatusFailed = 3
};

@interface AXMappedMessage : NSObject

@property (nonatomic, strong) NSString * accountType;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * from;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * imgPath;
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, assign) BOOL isImgDownloaded;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isRemoved;
@property (nonatomic, strong) NSNumber * messageId;
@property (nonatomic, strong) NSNumber * messageType;
@property (nonatomic, strong) NSNumber * sendStatus;
@property (nonatomic, strong) NSDate * sendTime;
@property (nonatomic, strong) NSString * thumbnailImgPath;
@property (nonatomic, strong) NSString * thumbnailImgUrl;
@property (nonatomic, strong) NSString * to;
@property (nonatomic, assign) BOOL isUploaded;

@end
