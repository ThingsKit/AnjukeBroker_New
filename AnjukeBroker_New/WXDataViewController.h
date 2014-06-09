//
//  WXDataViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "PICircularProgressView.h"

@interface WXDataViewController : RTViewController

@property (weak, nonatomic) IBOutlet PICircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *totalCustomer;
@property (weak, nonatomic) IBOutlet UILabel *totalResponseTime;


@property (nonatomic, strong) NSTimer *timer;
@end
