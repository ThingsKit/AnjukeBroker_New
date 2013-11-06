//
//  NoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanController.h"
//#import "BaseNoPlanListCell.h"
#import "SaleNoPlanListCell.h"

@interface BaseNoPlanController ()

@end

@implementation BaseNoPlanController
@synthesize myArray;
@synthesize myTable;
@synthesize selectedArray;
@synthesize iamge;

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
    [self setTitleViewWithString:@"待推广房源"];
    
    [self initModel_];
    
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
//    self.myTable.tableFooterView.hidden = YES;
    [self.view addSubview:self.myTable];
	// Do any additional setup after loading the view.
}

- (void)initModel_ {
    self.myArray = [NSMutableArray array];
    self.selectedArray = [NSMutableArray array];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
//        cell.clickDelegate = self;
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
//    headerLab.backgroundColor = [UIColor grayColor];
//    headerLab.text = @"总共12套";
//    
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
//    delete.frame = CGRectMake(20, 10, 130, 40);
//    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
//    [contentView addSubview:delete];
//    
//    UIButton *multiSelect = [UIButton buttonWithType:UIButtonTypeCustom];
//    multiSelect.frame = CGRectMake(190, 10, 130, 40);
//    [multiSelect setTitle:@"定价推广" forState:UIControlStateNormal];
//    [multiSelect addTarget:self action:@selector(multiSelect) forControlEvents:UIControlEventTouchDown];
//    [contentView addSubview:multiSelect];
//    
//    return contentView;
//}

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
