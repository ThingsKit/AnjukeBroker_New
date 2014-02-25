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

@end

@interface AXChatDataCenter : NSObject

@property (nonatomic, weak) id<AXChatDataCenterDelegate> delegate;

- (instancetype)initWithUID:(NSString *)uid;

- (void)fetchData;
- (void)writeData;
- (void)test;

- (void)switchToUID:(NSString *)uid;
- (NSString *)lastMsgId;

// message && message record list
- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;
- (AXMappedMessage *)addMessage:(AXMappedMessage *)message saveImmediatly:(BOOL)save;
- (void)deleteMessageByIdentifier:(NSString *)identifier;
- (void)updateMessage:(AXMappedMessage *)message;
- (AXMappedMessage *)fetchMessageWithIdentifier:(NSString *)identifier;
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID;
- (NSArray *)addMessageWithArray:(NSArray *)receiceArray;
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID;

// conversation list
- (NSFetchedResultsController *)conversationListFetchedResultController;
- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem;

// friends
- (void)successDeletePerson:(NSString *)uid;
- (void)addFriend:(AXMappedPerson *)person;
- (void)deleteFriend:(AXMappedPerson *)person;
- (void)updatePerson:(AXMappedPerson *)person;
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid;
- (NSArray *)fetchFriendList;
- (void)saveFriendListWithPersonArray:(NSArray *)friendArray;
- (AXMappedPerson *)fetchCurrentPerson;

#warning test methods
- (void)addConversationListItem:(AXMappedConversationListItem *)item;

@end
