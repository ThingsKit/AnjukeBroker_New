//
//  AJKChatMessageCenter.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-17.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "AXMappedMessage.h"
#import "AXMappedPerson.h"
#import "AXMappedConversationListItem.h"

static NSString * const kAXMessageCenterLinkParamHost = @"192.168.1.57";
static NSString * const kAXMessageCenterLinkParamPort = @"8080";
static NSString * const kAXMessageCenterLinkAppName = @"i-ajk";

//Notification
static NSString * const MessageCenterDidReceiveLastUpdataFriendList = @"MessageCenterDidReceiveFriendList";
static NSString * const MessageCenterDidReceiveLastUpdataMyInformation = @"MessageCenterDidReceiveLastUpdataMyInformation";
static NSString * const MessageCenterDidReceiveLastUpdataFriendInformation = @"MessageCenterDidReceiveLastUpdataFriendInformation";
static NSString * const MessageCenterDidInitedDataCenter = @"MessageCenterDidInitedDataCenter";

static NSString * const MessageCenterDidReceiveNewMessage = @"MessageCenterDidReceiveNewMessage";
//static NSString * const MessageCenterDidReceiveNewFriendList = @"MessageCenterDidReceiveNewFriendList";

typedef NS_ENUM (NSUInteger, AXMessageCenterStatus)
{
    AIFMessageCenterStatusDisconnected,
    AIFMessageCenterStatusConnecting,
    AIFMessageCenterStatusConnected
};


typedef NS_ENUM(NSUInteger,AXMessageCenterHttpRequestType )
{
    AXMessageCenterHttpRequestTypeQRCode,
    AXMessageCenterHttpRequestTypeDeleteFriend,
    AXMessageCenterHttpRequestTypeUploadImage
};

typedef NS_ENUM(NSUInteger, AXMessageCenterApiRequestType)
{
    AXMessageCenterApiRequestTypeJson,
    AXMessageCenterApiRequestTypeImage
};

@class AXChatMessageCenter;

@interface AXChatMessageCenter : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
+ (instancetype)defaultMessageCenter;
@property (nonatomic, strong) NSDictionary *userInfo;

- (void)cancelAllRequest;
- (void)closeKeepAlivingConnect;

- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void(^)(AXMappedPerson *brokerInfo))searchBrokerBlock;
- (void)fetchedPersonWithUID:(NSString *)uid withBlock:(void(^)(AXMappedPerson *person))personInfoBlock;
- (void)removeFriendWithMyPhone:(NSString *)phone deleteUid:(NSArray *)deleteUid compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock;

- (void)updataUserPassword:(NSString *)newPassWord compeletionBlock:(void(^)(BOOL isSuccess))updatePWDBlock;
- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void(^)(BOOL isSuccess))updateUserInfo;

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock;
- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus))sendMessageBlock;

- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;

- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void(^)(BOOL isSuccess))addFriendBlock;
- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void(^)(BOOL whetherSuccess))addFriendCompeletionBlock;
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void(^)(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend))fetchedChatList;

- (void)friendListWithPersonWithCompeletionBlock:(void(^)(NSArray *friendList,BOOL whetherSuccess))friendListBlock;
- (NSFetchedResultsController *)conversationListFetchedResultController;

- (void)updatePerson:(AXMappedPerson *)person;
- (AXMappedPerson *)fetchCurrentPerson;
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;

#warning Test
- (void)receiveMessage;

@end
