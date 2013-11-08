//
//  CommunityListViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "CommunityListViewController.h"
#import "Util_UI.h"
#import "LoginManager.h"

#define CELL_HEIGHT 45
#define SEARCH_DISTANCE @"5000"

@interface CommunityListViewController ()

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSMutableArray *listDataArray;
@property BOOL isHistroy; //根据联想词length获取显示数据
@property (nonatomic, strong) UISearchBar *search_Bar;
@end

@implementation CommunityListViewController
@synthesize listDataArray;
@synthesize tvList, search_Bar;
@synthesize isHistroy;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.tvList.delegate = self;
}

#pragma mark - private method
- (void)initModel {
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    
    UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    sb.delegate = self;
    sb.placeholder = @"请输入小区名或地址";
    sb.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
    sb.barStyle = UIBarStyleDefault;
    sb.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationItem.titleView = sb;
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    [self doRequestWithKeyword:sb.text];
}

- (void)doCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isHistroy) {
        return @"你附近的小区";
    }
    
    return @"你是否在找";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityCell = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCell];
        
    }
    else {
        
    }
    
    UIFont *font = [UIFont systemFontOfSize:18];
    
    if (self.isHistroy) {
        cell.textLabel.text = [[self.listDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else {
        cell.textLabel.text = [[self.listDataArray objectAtIndex:indexPath.row] objectForKey:@"commName"];
    }
    cell.textLabel.font = font;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - Request Method

- (void)doRequestWithKeyword:(NSString *)keyword {
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (keyword.length == 0) {
        self.isHistroy = YES;
        
        CLLocationCoordinate2D userCoordinate = [[[RTLocationManager sharedInstance] mapUserLocation] coordinate];
        NSString *lat = [NSString stringWithFormat:@"%f",userCoordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",userCoordinate.longitude];
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"city_id", lat, @"lat",lng, @"lng", SEARCH_DISTANCE, @"distance",@"0", @"map_type", nil];
        
        method = @"prop/getcommlist/";
    }
    else {
        self.isHistroy = NO;
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getCity_id], @"city_id", keyword, @"keyword", nil];
        
        method = @"comm/getcommbykw/";
    }
    
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onGetSearch:)];
}

- (void)onGetSearch:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索小区失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.listDataArray = [NSMutableArray array];
    if (self.isHistroy) {
        self.listDataArray = [[response content] objectForKey:@"data"];
    }
    else {
        self.listDataArray = [[[response content] objectForKey:@"data"] objectForKey:@"commlist"];
    }
    
    [self.tvList reloadData];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.search_Bar resignFirstResponder];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self doRequestWithKeyword:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Keyboard NOtifacation
-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.tvList setFrame:FRAME_WITH_NAV];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    [self.tvList setFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight] - 216 - 44)];
}

@end
