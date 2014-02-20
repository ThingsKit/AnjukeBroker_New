//
//  ClientDetailCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailCell.h"

#define DETAIL_LB_W 200

@implementation ClientDetailCell
@synthesize titleLb, detailLb;

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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, 12, 70, 20)];
    self.titleLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_LIGHT_GRAY;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    self.detailLb = messageLabel;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = SYSTEM_BLACK;
    messageLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:messageLabel];
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    
    CGFloat lbH = 0;
    
    switch (index) {
        case 0:
        {
            lbH = 20;
            self.titleLb.text = @"电话号码";
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [self showBottonLineWithCellHeight:CLIENT_DETAIL_TEL_HEIGHT];
        }
            break;
        case 1:
        {
            lbH = 60;
            self.titleLb.text = @"备注信息";
            
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self showBottonLineWithCellHeight:CLIENT_DETAIL_MESSAGE_HEIGHT];
        }
            break;
            
        default:
            break;
    }
    
    self.detailLb.frame = CGRectMake(self.titleLb.frame.origin.x + self.titleLb.frame.size.width+ CELL_OFFSET_TITLE, self.titleLb.frame.origin.y, DETAIL_LB_W, lbH);
    self.detailLb.text = @"测试测试测试";
    
    return YES;
}

@end
