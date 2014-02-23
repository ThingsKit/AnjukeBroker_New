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
    AXPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    person.name = @"casa";
    person.uid = @"1";
    person.phone = @"12345678901";
    
    AXPerson *broker = [NSEntityDescription insertNewObjectForEntityForName:@"AXPerson" inManagedObjectContext:self.managedObjectContext];
    broker.name = @"yuki";
    broker.uid = @"2";
    broker.phone = @"13245678901";
    
    __autoreleasing NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", error);
    }
}

- (void)test
{
    
}

#pragma mark - public methods
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
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
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

- (NSFetchedResultsController *)conversationListFetchedResultController
{
    NSManagedObjectContext *tempManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempManagedObjectContext.parentContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"last_update_time" ascending:YES]];
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

- (AXMappedMessage *)addMessage:(AXMappedMessage *)message
{
    AXMessage *messageToInsert = [NSEntityDescription insertNewObjectForEntityForName:@"AXMessage" inManagedObjectContext:self.managedObjectContext];
    [messageToInsert assignPropertiesFromMappedObject:message];
    
    AXMappedConversationListItem *item = [[AXMappedConversationListItem alloc] init];
    item.from = message.from;
    AXConversationListItem *conversationListItem = [self findConversationListItemWithItem:item];
    if (conversationListItem) {
        conversationListItem.count = @([conversationListItem.count integerValue] + 1);
    } else {
        conversationListItem = [NSEntityDescription insertNewObjectForEntityForName:@"AXConversationListItem" inManagedObjectContext:self.managedObjectContext];
        conversationListItem.count = @(0);
        conversationListItem.createTime = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    
    conversationListItem.from = message.from;
    conversationListItem.to = message.to;
    conversationListItem.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
    conversationListItem.messageTip = @"收到一条新消息";
    
    __autoreleasing NSError *error;
    [self.managedObjectContext save:&error];
    return [messageToInsert convertToMappedObject];
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
    [self.managedObjectContext save:NULL];
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

- (void)failedToDeletePerson:(NSString *)uid
{
#warning todo 应该是成功之后做回调，然后从数据库中删除数据，在将要删除好友的时候，数据库只是把人的被删除的属性设置一下。
//    AXPerson *personToDelete = [self findPersonWithUID:uid];
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
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"from = %@", conversationListItem.from];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if ([result count] > 0) {
        return [result firstObject];
    } else {
        return nil;
    }
}

@end
