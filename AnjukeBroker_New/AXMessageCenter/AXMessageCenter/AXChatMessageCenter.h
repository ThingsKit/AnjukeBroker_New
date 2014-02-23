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

static NSString * const kAXMessageCenterLinkParamHost = @"192.168.1.56";
static NSString * const kAXMessageCenterLinkParamPort = @"8080";
static NSString * const kAXMessageCenterLinkAppName = @"anjuke";

//Notification
static NSString * const MessageCenterDidReceiveLastUpdataFriendList = @"MessageCenterDidReceiveFriendList";
static NSString * const MessageCenterDidReceiveLastUpdataMyInformation = @"MessageCenterDidReceiveLastUpdataMyInformation";
static NSString * const MessageCenterDidReceiveLastUpdataFriendInformation = @"MessageCenterDidReceiveLastUpdataFriendInformation";

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
};

typedef NS_ENUM(NSUInteger, AXMessageCenterApiRequestType)
{
    AXMessageCenterApiRequestTypeJson,
    AXMessageCenterApiRequestTypeImage
};

@class AXChatMessageCenter;

@interface AXChatMessageCenter : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
+ (id)defaultMessageCenter;
@property (nonatomic, strong) NSDictionary *userInfo;

- (void)cancelAllRequest;
- (void)closeKeepAlivingConnect;
- (void)fetchedPersonWithUID:(NSString *)uid withBlock:(void(^)(AXMappedPerson *person))personInfoBlock;
- (void)removeFriendWithMyPhone:(NSString *)phone deleteUid:(NSString *)phone2 compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock;
- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void(^)(BOOL isSuccess))addFriendBlock;
- (void)updataUserPassword:(NSString *)newPassWord compeletionBlock:(void(^)(BOOL isSuccess))updatePWDBlock;
- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void(^)(BOOL isSuccess))updateUserInfo;
- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock;
- (void)sendImage:(NSDictionary *)message withCompeletionBlock:(void(^)(AXMappedMessage *message,BOOL whetherSuccess))sendImageBlock;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
//- (NSDictionary *)fetchHistoryMessagefrom:(NSString *)fromUserID to:(NSString *)toUserID;//对话页面的消息分页加载
//- (NSDictionary *)fetchMessageWithParam:(NSDictionary *)param;
//- (NSDictionary *)fetchMessageWithCurrentUsers; //view will appear and call this method
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;
- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void(^)(BOOL whetherSuccess))addFriendCompeletionBlock;
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void(^)(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend))fetchedChatList;

- (void)friendListWithPerson:(AXMappedPerson *)person compeletionBlock:(void(^)(NSArray *friendList,BOOL whetherSuccess))friendListBlock;

- (NSFetchedResultsController *)conversationListFetchedResultController;

#warning Test
- (void)receiveMessage;

@end
