//
//  AXMappedConversationListItem.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedPerson.h"
#import "AXMappedMessage.h"

typedef NS_ENUM(NSUInteger, AXConversationListItemType)
{
    AXConversationListItemTypeText = 1,
    AXConversationListItemTypePic = 2,
    AXConversationListItemTypeCard = 3,

    AXConversationListItemTypeESFProperty = 4,
    AXConversationListItemTypeHZProperty = 5,
    
    AXConversationListItemTypeVoice = 6,
    AXConversationListItemTypeLocation = 7,
    AXConversationListItemTypeCommunity = 8
};

@interface AXMappedConversationListItem : NSObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * friendUid;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * messageTip;
@property (nonatomic) AXConversationListItemType messageType;
@property (nonatomic, retain) NSString * presentName;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * lastMsgIdentifier;
@property (nonatomic, retain) NSString * iconPath;
@property (nonatomic) BOOL isIconDownloaded;
@property (nonatomic) AXMessageCenterSendMessageStatus messageStatus;
@property (nonatomic, retain) NSString * draftContent;
@property (nonatomic) BOOL hasDraft;

@end
