//
//  SaleBidDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleBidDetailController.h"
#import "PropertyObject.h"
#import "BidPropertyListCell.h"
#import "BidPropertyDetailController.h"
#import "SalePropertyListController.h"

@interface SaleBidDetailController ()

@end

@implementation SaleBidDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"竞价推广"];
    UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
    [action setTitle:@"新增" forState:UIControlStateNormal];
    [action addTarget:self action:@selector(addProperty) forControlEvents:UIControlEventTouchDown];
    [action setBackgroundColor:[UIColor lightGrayColor]];
    [action setFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:action];

    
    myTablel = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTablel.delegate = self;
    myTablel.dataSource = self;
    [self.view addSubview:myTablel];

    PropertyObject *property1 = [[PropertyObject alloc] init];
    property1.title = @"昨天最好的房子";
    property1.communityName = @"天涯社区";
    property1.price = @"1万";
    [myArray addObject:property1];
    
    PropertyObject *property2 = [[PropertyObject alloc] init];
    property2.title = @"今天最好的房子";
    property2.communityName = @"明日论坛";
    property2.price = @"2万";
    [myArray addObject:property2];
    
    PropertyObject *property3 = [[PropertyObject alloc] init];
    property3.title = @"明天最好的房子";
    property3.communityName = @"黄浦江";
    property3.price = @"3.05万";
    [myArray addObject:property3];
    
    PropertyObject *property4 = [[PropertyObject alloc] init];
    property4.title = @"未来天最好的房子";
    property4.communityName = @"东方明珠";
    property4.price = @"6万";
    [myArray addObject:property4];
    
    PropertyObject *property = [[PropertyObject alloc] init];
    property.title = @"上海最好的房子";
    property.communityName = @"上海电视台";
    property.price = @"1.9亿";
    [myArray addObject:property];

	// Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BidPropertyDetailController *controller = [[BidPropertyDetailController alloc] init];
    controller.propertyObject = [myArray objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *cellIdent = @"BidPropertyListCell";
        BidPropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"BidPropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BidPropertyListCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setValueForCellByObject:[myArray objectAtIndex:[indexPath row]]];
        }
        return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    headerLab.backgroundColor = [UIColor grayColor];
    headerLab.text = @"房源数：5套";
    return headerLab;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PrivateMethod
-(void)addProperty{
    SalePropertyListController *controller = [[SalePropertyListController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
