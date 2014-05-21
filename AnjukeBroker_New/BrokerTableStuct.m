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
    backGroundView.frame = CGRectMake(0, 0, 320, 200);
    backGroundView.backgroundColor = [UIColor clearColor];

    UIImageView *statusView = [[UIImageView alloc] init];
    [backGroundView addSubview:statusView];
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.backgroundColor = [UIColor clearColor];
    tipsLab.font = [UIFont systemFontOfSize:16];
//    tipsLab.numberOfLines = 0;
//    tipsLab.lineBreakMode = UILineBreakModeWordWrap;
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor brokerBlackColor];
    
    if (status == STATUSFORNETWORKERROR) {
        statusView.frame = CGRectMake(110, 50, 100, 70);
        tipsLab.frame = CGRectMake(0, 160, 320, 20);
        [statusView setImage:[UIImage imageNamed:@"check_no_wifi"]];

        tipsLab.text = @"网络连接失败";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNODATA){
        statusView.frame = CGRectMake(115, 50, 90, 78);
        tipsLab.frame = CGRectMake(0, 160, 320, 20);
        [statusView setImage:[UIImage imageNamed:@"check_no_community"]];
        
        tipsLab.text = @"没有可以签到的小区";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNOGPS){
        statusView.frame = CGRectMake(115, 10, 90, 90);
        tipsLab.frame = CGRectMake(0, 110, 320, 20);
        [statusView setImage:[UIImage imageNamed:@"check_no_gps"]];

        tipsLab.text = @"无法获取你的位置信息";
        [backGroundView addSubview:tipsLab];
        
        UILabel *gpsTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 320, 50)];
        gpsTipsLab.backgroundColor = [UIColor clearColor];
        gpsTipsLab.font = [UIFont systemFontOfSize:14];
        gpsTipsLab.numberOfLines = 0;
        gpsTipsLab.lineBreakMode = UILineBreakModeWordWrap;
        gpsTipsLab.textAlignment = NSTextAlignmentCenter;
        gpsTipsLab.textColor = [UIColor brokerLightGrayColor];
        gpsTipsLab.text = @"请到手机系统的[设置]>[隐私]>[定位服务]中 打开定位服务，并允许移动经纪人使用定位服务。";
        [backGroundView addSubview:gpsTipsLab];
    }
    
    
    self.headerView = [[UIView alloc] initWithFrame:self.frame];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    backGroundView.center = self.center;
    [self.headerView addSubview:backGroundView];
    
    self.tableHeaderView = self.headerView;
}
@end
