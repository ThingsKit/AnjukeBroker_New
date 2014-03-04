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
static NSString * const MessageCenterUserDidQuit = @"MessageCenterUserDidQuit";

//connection status notication object will include AXMessageCenterStatus by NSNumber in userinfo key is @"status"
static NSString * const MessageCenterConnectionStatusNotication = @"MessageCenterConnectionStatusNotication";

static NSString * const MessageCenterDidReceiveNewMessage = @"MessageCenterDidReceiveNewMessage";
//static NSString * const MessageCenterDidReceiveNewFriendList = @"MessageCenterDidReceiveNewFriendList";

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

typedef NS_ENUM(NSUInteger, AXMessageCenterApiRequestType)
{
    AXMessageCenterApiRequestTypeJson,
    AXMessageCenterApiRequestTypeImage
};

@class AXChatMessageCenter;

@interface AXChatMessageCenter : NSObject<ASIHTTPRequestDelegate>
+ (instancetype)defaultMessageCenter;
@property (nonatomic, strong) NSDictionary *userInfo;

- (void)cancelAllRequest;
- (void)closeKeepAlivingConnect;
- (void)userLoginOut; //just for broker the method !!!!


- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void(^)(AXMappedPerson *brokerInfo))searchBrokerBlock;
- (void)removeFriendBydeleteUid:(NSArray *)deleteUid compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock;

- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void (^)(BOOL))updateUserInfo;

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock;
- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus))sendMessageBlock;
- (NSInteger)totalUnreadMessageCount;

- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;

- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void(^)(BOOL isSuccess))addFriendBlock;
- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void(^)(AXMappedPerson *broker))addFriendByQRCompeletionBlock;
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void(^)(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend))fetchedChatList;

- (void)friendListWithPersonWithCompeletionBlock:(void(^)(NSArray *friendList,BOOL whetherSuccess))friendListBlock;
- (NSFetchedResultsController *)conversationListFetchedResultController;

- (void)updatePerson:(AXMappedPerson *)person;
- (AXMappedPerson *)fetchCurrentPerson;
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;

- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem;


- (void)getFriendInfoWithFriendUid:(NSArray *)personUids compeletionBlock:(void(^)(NSArray *person))getFriendInfoBlock;
- (void)getFriendInfoWithFriendUid:(NSArray *)personUids;

- (void)getUserOldMessageWithFriendUid:(NSString *)friendUid TopMinMsgId:(NSString *)TopMinMsgId messageIdArray:(NSArray *)messageIdArray compeletionBlock:(void(^)(NSArray *messageArray))getUserOldMessageBlock;

- (void)didLeaveChattingList;
- (NSFetchedResultsController *)friendListFetchedResultController;
- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid;
- (void)updateMessage:(AXMappedMessage *)message;
@end
