//
//  FindHomeViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FindHomeViewController.h"
#import "FindPropertyCell.h"
#import "Util_UI.h"
#import "BrokerLineView.h"

@interface FindHomeViewController ()

@end

@implementation FindHomeViewController
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

-(void)dealloc{
    self.myTable.delegate = nil;
    self.refreshView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleViewWithString:@"发现"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myTable setContentOffset:CGPointMake(0, -65) animated:YES];
}
- (void)initModel {
    self.myArray = [NSMutableArray array];
//    http://api.anjuke.test/mobile-ajk-broker/1.0/find/nearbycomm/?brokerId=147468&cityId=14&lat=39.956333931585&lng=116.8507188079&mapType=1

}

- (void)initDisplay {
    self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, [self windowWidth], [self windowHeight]- STATUS_BAR_H - TAB_BAR_H - NAV_BAT_H - 25) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:myTable];
    
    //refresh View
    CGRect refreshRect = CGRectMake(0.0f, 0.0f - self.myTable.bounds.size.height, self.myTable.frame.size.width, self.myTable.bounds.size.height);
    self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshRect arrowImageName:@"fresh1_1008.png" textColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    self.refreshView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.refreshView.delegate = self;
    [self.myTable addSubview:self.refreshView];
    
    UIView *img = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 25)];
    img.backgroundColor = [Util_UI colorWithHexString:@"#EEEEEE"];
    
    UILabel *lanhaiLab = [[UILabel alloc] initWithFrame:CGRectMake(64, 5, 100, 20)];
    lanhaiLab.backgroundColor = [UIColor clearColor];
    lanhaiLab.text = @"用户爱，宜发房";
    lanhaiLab.textColor = [Util_UI colorWithHexString:@"#666666"];
    lanhaiLab.font = [UIFont systemFontOfSize:11];
    [img addSubview:lanhaiLab];
    
   UILabel *hotLab = [[UILabel alloc] init];
    hotLab.backgroundColor = [UIColor clearColor];
    hotLab.frame = CGRectMake(192, 5, 100, 20);
    hotLab.text = @"竞争大，宜竞价";
    hotLab.textColor = [Util_UI colorWithHexString:@"#666666"];
    hotLab.font = [UIFont systemFontOfSize:11];
    [img addSubview:hotLab];
    
    UIImageView *lanhaiImg = [[UIImageView alloc] init];
    lanhaiImg.frame = CGRectMake(44, 7, 12, 12);
    lanhaiImg.image = [UIImage imageNamed:@"anjuke_icon_bluesea@2x.png"];
    [img addSubview:lanhaiImg];
    
    UIImageView *hotImg = [[UIImageView alloc] init];
    hotImg.frame = CGRectMake(173, 7, 12, 12);
    hotImg.image = [UIImage imageNamed:@"anjuke_icon_hot@2x.png"];
    [img addSubview:hotImg];
    //anjuke_icon_bluesea@2x.png
    //anjuke_icon_hot@2x.png
    [self.view addSubview:img];
//    self.myTable.tableHeaderView = img;
}

#pragma mark - 获取发现信息
-(void)doRequest{
    if (self.isLoading == YES) {
        //        return;
    }
    
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    CLLocationCoordinate2D userCoordinate = [[[RTLocationManager sharedInstance] mapUserLocation] coordinate];
    NSString *lat = [NSString stringWithFormat:@"%f",userCoordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",userCoordinate.longitude];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", @"1", @"mapType", lat, @"lat", lng, @"lng", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"find/nearbycomm/" params:params target:self action:@selector(onGetSuccess:)];
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
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

    if ([[resultFromAPI objectForKey:@"topComms"] count] > 0) {
        [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"topComms"]];
    }
    
    if ([[resultFromAPI objectForKey:@"commonComms"] count] > 0) {
        [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"commonComms"]];
    }
    
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0f / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"cell";
    FindPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[FindPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    [cell configureCell:[self.myArray objectAtIndex:indexPath.row] withIndex:indexPath.row];
    return cell;
}

- (void)setIsLoading:(BOOL)isLoading {
    if (isLoading == NO) {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTable];
    }
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
