//
//  CheckoutCommunityCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutCommunityCell.h"

#define CHECKOUTSTATEFRAME CGRectMake(200,0,90,48)

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
    self.checkStatusLab.textColor = [UIColor greenColor];
    self.checkStatusLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.checkStatusLab];    
}
- (BOOL)configureCell:(id)dataModel withIndex:(int)index{
    self.textLabel.text = [NSString stringWithFormat:@"东方曼哈顿%d",index];
    
    if (index%3 == 0) {
        self.checkStatusLab.text = @"已经签到";
    }else{
        self.checkStatusLab.text = @"";
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
