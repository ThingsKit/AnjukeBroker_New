//
//  XChatDataCenter.m
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import "AXChatDataCenter.h"

#import "AXPerson.h"
#import "AXMessage.h"
#import "AXMappedMessage.h"
#import "AXConversationListItem.h"
#import "NSArray+ExtraMethods.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSManagedObject+ExtraMethods.h"

@interface AXChatDataCenter ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *friendUid;

@end

@implementation AXChatDataCenter

#pragma mark - life cycle
- (instancetype)initWithUID:(NSString *)uid
{
    self = [super init];
    if (self) {
        NSURL *momdUrl = [[NSBundle mainBundle] URLForResource:@"XChatData" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdUrl];
        [self switchToUID:uid];
    }
    return self;
}

- (void)switchToUID:(NSString *)uid
{
    if (self.managedObjectContext) {
        [self.managedObjectContext save:NULL];
    }
    
    self.uid = uid;
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", uid]];
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    __autoreleasing NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption:[NSNumber numberWithBool:YES]};
    if ([self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
}


- (void)dealloc
{
    [self.managedObjectContext save:NULL];
}

#pragma mark - message related list
- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;
{
    if ([lastMessage.from isEqualToString:self.uid]) {
        self.friendUid = lastMessage.to;
    } else {
        self.friendUid = lastMessage.from;
    }
    
    [self checkAndAddOrderNumberWithFriendUid:self.friendUid];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND orderNumber < %@", self.friendUid, self.friendUid, [NSNumber numberWithInteger:lastMessage.orderNumber]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:NO]];
    fetchRequest.fetchLimit = pageSize;
    __autoreleasing NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];


    NSMutableArray *mappedResult = [[NSMutableArray alloc] initWithCapacity:[result count]];
    for (AXMessage *message in result) {
        [mappedResult addObject:[message convertToMappedObject]];
    }
    
    [self turnAllMessageToReadWithFriendUid:self.friendUid];
    
    BOOL hasMore = NO;
    AXMessage *fetchedLastMessage = [result lastObject];
    if (fetchedLastMessage) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND orderNumber < %@", self.friendUid, self.friendUid, fetchedLastMessage.orderNumber];
        NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
        if (count > 0) {
            hasMore = YES;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate dataCenter:self didFetchChatList:@{@"hasMore":@(hasMore), @"messages":[mappedResult reverseSelf]} withFriend:[self fetchPersonWithUID:self.friendUid] lastMessage:lastMessage];
    });
}

- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND isRemoved = %@ AND messageType = %@", friendUid, friendUid, [NSNumber numberWithBool:NO], [NSNumber numberWithInteger:AXMessageTypePic]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:NO]];
    
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[fetchedResult count]];
    
    NSArray *sortedResult = [fetchedResult sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        AXMessage *message1 = (AXMessage *)obj1;
        AXMessage *message2 = (AXMessage *)obj2;
        
        NSInteger message1Id = [message1.messageId integerValue];
        NSInteger message2Id = [message2.messageId integerValue];
        
        NSComparisonResult compareResult = NSOrderedSame;
        
        if (message1Id == 0 || message2Id == 0) {
            compareResult = NSOrderedSame;
        } else {
            if (message1Id > message2Id) {
                compareResult = NSOrderedAscending;
            }
            if (message1Id < message2Id) {
                compareResult = NSOrderedDescending;
            }
            if (message1Id == message2Id) {
                compareResult = NSOrderedSame;
            }
        }
        
        return compareResult;
        
    }];
    
    for (AXMessage *message in sortedResult) {
        [result addObject:[message convertToMappedObject]];
    }
    return result;
}

- (void)chatListWillAppearWithFriendUid:(NSString *)friendUid
{
    self.friendUid = friendUid;
    [self turnAllMessageToReadWithFriendUid:friendUid];
}

#pragma mark - message life cycle
- (NSArray *)willSendMessage:(AXMappedMessage *)message
{
    NSString *friendID = message.to;
    AXMessage *lastMessage = [self findLastMessageWithFriendUid:friendID];
    
    AXMessage *timeMessage = [self checkAndReturnTimeMessageWithCurrentDate:[NSDate dateWithTimeIntervalSinceNow:0] andLastDate:lastMessage.sendTime from:message.from to:message.to];
    if (timeMessage) {
        [self.managedObjectContext save:NULL];
        timeMessage.orderNumber = [NSNumber numberWithInteger:timeMessage.autoIncreamentPK];
        [self.managedObjectContext save:NULL];
    }
    
    AXPerson *person = [self findPersonWithUID:friendID];
    if (!person) {
        dispatch_queue_t queue = dispatch_queue_create("get_info", NULL);
        dispatch_async(queue, ^{
            [self.delegate dataCenter:self fetchPersonInfoWithUid:@[friendID]];
        });
    }

    message.sendStatus = @(AXMessageCenterSendMessageStatusSending);
    message.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];

    AXMessage *messageToInsert = [self findMessageWithIdentifier:message.identifier];
    if (!messageToInsert) {
        messageToInsert = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    }

    [messageToInsert assignPropertiesFromMappedObject:message];
    [self updateConversationListItemWithMessage:message];
    
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"save message error: %@", error);
    } else {
        messageToInsert.orderNumber = [NSNumber numberWithInteger:messageToInsert.autoIncreamentPK];
        [self.managedObjectContext save:&error];
    }

    if (timeMessage) {
        return @[[timeMessage convertToMappedObject], [messageToInsert convertToMappedObject]];
    } else {
        return @[[messageToInsert convertToMappedObject]];
    }
}

- (AXMappedMessage *)didSuccessSendMessageWithIdentifier:(NSString *)identifier messageId:(NSString *)messageId
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    if (message) {
        message.sendStatus = @(AXMessageCenterSendMessageStatusSuccessful);
        [self updateConversationListItemWithMessage:[message convertToMappedObject]];
    }
    __autoreleasing NSError *error = nil;
    [self.managedObjectContext save:&error];
    return [message convertToMappedObject];
}

- (AXMappedMessage *)didFailSendMessageWithIdentifier:(NSString *)identifier
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    if (message) {
        message.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
        [self updateConversationListItemWithMessage:[message convertToMappedObject]];
    }
    [self.managedObjectContext save:NULL];
    return [message convertToMappedObject];
}

- (void)didReceiveWithMessageDataArray:(NSArray *)receivedArray
{
    if (![receivedArray isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableDictionary *splitedDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    BOOL shouldAlert = NO;
    NSInteger count = 0;
    
    NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *managedMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in receivedArray) {
        count++;
        NSString *friendUID = item[@"from_uid"];
        if (![self.friendUid isEqualToString:friendUID]) {
            shouldAlert = YES;
        }
        
        NSMutableArray *picMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *commonMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *voiceMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
        [messageArray removeAllObjects];
        
        AXMessage *message = [self findLastMessageWithFriendUid:friendUID];
        NSDate *storedLastDate = message.sendTime;
        AXMessage *timeMessage = [self checkAndReturnTimeMessageWithCurrentDate:[NSDate dateWithTimeIntervalSinceNow:0] andLastDate:storedLastDate from:friendUID to:self.uid];
        
        if (timeMessage) {
            [commonMessageArray addObject:timeMessage];
        }
        
        NSArray *sortedArray = [item[@"messages"] sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
        
            NSInteger messageId1 = [obj1[@"msg_id"] integerValue];
            NSInteger messageId2 = [obj2[@"msg_id"] integerValue];
            
            if (messageId1 > messageId2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];

        for (NSDictionary *message in sortedArray) {

            AXMessageType messageType = [message[@"msg_type"] integerValue];
            AXMessageCenterSendMessageStatus messageSendStatus = AXMessageCenterSendMessageStatusSuccessful;
            BOOL isVersionLower = [self isOldVersionWithMessageType:messageType];
            NSNumber *messageId = [NSNumber numberWithInteger:[message[@"msg_id"] integerValue]];
            if ([self isMessageExistsWithMessageId:messageId]) {
                continue;
            }

            AXMessage *managedMessage = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];

            if (messageType == AXMessageTypePic) {
                managedMessage.imgPath = @"";
                managedMessage.imgUrl = message[@"body"];
                managedMessage.thumbnailImgPath = @"";
                managedMessage.thumbnailImgUrl = @"";
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:NO];
            } else if (messageType == AXMessageTypeVoice) {
                managedMessage.imgPath = @"";
                managedMessage.imgUrl = message[@"body"];
                managedMessage.thumbnailImgPath = @"";
                managedMessage.thumbnailImgUrl = @"";
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:NO];
            } else {
                managedMessage.imgPath = @"";
                managedMessage.imgUrl = @"";
                managedMessage.thumbnailImgPath = @"";
                managedMessage.thumbnailImgUrl = @"";
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:YES];
            }
            
            managedMessage.accountType = item[@"account_type"];
            managedMessage.from = friendUID;
            managedMessage.isRemoved = [NSNumber numberWithBool:NO];
            managedMessage.messageId = @([message[@"msg_id"] integerValue]);
            managedMessage.sendStatus = @(messageSendStatus);
            managedMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
            managedMessage.to = message[@"to_uid"];
            
            if ([self.friendUid isEqualToString:friendUID]) {
                managedMessage.isRead = [NSNumber numberWithBool:YES];
            } else {
                managedMessage.isRead = [NSNumber numberWithBool:NO];
            }
            
            if (messageType >= MIN_SYSTEM_MESSAGE_TYPE && messageType <= MAX_SYSTEM_MESSAGE_TYPE) {
                managedMessage.isRead = [NSNumber numberWithBool:YES];
            }
            
            if (isVersionLower) {
                managedMessage.isRead = [NSNumber numberWithBool:NO];
                managedMessage.content = @"你使用的版本太旧，显示不出对方的消息了。";
                managedMessage.messageType = @(AXMessageTypeSafeMessage);
                [self.managedObjectContext save:NULL];
            } else {
                managedMessage.content = message[@"body"];
                managedMessage.messageType = @(messageType);
            }
            
            if (messageType == AXMessageTypePic) {
                [picMessageArray addObject:[managedMessage convertToMappedObject]];
            } else if (messageType == AXMessageTypeVoice) {
                [voiceMessageArray addObject:[managedMessage convertToMappedObject]];
            } else {
                [commonMessageArray addObject:[managedMessage convertToMappedObject]];
            }
            
            [messageArray addObject:[managedMessage convertToMappedObject]];
            [managedMessageArray addObject:managedMessage];
            [self.managedObjectContext save:NULL];
            managedMessage.orderNumber = [NSNumber numberWithInteger:managedMessage.autoIncreamentPK];
            [self.managedObjectContext save:NULL];
        }
        
        AXMappedMessage *messageToUpdate = [self findMessageToUpdate:messageArray];
        if (messageToUpdate) {
            [self updateConversationListItemWithMessage:messageToUpdate];
        }

        
        splitedDictionary[friendUID] = @{@"pic":picMessageArray, @"voice":voiceMessageArray, @"other":commonMessageArray};
        
        [self checkAndFetchFriendInfoWithFriendUid:friendUID accountType:[item[@"account_type"] integerValue]];
    }
    
    if (shouldAlert) {
        if ([receivedArray count] >= 1) {
            [self bark];
        }
    }
    
    [self.delegate dataCenter:self didReceiveMessages:splitedDictionary];
}

- (void)deleteMessageByIdentifier:(NSString *)identifier
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    [self.managedObjectContext deleteObject:message];
    
    if (message) {
        NSString *friendUid;
        
        if ([message.to isEqualToString:self.uid]) {
            friendUid = message.from;
        } else {
            friendUid = message.to;
        }
        
        if (![self checkAndDeleteConversationItemWithFriendId:friendUid]) {
            
            AXMessage *lastMessage = [self findLastMessageWithFriendUid:friendUid];
            AXConversationListItem *item = [self findConversationListItemWithFriendUID:friendUid];
            
            if (lastMessage) {
                if (item) {
                    [self updateConversationListItemWithMessage:[lastMessage convertToMappedObject]];
                }
            } else {
                if (item) {
                    [self deleteConversationItemWithFriendUid:item.friendUid];
                }
            }
        }
    }

    [self.managedObjectContext save:NULL];
}

- (void)updateMessage:(AXMappedMessage *)message
{
    AXMessage *messageToUpdate = [self findMessageWithIdentifier:message.identifier];
    [messageToUpdate assignPropertiesFromMappedObject:message];
    
    NSString *friendUid;
    if ([message.from isEqualToString:self.uid]) {
        friendUid = message.to;
    } else {
        friendUid = message.from;
    }
    
    AXConversationListItem *item = [self findConversationListItemWithFriendUID:friendUid];
    item.messageStatus = messageToUpdate.sendStatus;
    
    [self.managedObjectContext save:NULL];
}

- (void)updateMessageWithIdentifier:(NSString *)identifier keyValues:(NSDictionary *)keyValues
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    AXMessage *message = [fetchedResult firstObject];
    if (message == nil) {
        return;
    } else {
        [keyValues enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop) {
            [message setValue:obj forKeyPath:key];
        }];
        [self.managedObjectContext save:NULL];
    }
}

#pragma mark - message for upload or download
- (NSArray *)messageToDownloadWithMessageType:(AXMessageType)messageType
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isImgDownloaded = %@ AND messageType = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithInteger:messageType]];

    __autoreleasing NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        DLog(@"%@", error);
        return nil;
    } else {
        NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (AXMessage *message in result) {
            if (messageDic[message.from] == nil) {
                messageDic[message.from] = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [messageDic[message.from] addObject:message];
        }
        
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
        [messageDic enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id userId, id messageArray, BOOL *stop) {
            [resultArray addObject:@{userId:messageArray}];
        }];
        return resultArray;
    }
}

- (NSArray *)messageToUploadWithMessageType:(AXMessageType)messageType
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isUploaded = %@ AND messageType = %@", [NSNumber numberWithBool:NO], [NSNumber numberWithInteger:messageType]];

    __autoreleasing NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        DLog(@"%@", error);
        return nil;
    } else {
        NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (AXMessage *message in result) {
            if (messageDic[message.to] == nil) {
                messageDic[message.to] = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [messageDic[message.to] addObject:message];
        }
        
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
        [messageDic enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id userId, id messageArray, BOOL *stop) {
            [resultArray addObject:@{userId:messageArray}];
        }];
        return resultArray;
    }
}

- (NSDictionary *)messageToUpload
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isUploaded = %@", [NSNumber numberWithBool:NO]];
    
    __autoreleasing NSError *error = nil;
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (AXMessage *message in fetchedResult) {
        
        if (result[message.to] == nil) {
            result[message.to] = [[NSMutableDictionary alloc] initWithCapacity:0];
            result[message.to][@"pic"] = [[NSMutableArray alloc] initWithCapacity:0];
            result[message.to][@"voice"] = [[NSMutableArray alloc] initWithCapacity:0];
            result[message.to][@"other"] = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        if ([message.messageType integerValue] == AXMessageTypePic) {
            [result[message.to][@"pic"] addObject:message];
        }
        
        if ([message.messageType integerValue] == AXMessageTypeVoice) {
            [result[message.to][@"voice"] addObject:message];
        }
    }
    
    return result;
}

- (NSDictionary *)messageToDownload
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isImgDownloaded = %@", [NSNumber numberWithBool:NO]];
    
    __autoreleasing NSError *error = nil;
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (AXMessage *message in fetchedResult) {

        if (result[message.from] == nil) {
            result[message.from] = [[NSMutableDictionary alloc] initWithCapacity:0];
            result[message.from][@"pic"] = [[NSMutableArray alloc] initWithCapacity:0];
            result[message.from][@"voice"] = [[NSMutableArray alloc] initWithCapacity:0];
            result[message.from][@"other"] = [[NSMutableArray alloc] initWithCapacity:0];
        }

        if ([message.messageType integerValue] == AXMessageTypePic) {
            [result[message.to][@"pic"] addObject:message];
        }

        if ([message.messageType integerValue] == AXMessageTypeVoice) {
            [result[message.to][@"voice"] addObject:message];
        }
    }
    
    return result;
}

#pragma mark - message related methods
- (NSString *)lastMsgId
{
    [self conversationListFetchedResultController];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.resultType = NSDictionaryResultType;
    NSExpression *keypathExpression = [NSExpression expressionForKeyPath:@"messageId"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[keypathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"lastMsgId";
    expressionDescription.expression = maxExpression;
    expressionDescription.expressionResultType = NSInteger32AttributeType;
    fetchRequest.propertiesToFetch = @[expressionDescription];
    
    __autoreleasing NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([result count] > 0) {
        NSNumber *lastMsgId = result[0][@"lastMsgId"];
        if ([lastMsgId integerValue ] == 0) {
            return @"0";
        } else {
            return [NSString stringWithFormat:@"%@", lastMsgId];
        }
    } else {
        return @"0";
    }
}

- (AXMappedMessage *)fetchMessageWithIdentifier:(NSString *)identifier
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    AXMessage *message = [result firstObject];
    if (message) {
        return [message convertToMappedObject];
    } else {
        return nil;
    }
}

- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID
{
    if (![self isFriendWithFriendUid:friendUID]) {
        return;
    }
    
    AXConversationListItem *conversationListItem = [self findConversationListItemWithFriendUID:friendUID];
    if ([content isEqualToString:@""]) {
        if (conversationListItem) {
            conversationListItem.hasDraft = [NSNumber numberWithBool:NO];
        }
    } else {
        if (!conversationListItem) {
            conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        }
        conversationListItem.friendUid = friendUID;
        conversationListItem.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
        conversationListItem.hasDraft = [NSNumber numberWithBool:YES];
        //补充头像
        AXMappedPerson *person = [self fetchPersonWithUID:friendUID];
        conversationListItem.iconUrl = person.iconUrl;
        conversationListItem.iconPath = person.iconPath;
    }
    conversationListItem.draftContent = content;
    [self.managedObjectContext save:NULL];
}

- (NSInteger)totalUnreadMessageCount
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRead = %@", [NSNumber numberWithBool:NO]];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
}

- (void)didLeaveChattingListWithFriendUID:(NSString *)friendUID
{
    self.friendUid = nil;
    if (![self isFriendWithFriendUid:friendUID]) {
        if ([self findConversationListItemWithFriendUID:friendUID]) {
            [self deleteConversationItemWithFriendUid:friendUID];
        }
    }
}

- (NSString *)lastServiceMsgId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"accountType = %d", AXPersonTypePublic];
    NSExpression *keypathExpression = [NSExpression expressionForKeyPath:@"messageId"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[keypathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"lastMsgId";
    expressionDescription.expression = maxExpression;
    expressionDescription.expressionResultType = NSInteger32AttributeType;
    fetchRequest.propertiesToFetch = @[expressionDescription];
    
    __autoreleasing NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([result count] > 0) {
        NSNumber *lastMsgId = result[0][@"lastMsgId"];
        if ([lastMsgId integerValue ] == 0) {
            return @"0";
        } else {
            return [NSString stringWithFormat:@"%@", lastMsgId];
        }
    } else {
        return @"0";
    }
}

#pragma mark - conversation List
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friendUid = %@", friendUID];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        AXConversationListItem *item = [result firstObject];
        return [item convertToMappedObject];
    } else {
        return nil;
    }
}

- (NSFetchedResultsController *)conversationListFetchedResultController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastUpdateTime" ascending:NO]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)deleteConversationItem:(AXConversationListItem *)conversationItem
{
    AXConversationListItem *listItem = conversationItem;
    NSString *friendUid = listItem.friendUid;
    [self deleteConversationItemWithFriendUid:friendUid];
}

#pragma mark - delete friends
- (NSArray *)friendUidListToDelete
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRemoved = %@", [NSNumber numberWithBool:YES]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *uidList = [[NSMutableArray alloc] initWithCapacity:0];
    for (AXPerson *friendToDelete in result) {
        [uidList addObject:friendToDelete.uid];
    }
    return uidList;
}

- (void)willDeleteFriendWithUidList:(NSArray *)uidList
{
    for (NSString *uid in uidList) {
        AXPerson *friendToDelete = [self findPersonWithUID:uid];
        if (friendToDelete) {
            friendToDelete.isPendingForRemove = [NSNumber numberWithBool:YES];
        }
        
        //删除所有消息
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@ OR to = %@", uid,uid];
        NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        for (AXMessage *message in result) {
            [self.managedObjectContext deleteObject:message];
        }
        
        //删除会话列表
        fetchRequest.entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friendUid = %@", uid];
        result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        for (AXConversationListItem *item in result) {
            [self.managedObjectContext deleteObject:item];
        }
    }
    [self.managedObjectContext save:NULL];
}

- (void)didDeleteFriendWithUidList:(NSArray *)uidList
{
    for (NSString *uid in uidList) {
        AXPerson *friendToDelete = [self findPersonWithUID:uid];
        [self.managedObjectContext deleteObject:friendToDelete];
    }
    [self.managedObjectContext save:NULL];
}

#pragma mark - add friends
- (BOOL)isFriendWithFriendUid:(NSString *)friendUid
{
    AXPerson *person = [self findPersonWithUID:friendUid];
    if (person && ![person.isPendingForRemove boolValue] && [person.isPendingForAdd integerValue] == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)willAddFriendWithUid:(NSString *)friendUid
{
    AXPerson *person = [self findPersonWithUID:friendUid];
    if (!person) {
        person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    }
    person.isPendingForAdd = [NSNumber numberWithBool:YES];
    person.isPendingForRemove = [NSNumber numberWithBool:NO];
    [self.managedObjectContext save:NULL];
}

- (void)didAddFriendWithFriendData:(NSDictionary *)friendData
{
    AXPerson *person = [self findPersonWithUID:friendData[@"user_id"]];
    if (!person) {
        person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    }
    person.created = [NSDate dateWithTimeIntervalSince1970:[friendData[@"create"] integerValue]];
    person.iconUrl = friendData[@"icon"];
    person.isPendingForAdd = [NSNumber numberWithBool:NO];
    person.isPendingForRemove = [NSNumber numberWithBool:NO];
    person.lastActiveTime = [NSDate dateWithTimeIntervalSince1970:[friendData[@"last_update"] integerValue]];
    person.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
    person.name = friendData[@"nick_name"];
    person.namePinyin = friendData[@"nick_name_pinyin"];
    person.markName = friendData[@"mark_name"]?friendData[@"mark_name"]:@"";
    person.markNamePinyin = friendData[@"mark_name_pinyin"]?friendData[@"mark_name_pinyin"]:@"";
    person.phone = friendData[@"phone"];
    person.uid = friendData[@"user_id"];
    person.userType = @([friendData[@"user_type"] integerValue]);
    [person updateFirstPinyin];
    [self.managedObjectContext save:NULL];
}

- (NSArray *)friendUidListToAdd
{
    NSMutableArray *uidListToAdd = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isPendingForAdd = %@", [NSNumber numberWithBool:YES]];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (AXPerson *person in result) {
        [uidListToAdd addObject:person.uid];
    }
    
    return uidListToAdd;
}

- (BOOL)hasFriendPendingForAdd
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isPendingForAdd = %@", [NSNumber numberWithBool:YES]];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - fetch && update friends
- (NSArray *)fetchFriendList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid != %@ AND isPendingForRemove = %@", self.uid, [NSNumber numberWithBool:NO]];
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    for (AXPerson *person in fetchedResult) {
        [result addObject:[person convertToMappedPerson]];
    }
    return result;
}

- (NSArray *)saveFriendListWithPersonArray:(NSArray *)friendArray
{
    NSMutableArray *friendList = [[NSMutableArray alloc] initWithCapacity:0];
    [self deleteFriendsNotInList:friendArray];
    
    for (NSDictionary *mappedPerson in friendArray) {
        AXPerson *person = [self findPersonWithUID:mappedPerson[@"user_id"]];
        
        if (!person) {
            person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
            person.isPendingForRemove = [NSNumber numberWithBool:NO];
            
            BOOL isStar = NO;
            if ([mappedPerson[@"is_star"] isEqualToString:@"1"]) {
                isStar = YES;
            }
            person.isStar = [NSNumber numberWithBool:isStar];

        }
        person.isPendingForAdd = [NSNumber numberWithBool:NO];
        person.created = [NSDate dateWithTimeIntervalSince1970:[mappedPerson[@"created"] integerValue]];
        person.iconPath = @"";
        person.iconUrl = mappedPerson[@"icon"];
        person.isIconDownloaded = [NSNumber numberWithBool:NO];
        person.lastActiveTime = [NSDate dateWithTimeIntervalSince1970:[mappedPerson[@"last_active_time"] integerValue]];
        person.lastUpdate = [NSDate dateWithTimeIntervalSince1970:[mappedPerson[@"last_update"] integerValue]];
        person.markName = mappedPerson[@"mark_name"];
        person.markNamePinyin = mappedPerson[@"mark_name_pinyin"];
        person.name = mappedPerson[@"nick_name"];
        person.namePinyin = mappedPerson[@"nick_name_pinyin"];
        person.phone = mappedPerson[@"phone"];
        person.uid = mappedPerson[@"user_id"];
        person.company = mappedPerson[@"corp"];
        person.userType = @([mappedPerson[@"user_type"] integerValue]);
        //
        if (mappedPerson[@"mark_phone"] && mappedPerson[@"mark_phone"] != nil) {
            person.markPhone = mappedPerson[@"mark_phone"];
        }
        
        if (person.userType == [NSNumber numberWithInt:AXPersonTypePublic]) { //公众账号保存desc，其他类型账号保存markDesc
            person.markDesc = mappedPerson[@"desc"];
        }
        else {
            if (mappedPerson[@"mark_desc"] && mappedPerson[@"mark_desc"] != nil) {
                person.markDesc = mappedPerson[@"mark_desc"];
            }
        }
        
        [person updateFirstPinyin];
        
        if (![person.isPendingForRemove boolValue]) {
            [friendList addObject:[person convertToMappedPerson]];
        }
    }
    
    __autoreleasing NSError *error = nil;
    [self.managedObjectContext save:&error];
    return friendList;
}

- (void)updatePerson:(AXMappedPerson *)person
{
    AXPerson *personToUpdate = [self findPersonWithUID:person.uid];
    
    if (personToUpdate == nil) {
        personToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    }
    
    person.isPendingForAdd = NO;
    [personToUpdate assignPropertiesFromMappedObject:person];
    [personToUpdate updateFirstPinyin];
    
    NSString *presentName = nil;
    if ([person.markName length] > 0) {
        presentName = person.markName;
    } else {
        presentName = person.name;
    }
    
    AXConversationListItem *item = [self findConversationListItemWithFriendUID:person.uid];
    if (item) {
        item.presentName = presentName;
        item.iconUrl = personToUpdate.iconUrl;
        item.iconPath = personToUpdate.iconPath;
        item.isIconDownloaded = personToUpdate.isIconDownloaded;
    }
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
}

- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid
{
    AXPerson *person = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        person = [result firstObject];
    }
    return [person convertToMappedPerson];
}

- (AXMappedPerson *)fetchCurrentPerson
{
    return [self fetchPersonWithUID:self.uid];
}

- (NSFetchedResultsController *)friendListFetchedResultController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AXPerson"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid != %@ AND isPendingForRemove = %@", self.uid,[NSNumber numberWithBool:NO]];
    
    NSSortDescriptor *sectionSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstPinYin" ascending:YES];
    NSSortDescriptor *uidSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];
    fetchRequest.sortDescriptors = @[sectionSortDescriptor,uidSortDescriptor];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"firstPinYin" cacheName:nil];
}

#pragma mark - private methods
- (void)updateConversationListItemWithMessage:(AXMappedMessage *)message
{
    BOOL shouldUpdateConversationListItem = YES;
    
    NSString *friendUID = nil;
    if ([message.from isEqualToString:self.uid]) {
        friendUID = message.to;
    } else {
        friendUID = message.from;
    }
    
    AXConversationListItemType itemType = 0;

    AXMessageType messageType = [message.messageType integerValue];
    NSString *messageTip;
    if (messageType == AXMessageTypeSettingNotifycation || messageType == AXMessageTypeSystemForbid || messageType == AXMessageTypeSystemTime || messageType == AXMessageTypeAddNuckName || messageType == AXMessageTypeVersion) {
        shouldUpdateConversationListItem = NO;
    }
    
    if (messageType == AXMessageTypeVoice) {
        itemType = AXConversationListItemTypeVoice;
        messageTip = @"你收到一句话";
    }

    if (messageType == AXMessageTypePic) {
        itemType = AXConversationListItemTypePic;
        messageTip = @"你收到一张图片";
    }
    
    if (messageType == AXMessageTypeLocation) {
        itemType = AXConversationListItemTypeLocation;
        messageTip = @"你收到一个位置";
    }
    
    if (messageType == AXMessageTypeProperty || messageType == AXMessageTypeJinpuProperty) {
        NSDictionary *messageContent = [NSJSONSerialization JSONObjectWithData:[message.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        messageTip = @"你收到一个房源";

        NSInteger propertyType = [messageContent[@"tradeType"] integerValue];
        if (propertyType == 1) {
            itemType = AXConversationListItemTypeESFProperty;
        }
        if (propertyType == 2) {
            itemType = AXConversationListItemTypeHZProperty;
        }
        if (propertyType == 3) {
            itemType = AXConversationListItemTypeCommunity;
        }
        //商铺出售（租）、写字楼出售（租）,均显示[商业地产]
        if (propertyType == 8 || propertyType == 9 || propertyType == 10 || propertyType == 11) {
            itemType = AXConversationListItemTypeJinpu;
        }
    }
    
    if (messageType == AXMessageTypeText) {
        itemType = AXConversationListItemTypeText;
        messageTip = message.content;
    }
    
    if (messageType == AXMessageTypePublicCard) {
        itemType = AXConversationListItemTypeCard;
        NSDictionary *messageContent = [NSJSONSerialization JSONObjectWithData:[message.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        messageTip = messageContent[@"title"];
    }
    
    if (shouldUpdateConversationListItem) {
        AXConversationListItem *conversationListItem = [self findConversationListItemWithFriendUID:friendUID];
        if (!conversationListItem) {
            conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        }
        
        AXPerson *friend = [self findPersonWithUID:friendUID];
        NSString *presentName;
        if ([friend.markName length] > 0) {
            presentName = friend.markName;
        } else {
            presentName = friend.name;
        }
        
        
        conversationListItem.presentName = presentName;
        conversationListItem.iconPath = friend.iconPath;
        conversationListItem.iconUrl = friend.iconUrl;
        conversationListItem.isIconDownloaded = friend.isIconDownloaded;
        conversationListItem.messageType = @(itemType);
        conversationListItem.lastMsgIdentifier = message.identifier;
        conversationListItem.lastUpdateTime = message.sendTime;
        conversationListItem.messageTip = messageTip;
        conversationListItem.friendUid = friendUID;
        conversationListItem.count = [NSNumber numberWithInteger:[self countUnreadMessagesWithFriendUid:friendUID]];
        conversationListItem.messageStatus = message.sendStatus;

        __autoreleasing NSError *error;
        [self.managedObjectContext save:&error];
    }
}

- (AXMessage *)findMessageWithIdentifier:(NSString *)identifier
{
    if (identifier == nil) {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        return [result firstObject];
    } else {
        return nil;
    }
}

- (BOOL)isMessageExistsWithMessageId:(NSNumber *)messageId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"messageId = %@", messageId];
    NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (AXPerson *)findPersonWithUID:(NSString *)uid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        return [result firstObject];
    } else {
        return nil;
    }
}

- (AXConversationListItem *)findConversationListItemWithFriendUID:(NSString *)friendUID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friendUid = %@", friendUID];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        return [result firstObject];
    } else {
        return nil;
    }
}

- (AXMessage *)findLastMessageWithFriendUid:(NSString *)friendUid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@ OR to = %@", friendUid, friendUid];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:NO]];
    fetchRequest.fetchLimit = 1;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        return [result firstObject];
    } else {
        return nil;
    }
}

- (NSUInteger)countUnreadMessagesWithFriendUid:(NSString *)friendUid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND isRead = %@", friendUid, friendUid, [NSNumber numberWithBool:NO]];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
}

- (void)turnAllMessageToReadWithFriendUid:(NSString *)friendUid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND isRead = %@", friendUid, friendUid, [NSNumber numberWithBool:NO]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (AXMessage *message in result) {
        message.isRead = [NSNumber numberWithBool:YES];
    }
    
    AXConversationListItem *item = [self findConversationListItemWithFriendUID:friendUid];
    item.count = [NSNumber numberWithInteger:0];
    [self.managedObjectContext save:NULL];
}

- (AXMappedMessage *)findMessageToUpdate:(NSArray *)mappedMessageArray
{
    AXMappedMessage *message;
    NSInteger maxMessageId = NSIntegerMin;
    for (AXMappedMessage *messageToCheck in mappedMessageArray) {

        AXMessageType messageType = [messageToCheck.messageType integerValue];
        if (messageType == AXMessageTypeSettingNotifycation || messageType == AXMessageTypeSystemForbid || messageType == AXMessageTypeSystemTime || messageType == AXMessageTypeAddNuckName || messageType == AXMessageTypeSafeMessage) {
            continue;
        } else {
            NSInteger messageId = [messageToCheck.messageId integerValue];
            if (messageId > maxMessageId) {
                maxMessageId = messageId;
            }
        }
    }
    
    for (AXMappedMessage *messageToCheck in mappedMessageArray) {
        if ([messageToCheck.messageId integerValue] == maxMessageId) {
            message = messageToCheck;
            break;
        }
    }
    
    return message;
}

- (void)deleteFriendsNotInList:(NSArray *)friendList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    NSArray *fetchedFriendList = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (AXPerson *friend in fetchedFriendList) {
        BOOL isExist = NO;
        
        for (NSDictionary *person in friendList) {
            if ([friend.uid isEqualToString:person[@"user_id"]]) {
                isExist = YES;
            }
            if ([friend.uid isEqualToString:self.uid]) {
                isExist = YES;
            }
        }
        
        if (!isExist) {
            [self.managedObjectContext deleteObject:friend];
        }
    }
    [self.managedObjectContext save:NULL];
}

- (AXMessage *)checkAndReturnTimeMessageWithCurrentDate:(NSDate *)currentDate andLastDate:(NSDate *)lastDate from:(NSString *)from to:(NSString *)to
{
    AXMessage *timeMessage = nil;
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:lastDate];
    if (timeInterval > 300) {
        timeMessage = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
        timeMessage.accountType = [NSString stringWithFormat:@"%lu", (unsigned long)AXPersonTypeServer];
        NSDateFormatter *dateFormatrer = [[NSDateFormatter alloc] init];
        dateFormatrer.dateFormat = @"HH:mm:ss";
        dateFormatrer.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        timeMessage.content = [dateFormatrer stringFromDate:currentDate];
        timeMessage.from = from;
        timeMessage.to = to;
        timeMessage.isImgDownloaded = [NSNumber numberWithBool:NO];
        timeMessage.isRead = [NSNumber numberWithBool:YES];
        timeMessage.isRemoved = [NSNumber numberWithBool:NO];
        timeMessage.messageType = [NSNumber numberWithInteger:AXMessageTypeSystemTime];
        timeMessage.sendTime = [NSDate dateWithTimeInterval:-0.01 sinceDate:currentDate];
        
        [self.managedObjectContext save:NULL];
    }
    
    return timeMessage;
}

- (void)deleteConversationItemWithFriendUid:(NSString *)friendUid
{
    AXConversationListItem *listItem = [self findConversationListItemWithFriendUID:friendUid];
    
    if (listItem != nil) {
        NSFetchRequest *fetchRequst = [[NSFetchRequest alloc] init];
        fetchRequst.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
        fetchRequst.predicate = [NSPredicate predicateWithFormat:@"from = %@ OR to = %@", friendUid, friendUid];
        NSArray *messages = [self.managedObjectContext executeFetchRequest:fetchRequst error:NULL];
        
        for (AXMessage *message in messages) {
            [self.managedObjectContext deleteObject:message];
        }
        
        [self.managedObjectContext deleteObject:listItem];
        [self.managedObjectContext save:NULL];
    }
}

- (BOOL)checkAndDeleteConversationItemWithFriendId:(NSString *)friendUid
{
    BOOL hasBeenDeleted = NO;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageType < %@", @(100)];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (count == 0) {
        hasBeenDeleted = YES;
        [self deleteConversationItemWithFriendUid:friendUid];
    }
    
    return hasBeenDeleted;
}

- (BOOL)isOldVersionWithMessageType:(AXMessageType)messageType
{
    BOOL result = NO;
    if (messageType < MIN_MESSAGE_TYPE) {
        result = YES;
    }
    if (messageType > MAX_MESSAGE_TYPE && messageType < MIN_SYSTEM_MESSAGE_TYPE) {
        result = YES;
    }
    if (messageType > MAX_SYSTEM_MESSAGE_TYPE) {
        result = YES;
    }
    return result;
}

- (void)checkAndFetchFriendInfoWithFriendUid:(NSString *)friendUid accountType:(AXPersonType)accountType
{
    if (![self isFriendWithFriendUid:friendUid]) {
        
        AXPerson *friend = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        friend.uid = friendUid;
        friend.isPendingForAdd = [NSNumber numberWithBool:YES];
        
        if (accountType == AXPersonTypePublic) {
            friend.userType = [NSNumber numberWithInteger:AXPersonTypePublic];
            [self.delegate dataCenter:self fetchPublicInfoWithUid:@[friendUid]];
        } else {
            [self.delegate dataCenter:self fetchPersonInfoWithUid:@[friendUid]];
        }
    }
}

- (void)bark
{
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    
    Float32 volume;
    UInt32 dataSize = sizeof(Float32);
    AudioSessionGetProperty (
                             kAudioSessionProperty_CurrentHardwareOutputVolume,
                             &dataSize,
                             &volume
                             );
    
    UIAccessibilityIsVoiceOverRunning();
    
    if (CFStringGetLength(state) == 0 || volume == 0) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
        AudioServicesPlaySystemSound(1015);
    }
}


- (void)checkAndAddOrderNumberWithFriendUid:(NSString *)friendUid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND (orderNumber = 0 OR orderNumber = nil)", friendUid, friendUid];
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];

    if ([fetchedResult count] > 0) {
        for (AXMessage *message in fetchedResult) {
            message.orderNumber = [NSNumber numberWithInteger:message.autoIncreamentPK];
        }
        [self.managedObjectContext save:NULL];
    }

}

@end
