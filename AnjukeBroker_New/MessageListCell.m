//
//  MessageListCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell
@synthesize imageIcon, nameLb, messageLb, timeLb;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 12, icon.frame.origin.y, 150, 20)];
    self.nameLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - CELL_OFFSET_TITLE - 70, icon.frame.origin.y, 70, 20)];
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
}

- (BOOL)configureCell:(id)dataModel {
    [self cleanValue];
    
    self.imageIcon.imageUrl = @"";
    self.nameLb.text = @"珍珍阿姨";
    self.timeLb.text = @"11:00";
    self.messageLb.text = @"有新房子了你造吗，1折1000万要不要";
    
    return YES;
}

- (void)cleanValue {
    self.imageIcon.image = nil;
    self.nameLb.text = @"";
    self.timeLb.text = @"";
    self.messageLb.text = @"";
}

@end
