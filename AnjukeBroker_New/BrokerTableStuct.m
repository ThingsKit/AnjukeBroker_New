//
//  BrokerTableStuct.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerTableStuct.h"

@implementation BrokerTableStuct
@synthesize headerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark -tableview 状态设置
- (void)setTableStatus:(TableStatus)status{
    if (status == STATUSFOROK) {
        self.tableHeaderView = nil;
        return;
    }
    if (!self.headerView) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    UIImageView *backGroundView = [[UIImageView alloc] init];
    if (status == STATUSFORNETWORKERROR || status == STATUSFORNODATA) {
        backGroundView.frame = CGRectMake(0, 0, 135, 135);
        [backGroundView setImage:[UIImage imageNamed:@"anjuke_icon_tips_bg"]];
        
        UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 20, 70, 70)];
        [statusView setImage:[UIImage imageNamed:@"anjuke_icon_tips_sad"]];
        [backGroundView addSubview:statusView];

        UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 135, 20)];
        tipsLab.backgroundColor = [UIColor clearColor];
        tipsLab.font = [UIFont systemFontOfSize:18];
        tipsLab.textAlignment = NSTextAlignmentCenter;
        tipsLab.textColor = [UIColor whiteColor];
        [backGroundView addSubview:tipsLab];
        
        if (status == STATUSFORNETWORKERROR) {
            tipsLab.text = @"网络不畅";
        }else{
            tipsLab.text = @"暂无数据";
        }
    }
    
    self.headerView = [[UIView alloc] initWithFrame:self.frame];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    backGroundView.center = self.center;
    [self.headerView addSubview:backGroundView];
    
    self.tableHeaderView = self.headerView;
}
@end
