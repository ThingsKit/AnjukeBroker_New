//
//  SaleNoPlanGroupController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleNoPlanGroupController.h"
#import "SaleNoPlanListCell.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleFixedDetailController.h"
#import "Util_UI.h"

@interface SaleNoPlanGroupController ()
{
    UIView *contentView;
}
@end

@implementation SaleNoPlanGroupController

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
    self.myTable.frame = FRAME_BETWEEN_NAV_TAB;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myTable.frame.size.height, 320, 64)];
    contentView.backgroundColor = SYSTEM_LIGHT_GRAY;
    
    UIButton *mutableSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [mutableSelect setTitle:@"全选" forState:UIControlStateNormal];
    mutableSelect.frame = CGRectMake(10, 0, 90, 44);
    [mutableSelect addTarget:self action:@selector(mutableAction:) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:mutableSelect];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.frame = CGRectMake(110, 0, 90, 44);
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:delete];
    
    UIButton *multiSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    multiSelect.frame = CGRectMake(210, 0, 90, 44);
    [multiSelect setTitle:@"定价推广" forState:UIControlStateNormal];
    [multiSelect addTarget:self action:@selector(mutableFixed) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:multiSelect];
    [self.view addSubview:contentView];
	// Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        [cell.mutableBtn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon06_select@2x.png"] forState:UIControlStateNormal];
//        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
        [cell setValueForTableCell];
    }
    
    if([self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        [cell.mutableBtn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon06_selected@2x.png"] forState:UIControlStateNormal];
//        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon06_selected@2x.png"];
    }else{
        [cell.mutableBtn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon06_select@2x.png"] forState:UIControlStateNormal];
//        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    [cell.mutableBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    cell.mutableBtn.tag = [indexPath row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"定价推广", @"编辑房源", @"删除房源", nil];
    [action showInView:self.view];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 55.0;
//}

-(void)clickButton:(id) sender{
    UIButton *but = (UIButton *)sender;
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:but.tag]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:but.tag]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:but.tag]];
    }
    [self.myTable reloadData];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return contentView;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- PrivateMethod
-(void)mutableAction:(id) sender{
    UIButton *tempBtn = (UIButton *)sender;
    if ([tempBtn.titleLabel.text isEqualToString:@"全选"]){
        [tempBtn setTitle:@"反选" forState:UIControlStateNormal];
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObjectsFromArray:self.myArray];
        [self.myTable reloadData];
    }else {
        [tempBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectedArray removeAllObjects];
        [self.myTable reloadData];
    }
}

-(void)delete{
    if ([self.selectedArray count] == 0) {
        UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请选择房源" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tempView show];
        return ;
    }
    UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定删除房源？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [tempView show];

}

-(void)mutableFixed{
    if ([self.selectedArray count] == 0) {
        UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请选择房源" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tempView show];
        return ;
    }
    SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark --UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 1){
        AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 2){
    
    }
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self.myArray removeObjectsInArray:self.selectedArray];
        [self.myTable reloadData];
    }
}
@end
