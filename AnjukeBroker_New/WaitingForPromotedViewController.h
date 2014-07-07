//
//  HZWaitingForPromotedViewController.h
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "MultipleChoiceAndEditListCell.h"


@interface WaitingForPromotedViewController : RTViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SWTableViewCellDelegate, CellSelectStatusDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIView *mutipleEditView;
@property (nonatomic, strong) NSIndexPath *editAndDeleteCellIndexPath;
@property (nonatomic, strong) NSString *planId;
@property (nonatomic) BOOL isHaozu;

@end
