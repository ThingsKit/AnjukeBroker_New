//
//  PricePromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PricePromotionPropertySingleViewController.h"

#import "PropertyDetailTableViewFooter.h"
#import "PropertyDetailTableViewCell.h"

@interface PricePromotionPropertySingleViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation PricePromotionPropertySingleViewController

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    PropertyDetailTableViewFooter* footer = [[PropertyDetailTableViewFooter alloc] init];
    [self.view addSubview:footer];
}

#pragma mark -
#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PropertyDetailTableViewCell* cell;
//    if (indexPath.section == 0) {
        cell = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        
//    }
    return cell;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        return @"30天前发布";
//    }
//    return nil;
//}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}




@end
