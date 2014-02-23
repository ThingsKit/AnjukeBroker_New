//
//  AXConversationListItem.h
//  Anjuke2
//
//  Created by casa on 14-2-23.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AXMappedConversationListItem.h"

@class AXPerson;

@interface AXConversationListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * messageTip;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) AXPerson *fromPerson;
@property (nonatomic, retain) AXPerson *toPerson;

- (AXMappedConversationListItem *)convertToMappedObject;
- (void)assignPropertiesFromMappedObject:(AXMappedConversationListItem *)mappedConversationListItem;

@end
