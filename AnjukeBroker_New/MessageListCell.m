//
//  MessageListCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MessageListCell.h"
#import "AXMappedConversationListItem.h"
#import "ChatModel.h"
#import "Util_TEXT.h"

@implementation MessageListCell
@synthesize imageIcon, nameLb, messageLb, timeLb;
@synthesize iconNumLb, statusIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initUI {
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, (MESSAGE_LIST_HEIGHT - IMG_ICON_H)/2, IMG_ICON_H, IMG_ICON_H)];
    self.imageIcon = icon;
    icon.layer.cornerRadius = 5;
    icon.layer.borderColor = SYSTEM_LIGHT_GRAY.CGColor;
    icon.layer.borderWidth = 0.5;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:icon];
    
    CGFloat iconLbW = 18;
    UILabel *iconLb = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x +icon.frame.size.width - iconLbW/2, icon.frame.origin.y -iconLbW/4, iconLbW, iconLbW)];
    iconLb.backgroundColor = SYSTEM_ZZ_RED;
    iconLb.textColor = [UIColor whiteColor];
    iconLb.layer.cornerRadius = iconLbW/2;
    iconLb.font = [UIFont systemFontOfSize:12];
    iconLb.textAlignment = NSTextAlignmentCenter;
    self.iconNumLb = iconLb;
    [self.contentView addSubview:iconLb];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 12, 14, 150, 20)];
    self.nameLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - CELL_OFFSET_TITLE - 70, 14, 70, 20)];
    self.timeLb = timeLabel;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = SYSTEM_LIGHT_GRAY;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    CGFloat messageLabelH = 15;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, MESSAGE_LIST_HEIGHT - icon.frame.origin.y - messageLabelH, 240, messageLabelH)];
    self.messageLb = messageLabel;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = SYSTEM_LIGHT_GRAY;
    messageLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:messageLabel];
    
    //消息状态
    UIImageView *statusImg = [[UIImageView alloc] init];
    statusImg.backgroundColor = [UIColor clearColor];
    self.statusIcon = statusImg;
    [self.contentView addSubview:statusImg];
}

- (BOOL)configureCell:(id)dataModel {
    
    DLog(@"messageListCellData [%@]", dataModel);
    
    [self cleanValue];
    
    AXMappedConversationListItem *item = (AXMappedConversationListItem *)dataModel;
    
    if (item.iconUrl) {
        if (item.isIconDownloaded) {
            self.imageIcon.image = [UIImage imageWithContentsOfFile:item.iconPath];
        }
        else {
            self.imageIcon.imageUrl = item.iconUrl;
        }
    }
    else {
        self.imageIcon.image = [UIImage imageNamed:@""];
    }
    
    self.nameLb.text = [NSString stringWithFormat:@"%@", item.presentName];
    self.timeLb.text = [Util_TEXT getDateStrWithDate:item.lastUpdateTime];
    self.messageLb.text = item.messageTip;
    
    self.iconNumLb.text = [NSString stringWithFormat:@"%d", item.count];
    
    return YES;
}

- (void)cleanValue {
    self.imageIcon.image = nil;
    self.nameLb.text = @"";
    self.timeLb.text = @"";
    self.messageLb.text = @"";
    self.iconNumLb.text = @"";
}

@end
