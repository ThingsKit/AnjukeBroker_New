//
//  UserCenterCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
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

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
}

- (void)initLabelTitle:(NSString *)title{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.text = title;
    self.textLabel.textColor = [UIColor brokerBlackColor];
    self.textLabel.font = [UIFont ajkH2Font];
}

- (void)showTightIcon{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:ICONFRAME];
    [icon setImage:nil];
    icon.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:icon];
}
- (void)setDetailText:(NSString *)detailStr rightSpace:(float)rightSpace{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake([self windowWidth]-170-rightSpace, 1,  170, CELL_HEIGHT - 2)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor brokerBlackColor];
    lb.textAlignment = NSTextAlignmentRight;
    lb.font = [UIFont ajkH2Font];
    lb.text = detailStr;
    [self.contentView addSubview:lb];
}
- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

@end     
