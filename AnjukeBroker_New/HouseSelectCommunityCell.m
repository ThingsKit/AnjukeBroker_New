//
//  houseSelectCommunityCell.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
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
    communityNameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 16, 270, 17)];
    communityNameLab.textColor = [Util_UI colorWithHexString:@"#000000"];
    communityNameLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:communityNameLab];
    
    detailLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 270, 12)];
    detailLab.textColor = [Util_UI colorWithHexString:@"#999999"];
    detailLab.font = [UIFont systemFontOfSize:12];
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
