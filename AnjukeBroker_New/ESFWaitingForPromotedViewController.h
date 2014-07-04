//
//  ESFWaitingForPromotedViewController.h
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "MultipleChoiceAndEditListCell.h"

@interface ESFWaitingForPromotedViewController : RTViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SWTableViewCellDelegate, CellSelectStatusDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIView *MutipleEditView;
@property (nonatomic, strong) NSIndexPath *editAndDeleteCellIndexPath;
@property (nonatomic, strong) NSString *planId;
- (void)loadData;
@end
