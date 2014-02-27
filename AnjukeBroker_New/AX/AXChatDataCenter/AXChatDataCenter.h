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

- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSArray *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message;
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchFriendList:(NSArray *)chatList;

@end

@interface AXChatDataCenter : NSObject

@property (nonatomic, weak) id<AXChatDataCenterDelegate> delegate;

// life cycle
- (instancetype)initWithUID:(NSString *)uid;
- (void)switchToUID:(NSString *)uid;

// message && message record list
- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;

// message related methods
- (AXMappedMessage *)willSendMessage:(AXMappedMessage *)message;
- (AXMappedMessage *)didSuccessSendMessageWithIdentifier:(NSString *)identifier messageId:(NSString *)messageId;
- (AXMappedMessage *)didFailSendMessageWithIdentifier:(NSString *)identifier;

- (NSDictionary *)didReceiveWithMessageDataArray:(NSArray *)receivedArray;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (void)updateMessage:(AXMappedMessage *)message;
- (NSString *)lastMsgId;

- (AXMappedMessage *)fetchMessageWithIdentifier:(NSString *)identifier;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;

- (NSInteger)totalUnreadMessageCount;
- (void)didLeaveChattingList;

// conversation list
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;
- (NSFetchedResultsController *)conversationListFetchedResultController;
- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem;

// delete friends
- (void)willDeleteFriendWithUidList:(NSArray *)uidList;
- (void)didDeleteFriendWithUidList:(NSArray *)uidList;
- (NSArray *)friendUidListToDelete;

// add friends
- (BOOL)isFriendWithFriendUid:(NSString *)friendUid;
- (void)willAddFriendWithUid:(NSString *)friendUid;
- (void)didAddFriendWithFriendData:(NSDictionary *)friendData;
- (NSArray *)friendUidListToAdd;

// fetch and update friends
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;
- (void)updatePerson:(AXMappedPerson *)person;
- (NSArray *)saveFriendListWithPersonArray:(NSArray *)friendArray;
- (NSArray *)fetchFriendList;
- (AXMappedPerson *)fetchCurrentPerson;

@end
