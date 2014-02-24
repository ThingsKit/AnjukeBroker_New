//
//  AXConversationListItem.h
//  Anjuke2
//
//  Created by casa on 14-2-24.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AXMappedConversationListItem.h"

@interface AXConversationListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * friendUid;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * messageTip;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSString * presentName;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * lastMsgIdentifier;
@property (nonatomic, retain) NSString * iconPath;
@property (nonatomic, retain) NSNumber * isIconDownloaded;
@property (nonatomic, retain) NSNumber * messageStatus;

- (AXMappedConversationListItem *)convertToMappedObject;
- (void)assignPropertiesFromMappedObject:(AXMappedConversationListItem *)mappedConversationListItem;

@end
