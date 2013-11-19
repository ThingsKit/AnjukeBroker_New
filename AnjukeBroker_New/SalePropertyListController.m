//
//  SalePropertyListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SalePropertyListController.h"
#import "BasePropertyObject.h"
#import "PropertyDetailCell.h"
#import "SaleBidPlanController.h"
#import "SaleAuctionViewController.h"
#import "RTNavigationController.h"

@interface SalePropertyListController ()

@end

@implementation SalePropertyListController
@synthesize myArray;
@synthesize myTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myArray = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"选择房源"];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
    BasePropertyObject *property1 = [[BasePropertyObject alloc] init];
    property1.title = @"昨天最好的房子";
    property1.communityName = @"3室1厅 66平 125万";
    property1.price = @"1万";
    [self.myArray addObject:property1];
    
    BasePropertyObject *property2 = [[BasePropertyObject alloc] init];
    property2.title = @"今天最好的房子";
    property2.communityName = @"3室1厅 66平 125万";
    property2.price = @"2万";
    [self.myArray addObject:property2];
    
    BasePropertyObject *property3 = [[BasePropertyObject alloc] init];
    property3.title = @"明天最好的房子";
    property3.communityName = @"3室1厅 66平 125万";
    property3.price = @"3.05万";
    [self.myArray addObject:property3];
    
    BasePropertyObject *property4 = [[BasePropertyObject alloc] init];
    property4.title = @"未来天最好的房子";
    property4.communityName = @"3室1厅 66平 125万";
    property4.price = @"6万";
    [self.myArray addObject:property4];
    
    BasePropertyObject *property = [[BasePropertyObject alloc] init];
    property.title = @"上海最好的房子";
    property.communityName = @"3室1厅 66平 125万";
    property.price = @"1.9亿";
    [self.myArray addObject:property];
    
	// Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SaleAuctionViewController *controller = [[SaleAuctionViewController alloc] init];
    controller.backType = RTSelectorBackTypeDismiss;
    controller.delegateVC = self;
    RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:nav animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdent = @"PropertyDetailCell";
        PropertyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"PropertyDetailCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyDetailCell"];
            [cell setValueForCellByObject:[self.myArray objectAtIndex:[indexPath row]]];
        }
        return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --PrivateMethod

@end
