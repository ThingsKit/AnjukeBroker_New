//
//  ChatModel.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

+ (NSString *)getMessageListCellWithItem:(AXMappedConversationListItem *)item {
    NSString *str = [NSString string];
    
    str = [item presentName];
    
    return str;
}

@end
