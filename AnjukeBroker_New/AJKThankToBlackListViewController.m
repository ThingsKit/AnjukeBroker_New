//
//  AJKThankToBlackListViewController.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-7-7.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AJKThankToBlackListViewController.h"

@interface AJKThankToBlackListViewController ()

@end

@implementation AJKThankToBlackListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"感谢举报"];
    [self initView];
}

- (void)initView
{
    UIImage *img = [UIImage imageNamed:@"broker_wl_jubao_solution.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    
    CGFloat imgPointX = CGRectGetWidth(self.view.frame) - img.size.width / 2 - (CGRectGetWidth(self.view.frame) - img.size.width)/2;
    CGFloat imgPointY = 210 - img.size.height / 2;
    
    CGPoint imgPoint = CGPointMake(imgPointX, imgPointY);
    [imgView setCenter:imgPoint];
    [self.view addSubview:imgView];
    
    CGFloat oneY = CGRectGetHeight(imgView.frame) + imgView.frame.origin.y + 15;
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(0, oneY, CGRectGetWidth(self.view.frame), 15)];
    [labelOne setText:@"非常感谢，我们会认真处理你的投诉，"];
    [labelOne setFont:[UIFont systemFontOfSize:15]];
    [labelOne setTextColor:[UIColor brokerBlackColor]];
    [labelOne setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelOne];
    
    
    CGFloat twoY = CGRectGetHeight(labelOne.frame) + labelOne.frame.origin.y + 3;
    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, twoY, CGRectGetWidth(self.view.frame), 15)];
    [labelTwo setText:@"维护绿色、健康的微聊环境。"];
    [labelTwo setFont:[UIFont systemFontOfSize:15]];
    [labelTwo setTextColor:[UIColor brokerBlackColor]];
    [labelTwo setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelTwo];
    

}

@end
