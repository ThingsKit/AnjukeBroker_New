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

@class MBProgressHUD;
@interface RushPropertyViewController : RTViewController<BaseTableViewEventDelegate>

//自动拉下刷新
- (void)autoRefresh;

//取消模态视图
- (void)cancelAction:(UIButton*)button;

//供外部调用的MBProgressHUD
- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode;

@end
