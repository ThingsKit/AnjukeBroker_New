//
//  BidPropertyListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BidPropertyListCell.h"

@implementation BidPropertyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *bidStatus = [[UILabel alloc] initWithFrame:CGRectMake(90, 75, 60, 20)];
        bidStatus.text = @"排队中";
        bidStatus.font = [UIFont systemFontOfSize:12];
        bidStatus.layer.cornerRadius = 6;
        [bidStatus setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:bidStatus];
        
        UILabel *bidValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 75, 100, 20)];
        bidValue.text = @"当前排名：第5名";
        [bidValue setBackgroundColor:[UIColor clearColor]];
        bidValue.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:bidValue];
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

@end
