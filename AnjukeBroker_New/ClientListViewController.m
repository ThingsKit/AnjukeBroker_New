//
//  ClientListViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientListViewController.h"
#import "ClientDetailViewController.h"

@interface ClientListViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) NSMutableArray *publicDataArr; //公共账号列表
@property (nonatomic, strong) NSMutableArray *starDataArr; //星标客户列表
@property (nonatomic, strong) NSMutableArray *allDataArr; //所有客户列表

@end

@implementation ClientListViewController
@synthesize publicDataArr, starDataArr, allDataArr;
@synthesize tableViewList, listDataArray;

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
    
    [self setTitleViewWithString:@"我的客户"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redrawList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    self.publicDataArr = [NSMutableArray array];
    self.starDataArr = [NSMutableArray array];
    self.allDataArr = [NSMutableArray array];
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
//    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];

}

- (void)redrawList {
    self.listDataArray = [NSMutableArray array];
    
    //reset 3 list arr ...
    //test
    NSArray *arr = @[@"", @"", @"", @"", @""];
    self.publicDataArr = [NSMutableArray arrayWithArray:arr];
    self.starDataArr = [NSMutableArray arrayWithArray:arr];
    self.allDataArr = [NSMutableArray arrayWithArray:arr];
    
    //add 3 arr to list data att
    if (self.publicDataArr.count > 0) {
        [self.listDataArray addObject:self.publicDataArr];
    }
    if (self.starDataArr.count > 0) {
        [self.listDataArray addObject:self.starDataArr];
    }
    if (self.allDataArr.count > 0) {
        [self.listDataArray addObject:self.allDataArr];
    }
    
    [self.tableViewList reloadData];
}

#pragma mark - private Method

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"标星"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"删除"];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray array];
    
    return leftUtilityButtons;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.listDataArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CLIENT_LIST_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"★星标客户";
            break;
        case 2:
            return @"全部客户";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClientListCell *cell = (ClientListCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    NSArray *rightBtnarr = [NSArray array];
    if (indexPath.section > 0) {
        DLog(@"section > 0");
        rightBtnarr = [self rightButtons];
    }
    
    if (cell == nil) {
        cell = [[ClientListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil
                                  containingTableView:tableView // Used for row height and selection
                                   leftUtilityButtons:[self leftButtons]
                                  rightUtilityButtons:rightBtnarr];
        cell.delegate = self;
    }
    
    [cell setCellHeight:CLIENT_LIST_HEIGHT];
    [cell configureCellWithData:nil];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //for test
    ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
    [cd setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cd animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableViewList indexPathForCell:cell];
    
    switch (index) {
        case 0:
        {
            DLog(@"More button was pressed--index[%d, %d]", cellIndexPath.section, cellIndexPath.row);
//            [cell hideUtilityButtonsAnimated:YES];
            [[[cell rightUtilityButtons] objectAtIndex:0] setTitle:@"已标" forState:UIControlStateNormal];
            
            break;
        }
        case 1:
        {
            // Delete button was pressed
            [self.tableViewList beginUpdates];
            [cell hideUtilityButtonsAnimated:NO];
            
            [self.listDataArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            [self.tableViewList deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableViewList endUpdates];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

@end
