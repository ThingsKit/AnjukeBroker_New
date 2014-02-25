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

@interface AXChatDataCenter ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *uid;

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
    uid = @"1";
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

#pragma mark - test methods
- (void)fetchData
{
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    [tempManagedObjectContext performBlock:^{
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:tempManagedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        
        __autoreleasing NSError *error = nil;
        
        NSArray *result = [tempManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([result count] <= 0) {
            NSLog(@"error %@", error);
        }
    }];
}

- (void)writeData
{
    for (int count = 0; count < 200; count++) {
        AXMessage *message = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
        if (count % 2 == 0) {
            message.from = @"2";
            message.to = @"1";
        } else {
            message.from = @"1";
            message.to = @"2";  
        }
        message.messageId = @(count);
        message.sendTime = [NSDate dateWithTimeIntervalSinceNow:count];
        message.content = [NSString stringWithFormat:@"content: %d", count];
        __autoreleasing NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"%@", error);
        }
    }
    
    for (int i = 0; i < 10; i++) {
        AXConversationListItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        item.count = @(i);
        item.friendUid = @"123";
        item.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:-3600*5*i];
        item.messageTip = [NSString stringWithFormat:@"%d %d",i,i];
        item.messageType = @(arc4random() %6 + 1);
        item.presentName = [NSString stringWithFormat:@"Person:%d",i];
        item.iconUrl = @"http://imgstatic.baidu.com/img/image/d833c895d143ad4bf450b6dd80025aafa40f06b4_副本.jpg";
        item.messageStatus = @(arc4random() %3 + 1);
    }
    
    
    {
        AXPerson *person1 = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        
        person1.name = @"田大师";
        person1.namePinyin = @"tiandashi";
        person1.uid = @"123";
        
        AXPerson *person2 = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        
        person2.name = @"小豪豪";
        person2.namePinyin = @"xiaohaohao";
        person2.uid = @"234";
        
        AXPerson *person3 = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        
        person3.name = @"小峰峰";
        person3.namePinyin = @"xiaofengfeng";
        person3.uid = @"345";
        
        AXPerson *person4 = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        
        person4.name = @"王老板";
        person4.namePinyin = @"wanglaoban";
        person4.uid = @"456";
        
        AXPerson *person5 = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
        
        person5.name = @"110";
        person5.namePinyin = @"110";
        person5.uid = @"567";
    }
    
//    AXPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
//    person.name = @"xx";
//    person.uid = @"43";
//    person.phone = @"133333333339";
//    
//    AXPerson *broker = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
//    broker.name = @"yuki";
//    broker.uid = @"2";
//    broker.phone = @"13245678901";
    
    __autoreleasing NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", error);
    }
}

- (void)test
{
}

#pragma mark - public methods
- (NSArray *)addMessageWithArray:(NSArray *)receiceArray
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in receiceArray) {
        NSString *friendUID = item[@"from_uid"];
        for (NSDictionary *message in item[@"messages"]) {

            AXMessageType messageType = [message[@"msg_type"] integerValue];
            AXMessageCenterSendMessageStatus messageSendStatus = AXMessageCenterSendMessageStatusSuccessful;
            NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];

            AXMessage *managedMessage = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];

            if (messageType == AXMessageTypePic) {
#warning todo
                managedMessage.imgPath = @"";
                managedMessage.imgUrl = @"";
                managedMessage.thumbnailImgPath = @"";
                managedMessage.thumbnailImgUrl = @"";
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:YES];
            } else {
                managedMessage.imgPath = @"";
                managedMessage.imgUrl = @"";
                managedMessage.thumbnailImgPath = @"";
                managedMessage.thumbnailImgUrl = @"";
                managedMessage.isImgDownloaded = [NSNumber numberWithBool:YES];
            }

            managedMessage.accountType = message[@"account_type"];
            managedMessage.content = message[@"body"];
            managedMessage.from = friendUID;
            managedMessage.isRead = [NSNumber numberWithBool:YES];
            managedMessage.isRemoved = [NSNumber numberWithBool:NO];
            managedMessage.messageId = @([message[@"msg_id"] integerValue]);
            managedMessage.messageType = @(messageType);
            managedMessage.sendStatus = @(messageSendStatus);
            managedMessage.sendTime = lastUpdateTime;
            managedMessage.to = message[@"to_uid"];
            
            [messageArray addObject:[managedMessage convertToMappedObject]];
            
            [self addConversationListItemWithMessage:[managedMessage convertToMappedObject]];
        }
    }
    
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    return messageArray;
}

- (NSString *)lastMsgId
{
    [self conversationListFetchedResultController];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"messageId > 0"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    fetchRequest.fetchLimit = 1;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    AXMessage *message = [result lastObject];
    if ([result count] <= 0) {
        return @"1";
    } else {
        return [NSString stringWithFormat:@"%@", message.messageId];
    }
}

- (void)fetchChatListByLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize;
{
    NSString *friendUID = nil;
    if ([lastMessage.from isEqualToString:self.uid]) {
        friendUID = lastMessage.to;
    } else {
        friendUID = lastMessage.from;
    }

    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;

    [tempManagedObjectContext performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:tempManagedObjectContext];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:NO]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sendTime <= %@ AND ( from = %@ OR to = %@ )", lastMessage.sendTime, friendUID, friendUID];
        fetchRequest.fetchLimit = pageSize;
        __autoreleasing NSError *error;
        NSArray *result = [tempManagedObjectContext executeFetchRequest:fetchRequest error:&error];

        NSMutableArray *mappedResult = [[NSMutableArray alloc] initWithCapacity:0];
        for (AXMessage *message in result) {
            [mappedResult addObject:[message convertToMappedObject]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dataCenter:self didFetchChatList:mappedResult withFriend:[self fetchPersonWithUID:friendUID] lastMessage:lastMessage];
        });
    }];
}
- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID
{
    AXConversationListItem *conversationListItem = [self findConversationListItemWithFriendUID:friendUID];
    if (!conversationListItem) {
        conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    }
    conversationListItem.messageType = @(AXConversationListItemTypeDraft);
    conversationListItem.messageTip = content;
    [self.managedObjectContext save:NULL];
}

- (NSFetchedResultsController *)conversationListFetchedResultController
{
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastUpdateTime" ascending:NO]];
    
    __autoreleasing NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%@", error);
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (NSArray *)fetchFriendList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid != %@", self.uid];
    NSArray *fetchedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    for (AXPerson *person in fetchedResult) {
        [result addObject:[person convertToMappedPerson]];
    }
    return result;
}

- (void)saveFriendListWithPersonArray:(NSArray *)friendArray
{
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    [tempManagedObjectContext performBlock:^{
        
        for (AXMappedPerson *mappedPerson in friendArray) {
            AXPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:tempManagedObjectContext];
            [person assignPropertiesFromMappedObject:mappedPerson];
        }
        
        [tempManagedObjectContext save:NULL];
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext save:NULL];
        }];
    }];
}

- (AXMappedMessage *)addMessage:(AXMappedMessage *)message saveImmediatly:(BOOL)save
{
    AXMessage *messageToInsert = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    [messageToInsert assignPropertiesFromMappedObject:message];
    
    [self addConversationListItemWithMessage:message];
    
    if (save) {
        __autoreleasing NSError *error;
        [self.managedObjectContext save:&error];
        return [messageToInsert convertToMappedObject];
    } else {
        return nil;
    }
}

- (void)addConversationListItemWithMessage:(AXMappedMessage *)message
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
        itemType = AXConversationListItemTypeESFProperty;
        messageTip = @"你收到一个房源";
#warning todo check the message property type
    }
    if (messageType == AXMessageTypeText) {
        itemType = AXConversationListItemTypeText;
        messageTip = message.content;
    }
    if (messageType == AXMessageTypePublicCard) {
        itemType = AXConversationListItemTypeCard;
#warning todo 给出卡片的title
        messageTip = @"你收到一条消息";
    }
    
    if (shouldUpdateConversationListItem) {
        AXMappedConversationListItem *item = [[AXMappedConversationListItem alloc] init];
        item.friendUid = friendUID;
        AXConversationListItem *conversationListItem = [self findConversationListItemWithItem:item];
        if (conversationListItem) {
            if (!message.isRead) {
                conversationListItem.count = @([conversationListItem.count integerValue] + 1);
            }
        } else {
            conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
            if (!message.isRead) {
                conversationListItem.count = @(0);
            } else {
                conversationListItem.count = @(1);
            }
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
        conversationListItem.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
        conversationListItem.messageTip = messageTip;
        conversationListItem.friendUid = friendUID;
        
        __autoreleasing NSError *error;
        [self.managedObjectContext save:&error];
        NSLog(@"%@", error);
    }
}

- (void)deleteMessageByIdentifier:(NSString *)identifier
{
    AXMessage *message = [self findMessageWithIdentifier:identifier];
    message.isRemoved = [NSNumber numberWithBool:YES];
    [self updateMessage:[message convertToMappedObject]];
}

- (void)updateMessage:(AXMappedMessage *)message
{
    AXMessage *messageToUpdate = [self findMessageWithIdentifier:message.identifier];
    [messageToUpdate assignPropertiesFromMappedObject:message];
    [self.managedObjectContext save:NULL];
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

- (void)addFriend:(AXMappedPerson *)person
{
    AXPerson *personToInsert = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    [personToInsert assignPropertiesFromMappedObject:person];
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    NSLog(@"%@", error);
}

- (void)deleteFriend:(AXMappedPerson *)person
{
    AXPerson *personToDelete = [self findPersonWithUID:person.uid];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@ OR to = %@", person.uid];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    
    [tempManagedObjectContext performBlock:^{
        for (NSManagedObject *object in result) {
            [tempManagedObjectContext deleteObject:object];
        }
        [tempManagedObjectContext deleteObject:personToDelete];
        [tempManagedObjectContext save:NULL];
        
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext save:NULL];
        }];
    }];
    
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

- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem
{
    AXConversationListItem *listItem = [self findConversationListItemWithItem:conversationItem];
    [self.managedObjectContext deleteObject:listItem];
    [self.managedObjectContext save:NULL];
}

- (AXMappedPerson *)fetchCurrentPerson
{
    return [self fetchPersonWithUID:self.uid];
}

- (void)successDeletePerson:(NSString *)uid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@ OR to = %@", uid];
    fetchRequest.entity = [NSEntityDescription entityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    NSArray *relatedMessages = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *message in relatedMessages) {
        [self.managedObjectContext deleteObject:message];
    }
    
    AXPerson *person = [self findPersonWithUID:uid];
    [self.managedObjectContext deleteObject:person];
    
    AXConversationListItem *conversationListItem = [self findConversationListItemWithFriendUID:uid];
    [self.managedObjectContext deleteObject:conversationListItem];
    
    [self.managedObjectContext save:NULL];
}

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

#pragma mark - private methods
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

@end
