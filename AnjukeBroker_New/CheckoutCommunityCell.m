//
//  CheckoutCommunityCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutCommunityCell.h"
#import "CheckCommunityModel.h"
#import "UIFont+RT.h"
#import "UIColor+BrokerRT.h"

#define CHECKOUTSTATEFRAME CGRectMake(200,0,90,45)

@implementation CheckoutCommunityCell
@synthesize checkStatusLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.checkStatusLab = [[UILabel alloc] initWithFrame:CHECKOUTSTATEFRAME];
    self.checkStatusLab.textAlignment = NSTextAlignmentRight;
    self.checkStatusLab.textColor = [UIColor brokerBlueColor];
    self.checkStatusLab.backgroundColor = [UIColor clearColor];
    self.checkStatusLab.font = [UIFont ajkH3Font];
    [self.contentView addSubview:self.checkStatusLab];    

    
}
- (BOOL)configureCell:(id)dataModel withIndex:(int)index{
    CheckCommunityModel *model = (CheckCommunityModel *)dataModel;
    if (model) {
        self.textLabel.text = [NSString stringWithFormat:@"%@",model.commName];
        self.textLabel.textColor = [UIColor brokerBlackColor];
        self.textLabel.font = [UIFont ajkH2Font_B];
        self.checkStatusLab.text = model.signAble ? @"已签到" : @"";        
    }
    return YES;
}

@end
