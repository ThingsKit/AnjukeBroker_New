//
//  AJKChatMessageTextCell.h
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRootCell.h"

static CGFloat const kLabelWidth = 200;
static CGFloat const kLabelVMargin = 10;


@interface AXChatMessageTextCell : AXChatMessageRootCell

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDictionary *cellData;

@end
