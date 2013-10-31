//
//  PropertyDetailCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "PropertyDetailCell.h"
#import "Util_UI.h"

@implementation PropertyDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 20)];
        title.text = @"最好的房子";
        title.textColor = [Util_UI colorWithHexString:@"#333333"];
        communityName = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 150, 20)];
        communityName.textColor = [Util_UI colorWithHexString:@"#666666"];
        communityName.text = @"明日社区";
        communityName.font = [UIFont systemFontOfSize:12];
        price = [[UILabel alloc] initWithFrame:CGRectMake(210, 45, 150, 20)];
        price.textColor = [UIColor grayColor];
        price.text = @"-190万";
        price.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:title];
        [self.contentView addSubview:communityName];
//        [self.contentView addSubview:price];
    }
    return self;
}
-(void)setValueForCellByObject:(PropertyObject *) obj{
    title.text = obj.title;
    communityName.text = obj.communityName;
    price.text = obj.price;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
