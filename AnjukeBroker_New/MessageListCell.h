//
//  MessageListCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"
#import "BK_WebImageView.h"
#import "AXConversationListItem.h"

#define MESSAGE_LIST_HEIGHT 65

#define IMG_ICON_H 40

@interface MessageListCell : RTListCell

@property (nonatomic, strong) BK_WebImageView *imageIcon;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *messageLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *iconNumLb;

@property (nonatomic, strong) UIImageView *statusIcon;
@property (nonatomic, strong) UILabel *statusLabel;

- (void)setMessageShowWithData:(AXConversationListItem *)item;

@end
