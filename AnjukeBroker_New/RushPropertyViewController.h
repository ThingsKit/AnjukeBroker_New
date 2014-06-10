//
//  QiangFangYuanWeiTuoViewController.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "PropertyTableView.h"
#import "MyPropertyTableView.h"

@class PropertyTableViewCell;
@class MBProgressHUD;
@class PropertyModel;
@interface RushPropertyViewController : RTViewController<BaseTableViewEventDelegate>

@property(nonatomic, strong) UILabel* propertyListBadgeLabel;
@property(nonatomic, assign) NSInteger badgeNumber;

//设置是否自动下拉
@property (nonatomic, assign) BOOL leftAutoPullDown;
@property (nonatomic, assign) BOOL rightAutoPullDown;

//每一个时刻只能有一个网络请求
@property (nonatomic, assign) BOOL leftIsRequesting; //左边tableView正在请求
@property (nonatomic, assign) BOOL rightIsRequesting; //右边tableView正在请求

//自动拉下刷新
- (void)autoRefresh;

//供外部调用的MBProgressHUD
- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode;

//删除propertyTableView的某个cell
//- (void)removeCellFromPropertyTableViewWithIndexPath:(NSIndexPath*)indexPath;
- (void)removeCellFromPropertyTableViewWithCell:(PropertyTableViewCell*)cell;

//更新propertyTableView的某个cell状态
- (void)updateCellWithCell:(PropertyTableViewCell*)cell;

//获取propertyTableView的某个cell
- (NSIndexPath*)indexPathFromCell:(PropertyTableViewCell*)cell;

@end
