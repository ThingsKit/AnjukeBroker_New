//
//  HomeCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HomeCell.h"


@implementation HomeCell
@synthesize cellTit;
@synthesize cellDes;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.cellTit = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 150, 30)];
    self.cellTit.backgroundColor = [UIColor clearColor];
    self.cellTit.font = [UIFont ajkH2Font];
    self.cellTit.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:self.cellTit];
    
    self.cellDes = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 200, 20)];
    self.cellDes.backgroundColor = [UIColor clearColor];
    self.cellDes.font = [UIFont ajkH4Font];
    self.cellDes.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:self.cellDes];
}

- (void)configWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSArray *arr = (NSArray *)model;
    
    NSArray *titAndDesArr = [[arr objectAtIndex:indexPath.row] componentsSeparatedByString:NSLocalizedString(@"=", nil)];
    
    self.cellTit.text = [NSString stringWithFormat:@"%@",[titAndDesArr objectAtIndex:0]];
    self.cellDes.text = [NSString stringWithFormat:@"%@",[titAndDesArr objectAtIndex:1]];
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
