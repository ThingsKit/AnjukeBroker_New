//
//  PPCHeaderView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-10.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PPCHeaderView.h"

@implementation PPCHeaderView
@synthesize clickNumLab;
@synthesize todayCostLab;

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
    
    self.clickNumLab = [[UILabel alloc] init];
    self.clickNumLab.textAlignment = NSTextAlignmentCenter;
    self.clickNumLab.text = @"-";
    self.clickNumLab.textColor = [UIColor brokerBlackColor];
    self.clickNumLab.font = [UIFont systemFontOfSize:25];
    self.clickNumLab.frame = CGRectMake(60, 20, 100, 30);
    [self addSubview:self.clickNumLab];

    self.todayCostLab = [[UILabel alloc] init];
    self.todayCostLab.textAlignment = NSTextAlignmentCenter;
    self.todayCostLab.text = @"-";
    self.todayCostLab.textColor = [UIColor brokerBlackColor];
    self.todayCostLab.font = [UIFont systemFontOfSize:25];
    self.todayCostLab.frame = CGRectMake(160, 20, 100, 30);
    [self addSubview:self.todayCostLab];

    UILabel *clickDesLab = [[UILabel alloc] init];
    clickDesLab.text = @"今日点击";
    clickDesLab.font = [UIFont systemFontOfSize:15];
    clickDesLab.textAlignment = NSTextAlignmentCenter;
    clickDesLab.textColor = [UIColor brokerBlackColor];
    clickDesLab.frame = CGRectMake(60, 60, 100, 30);
    [self addSubview:clickDesLab];

    UILabel *costDesLab = [[UILabel alloc] init];
    costDesLab.text = @"今日花费";
    costDesLab.font = [UIFont systemFontOfSize:15];
    costDesLab.textAlignment = NSTextAlignmentCenter;
    costDesLab.textColor = [UIColor brokerBlackColor];
    costDesLab.frame = CGRectMake(160, 60, 100, 30);
    [self addSubview:costDesLab];
}

- (void)updatePPCData:(NSDictionary *)dic isAJK:(BOOL)isAJK{
    if (isAJK) {
        self.clickNumLab.text = [dic objectForKey:@"ajkClick"];
        self.todayCostLab.text = [dic objectForKey:@"ajkConsume"];
    }else{
        self.clickNumLab.text = [dic objectForKey:@"hzClick"];
        self.todayCostLab.text = [dic objectForKey:@"hzConsume"];
    }
}


@end
