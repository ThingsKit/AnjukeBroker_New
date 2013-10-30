//
//  NoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanListCell.h"

@implementation BaseNoPlanListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 250, 20)];
        
        communityName = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 150, 20)];
        communityName.textColor = [UIColor grayColor];
        communityName.font = [UIFont systemFontOfSize:12];
        price = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 150, 20)];
        price.textColor = [UIColor grayColor];
        price.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:title];
        [self.contentView addSubview:communityName];
        [self.contentView addSubview:price];
        // Initialization code
    }
    return self;
}
-(void)setValueForTableCell{
    title.text = @"绝世好房";
    communityName.text = @"天涯小区";
    price.text = @"250万";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
