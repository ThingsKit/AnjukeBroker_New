//
//  PPCDataShowViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableStructViewController.h"
#import "RTViewController.h"

typedef enum {
    SwitchType_RentNoPlan = 0, //租房未推广
    SwitchType_RentFixed, //定价
    SwitchType_RentBid, //竞价
    SwitchType_SaleNoPlan, //二手房未推广
    SwitchType_SaleFixed,
    SwitchType_SaleBid,
    SwitchType_SELECT //精选城市发房
} TabSwitchType; //发房结束后tab0跳tab1、2的结果PPC管理请求类型

@interface PPCDataShowViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic, assign) BOOL isHaozu;

//用于非精选/精选 发房结束后页面跳转到计划管理房源列表页面
- (void)dismissController:(UIViewController *)dismissController withSwitchIndex:(int)index withSwtichType:(TabSwitchType)switchType withPropertyDic:(NSDictionary *)propDic;

@end
