//
//  PPCSelectedListViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-2.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseTableStructViewController.h"

@interface PPCSelectedListViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign) BOOL isHaozu;
@property(nonatomic, strong) NSString *planId;
@end

