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

@interface PPCDataShowViewController : BaseTableStructViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign) BOOL isHaozu;

@end
