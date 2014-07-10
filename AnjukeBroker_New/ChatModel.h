//
//  ChatModel.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedConversationListItem.h"

@interface ChatModel : NSObject

+ (NSString *)getMessageListCellWithItem:(AXMappedConversationListItem *)item;

@end
