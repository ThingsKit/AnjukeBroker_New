//
//  houseSelectCommunityCell.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "HouseSelectCommunityCell.h"

@implementation HouseSelectCommunityCell
@synthesize communityNameLab;
@synthesize detailLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    CGFloat cxZhou = 20;
    CGFloat cyZhou = 16;
    CGFloat cWidth = 270;
    CGFloat cHeight = 17;
    
    communityNameLab = [[UILabel alloc] initWithFrame:CGRectMake(cxZhou, cyZhou, cWidth, cHeight)];
    communityNameLab.textColor = [UIColor ajkBlackColor];
    communityNameLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:communityNameLab];
    
    detailLab = [[UILabel alloc] initWithFrame:CGRectMake(cxZhou, cyZhou + cHeight + 6, cWidth, 12)];
    detailLab.textColor = [UIColor ajkLightGrayColor];
    detailLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:detailLab];
}
-(void)insertCellWithDic:(NSDictionary *)dic{
    communityNameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"commName"]];
    detailLab.text = [NSString stringWithFormat:@"房源数：%@套",[dic objectForKey:@"propNums"]];
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
