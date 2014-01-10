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
@synthesize planDic;
@synthesize refreshView;

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
    self.refreshView.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

-(void)reloadData{
    
    if(self.myArray == nil){
        self.myArray = [NSMutableArray array];
    }else{
        [self.myArray removeAllObjects];
    }
    
    [self.myTable reloadData];
    
//    [self doRequest];
    [self.myTable setContentOffset:CGPointMake(0, -65) animated:YES];
}

-(void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
//    self.myTable.separatorColor = [UIColor whiteColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];
    
    //refresh View
    CGRect refreshRect = CGRectMake(0.0f, 0.0f - self.myTable.bounds.size.height, self.myTable.frame.size.width, self.myTable.bounds.size.height);
    self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshRect arrowImageName:@"fresh1_1008.png" textColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    self.refreshView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.refreshView.delegate = self;
    [self.myTable addSubview:self.refreshView];
}

-(void)initModel{
    self.myArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doRequest{
    
}

- (void)setIsLoading:(BOOL)isLoading {
    if (isLoading == NO) {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTable];
    }
}

#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.myArray.count == 0) {
        if (self.planDic == nil) {
            return 0;
        }
        else
            return 1;
    }
    
    DLog(@"count [%d]", self.myArray.count);
    return [self.myArray count] +1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView.separatorColor = [UIColor whiteColor];
    if([indexPath row] == 0){
        static NSString *cellIdent = @"BaseFixedCell";
        BaseFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"BaseFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseFixedCell"];
        }
        [cell configureCell:self.planDic];
        
        return cell;
    }else{
        
        static NSString *cellIdent = @"PropertyListCell";
        BasePropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"PropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyListCell"];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setValueForCellByObject:[self.myArray objectAtIndex:[indexPath row] +1]];
        
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

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    if ([self isNetworkOkay]) {
        [self doRequest];
    }
    else {
        [self.myTable setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTable];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.isLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (![self isNetworkOkay]) {
        self.isLoading = NO;
        [self.myTable setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![self isNetworkOkay]) {
        self.isLoading = NO;
        [self.myTable setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

@end
