//
//  SystemSettingViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"

@interface AppSettingViewController : RTViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic) BOOL idfaFlg;

- (void)updateVersionInfo:(NSDictionary *)dic;

@end
