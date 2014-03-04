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
#import "AXConversationListItem.h"
#import "NSArray+ExtraMethods.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AXChatDataCenter ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *uid;
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
    if (error) {
        NSLog(@"%@", error);
    }
}


#pragma mark - test methods
//- (void)test
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
//    
//    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
//    for (AXPerson *person in result) {
//        NSLog(@"%@", person.isPendingForRemove);
//    }
//    NSLog(@"%@",result);
//}

#pragma mark - message related list
- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;
{
    if ([lastMessage.from isEqualToString:self.uid]) {
        self.friendUid = lastMessage.to;
    } else {
        self.friendUid = lastMessage.from;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:NO]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND sendTime < %@ AND isRemoved = %@", self.friendUid, self.friendUid, lastMessage.sendTime, [NSNumber numberWithBool:NO]];
    fetchRequest.fetchLimit = pageSize;
    __autoreleasing NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    NSMutableArray *mappedResult = [[NSMutableArray alloc] initWithCapacity:0];
    for (AXMessage *message in result) {
        [mappedResult addObject:[message convertToMappedObject]];
    }
    
    [self turnAllMessageToReadWithFriendUid:self.friendUid];
    
    BOOL hasMore = NO;
    AXMessage *fetchedLastMessage = [result lastObject];
    if (fetchedLastMessage) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(from = %@ OR to = %@) AND sendTime < %@ AND isRemoved = %@", self.friendUid, self.friendUid, fetchedLastMessage.sendTime, [NSNumber numberWithBool:NO]];
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
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[fetchedResult count]];
    for (AXMessage *message in fetchedResult) {
        [result addObject:[message convertToMappedObject]];
    }
    return result;
}

#pragma mark - message related methods
- (AXMappedMessage *)willSendMessage:(AXMappedMessage *)message
{
    message.sendStatus = @(AXMessageCenterSendMessageStatusSending);
    message.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    AXMessage *messageToInsert = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    [messageToInsert assignPropertiesFromMappedObject:message];
    [self updateConversationListItemWithMessage:message];
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    return [messageToInsert convertToMappedObject];
}

- (AXMappedMessage *)didSuccessSendMessageWithIdentifier:(NSString *)identifier messageId:(NSString *)messageId
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    if (message) {
        message.sendStatus = @(AXMessageCenterSendMessageStatusSuccessful);
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
    }
    [self.managedObjectContext save:NULL];
    return [message convertToMappedObject];
}

- (NSDictionary *)didReceiveWithMessageDataArray:(NSArray *)receivedArray
{
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *splitedDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSDictionary *item in receivedArray) {
        NSString *friendUID = item[@"from_uid"];
        NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSMutableArray *picMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *commonMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        AXMessage *message = [self findLastMessageWithFriendUid:friendUID];
        NSDate *storedLastDate = message.sendTime;
        
        for (NSDictionary *message in item[@"messages"]) {

            AXMessageType messageType = [message[@"msg_type"] integerValue];
            AXMessageCenterSendMessageStatus messageSendStatus = AXMessageCenterSendMessageStatusSuccessful;
            NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];

            AXMessage *managedMessage = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];

            if (messageType == AXMessageTypePic) {
#warning todo 应该根据UBB来区分
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
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:NO];
            }

            managedMessage.accountType = message[@"account_type"];
            managedMessage.content = message[@"body"];
            managedMessage.from = friendUID;
            managedMessage.isRemoved = [NSNumber numberWithBool:NO];
            managedMessage.messageId = @([message[@"msg_id"] integerValue]);
            managedMessage.messageType = @(messageType);
            managedMessage.sendStatus = @(messageSendStatus);
            managedMessage.sendTime = lastUpdateTime;
            managedMessage.to = message[@"to_uid"];
            
            if ([self.friendUid isEqualToString:friendUID]) {
                managedMessage.isRead = [NSNumber numberWithBool:YES];
            } else {
                managedMessage.isRead = [NSNumber numberWithBool:NO];
            }
            
            if (messageType == AXMessageTypePic) {
                [picMessageArray addObject:[managedMessage convertToMappedObject]];
            } else {
                [commonMessageArray addObject:[managedMessage convertToMappedObject]];
            }
            
            [messageArray addObject:[managedMessage convertToMappedObject]];
        }
        
        [self updateConversationListItemWithMessage:[messageArray firstObject]];
        
        NSDate *fetchedLastDate = [(AXMessage *)[messageArray lastObject] sendTime];
        NSTimeInterval timeInterval = [fetchedLastDate timeIntervalSinceDate:storedLastDate];
        if (timeInterval > 300 && [message.messageType integerValue] != AXMessageTypeSystemTime) {
            AXMessage *notificationMessage = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
            notificationMessage.accountType = [NSString stringWithFormat:@"%d", AXPersonTypeServer];
            NSDateFormatter *dateFormatrer = [[NSDateFormatter alloc] init];
            dateFormatrer.dateFormat = @"HH:mm:ss";
            dateFormatrer.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            notificationMessage.content = [dateFormatrer stringFromDate:fetchedLastDate];
            notificationMessage.from = friendUID;
            notificationMessage.to = self.uid;
            notificationMessage.isImgDownloaded = [NSNumber numberWithBool:NO];
            if ([self.friendUid isEqualToString:friendUID]) {
                notificationMessage.isRead = [NSNumber numberWithBool:YES];
            } else {
                notificationMessage.isRead = [NSNumber numberWithBool:NO];
            }
            notificationMessage.isRemoved = [NSNumber numberWithBool:NO];
            notificationMessage.messageType = [NSNumber numberWithInteger:AXMessageTypeSystemTime];
            notificationMessage.sendTime = [NSDate dateWithTimeInterval:-0.01 sinceDate:[(AXMessage *)[messageArray firstObject] sendTime]];
            
            [messageArray insertObject:[notificationMessage convertToMappedObject] atIndex:0];
            [commonMessageArray insertObject:[notificationMessage convertToMappedObject] atIndex:0];
         }
        
        messageDictionary[friendUID] = [messageArray reverseSelf];
        splitedDictionary[friendUID] = @{@"pic":picMessageArray, @"other":commonMessageArray};
        
        if (![self isFriendWithFriendUid:friendUID]) {
            AXPerson *friend = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
            friend.uid = friendUID;
            [self.delegate dataCenter:self fetchPersonInfoWithUid:@[friendUID]];
        }
        
    }
    
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    
    if (self.friendUid) {
        CFStringRef state;
        UInt32 propertySize = sizeof(CFStringRef);
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
        
        if (CFStringGetLength(state) > 0) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        } else {
            AudioServicesPlaySystemSound(1015);
        }
    }
    
    [self.delegate dataCenter:self didReceiveMessages:splitedDictionary];
    
    return messageDictionary;
}

- (void)deleteMessageByIdentifier:(NSString *)identifier
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    if (message) {
        [self.managedObjectContext deleteObject:message];
    }
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
            return @"1";
        } else {
            return [NSString stringWithFormat:@"%@", lastMsgId];
        }
    } else {
        return @"1";
    }
    
    return nil;
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
    AXConversationListItem *conversationListItem = [self findConversationListItemWithFriendUID:friendUID];
    conversationListItem.draftContent = content;
    if ([content isEqualToString:@""]) {
        if (conversationListItem) {
            conversationListItem.hasDraft = [NSNumber numberWithBool:NO];
        }
    } else {
        if (!conversationListItem) {
            conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        }
        conversationListItem.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
        conversationListItem.hasDraft = [NSNumber numberWithBool:YES];
    }
    [self.managedObjectContext save:NULL];
}

- (NSInteger)totalUnreadMessageCount
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isRead = %@", [NSNumber numberWithBool:NO]];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
}

- (void)didLeaveChattingList
{
    self.friendUid = nil;
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
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastUpdateTime" ascending:NO]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem
{
    AXConversationListItem *listItem = [self findConversationListItemWithItem:conversationItem];
    NSString *friendUid = listItem.friendUid;
    
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
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@ AND to = %@", uid,uid];
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
    
    for (NSDictionary *mappedPerson in friendArray) {
        AXPerson *person = [self findPersonWithUID:mappedPerson[@"user_id"]];
        
        if (!person) {
            person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
            person.isPendingForRemove = [NSNumber numberWithBool:NO];
            person.isStar = [NSNumber numberWithBool:NO];
            person.isPendingForAdd = [NSNumber numberWithBool:NO];
        }
        
        person.created = [NSDate dateWithTimeIntervalSince1970:[mappedPerson[@"created"] integerValue]];
#warning todo
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
    
    [personToUpdate assignPropertiesFromMappedObject:person];
    [self.managedObjectContext save:NULL];
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
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
    
    AXConversationListItemType itemType;
    AXMessageType messageType = [message.messageType integerValue];
    NSString *messageTip;
    if (messageType == AXMessageTypeSettingNotifycation || messageType == AXMessageTypeSystemForbid || messageType == AXMessageTypeSystemTime || messageType == AXMessageTypeAddNuckName) {
        shouldUpdateConversationListItem = NO;
    }
    
    if (messageType == AXMessageTypePic) {
        itemType = AXConversationListItemTypePic;
        messageTip = @"你收到一张图片";
    }
    
    if (messageType == AXMessageTypeProperty) {
        NSDictionary *messageContent = [NSJSONSerialization JSONObjectWithData:[message.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        messageTip = @"你收到一个房源";
        NSInteger propertyType = [messageContent[@"tradeType"] integerValue];
        if (propertyType == 1) {
            itemType = AXConversationListItemTypeESFProperty;
        } else {
            itemType = AXConversationListItemTypeHZProperty;
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
        AXMappedConversationListItem *item = [[AXMappedConversationListItem alloc] init];
        item.friendUid = friendUID;
        AXConversationListItem *conversationListItem = [self findConversationListItemWithItem:item];
        if (!conversationListItem) {
            conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
            AXPerson *person = [self findPersonWithUID:friendUID];
            conversationListItem.iconPath = person.iconPath;
            conversationListItem.isIconDownloaded = person.isIconDownloaded;
            conversationListItem.iconUrl = person.iconUrl;
            if ([person.markName length] > 0) {
                conversationListItem.presentName = person.markName;
            } else {
                conversationListItem.presentName = person.name;
            }
        }
        
        conversationListItem.messageType = @(itemType);
        conversationListItem.lastMsgIdentifier = message.identifier;
        conversationListItem.lastUpdateTime = message.sendTime;
        conversationListItem.messageTip = messageTip;
        conversationListItem.friendUid = friendUID;
        conversationListItem.count = [NSNumber numberWithInteger:[self countUnreadMessagesWithFriendUid:friendUID]];
        conversationListItem.messageStatus = message.sendStatus;
        
        __autoreleasing NSError *error;
        [self.managedObjectContext save:&error];
        NSLog(@"%@", error);
    }
}

- (AXMessage *)findMessageWithIdentifier:(NSString *)identifier
{
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

- (AXConversationListItem *)findConversationListItemWithItem:(AXMappedConversationListItem *)conversationListItem
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friendUid = %@", conversationListItem.friendUid];
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
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:NO]];
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

@end
