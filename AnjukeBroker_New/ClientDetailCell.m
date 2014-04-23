//
//  ClientDetailCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailCell.h"
#import "AXMappedPerson.h"

#define DETAIL_LB_W 190

@implementation ClientDetailCell
@synthesize titleLb, detailTV, phoneIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = [self baseCellBackgroundView];
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
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundView = [self baseCellBackgroundView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, 12, 70, 20)];
    self.titleLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_LIGHT_GRAY;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    UITextView *messageLabel = [[UITextView alloc] init];
    self.detailTV = messageLabel;
    messageLabel.userInteractionEnabled = NO;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = SYSTEM_BLACK;
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.contentMode = UIViewContentModeTop;
    [self.contentView addSubview:messageLabel];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_PHONEICON, 7, 30, 30)];
    self.phoneIcon = phoneImgView;
    phoneImgView.image = [UIImage imageNamed:@""];
    phoneImgView.backgroundColor = [UIColor lightGrayColor];
    phoneImgView.hidden = YES;
    [self.contentView addSubview:phoneImgView];
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index isBlankStyle:(BOOL)isBlankStyle{
    
    CGFloat lbH = 0;
    
    AXMappedPerson *item = (AXMappedPerson *)dataModel;
    
    switch (index) {
        case 0:
        {
            lbH = 30;
            if (isBlankStyle) {
                self.titleLb.text = @"请添加备注信息";
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                self.titleLb.text = @"电话号码";
                self.phoneIcon.hidden = NO;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self showTopLine];
            [self showBottonLineWithCellHeight:CLIENT_DETAIL_TEL_HEIGHT];
        }
            break;
        case 1:
        {
            lbH = 65;
            self.titleLb.text = @"备注信息";
            
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [self showBottonLineWithCellHeight:CLIENT_DETAIL_MESSAGE_HEIGHT];
        }
            break;
            
        default:
            break;
    }
    
    if (index == 0 && isBlankStyle) {
        self.titleLb.frame = CGRectMake(CELL_OFFSET_TITLE, 12, 170, 20);
    }
    self.detailTV.frame = CGRectMake(self.titleLb.frame.origin.x + 70+ CELL_OFFSET_TITLE, 5, DETAIL_LB_W, lbH );
    
    if (index == 1) {
        self.titleLb.frame = CGRectMake(CELL_OFFSET_TITLE, 32, 70, 20);
        self.detailTV.frame = CGRectMake(self.titleLb.frame.origin.x + 70+ CELL_OFFSET_TITLE, 8, DETAIL_LB_W, lbH );
    }
    
    if (!isBlankStyle) {
        if (index == 0) {
            self.detailTV.text = item.markPhone;
        }
        else
            self.detailTV.text = item.markDesc;
    }
    
    return YES;
}

@end
