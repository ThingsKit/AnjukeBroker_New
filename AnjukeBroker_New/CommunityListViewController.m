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
#import "Util_TEXT.h"
#import "AppManager.h"
#import "PublishBuildingViewController.h"

#define COM_CELL_HEIGHT 55
#define SEARCH_DISTANCE @"5000"

@interface CommunityListViewController ()

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) UISearchBar *search_Bar;

@property (nonatomic, strong) UIImageView *noDataImgView;//tableview没有数据显示图片
@property (nonatomic)         BOOL         isCheckNoDataImg;//第一次进入

@property BOOL requestKeywords; //是否请求关键词，用于解析数据的区分
@end

@implementation CommunityListViewController
@synthesize listDataArray;
@synthesize tvList, search_Bar;
@synthesize listType;
@synthesize requestKeywords;
@synthesize communityDelegate;
@synthesize isHaouzu;
@synthesize isFirstShow;

@synthesize noDataImgView = _noDataImgView;
@synthesize isCheckNoDataImg  = _isCheckNoDataImg;

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
    
    DLog(@"dealloc CommunityListViewController");
}

#pragma mark - log
- (void)sendAppearLog {
    NSString *code = [NSString string];
    if (self.isHaouzu) {
        code = HZ_COMMUNITY_001;
    }
    else
        code = AJK_COMMUNITY_001;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    NSString *code = [NSString string];
    if (self.isHaouzu) {
        code = HZ_COMMUNITY_002;
    }
    else
        code = AJK_COMMUNITY_002;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - private method
- (void)initModel {
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
//    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
//    
//    // Change search bar text color
//    searchField.textColor = [UIColor blackColor];
//    
//    // Change the search bar placeholder text color
//    [searchField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    sb.delegate = self;
    sb.placeholder = @"请输入小区名或地址";
    sb.tintColor = [UIColor whiteColor];
    sb.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
    sb.backgroundImage = [UIImage createImageWithColor:SYSTEM_NAVBAR_DARK_BG];

    UITextField *searchField = nil;
    if ([AppManager isIOS6]) {
        sb.barStyle = UIBarStyleDefault;
        //ios6及以下设置搜索框颜色
        for (UIView *subview in sb.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)subview;
                searchField.textColor = [UIColor blackColor];
                break;
            }
        }
    }
    else
        sb.barStyle = UIBarStyleBlackOpaque;
        //ios7设置搜索框颜色
        for (UIView *subView in sb.subviews){
            for (UIView *secondLevelSubview in subView.subviews){
                if ([secondLevelSubview isKindOfClass:[UITextField class]])
                {
                    UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                    searchBarTextField.textColor = [UIColor whiteColor];
                    break;
                }
            }
        }

    sb.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationItem.titleView = sb;
    
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    [self doRequestWithKeyword:sb.text];
    
    //noImgview
    UIImage *noDataImg = [UIImage imageNamed:@""];
    CGFloat noDataX = (CGRectGetWidth(tv.frame) - noDataImg.size.width) / 2;
    CGFloat noDataY = (CGRectGetHeight(tv.frame) - noDataImg.size.height) / 2;
    _noDataImgView = [[UIImageView alloc] initWithFrame:CGRectMake(noDataX, noDataY, noDataImg.size.width, noDataImg.size.height)];
    [self.tvList addSubview:_noDataImgView];
    [_noDataImgView setHidden:YES];
    _isCheckNoDataImg = YES;
}

- (void)doCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.listType == DataTypeNearby) {
        return @"你附近的小区";
    }
    else if (self.listType == DataTypeHistory) {
        return @"最近发布";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.listType == DataTypeNearby ||
        self.listType == DataTypeHistory) {
        return 25;
    }
    
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return COM_CELL_HEIGHT;
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
    }else
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    [self.tvList setHidden:NO];
    UIView *searchView = [self searchCellView:indexPath.row cellHeight:CGRectGetHeight(cell.contentView.frame)];
        
    [cell.contentView addSubview:searchView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

//绘画自定义搜索结果cellview
- (UIView *)searchCellView:(NSInteger)indexPathRow cellHeight:(CGFloat)clHeight
{
    NSDictionary *arrDict = [self.listDataArray objectAtIndex:indexPathRow];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), clHeight)];
    [cellView setBackgroundColor:[UIColor clearColor]];
    
    //小区名的label
    UILabel *commNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, CGRectGetWidth(cellView.frame), 28)];
    [commNameLabel setText:[arrDict objectForKey:@"commName"]];
    [commNameLabel setBackgroundColor:[UIColor clearColor]];
    [commNameLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    //小区地址的label
    CGFloat addLabelX = commNameLabel.frame.origin.x;
    CGFloat addLabelY = commNameLabel.frame.origin.y + CGRectGetHeight(commNameLabel.frame) - 5;
    CGFloat addLabelWidht = CGRectGetWidth(commNameLabel.frame);
    CGFloat addLabelHeight = 22;
    UIFont *addLabelFont = [UIFont systemFontOfSize:12];
    NSString *addLabelText = [arrDict objectForKey:@"address"];
        
    if ([addLabelText length] > 20)
    {
        CGSize sizeText = [[addLabelText substringToIndex:20] sizeWithFont:addLabelFont];
        
        addLabelWidht = sizeText.width;
    }
    
    
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addLabelX, addLabelY, addLabelWidht, addLabelHeight)];
    [addressLabel setText:addLabelText];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [addressLabel setFont:addLabelFont];
    [addressLabel setTextColor:SYSTEM_NAVBAR_DARK_BG];
    
    [cellView addSubview:commNameLabel];
    [cellView addSubview:addressLabel];
    
    return cellView;
    
}

#pragma mark - Request Method

- (void)doRequestWithKeyword:(NSString *)keyword {
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (keyword.length == 0) {
        self.requestKeywords = NO;
        
        CLLocationCoordinate2D userCoordinate = [[[RTLocationManager sharedInstance] mapUserLocation] coordinate];
        NSString *lat = [NSString stringWithFormat:@"%f",userCoordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",userCoordinate.longitude];
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", lat, @"lat", lng, @"lng", @"0", @"mapType", nil];
        
        if (self.isHaouzu) {
            method = @"zufang/prop/getcommlist/"; //好租
        }
        else {
            method = @"anjuke/prop/getcommlist/"; //二手房
        }
    }
    else {
        self.requestKeywords = YES;
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", keyword, @"keyword", nil];
        
        method = @"comm/getcommbykw/";
        
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onGetSearch:)];
    }
    
    if (keyword.length == 0)
    {
        _isCheckNoDataImg = YES;
    }
    
    if ([self isNetworkOkay]) {
        [self showLoadingActivity:YES];
        self.isLoading = YES;
        
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onGetSearch:)];
    }
}

- (void)onGetSearch:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索小区失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;

        return;
    }
    
    self.listDataArray = [NSMutableArray array];
    
    NSArray *hisArr = nil;
    if (!self.requestKeywords) { //历史+附近
        hisArr = [[[response content] objectForKey:@"data"] objectForKey:@"history"];
        if (hisArr.count == 0 || hisArr == nil) {
            //没有历史记录，使用附近小区list
            self.listDataArray = [[[response content] objectForKey:@"data"] objectForKey:@"nearby"];
            self.listType = DataTypeNearby;
        }
        else {
            self.listDataArray = [NSMutableArray arrayWithArray:hisArr];
            self.listType = DataTypeHistory;
        }
        
    }
    else {
        self.listType = DataTypeKeywords;
        NSArray *arr = [[[response content] objectForKey:@"data"] objectForKey:@"commlist"];
        self.listDataArray = [NSMutableArray arrayWithArray:arr];
    }
    
    //如果arr中没有数据隐藏
    if ([self.listDataArray count] == 0 && !_isCheckNoDataImg)
    {
        [self.tvList setHidden:YES];
        [_noDataImgView setHidden:NO];//显示nodatanoticeimg
    }else
    {
        [_noDataImgView setHidden:YES];//隐藏nodatanoticeimg
    }
    
    _isCheckNoDataImg = NO;
    
    [self.tvList reloadData];
    [self.tvList setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;

}



#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isFirstShow) { //首次发房push出的小区列表页，点击小区后push进发房页面
        
        [self.search_Bar resignFirstResponder];
        
        PublishBuildingViewController *pb = [[PublishBuildingViewController alloc] init];
        pb.isHaozu = self.isHaouzu;
        [pb setCommunityDic:[NSDictionary dictionaryWithDictionary:[self.listDataArray objectAtIndex:indexPath.row]]]; //小区数据传递
        [self.navigationController pushViewController:pb animated:YES];
        
        return;
    }
    if ([self.communityDelegate respondsToSelector:@selector(communityDidSelect:)]) {
        [self.communityDelegate communityDidSelect:[self.listDataArray objectAtIndex:indexPath.row]];
    }
    
    if ([AppManager isIOS6]) { //iOS6下需要做动画以适配crash
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *code = [NSString string];
    if (self.isHaouzu) {
        code = HZ_COMMUNITY_003;
    }
    else
        code = AJK_COMMUNITY_003;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    NSString *newStr = [Util_TEXT rmBlankFromString:searchText];
    DLog(@"联想词 [%@]", newStr);
    
    if (newStr.length > 0) {
        [self doRequestWithKeyword:newStr];
    }else
    {
        [self doRequestWithKeyword:@""];
        /*
        [self.listDataArray removeAllObjects];
        [self.tvList reloadData];
         */
    }
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
