//
//  BaseBidDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseBidDetailController.h"
#import "BaseBidPropertyCell.h"
#import "Util_UI.h"

@interface BaseBidDetailController ()

@end

@implementation BaseBidDetailController
@synthesize myArray;
@synthesize myTable;
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
-(void)initModel{
    self.myArray = [NSMutableArray array];
}
-(void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable setBackgroundColor:[Util_UI colorWithHexString:@"#EFEFF4"]];
    self.myTable.separatorColor = [Util_UI colorWithHexString:@"#EFEFF4"];
    [self.view addSubview:self.myTable];
    
    //refresh View
    CGRect refreshRect = CGRectMake(0.0f, 0.0f - self.myTable.bounds.size.height, self.myTable.frame.size.width, self.myTable.bounds.size.height);
    self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshRect arrowImageName:@"fresh1_1008.png" textColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    self.refreshView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.refreshView.delegate = self;
    [self.myTable addSubview:self.refreshView];
}

- (void)setIsLoading:(BOOL)isLoading {
    if (isLoading == NO) {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTable];
    }
}

-(void)doRequest{
    
}

#pragma mark - TableView Delegate && DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源信息", @"竞价出价及预算", @"暂停竞价推广", nil];
    [action showInView:self.view];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdent = @"BaseBidPropertyCell";
    BaseBidPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if(cell == nil){
        cell = [[NSClassFromString(@"BaseBidPropertyCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseBidPropertyCell"];
    }
    
    [cell setValueForCellByDictinary:[self.myArray objectAtIndex:[indexPath row]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self doRequest];
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
        return;
    }
    
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![self isNetworkOkay]) {
        self.isLoading = NO;
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
