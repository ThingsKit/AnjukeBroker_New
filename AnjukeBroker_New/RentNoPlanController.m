//
//  RentNpPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentNoPlanController.h"
#import "BaseNoPlanListCell.h"
#import "SaleNoPlanListCell.h"

@interface RentNoPlanController ()

@end

@implementation RentNoPlanController

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
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"确定"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(action)];
    self.navigationItem.rightBarButtonItem = editButton;
	// Do any additional setup after loading the view.
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0f;
}

#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    
    [cell configureCell:nil withIndex:indexPath.row];
    
    if([self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_selected@2x.png"];
    }else{
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doCheckmarkAtRow:indexPath.row];
}

#pragma mark - Checkmark Btn Delegate

- (void)checkmarkBtnClickedWithRow:(int)row {
    DLog(@"row -[%d]", row);
    
    [self doCheckmarkAtRow:row];
}

#pragma mark - PrivateMethod
//***打勾操作***
- (void)doCheckmarkAtRow:(int)row {
    
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:row]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:row]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:row]];
    }
    [self.myTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod

-(void)action{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
