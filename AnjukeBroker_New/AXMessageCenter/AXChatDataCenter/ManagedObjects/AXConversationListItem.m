//
//  AXConversationListItem.m
//  Anjuke2
//
//  Created by casa on 14-2-23.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXConversationListItem.h"
#import "AXPerson.h"


@implementation AXConversationListItem

@dynamic count;
@dynamic createTime;
@dynamic from;
@dynamic lastUpdateTime;
@dynamic messageTip;
@dynamic messageType;
@dynamic to;
@dynamic fromPerson;
@dynamic toPerson;

- (AXMappedConversationListItem *)convertToMappedObject
{
    AXMappedConversationListItem *mappedConversationListItem = [[AXMappedConversationListItem alloc] init];
    mappedConversationListItem.count = self.count;
    mappedConversationListItem.createTime = self.createTime;
    mappedConversationListItem.from = self.from;
    mappedConversationListItem.lastUpdateTime = self.lastUpdateTime;
    mappedConversationListItem.messageTip = self.messageTip;
    mappedConversationListItem.to = self.to;
    mappedConversationListItem.fromPerson = [self.fromPerson convertToMappedPerson];
    mappedConversationListItem.toPerson = [self.toPerson convertToMappedPerson];
    return mappedConversationListItem;
}

- (void)assignPropertiesFromMappedObject:(AXMappedConversationListItem *)mappedConversationListItem
{
    self.count = mappedConversationListItem.count;
    self.createTime = mappedConversationListItem.createTime;
    self.from = mappedConversationListItem.from;
    self.lastUpdateTime = mappedConversationListItem.lastUpdateTime;
    self.messageTip = mappedConversationListItem.messageTip;
    self.to = mappedConversationListItem.to;
}

@end
