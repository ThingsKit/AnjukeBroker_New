//
//  BrokerAccountController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface BrokerAccountController : RTViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) NSMutableDictionary *ppcDataDic;
@end
