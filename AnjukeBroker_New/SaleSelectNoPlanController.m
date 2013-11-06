//
//  SaleSelectNoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleSelectNoPlanController.h"
#import "BaseNoPlanListCell.h"
#import "SaleNoPlanListCell.h"

@interface SaleSelectNoPlanController ()

@end

@implementation SaleSelectNoPlanController

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
    
    [self addRightButton:@"确定" andPossibleTitle:nil];
    self.myTable.frame = FRAME_WITH_NAV;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    [cell.mutableBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    cell.mutableBtn.tag = [indexPath row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:[indexPath row]]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:[indexPath row]]];
        
    }
    [self.myTable reloadData];
}

#pragma mark - PrivateMethod
-(void)rightButtonAction:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickButton:(id) sender{
    UIButton *but = (UIButton *)sender;
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:but.tag]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:but.tag]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:but.tag]];
    }
    [self.myTable reloadData];
}
@end
