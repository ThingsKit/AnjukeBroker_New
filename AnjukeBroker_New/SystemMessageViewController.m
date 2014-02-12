//
//  SystemMessageViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-31.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "Util_UI.h"
#import "SystemCellManager.h"
#import "SystemMessageCell.h"
#import "SystemMessageDetailViewController.h"

@interface SystemMessageViewController ()
@property int selectedIndex;
@end

@implementation SystemMessageViewController
//@synthesize  messageDataArr;
@synthesize myTable;
@synthesize myArray;
@synthesize selectedIndex; //选中的cell记录

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
    
    [self setTitleViewWithString:@"系统公告"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.myTable.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self doRequest];
}

#pragma mark - private method

- (void)initModel {
    self.myArray = [NSMutableArray array];
}

- (void)initDisplay {
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];
}

#pragma mark - 获取系统消息
- (void)doRequest{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"announcelist/" params:params target:self action:@selector(onGetSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    [self.myArray removeAllObjects];
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return ;
    }
    
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"announce_list"]];
    
    [self.myTable reloadData];
    
    
    NSTimeInterval interv = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",(int)interv] forKey:@"datetime"];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}

#pragma mark - tableView Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myArray count];//self.groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SystemCellManager getCellHeightForExpand:YES withContentStr:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    else {
        
    }
    [cell configureCell:self.myArray withIndex:indexPath.row];
    
    [cell showBottonLineWithCellHeight:[SystemCellManager getCellHeightForExpand:YES withContentStr:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"content"]]];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemMessageDetailViewController *sd = [[SystemMessageDetailViewController alloc] init];
    [sd drawTextWithContent:[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
    [self.navigationController pushViewController:sd animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
