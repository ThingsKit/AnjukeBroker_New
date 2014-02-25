//
//  AXMappedConversationListItem.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedPerson.h"

typedef NS_ENUM(NSUInteger, AXConversationListItemType)
{
    AXConversationListItemTypeText = 1,
    AXConversationListItemTypeDraft = 2,
    AXConversationListItemTypePic = 3,
    AXConversationListItemTypeCard = 4,
    AXConversationListItemTypeESFProperty = 5,
    AXConversationListItemTypeHZProperty = 6
};

@interface AXMappedConversationListItem : NSObject

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

@end
