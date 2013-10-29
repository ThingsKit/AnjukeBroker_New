//
//  FixedDetailCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "FixedDetailCell.h"

@implementation FixedDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        content.backgroundColor = [UIColor clearColor];
        
        tapNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 20)];
        tapNum.backgroundColor = [UIColor clearColor];
        tapNum.text = @"10";
        [content addSubview:tapNum];
        
        tapNumStr = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 320, 20)];
        tapNumStr.backgroundColor = [UIColor clearColor];
        tapNumStr.font = [UIFont systemFontOfSize:12];
        tapNumStr.text = @"在线房源";
        [content addSubview:tapNumStr];
        
        totalCost = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 50, 20)];
        totalCost.backgroundColor = [UIColor clearColor];
        totalCost.text = @"100";
        [content addSubview:totalCost];
        
        totalCostStr = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 320, 20)];
        totalCostStr.backgroundColor = [UIColor clearColor];
        totalCostStr.font = [UIFont systemFontOfSize:12];
        totalCostStr.text = @"总花费(元)";
        [content addSubview:totalCostStr];
        
        topCost = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 50, 20)];
        topCost.backgroundColor = [UIColor clearColor];
        topCost.text = @"99.0";
        [content addSubview:topCost];
        
        topCostStr = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 320, 20)];
        topCostStr.backgroundColor = [UIColor clearColor];
        topCostStr.text = @"今日最高消费(元)";
        topCostStr.font = [UIFont systemFontOfSize:12];
        [content addSubview:topCostStr];
        [self.contentView addSubview:content];
    }
    return self;
}
-(void)setValueForCellByObject:(FixedObject *) obj{
    tapNum.text = obj.tapNum;
    totalCost.text = obj.totalCost;
    topCost.text = obj.topCost;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
