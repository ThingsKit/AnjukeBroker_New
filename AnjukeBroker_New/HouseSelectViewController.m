//
//  houseSelectViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "houseSelectViewController.h"

@interface HouseSelectViewController ()

@end

@implementation HouseSelectViewController
@synthesize tableList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (![AppManager isIOS6]) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
	// Do any additional setup after loading the view.
    self.tableList = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableList.delegate = self;
    self.tableList.dataSource = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableList];
}

#pragma UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
