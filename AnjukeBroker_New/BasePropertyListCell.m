//
//  PropertyListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BasePropertyListCell.h"
#import "PropertyObject.h"
#import "Util_UI.h"

@implementation BasePropertyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        tapNum = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        tapNum.backgroundColor = [UIColor clearColor];
        tapNum.textColor = [Util_UI colorWithHexString:@"#666666"];
        tapNum.font = [UIFont systemFontOfSize:12];
        tapNum.text = @"点击：50";
        [self.contentView addSubview:tapNum];
        
        tapNumStr = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 320, 20)];
        tapNumStr.backgroundColor = [UIColor clearColor];
        tapNumStr.font = [UIFont systemFontOfSize:12];
        tapNumStr.text = @"今日点击";
//        [self.contentView addSubview:tapNumStr];

        
        title = [[UILabel alloc] initWithFrame:CGRectMake(27, 10, 250, 20)];
        title.text = @"最好的房子";
        title.font = [UIFont systemFontOfSize:16];
        communityName = [[UILabel alloc] initWithFrame:CGRectMake(27, 45, 150, 20)];
        communityName.textColor = [Util_UI colorWithHexString:@"#666666"];
        communityName.text = @"明日社区";
        communityName.font = [UIFont systemFontOfSize:12];
        price = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 150, 20)];
        price.textColor = [UIColor grayColor];
        price.text = @"-190万";
        price.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:title];
        [self.contentView addSubview:communityName];
        [self.contentView addSubview:price];
        
        [self showUpArrowImg];
    }
    return self;
}
-(void)setValueForCellByObject:(PropertyObject *) obj{
    title.text = obj.title;
    communityName.text = obj.communityName;
    price.text = obj.price;
}
-(BOOL)configureCell:(id)dataModel{
    if([dataModel isKindOfClass:[PropertyObject class]]){
        PropertyObject *obj = (PropertyObject *)dataModel;
        title.text = obj.title;
        communityName.text = obj.communityName;
        price.text = obj.price;
        return YES;
    }
    return NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
