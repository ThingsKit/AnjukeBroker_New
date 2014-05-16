//
//  UserCenterCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserCenterCell.h"

#define ICONFRAME CGRectMake(270,10,30,30)

@implementation UserCenterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)initLabelTitle:(NSString *)title{
    self.textLabel.text = title;
}

- (void)showTightIcon{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:ICONFRAME];
    [icon setImage:nil];
    icon.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:icon];
}
- (void)setDetailText:(NSString *)detailStr rightSpace:(float)rightSpace{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake([self windowWidth]-170-rightSpace, 1,  170, CELL_HEIGHT - 1*5)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor lightGrayColor];
    lb.textAlignment = NSTextAlignmentRight;
    lb.font = [UIFont systemFontOfSize:16];
    lb.text = detailStr;
    [self.contentView addSubview:lb];
}
- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

@end     
