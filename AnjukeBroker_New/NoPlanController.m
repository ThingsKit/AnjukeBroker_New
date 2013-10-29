//
//  NoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "NoPlanController.h"
#import "NoPlanListCell.h"

@interface NoPlanController ()

@end

@implementation NoPlanController

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
    [self setTitleViewWithString:@"未推广房源"];
    myArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
    selected = [[NSMutableArray alloc] initWithCapacity:16];
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
	// Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![selected containsObject:[myArray objectAtIndex:[indexPath row]]]){
        [selected addObject:[myArray objectAtIndex:[indexPath row]]];
        
    }else{
        [selected removeObject:[myArray objectAtIndex:[indexPath row]]];
        
    }
    [myTable reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    NoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == Nil){
        cell = [[NoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_normal.png"];
        [cell setValueForTableCell];
        //        iamge = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        //        iamge.image = [UIImage imageNamed:@"2leftarrow.png"];
        //        [cell addSubview:iamge];
    }
    
    if([selected containsObject:[myArray objectAtIndex:[indexPath row]]]){
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_selected.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_normal.png"];
    }
//    cell.textLabel.text = [myArray objectAtIndex:[indexPath row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    headerLab.backgroundColor = [UIColor grayColor];
    headerLab.text = @"总共12套";
    
    return headerLab;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    contentView.backgroundColor = [UIColor grayColor];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.frame = CGRectMake(20, 10, 130, 40);
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:delete];
    
    UIButton *multiSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    multiSelect.frame = CGRectMake(190, 10, 130, 40);
    [multiSelect setTitle:@"定价推广" forState:UIControlStateNormal];
    [multiSelect addTarget:self action:@selector(multiSelect) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:multiSelect];
    
    return contentView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- PrivateMethod
-(void)delete{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)multiSelect{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
