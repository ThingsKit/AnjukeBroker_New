//
//  AJKChatMessageCenter.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-17.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedMessage.h"
#import "AXMappedPerson.h"
#import "AXMappedConversationListItem.h"

//Notification
static NSString * const kMessageCenterReceiveNewPush = @"kMessageCenterReceiveNewPushMessage";
static NSString * const MessageCenterDidReceiveLastUpdataFriendList = @"MessageCenterDidReceiveFriendList";
static NSString * const MessageCenterDidReceiveLastUpdataMyInformation = @"MessageCenterDidReceiveLastUpdataMyInformation";
static NSString * const MessageCenterDidReceiveLastUpdataFriendInformation = @"MessageCenterDidReceiveLastUpdataFriendInformation";
static NSString * const MessageCenterUserDidQuit = @"MessageCenterUserDidQuit";
static NSString * const MessageCenterUserDidQuitToAllReceiveNotication = @"MessageCenterUserDidQuitToAllReceiveNotication";
static NSString * const MessageCenterDidInitedDataCenter = @"MessageCenterDidInitedDataCenter";

//connection status notication object will include AXMessageCenterStatus by NSNumber in userinfo key is @"status"
static NSString * const MessageCenterConnectionStatusNotication = @"MessageCenterConnectionStatusNotication";
static NSString * const MessageCenterDidReceiveNewMessage = @"MessageCenterDidReceiveNewMessage";
static NSString * const MessageCenterDidUpdataFriendInformationNotication = @"MessageCenterDidUpdataFriendInformationNotication";

typedef NS_ENUM (NSUInteger, AXMessageCenterStatus)
{
    AXMessageCenterStatusDisconnected = 1,
    AXMessageCenterStatusConnecting = 2,
    AXMessageCenterStatusConnected = 3,
    AXMessageCenterStatusUserLoginOut = 4
};

typedef NS_ENUM(NSUInteger,AXMessageCenterHttpRequestType )
{
    AXMessageCenterHttpRequestTypeQRCode,
    AXMessageCenterHttpRequestTypeDeleteFriend,
    AXMessageCenterHttpRequestTypeUploadImage,
    AXMessageCenterHttpRequestTypeDownLoadImage,
    AXMessageCenterHttpRequestTypeUploadVoice,
    AXMessageCenterHttpRequestTypeDownloadVoice
};

typedef NS_ENUM(NSUInteger,AXMessageCenterSendMessageErrorTypeCode)
{
    AXMessageCenterSendMessageErrorTypeCodeNone = 1,
    AXMessageCenterSendMessageErrorTypeCodeFailed = 2,
    AXMessageCenterSendMessageErrorTypeCodeNotFriend = 3
};

typedef NS_ENUM(NSUInteger, AXMessageCenterApiRequestType)
{
    AXMessageCenterApiRequestTypeJson,
    AXMessageCenterApiRequestTypeImage
};

@class AXChatMessageCenter;

@interface AXChatMessageCenter : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;

#pragma mark - life cycle
+ (instancetype)defaultMessageCenter;

#pragma mark - link related
- (void)breakLink;
- (void)connect;

#pragma mark - sending Message
- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (NSDictionary *)sendMessage:(AXMappedMessage *)message sayHello:(BOOL)sayHello willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)sendMessageToPublic:(AXMappedMessage *)message willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)sendImageToPublic:(AXMappedMessage *)message willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)sendVoiceToPublic:(AXMappedMessage *)message willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;


- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)sendVoice:(AXMappedMessage *)message withCompeletionBlock:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;

- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(NSArray *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendMessageToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendVoiceToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendImageToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendImage:(NSString *)identify withCompeletionBlock:(void(^)(NSArray *messageList, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendVoice:(NSString *)identify withCompeletionBlock:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;

#pragma mark - message related methods except sending messages
// fetch messages
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void(^)(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend))fetchedChatList;
- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid;
- (void)getUserOldMessageWithFriendUid:(NSString *)friendUid TopMinMsgId:(NSString *)TopMinMsgId messageIdArray:(NSArray *)messageIdArray compeletionBlock:(void(^)(NSArray *messageArray))getUserOldMessageBlock;

// message related operation
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (void)updateMessage:(AXMappedMessage *)message;
- (void)updateMessageWithIdentifier:(NSString *)identifier keyValues:(NSDictionary *)keyValues;
- (NSInteger)totalUnreadMessageCount;

// UI life cycle
- (void)didLeaveChattingListWithFriendUID:(NSString *)friendUID;
- (void)chatListWillAppearWithFriendUid:(NSString *)friendUid;

#pragma mark - friend list related methods
- (void)friendListWithPersonWithCompeletionBlock:(void(^)(NSArray *friendList,BOOL whetherSuccess))friendListBlock;
- (NSFetchedResultsController *)friendListFetchedResultController;

#pragma mark - conversation list item related methods
- (NSFetchedResultsController *)conversationListFetchedResultController;
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;
- (void)deleteConversationItem:(AXConversationListItem *)conversationItem;

#pragma mark - person related methods
// fetch person
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;
- (AXMappedPerson *)fetchCurrentPerson;

// fetch person info
- (void)getFriendInfoWithFriendUid:(NSArray *)personUids compeletionBlock:(void(^)(NSArray *person))getFriendInfoBlock;
- (void)getFriendInfoWithFriendUid:(NSArray *)personUids;
- (void)getServiceInfoByServiceID:(NSString *)serviceId;

// update person info
- (void)updatePerson:(AXMappedPerson *)person;
- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void (^)(BOOL))updateUserInfo;

// add firend
- (void)addFriendWithStangerPerson:(NSString *)deviceID;

- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void(^)(BOOL isSuccess))addFriendBlock;
- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void(^)(AXMappedPerson *broker))addFriendByQRCompeletionBlock;
- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void(^)(AXMappedPerson *brokerInfo,BOOL success))searchBrokerBlock;

- (void)removeFriendBydeleteUid:(NSArray *)deleteUid compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock;
- (BOOL)isFriendWithFriendUid:(NSString *)friendUid;

//publicMenuApiEvent 事件请求
- (void)publicServiceSendActionByServiceId:(NSString *)serviceID actionID:(NSString *)actionID cityID:(NSString *)cityID userID:(NSString *)userID;

@end
