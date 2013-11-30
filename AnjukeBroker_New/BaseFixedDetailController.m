//
//  BaseFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseFixedDetailController.h"
#import "SaleFixedCell.h"
#import "BasePropertyListCell.h"
#import "BaseFixedCell.h"

@interface BaseFixedDetailController ()

@end

@implementation BaseFixedDetailController
@synthesize myTable;
@synthesize myArray;

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
    
	// Do any additional setup after loading the view.
}
-(void)dealloc{
    self.myTable.delegate = nil;
}
-(void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self.myTable];
}

-(void)initModel{
    self.myArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorColor = [UIColor whiteColor];
    if([indexPath row] == 0){
        static NSString *cellIdent = @"BaseFixedCell";
        BaseFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"BaseFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseFixedCell"];
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row]]];
        
        return cell;
    }else{
        
        static NSString *cellIdent = @"PropertyListCell";
        BasePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"PropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyListCell"];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setValueForCellByObject:[self.myArray objectAtIndex:[indexPath row]]];
        
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

@end
