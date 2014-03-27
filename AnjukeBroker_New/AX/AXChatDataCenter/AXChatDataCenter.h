//
//  XChatDataCenter.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// mapped objects
#import "AXMappedConversationListItem.h"
#import "AXMappedMessage.h"
#import "AXMappedPerson.h"


@class AXChatDataCenter;

@protocol AXChatDataCenterDelegate <NSObject>

- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSDictionary *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message;
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchFriendList:(NSArray *)chatList;
- (void)dataCenter:(AXChatDataCenter *)dataCenter didReceiveMessages:(NSDictionary *)messages;

- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPersonInfoWithUid:(NSArray *)uid;
- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPublicInfoWithUid:(NSArray *)uid;

@end

@interface AXChatDataCenter : NSObject

@property (nonatomic, weak) id<AXChatDataCenterDelegate> delegate;
@property (nonatomic, copy) NSString *uid;

// life cycle
- (instancetype)initWithUID:(NSString *)uid;
- (void)switchToUID:(NSString *)uid;

// message && message record list
- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;
- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid;
- (void)chatListWillAppearWithFriendUid:(NSString *)friendUid;

// message life cycle
- (NSArray *)willSendMessage:(AXMappedMessage *)message;
- (AXMappedMessage *)didSuccessSendMessageWithIdentifier:(NSString *)identifier messageId:(NSString *)messageId;
- (AXMappedMessage *)didFailSendMessageWithIdentifier:(NSString *)identifier;
- (void)didReceiveWithMessageDataArray:(NSArray *)receivedArray;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (void)updateMessage:(AXMappedMessage *)message;
- (void)updateMessageWithIdentifier:(NSString *)identifier keyValues:(NSDictionary *)keyValues;

// methods for upload and download
- (NSArray *)messageToDownloadWithMessageType:(AXMessageType)messageType;
- (NSArray *)messageToUploadWithMessageType:(AXMessageType)messageType;
- (NSDictionary *)messageToDownload;
- (NSDictionary *)messageToUpload;

// message related methods
- (NSInteger)totalUnreadMessageCount;
- (AXMappedMessage *)fetchMessageWithIdentifier:(NSString *)identifier;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;
- (void)didLeaveChattingList;
- (NSString *)lastMsgId;
- (NSString *)lastServiceMsgId;

// conversation list
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;
- (NSFetchedResultsController *)conversationListFetchedResultController;
- (void)deleteConversationItem:(AXConversationListItem *)conversationItem;

// delete friends
- (void)willDeleteFriendWithUidList:(NSArray *)uidList;
- (void)didDeleteFriendWithUidList:(NSArray *)uidList;
- (NSArray *)friendUidListToDelete;

// add friends
- (BOOL)isFriendWithFriendUid:(NSString *)friendUid;
- (void)willAddFriendWithUid:(NSString *)friendUid;
- (void)didAddFriendWithFriendData:(NSDictionary *)friendData;
- (NSArray *)friendUidListToAdd;
- (BOOL)hasFriendPendingForAdd;

// fetch and update friends
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;
- (void)updatePerson:(AXMappedPerson *)person;
- (NSArray *)saveFriendListWithPersonArray:(NSArray *)friendArray;
- (NSArray *)fetchFriendList;
- (AXMappedPerson *)fetchCurrentPerson;
- (NSFetchedResultsController *)friendListFetchedResultController;

@end
