//
//  HZWaitingForPromotedViewController.h
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "MultipleChoiceAndEditListCell.h"



@interface HZWaitingForPromotedViewController : RTViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,CellSelectStatus>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIView *MutipleEditView;


@end
