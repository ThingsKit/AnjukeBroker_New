//
//  RTPopoverTableViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-4.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RT_POPOVER_TV_HEIGHT 78/2

@protocol RTPopoverTableViewDelegate <NSObject>

- (void)popoverCellClick:(int)row;

@end

@interface RTPopoverTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) id <RTPopoverTableViewDelegate> popoverDelegate;
@property (nonatomic, strong) UITableView *tvList;

- (void)setTableViewWithFrame:(CGRect)frame;

@end
