//
//  PPCPromoteCompletListViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-3.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseTableStructViewController.h"
#import "PPCHouseCell.h"

@interface PPCPromoteCompletListViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property(nonatomic, assign) BOOL isHaozu;
@property(nonatomic, strong) NSMutableArray *tableData;
@end
