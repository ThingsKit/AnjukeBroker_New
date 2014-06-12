//
//  WXDataShowViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "UserCenterModel.h"
#import "HUDNews.h"
#import "PICircularProgressView.h"

@interface WXDataShowViewController : RTViewController

@property (strong, nonatomic) PICircularProgressView *progressView;
@property (strong, nonatomic) UILabel *numberLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) UILabel *totalCustomer;
@property (strong, nonatomic) UILabel *totalResponseTime;
@property (strong ,nonatomic) UserCenterModel *userCenterModel;

@end
