//
//  SalePropertyDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SalePropertyDetailController.h"
#import "SaleFixedCell.h"
#import "PropertyDetailCell.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleBidPlanController.h"

@interface SalePropertyDetailController ()

@end

@implementation SalePropertyDetailController
@synthesize myArray;
@synthesize myTable;
@synthesize propertyObject;
@synthesize fixedObject;

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
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
    [self addRightButton:@"操作" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 1){
        static NSString *cellIdent = @"FixedDetailCell";
        SaleFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"FixedDetailCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FixedDetailCell"];
//            [cell setValueForCellByObject:self.fixedObject];
        }
        [cell configureCell:self.fixedObject];
        return cell;
    }else{
        static NSString *cellIdent = @"PropertyDetailCell";
        PropertyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"PropertyDetailCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyDetailCell"];
            [cell setValueForCellByObject:self.propertyObject];
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"取消定价推广", @"竞价推广本房源", nil];
    [action showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (buttonIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (buttonIndex == 2){
        SaleBidPlanController *controller = [[SaleBidPlanController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
@end
