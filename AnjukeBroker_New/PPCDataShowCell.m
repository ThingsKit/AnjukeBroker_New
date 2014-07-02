//
//  PPCDataShowCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCDataShowCell.h"
#import "PPCDataShowModel.h"

@interface PPCDataShowCell ()
@property(nonatomic, strong) UILabel *titLab;
@property(nonatomic, strong) UILabel *todayClickLab;
@property(nonatomic, strong) UILabel *todayCostLab;
@property(nonatomic, strong) UILabel *houseNumLab;
@end

@implementation PPCDataShowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor brokerWhiteColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 20)];
    self.titLab.backgroundColor = [UIColor clearColor];
    self.titLab.textAlignment = NSTextAlignmentLeft;
    self.titLab.font = [UIFont ajkH2Font];
    self.titLab.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:self.titLab];

    UILabel *clickTitLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 60, 15)];
    clickTitLab.backgroundColor = [UIColor clearColor];
    clickTitLab.textAlignment = NSTextAlignmentLeft;
    clickTitLab.font = [UIFont ajkH5Font];
    clickTitLab.textColor = [UIColor brokerLightGrayColor];
    clickTitLab.text = @"今日点击";
    [self.contentView addSubview:clickTitLab];
    
    UILabel *costTitLab = [[UILabel alloc] initWithFrame:CGRectMake(145, 120, 60, 15)];
    costTitLab.backgroundColor = [UIColor clearColor];
    costTitLab.textAlignment = NSTextAlignmentLeft;
    costTitLab.font = [UIFont ajkH5Font];
    costTitLab.textColor = [UIColor brokerLightGrayColor];
    costTitLab.text = @"今日花费";
    [self.contentView addSubview:costTitLab];

    UILabel *houseNumTitLab = [[UILabel alloc] initWithFrame:CGRectMake(225, 120, 60, 15)];
    houseNumTitLab.backgroundColor = [UIColor clearColor];
    houseNumTitLab.textAlignment = NSTextAlignmentLeft;
    houseNumTitLab.font = [UIFont ajkH5Font];
    houseNumTitLab.textColor = [UIColor brokerLightGrayColor];
    houseNumTitLab.text = @"房源量";
    [self.contentView addSubview:houseNumTitLab];
    
    self.todayClickLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 80, 80)];
    self.todayClickLab.font = [UIFont boldSystemFontOfSize:80];
    self.todayClickLab.text = @"0";
    [self.contentView addSubview:self.todayClickLab];

    self.todayCostLab = [[UILabel alloc] initWithFrame:CGRectMake(145, 90, 60, 30)];
    self.todayCostLab.textColor = [UIColor brokerMiddleGrayColor];
    self.todayCostLab.font = [UIFont boldSystemFontOfSize:30];
    self.todayCostLab.text = @"0";
    [self.contentView addSubview:self.todayCostLab];

    self.houseNumLab = [[UILabel alloc] initWithFrame:CGRectMake(225, 90, 60, 30)];
    self.houseNumLab.textColor = [UIColor brokerMiddleGrayColor];
    self.houseNumLab.font = [UIFont boldSystemFontOfSize:30];
    self.houseNumLab.text = @"0";
    [self.contentView addSubview:self.houseNumLab];
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    if (self.isPricing) {
        self.titLab.text = @"定价推广";
        self.todayClickLab.textColor = [UIColor brokerBlueColor];
    }else{
        self.titLab.text = @"精选推广";
        self.todayClickLab.textColor = [UIColor colorWithHex:0xFFB75B alpha:1.0];
    }

    
    PPCDataShowModel *model = (PPCDataShowModel *)dataModel;
    
    NSString *clickStr = [NSString stringWithFormat:@"%d",[model.todayClickNum intValue]];
    
    self.todayClickLab.text = clickStr;
    if (clickStr.length == 3) {
        self.todayClickLab.font = [UIFont systemFontOfSize:60];
    }else if (clickStr.length == 4){
        self.todayClickLab.font = [UIFont systemFontOfSize:40];
    }
    
    self.todayCostLab.text = [NSString stringWithFormat:@"%d",[model.todayCostFee intValue]];
    self.houseNumLab.text = [NSString stringWithFormat:@"%d",[model.houseNum intValue]];
    
    return YES;
}
@end
