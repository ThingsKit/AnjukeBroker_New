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
    AXMessageTypePublicCard2 = 7, // 服务号消息2号类型
    AXMessageTypePublicCard3 = 8, // 服务号消息3号类型
    AXMessageTypeJinpuProperty = 9, // 金铺卡片
    
    AXMessageTypeSystemTime = 100, // 时间
    AXMessageTypeSystemForbid = 101, // 提示拒绝加好友
    AXMessageTypeSettingNotifycation = 102, // 提示打开推送
    AXMessageTypeAddNuckName = 103, // 用户添加备注
    AXMessageTypeAddNote = 104, // 经纪人添加备注
    AXMessageTypeSendProperty = 105, // 提示发送房源
    AXMessageTypeSafeMessage = 106, // 安全提示
    AXMessageTypeVersion = 107, //对方使用的版本太低
    
    AXMessageTypeUIBlank = 10000 // UI效果 空一行白行 PS：只是本地使用 不会进行网络发送
};
#define MIN_MESSAGE_TYPE 1
#define MAX_MESSAGE_TYPE 9
#define MIN_SYSTEM_MESSAGE_TYPE 100
#define MAX_SYSTEM_MESSAGE_TYPE 107

typedef NS_ENUM(NSUInteger, AXMessagePropertySourceType)
{
    AXMessagePropertySourceErShouFang = 1, // 二手房
    AXMessagePropertySourceZuFang = 2, // 租房经纪人
    AXMessagePropertySourceCommunity = 3,
    
    AXMessagePropertySourceXinFang = 4, // 新房
    AXMessagePropertySourceXinPan = 5,  // 新盘
    AXMessagePropertySourceTuanGou = 6,  // 团购
    AXMessagePropertySourceArticle = 7,  // 文章
    
    AXMessagePropertySourceShopRent = 8, //商铺出租
    AXMessagePropertySourceShopBuy = 9, //商铺出售
    AXMessagePropertySourceOfficeRent = 10, //写字楼出租
    AXMessagePropertySourceOfficeBuy = 11, //写字楼出售
    AXMessagePropertySourceZuFangGeRen = 12 // 租房个人
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
@property (nonatomic, assign) NSInteger orderNumber;

@end
