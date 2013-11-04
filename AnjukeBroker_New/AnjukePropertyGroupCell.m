//
//  AnjukePropertyGroupCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukePropertyGroupCell.h"
#import "Util_UI.h"

#define TITLE_OFFESTX 17

@implementation AnjukePropertyGroupCell
@synthesize groupNameLb, limitPriceLb, statusIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    return self;
}

- (void)initUI {
    CGFloat lbW = 150;
    CGFloat lbFont = 15;
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 5, lbW, 20)];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont systemFontOfSize:lbFont];
    lb1.textColor = SYSTEM_BLACK;
    self.groupNameLb = lb1;
    [self.contentView addSubview:lb1];

    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 5 *2 + lb1.frame.size.height, 250, 20)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.font = [UIFont systemFontOfSize:lbFont];
    lb2.textColor = SYSTEM_LIGHT_GRAY;
    self.limitPriceLb = lb2;
    [self.contentView addSubview:lb2];
    
    CGFloat imgW = 60/2;
    CGFloat imgH = 26/2;
    UIImageView *lb3 = [[UIImageView alloc] initWithFrame:CGRectMake(320 - TITLE_OFFESTX*1.5-imgW, (PROPERTY_GROUP_CELL-imgH)/2, imgW, imgH)];
    lb3.backgroundColor = [UIColor clearColor];
    lb3.contentMode = UIViewContentModeScaleAspectFit;
    self.statusIcon = lb3;
    [self.contentView addSubview:lb3];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)configureCell:(id)dataModel {
//    if (![dataModel isKindOfClass:[NSDictionary class]]) {
//        return NO;
//    }
//    
//    NSDictionary *dic = nil;
//    if (dataModel != nil) {
//        dic = (NSDictionary *)dataModel;
//    }
    
    //test
    self.groupNameLb.text = @"定价组1（20）";
    self.limitPriceLb.text = @"房源数:20套    每日限额30元";
    
    self.statusIcon.image = STATUS_OK_ICON;
    
    return YES;
}

@end
