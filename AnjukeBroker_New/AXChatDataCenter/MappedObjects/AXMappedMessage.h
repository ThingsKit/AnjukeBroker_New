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
    AXMessageTypeSystemTime = 4, // 时间
    AXMessageTypeSystemForbid = 5, // 提示拒绝加好友
    AXMessageTypeSettingNotifycation = 6, // 提示打开推送
    AXMessageTypeAddNuckName = 7, // 添加备注
    AXMessageTypePublicCard = 8, // 服务号消息
};

typedef NS_ENUM(NSUInteger, AXMessagePropertySourceType)
{
    AXMessagePropertySourceErShouFang, // 二手房
    AXMessagePropertySourceZuFang // 租房
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
@property (nonatomic, strong) NSNumber * isImgDownloaded;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, strong) NSNumber * isRemoved;
@property (nonatomic, strong) NSNumber * messageId;
@property (nonatomic, strong) NSNumber * messageType;
@property (nonatomic, strong) NSNumber * sendStatus;
@property (nonatomic, strong) NSDate * sendTime;
@property (nonatomic, strong) NSString * thumbnailImgPath;
@property (nonatomic, strong) NSString * thumbnailImgUrl;
@property (nonatomic, strong) NSString * to;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
