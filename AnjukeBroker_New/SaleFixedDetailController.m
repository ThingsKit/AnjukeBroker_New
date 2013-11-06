//
//  SaleFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleFixedDetailController.h"
#import "BaseNoPlanController.h"
#import "ModifyFixedCostController.h"
#import "SalePropertyDetailController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleBidPlanController.h"
#import "SaleSelectNoPlanController.h"
#import "PropertyAuctionViewController.h"
#import "RTNavigationController.h"

#import "SalePropertyListCell.h"
#import "SaleFixedCell.h"
#import "BasePropertyListCell.h"

#import "PropertyObject.h"

@interface SaleFixedDetailController ()
{
}
@property (nonatomic, strong) RTPopoverTableViewController *popoverTableView;
@property (nonatomic, strong) UIPopoverController *popoverBG;
@property (nonatomic, strong) NSArray *titleArr_Popover;

@end

@implementation SaleFixedDetailController
@synthesize myTable;
@synthesize myArray;
@synthesize popoverTableView, popoverBG;
@synthesize titleArr_Popover;

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
    [self setTitleViewWithString:@"定价房源"];
    //黑框
    self.titleArr_Popover= [NSArray arrayWithObjects:@"添加房源", @"停止推广", @"修改限额", nil];
    [self addRightButton:@"操作" andPossibleTitle:@""];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
    FixedObject *fixed = [[FixedObject alloc] init];
    fixed.tapNum = @"10";
    fixed.topCost = @"100";
    fixed.totalCost = @"30";
    [self.myArray addObject:fixed];
    
    PropertyObject *property1 = [[PropertyObject alloc] init];
    property1.title = @"昨天最好的房子";
    property1.communityName = @"2室1厅  33平";
    property1.price = @"345万";
    [self.myArray addObject:property1];
    
    PropertyObject *property2 = [[PropertyObject alloc] init];
    property2.title = @"今天最好的房子";
    property2.communityName = @"2室1厅  120平";
    property2.price = @"567万";
    [self.myArray addObject:property2];
    
    PropertyObject *property3 = [[PropertyObject alloc] init];
    property3.title = @"明天最好的房子";
    property3.communityName = @"2室1厅  340平";
    property3.price = @"7896万";
    [self.myArray addObject:property3];
    
    PropertyObject *property4 = [[PropertyObject alloc] init];
    property4.title = @"未来天最好的房子";
    property4.communityName = @"2室1厅  200平";
    property4.price = @"6435万";
    [self.myArray addObject:property4];
    
    PropertyObject *property = [[PropertyObject alloc] init];
    property.title = @"上海最好的房子";
    property.communityName = @"2室1厅  80平";
    property.price = @"234万";
    [self.myArray addObject:property];

}
#pragma mark - RTPOPOVER Delegate
- (void)popoverCellClick:(int)row {
    
}

#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 0){
    
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"取消定价推广", @"竞价推广本房源", nil];
        [action showInView:self.view];
        
        
//        SalePropertyDetailController *controller = [[SalePropertyDetailController alloc] init];
//        controller.propertyObject = [self.myArray objectAtIndex:[indexPath row]];
//        controller.fixedObject = [self.myArray objectAtIndex:0];
//        [self.navigationController pushViewController:controller animated:YES];
    
    }
//    if(![selected containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
//        [selected addObject:[self.myArray objectAtIndex:[indexPath row]]];
//        
//    }else{
//        [selected removeObject:[self.myArray objectAtIndex:[indexPath row]]];
//        
//    }
//    [self.myTable reloadData];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 1){
    return 71.0f;
    }
    return 69.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0){
        static NSString *cellIdent = @"SaleFixedCell";
        SaleFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SaleFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaleFixedCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }else{
        static NSString *cellIdent = @"SalePropertyListCell";
        SalePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"SalePropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SalePropertyListCell"];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
//        [cell setValueForCellByObject:[self.myArray objectAtIndex:[indexPath row]]];
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
//    headerLab.backgroundColor = [UIColor grayColor];
//    headerLab.text = fixedStatus;
//    return headerLab;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 55;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
//    contentView.backgroundColor = [UIColor grayColor];
//    
//    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
//    [delete setTitle:@"删除" forState:UIControlStateNormal];
//    delete.frame = CGRectMake(20, 10, 80, 35);
//    [contentView addSubview:delete];
//    
//    UIButton *multiSelect = [UIButton buttonWithType:UIButtonTypeCustom];
//    multiSelect.frame = CGRectMake(190, 10, 80, 35);
//    [multiSelect setTitle:@"定价推广" forState:UIControlStateNormal];
//    [contentView addSubview:multiSelect];
//    
//    return contentView;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    //    if (self.popoverBG) {
    //        [self.popoverBG dismissPopoverAnimated:YES];
    //		self.popoverBG = nil;
    //
    //        return;
    //    }
    
    //    RTPopoverTableViewController *ptv = [[RTPopoverTableViewController alloc] init];
    //    self.popoverTableView = ptv;
    //    ptv.view.backgroundColor = [UIColor clearColor];
    //    ptv.popoverDelegate = self;
    //    ptv.titleArray = [NSArray arrayWithArray:self.titleArr_Popover];
    //    [ptv setTableViewWithFrame:CGRectMake(0, 0, 198/2, 3* RT_POPOVER_TV_HEIGHT)];
    //    [self.view addSubview:ptv.view];
    
    //    UIPopoverController *pop = nil;
    //    pop = [[UIPopoverController alloc] init];
    //    self.popoverBG = pop;
    //    self.popoverBG.delegate = self;
    //    self.popoverBG.popoverContentSize = CGSizeMake(198/2, 3* RT_POPOVER_TV_HEIGHT); //popover View 大小
    ////    self.popoverBG.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
    //    [self.popoverBG presentPopoverFromRect:CGRectMake(0, 0, 20, 20)
    //                                            inView:self.navigationController.navigationBar
    //                          permittedArrowDirections:UIPopoverArrowDirectionUp
    //                                          animated:YES];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加房源", @"停止推广", @"修改限额", nil];
    action.tag = 100;
    [action showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverBG = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(actionSheet.tag == 100){
        if(buttonIndex == 0){
            SaleSelectNoPlanController *controller = [[SaleSelectNoPlanController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *navi = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (buttonIndex == 1){
            [self.myTable reloadData];
        }else if (buttonIndex == 2){
            ModifyFixedCostController *controller = [[ModifyFixedCostController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
//            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        if(buttonIndex == 0){
            AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (buttonIndex == 1){
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (buttonIndex == 2){
            PropertyAuctionViewController *controller = [[PropertyAuctionViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
