//
//  MessageListCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MessageListCell.h"
#import "ChatModel.h"
#import "Util_TEXT.h"

@implementation MessageListCell
@synthesize imageIcon, nameLb, messageLb, timeLb;
@synthesize iconNumLb, statusIcon, statusLabel;

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
//    [self.contentView addSubview:iconLb];
    
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
    
    UILabel *messageLabel = [[UILabel alloc] init];
    self.messageLb = messageLabel;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = SYSTEM_LIGHT_GRAY;
    messageLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:messageLabel];
    
    //消息状态
    UIImageView *statusImg = [[UIImageView alloc] init];
    statusImg.backgroundColor = [UIColor clearColor];
    self.statusIcon = statusImg;
//    [self.contentView addSubview:statusImg];
    
    //消息类型
    UILabel *statusLb = [[UILabel alloc] init];
    self.statusLabel = statusLb;
    statusLb.backgroundColor = [UIColor clearColor];
    statusLb.font = [UIFont systemFontOfSize:12];
    statusLb.textColor = SYSTEM_LIGHT_GRAY;
//    [self.contentView addSubview:statusLb];
}

- (BOOL)configureCell:(id)dataModel {
    
    DLog(@"messageListCellData [%@]", dataModel);
    
    [self cleanValue];
    
    AXConversationListItem *item = (AXConversationListItem *)dataModel;
    
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
    [self setMessageShowWithData:item];
    
    if ([item.count intValue] > 0) {
        self.iconNumLb.text = [item.count stringValue];
        [self.contentView addSubview:self.iconNumLb];
    }
    else
        [self.iconNumLb removeFromSuperview];
    
    return YES;
}

- (void)cleanValue {
    self.imageIcon.image = nil;
    self.nameLb.text = @"";
    self.timeLb.text = @"";
    self.messageLb.text = @"";
    
    self.iconNumLb.text = @"";
    self.statusIcon.image = nil;
    [self.statusIcon removeFromSuperview];
    self.statusLabel.text = @"";
    [self.statusLabel removeFromSuperview];
}

- (void)setMessageShowWithData:(AXConversationListItem *)item {    
    CGFloat messageLabelH = 15;
    CGFloat messageLabelW = 220;
    
    CGFloat iconW = 20;
    CGFloat iconH = 15;
    
    CGFloat offsetX = self.nameLb.frame.origin.x + self.frame.size.width;
    CGFloat offsetY = self.nameLb.frame.origin.y + self.nameLb.frame.size.height + 10;
    
    CGRect iconFrame = CGRectMake(offsetX, offsetY, iconW, iconH);
    CGRect messageFrame_icon = CGRectMake(offsetX + iconW, offsetY, messageLabelW, messageLabelH);
    CGRect messageFrame_noIcon = CGRectMake(offsetX + 0, offsetY, messageLabelW, messageLabelH);
    
    //草稿
    if ([item.hasDraft boolValue]) { //草稿
        self.messageLb.text = item.draftContent;
        self.messageLb.frame = messageFrame_icon;
        
        self.statusLabel.text = @"[草稿]";
        self.statusLabel.textColor = SYSTEM_ZZ_RED;
        self.statusLabel.frame = iconFrame;
        [self.contentView addSubview:self.statusLabel];
    }
    else {
        if ([item.messageType integerValue] == AXConversationListItemTypeText) {
            if ([item.messageStatus integerValue] == AXMessageCenterSendMessageStatusSuccessful) { //发送成功
                self.messageLb.frame = messageFrame_noIcon;
            }
            if ([item.messageStatus integerValue] == AXMessageCenterSendMessageStatusSending) { //发送中
                self.statusIcon.image = [UIImage imageNamed:@"anjuke_icon_fasonging.png"];
                self.statusIcon.frame = iconFrame;
            }
            else if ([item.messageStatus integerValue] == AXMessageCenterSendMessageStatusFailed) {
                self.statusIcon.image = [UIImage imageNamed:@"anjuke_icon_attention.png"];
                self.statusIcon.frame = iconFrame;
            }
            
            self.messageLb.text = item.messageTip;
        }
        else if ([item.messageType integerValue] == AXConversationListItemTypeCard) { //卡片
            
        }
        else if ([item.messageType integerValue] == AXConversationListItemTypeESFProperty) { //二手房
            self.messageLb.frame = messageFrame_icon;
            self.messageLb.text = @"";
            
            self.statusLabel.text = @"[二手房]";
            self.statusLabel.frame = iconFrame;
            [self.contentView addSubview:self.statusLabel];
        }
        else if ([item.messageType integerValue] == AXConversationListItemTypeHZProperty) { //租房
            self.messageLb.frame = messageFrame_icon;
            self.messageLb.text = @"";
            
            self.statusLabel.text = @"[租房]";
            self.statusLabel.frame = iconFrame;
            [self.contentView addSubview:self.statusLabel];
        }
        else if ([item.messageType integerValue] == AXConversationListItemTypePic) { //图片
            self.messageLb.frame = messageFrame_icon;
            self.messageLb.text = @"";
            
            self.statusLabel.text = @"[图片]";
            self.statusLabel.frame = iconFrame;
            [self.contentView addSubview:self.statusLabel];
        }
    }
}

@end
