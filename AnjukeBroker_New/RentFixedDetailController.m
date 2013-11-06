//
//  RentFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentFixedDetailController.h"
#import "AnjukeEditPropertyViewController.h"
#import "PropertyAuctionViewController.h"
#import "ModifyFixedCostController.h"
#import "RTNavigationController.h"
#import "RentNoPlanController.h"

#import "FixedObject.h"
#import "BasePropertyObject.h"
#import "RentFixedCell.h"
#import "RentPropertyListCell.h"

@interface RentFixedDetailController ()

@end

@implementation RentFixedDetailController

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
    [self addRightButton:@"操作" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
    FixedObject *fixed = [[FixedObject alloc] init];
    fixed.tapNum = @"10";
    fixed.topCost = @"100";
    fixed.totalCost = @"30";
    [self.myArray addObject:fixed];
    
    BasePropertyObject *property1 = [[BasePropertyObject alloc] init];
    property1.title = @"昨天最好的房子";
    property1.communityName = @"2室1厅  33平";
    property1.price = @"345万";
    [self.myArray addObject:property1];
    
    BasePropertyObject *property2 = [[BasePropertyObject alloc] init];
    property2.title = @"今天最好的房子";
    property2.communityName = @"2室1厅  120平";
    property2.price = @"567万";
    [self.myArray addObject:property2];
    
    BasePropertyObject *property3 = [[BasePropertyObject alloc] init];
    property3.title = @"明天最好的房子";
    property3.communityName = @"2室1厅  340平";
    property3.price = @"7896万";
    [self.myArray addObject:property3];
    
    BasePropertyObject *property4 = [[BasePropertyObject alloc] init];
    property4.title = @"未来天最好的房子";
    property4.communityName = @"2室1厅  200平";
    property4.price = @"6435万";
    [self.myArray addObject:property4];
    
    BasePropertyObject *property = [[BasePropertyObject alloc] init];
    property.title = @"上海最好的房子";
    property.communityName = @"2室1厅  80平";
    property.price = @"234万";
    [self.myArray addObject:property];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & DataSource

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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 1){
        return 71.0f;
    }
    return 69.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0){
        static NSString *cellIdent = @"RentFixedCell";
        RentFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentFixedCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }else{
        static NSString *cellIdent = @"RentPropertyListCell";
        RentPropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentPropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentPropertyListCell"];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        return cell;
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 100){
        if(buttonIndex == 0){
            RentNoPlanController *controller = [[RentNoPlanController alloc] init];
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

#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加房源", @"停止推广", @"修改限额", nil];
    action.tag = 100;
    [action showInView:self.view];
}
@end
