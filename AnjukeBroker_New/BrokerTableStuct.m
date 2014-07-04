//
//  BrokerTableStuct.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerTableStuct.h"

@implementation BrokerTableStuct
@synthesize headerViews;

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
    if (!self.headerViews) {
        [self.headerViews removeFromSuperview];
        self.headerViews = nil;
    }
    UIImageView *backGroundView = [[UIImageView alloc] init];
    backGroundView.frame = CGRectMake(0, 0, 320, ScreenHeight-20-44);
    backGroundView.backgroundColor = [UIColor clearColor];

    UIImageView *statusView = [[UIImageView alloc] init];
    [backGroundView addSubview:statusView];
    
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.backgroundColor = [UIColor clearColor];
    tipsLab.font = [UIFont ajkH3Font];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor brokerLightGrayColor];
    
    if (status == STATUSFORNETWORKERROR) {
        statusView.frame = CGRectMake(110, backGroundView.frame.size.height/2 - 160/2, 100, 70);
        [statusView setImage:[UIImage imageNamed:@"check_no_wifi"]];

        tipsLab.frame = CGRectMake(0, backGroundView.frame.size.height/2 + 15, 320, 20);
        tipsLab.text = @"网络连接失败";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNODATA){
        statusView.frame = CGRectMake(115, backGroundView.frame.size.height/2 - 160/2, 90, 78);
        [statusView setImage:[UIImage imageNamed:@"check_no_community"]];

        tipsLab.frame = CGRectMake(0, backGroundView.frame.size.height/2 + 15, 320, 20);
        tipsLab.text = @"没有可以签到的小区";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNODATAFORPRICINGLIST){
        statusView.frame = CGRectMake(115, backGroundView.frame.size.height/2 - 160/2, 90, 78);
        [statusView setImage:[UIImage imageNamed:@"check_no_community"]];

        tipsLab.frame = CGRectMake(0, backGroundView.frame.size.height/2 + 15, 320, 20);
        tipsLab.text = @"暂无定价计划";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNODATAFOSELECTLIST){
        statusView.frame = CGRectMake(115, backGroundView.frame.size.height/2 - 300/2, 100, 111);
        [statusView setImage:[UIImage imageNamed:@"broker_property_no_jx@2x.png"]];
        
        UILabel *tipsDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(0, backGroundView.frame.size.height/2-25, 320, 50)];
        tipsDetailLab.backgroundColor = [UIColor clearColor];
        tipsDetailLab.font = [UIFont ajkH3Font];
        tipsDetailLab.numberOfLines = 0;
        tipsDetailLab.lineBreakMode = UILineBreakModeWordWrap;
        tipsDetailLab.textAlignment = NSTextAlignmentCenter;
        tipsDetailLab.textColor = [UIColor brokerLightGrayColor];
        tipsDetailLab.text = @"精选推广提升8倍效果\n选一套定价房源,做精选推广吧";
        [backGroundView addSubview:tipsDetailLab];
    }else if (status == STATUSFORREMOTESERVERERROR){
        statusView.frame = CGRectMake(110, backGroundView.frame.size.height/2 - 160/2, 100, 70);
        [statusView setImage:[UIImage imageNamed:@"check_no_wifi"]];
        
        tipsLab.frame = CGRectMake(0, backGroundView.frame.size.height/2 + 15, 320, 20);
        tipsLab.text = @"服务器开溜了";
        [backGroundView addSubview:tipsLab];
    }else if (status == STATUSFORNOGPS){
        statusView.frame = CGRectMake(115, backGroundView.frame.size.height/2 - 210/2, 90, 90);
        [statusView setImage:[UIImage imageNamed:@"check_no_gps"]];

        tipsLab.frame = CGRectMake(0, backGroundView.frame.size.height/2 - 5, 320, 20);
        tipsLab.text = @"无法获取你的位置信息";
        [backGroundView addSubview:tipsLab];
        
        UILabel *gpsTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, backGroundView.frame.size.height/2 + 15, 320, 50)];
        gpsTipsLab.backgroundColor = [UIColor clearColor];
        gpsTipsLab.font = [UIFont ajkH3Font];
        gpsTipsLab.numberOfLines = 0;
        gpsTipsLab.lineBreakMode = UILineBreakModeWordWrap;
        gpsTipsLab.textAlignment = NSTextAlignmentCenter;
        gpsTipsLab.textColor = [UIColor brokerLightGrayColor];
        gpsTipsLab.text = @"请到手机系统的[设置]>[隐私]>[定位服务]中 打开定位服务，并允许移动经纪人使用定位服务。";
        [backGroundView addSubview:gpsTipsLab];
    }else if (status == STATUSFORNODATAFORNOHOUSE){
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(104.0f, backGroundView.frame.size.height/2 - 120, 112.0f, 80.0f)];
        [imgView1 setImage:[UIImage imageNamed:@"pic_3.4_01.png"]];
        [backGroundView addSubview:imgView1];

        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(255.0f, 45, 35.0f, 64.0f)];
        [imgView2 setImage:[UIImage imageNamed: @"pic_3.4_02.png"]];
        [backGroundView addSubview:imgView2];        
        
        UILabel *tipsDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(0, backGroundView.frame.size.height/2-35, 320, 50)];
        tipsDetailLab.backgroundColor = [UIColor clearColor];
        tipsDetailLab.font = [UIFont ajkH3Font];
        tipsDetailLab.numberOfLines = 0;
        tipsDetailLab.lineBreakMode = UILineBreakModeWordWrap;
        tipsDetailLab.textAlignment = NSTextAlignmentCenter;
        tipsDetailLab.textColor = [UIColor brokerLightGrayColor];
        tipsDetailLab.text = @"暂无房源 \n 快去发布吧";
        [backGroundView addSubview:tipsDetailLab];
    }
    
    
    self.headerViews = [[UIView alloc] initWithFrame:self.frame];
    self.headerViews.backgroundColor = [UIColor clearColor];
    
    backGroundView.center = self.center;
    [self.headerViews addSubview:backGroundView];
    
    self.tableHeaderView = self.headerViews;
}

@end
