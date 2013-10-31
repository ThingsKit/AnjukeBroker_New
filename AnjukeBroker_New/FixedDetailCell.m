//
//  FixedDetailCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "FixedDetailCell.h"
#import "Util_UI.h"

@implementation FixedDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        content.backgroundColor = [Util_UI colorWithHexString:@"#EFEFF4"];
        
        tapNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 50, 20)];
        tapNum.backgroundColor = [UIColor clearColor];
        tapNum.textColor = SYSTEM_BLACK;
        tapNum.text = @"10";
        tapNum.font = [UIFont systemFontOfSize:20];
        [content addSubview:tapNum];
        
        tapNumStr = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, 320, 20)];
        tapNumStr.backgroundColor = [UIColor clearColor];
        tapNumStr.font = [UIFont systemFontOfSize:12];
        tapNumStr.textColor = SYSTEM_LIGHT_GRAY;
        tapNumStr.text = @"总点击";
        [content addSubview:tapNumStr];
        
        totalCost = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 50, 20)];
        totalCost.backgroundColor = [UIColor clearColor];
        totalCost.textColor = SYSTEM_BLACK;
        totalCost.font = [UIFont systemFontOfSize:20];
        totalCost.text = @"100";
        [content addSubview:totalCost];
        
        totalCostStr = [[UILabel alloc] initWithFrame:CGRectMake(120, 42, 320, 20)];
        totalCostStr.backgroundColor = [UIColor clearColor];
        totalCostStr.font = [UIFont systemFontOfSize:12];
        totalCostStr.text = @"总花费(元)";
        totalCostStr.textColor = SYSTEM_LIGHT_GRAY;
        [content addSubview:totalCostStr];
        
        topCost = [[UILabel alloc] initWithFrame:CGRectMake(230, 15, 50, 20)];
        topCost.backgroundColor = [UIColor clearColor];
        topCost.textColor = SYSTEM_BLACK;
        topCost.font = [UIFont systemFontOfSize:20];
        topCost.text = @"99.0";
        [content addSubview:topCost];
        
        topCostStr = [[UILabel alloc] initWithFrame:CGRectMake(225, 42, 320, 20)];
        topCostStr.backgroundColor = [UIColor clearColor];
        topCostStr.textColor = SYSTEM_LIGHT_GRAY;
        topCostStr.text = @"日限额";
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
