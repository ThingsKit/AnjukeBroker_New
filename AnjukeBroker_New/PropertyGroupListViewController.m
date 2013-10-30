//
//  PropertyListViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyGroupListViewController.h"
#import "AnjukePropertyGroupCell.h"
#import "PropertyAuctionViewController.h"

@interface PropertyGroupListViewController ()
@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSArray *groupArray;
@end

@implementation PropertyGroupListViewController
@synthesize tvList;
@synthesize groupArray;

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
    
    [self setTitleViewWithString:@"选择推广组"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initModel {
    self.groupArray = [NSArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PROPERTY_GROUP_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    AnjukePropertyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[AnjukePropertyGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        
    }
    
    [cell configureCell:nil];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //test
    PropertyAuctionViewController *pa = [[PropertyAuctionViewController alloc] init];
    [self.navigationController pushViewController:pa animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
