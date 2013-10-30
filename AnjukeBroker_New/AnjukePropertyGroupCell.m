//
//  AnjukePropertyGroupCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukePropertyGroupCell.h"

#define TITLE_OFFESTX 13

@implementation AnjukePropertyGroupCell
@synthesize groupNameLb, limitPriceLb, statusLb;

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
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat lbW = 150;
    CGFloat lbFont = 17;
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 5, lbW, 30)];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont systemFontOfSize:lbFont];
    lb1.textColor = [UIColor blackColor];
    self.groupNameLb = lb1;
    [self.contentView addSubview:lb1];

    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 5 *2 + lb1.frame.size.height, lbW, 30)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.font = [UIFont systemFontOfSize:lbFont];
    lb2.textColor = [UIColor lightGrayColor];
    self.limitPriceLb = lb2;
    [self.contentView addSubview:lb2];
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(320 - TITLE_OFFESTX-65, (PROPERTY_GROUP_CELL-15)/2, 47, 15)];
    lb3.backgroundColor = [UIColor clearColor];
    lb3.font = [UIFont boldSystemFontOfSize:12];
    lb3.textColor = [UIColor whiteColor];
    lb3.layer.cornerRadius = 3;
    lb3.textAlignment = NSTextAlignmentCenter;
    self.statusLb = lb3;
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
    self.limitPriceLb.text = @"每日限额30元";
    
    self.statusLb.backgroundColor = [UIColor colorWithRed:0.36 green:0.8 blue:0.25 alpha:1];
    self.statusLb.text = @"推广中";
    
    return YES;
}

@end
