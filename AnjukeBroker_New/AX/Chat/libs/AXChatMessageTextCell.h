//
//  AJKChatMessageTextCell.h
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageAvatarCell.h"

static NSInteger const kAttributedLabelTag = 100;
static CGFloat const kLabelWidth = 200;
static CGFloat const kLabelVMargin = 10;

typedef NS_ENUM(NSUInteger,AXChatCellViewType )
{
    AXChatCellViewTypePhoneAlert,
    AXChatCellViewTypePhoneAction
};


@interface AXChatMessageTextCell : AXChatMessageAvatarCell

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDictionary *cellData;

@end
