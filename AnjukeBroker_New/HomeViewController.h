//
//  AJK_HomeViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "IMGDowloaderManager.h"
//#import "SelectionToolView.h"
//#import "SegmentView.h"
#import "HomeHeaderView.h"
#import "HomeCell.h"

@interface HomeViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, headerBtnClickDelegate>

- (void)doRequest;

@property BOOL hasLongLinked;
@property (nonatomic, strong) IMGDowloaderManager *img;
@property (nonatomic, strong) UITableView *myTable;

- (void)requestPropertyCount; //请求可抢房源数
- (void)requestCustomerCount; //请求可抢客户数

- (void)btnClickWithTag:(NSInteger)index;
@end
