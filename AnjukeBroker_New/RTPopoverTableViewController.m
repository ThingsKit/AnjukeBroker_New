//
//  RTPopoverTableViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-4.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTPopoverTableViewController.h"

@interface RTPopoverTableViewController ()
@end

@implementation RTPopoverTableViewController
@synthesize titleArray, popoverDelegate;
@synthesize tvList;

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
    
    self.titleArray = [NSArray array];
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableViewWithFrame:(CGRect)frame {
    if (self.tvList) {
        self.tvList.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    else {
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.backgroundColor = [UIColor clearColor];
        self.tvList = tv;
        [self.view addSubview:tv];
        
    }
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RT_POPOVER_TV_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    else {
        
    }
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.popoverDelegate respondsToSelector:@selector(popoverCellClick:)]) {
        [self.popoverDelegate popoverCellClick:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
