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

//自动拉下刷新
- (void)autoRefresh;

//取消模态视图
- (void)cancelAction:(UIButton*)button;

//供外部调用的MBProgressHUD
- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode;

//删除某个cell
//- (void)removeCellFromPropertyTableViewWithIndexPath:(NSIndexPath*)indexPath;
- (void)removeCellFromPropertyTableViewWithCell:(PropertyTableViewCell*)cell;

//更新cell状态
//- (void)updateCellWithIndexPath:(NSIndexPath*)indexPath PropertyModel:(PropertyModel*)propertyModel;
- (void)updateCellWithCell:(PropertyTableViewCell*)cell;

@end
