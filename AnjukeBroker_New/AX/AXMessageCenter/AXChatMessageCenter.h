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

static NSString * const kAXMessageCenterLinkParamHost = @"push10.anjuke.com";
static NSString * const kAXMessageCenterLinkParamPort = @"443";
static NSString * const kAXMessageCenterLinkAppName = @"i-ajk";

//Notification
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
    AIFMessageCenterStatusDisconnected = 1,
    AIFMessageCenterStatusConnecting = 2,
    AIFMessageCenterStatusConnected = 3,
    AIFMessageCenterStatusUserLoginOut = 4
};


typedef NS_ENUM(NSUInteger,AXMessageCenterHttpRequestType )
{
    AXMessageCenterHttpRequestTypeQRCode,
    AXMessageCenterHttpRequestTypeDeleteFriend,
    AXMessageCenterHttpRequestTypeUploadImage,
    AXMessageCenterHttpRequestTypeDownLoadImage,
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

typedef NS_ENUM(NSUInteger, AXMessageCenterLinkStatus)
{
    AXMessageCenterLinkStatusWillLinkAsDevice,
    AXMessageCenterLinkStatusWillCloseDevice,
    AXMessageCenterLinkStatusLinkedAsDevice,
    AXMessageCenterLinkStatusWillLinkAsUser,
    AXMessageCenterLinkStatusWillCloseUser,
    AXMessageCenterLinkStatusLinkedAsUser,
    AXMessageCenterLinkStatusNoLink
};

@class AXChatMessageCenter;

@interface AXChatMessageCenter : NSObject<ASIHTTPRequestDelegate>
+ (instancetype)defaultMessageCenter;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic) AXMessageCenterLinkStatus linkStatus;

- (void)cancelAllRequest;
- (void)closeKeepAlivingConnect;
- (void)breakLink; //just for broker the method !!!!
//- (void)buildLongLinkWithUserId:(NSString *)uid;
- (void)connect;

- (void)userLoginOut;

- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void(^)(AXMappedPerson *brokerInfo))searchBrokerBlock;
- (void)removeFriendBydeleteUid:(NSArray *)deleteUid compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock;

- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void (^)(BOOL))updateUserInfo;

//send message to friend
- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;

//send message to publice service
- (void)sendMessageToPublic:(AXMappedMessage *)message willSendMessage:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)reSendMessageToPublic:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;

- (NSInteger)totalUnreadMessageCount;

- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;

- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void(^)(BOOL isSuccess))addFriendBlock;
- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void(^)(AXMappedPerson *broker))addFriendByQRCompeletionBlock;
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void(^)(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend))fetchedChatList;

- (void)friendListWithPersonWithCompeletionBlock:(void(^)(NSArray *friendList,BOOL whetherSuccess))friendListBlock;
- (NSFetchedResultsController *)conversationListFetchedResultController;

- (void)updatePerson:(AXMappedPerson *)person;
- (AXMappedPerson *)fetchCurrentPerson;
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;

- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem;


- (void)getFriendInfoWithFriendUid:(NSArray *)personUids compeletionBlock:(void(^)(NSArray *person))getFriendInfoBlock;
- (void)getFriendInfoWithFriendUid:(NSArray *)personUids;
- (void)getServiceInfoByServiceID:(NSString *)serviceId;

- (void)getUserOldMessageWithFriendUid:(NSString *)friendUid TopMinMsgId:(NSString *)TopMinMsgId messageIdArray:(NSArray *)messageIdArray compeletionBlock:(void(^)(NSArray *messageArray))getUserOldMessageBlock;

- (void)didLeaveChattingList;
- (NSFetchedResultsController *)friendListFetchedResultController;
- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid;
- (void)updateMessage:(AXMappedMessage *)message;

- (BOOL)isFriendWithFriendUid:(NSString *)friendUid;
- (void)chatListWillAppearWithFriendUid:(NSString *)friendUid;
@end
