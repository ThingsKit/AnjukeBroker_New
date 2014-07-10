//
//  CommunitySelectViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CommunitySelectViewController.h"

@interface CommunitySelectViewController ()
@property(nonatomic, strong) UIView *noDataView;
@end

@implementation CommunitySelectViewController
@synthesize pageTypeFrom;
@synthesize arr;
#pragma mark - log
- (void)sendAppearLog {
    if (self.pageTypeFrom == secondHandHouse) {
        if (_isSayHello)
        {
            [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_XIAOQU_ONVIEW page:potential_client_xiaoqu note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }else
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_XIAOQU_ONVIEW page:CHAT_ESF_XIAOQU note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }
        
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_XIAOQU_ONVIEW page:CHAT_ZF_XIAOQU note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

- (void)sendDisAppearLog {
    if (self.pageTypeFrom == secondHandHouse) {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_COMMUNITY_CHAT_002 page:CHAT_ESF_XIAOQU note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_COMMUNITY_CHAT_002 page:CHAT_ZF_XIAOQU note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
    }
}

#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithTarget:(id)target action:(SEL)selector {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleViewWithString:@"选择小区"];
    
    [self request];
}
-(void)request{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSString *urlStr;
    NSMutableDictionary *params;
    if (self.pageTypeFrom == secondHandHouse) {
        urlStr = @"anjuke/chat/getcommlist/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    }else{
        urlStr = @"zufang/chat/getcommlist/";
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:urlStr params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
-(void)onGetFixedInfo:(RTNetworkResponse *)response{
    self.isLoading = NO;
    
    if([[response content] count] == 0){
        [self showInfo:@"操作失败"];
        
        [self hideLoadWithAnimated:YES];
        
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        
        return;
        
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
    
    if (![resultFromAPI objectForKey:@"data"] || [[resultFromAPI objectForKey:@"data"] count] == 0) {
        [self hideLoadWithAnimated:YES];

        self.tableList.hidden = YES;
        [self.view addSubview:self.noDataView];

        return;
    }else{
        if (self.arr) {
            [self.arr removeAllObjects];
        }
        self.arr = [[NSMutableArray alloc] initWithArray:[resultFromAPI objectForKey:@"data"]];
        
        [self.tableList reloadData];
    }
    
    [self hideLoadWithAnimated:YES];
}

- (UIView *)noDataView{
    UIView *view = [[UIView alloc] initWithFrame:FRAME_WITH_NAV];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-90)/2, (ScreenHeight - 20 - 44)/2 - 100, 90, 79)];
    [imgView setImage:[UIImage imageNamed:@"check_no_community"]];
    [view addSubview:imgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, (ScreenHeight - 20 - 44)/2 - 15, ScreenWidth, 30)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"暂无房源";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor lightGrayColor];
    [view addSubview:lab];
    
    return view;
}

#pragma UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return COMMUNITYSELECTCELLHEIGHT;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellName";
    HouseSelectCommunityCell *houseCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (houseCell == nil) {
        houseCell = [[HouseSelectCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    houseCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [houseCell insertCellWithDic:[arr objectAtIndex:indexPath.row]];
    [houseCell showBottonLineWithCellHeight:COMMUNITYSELECTCELLHEIGHT];
    return houseCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pageTypeFrom == secondHandHouse) {
        if (_isSayHello)
        {
            [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_XIAOQU_SELECT page:potential_client_xiaoqu note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
        }else
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_XIAOQU_SELECT page:CHAT_ESF_XIAOQU note:nil];
        }
        
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_XIAOQU_SELECT page:CHAT_ZF_XIAOQU note:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PropertySelectViewController *proLVC = [[PropertySelectViewController alloc] init];
    proLVC.backType = RTSelectorBackTypePopBack;
    if (self.pageTypeFrom == secondHandHouse) {
        proLVC.pageTypePropertyFrom = secondHandPropertyHouse;
        proLVC.isSayHello = _isSayHello;
        proLVC.willsendProp = _willSendProp;
    }else{
        proLVC.pageTypePropertyFrom = rentPropertyHouse;
    }
    [proLVC passDataWithDic:[self.arr objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:proLVC animated:YES];
}

- (void)doBack:(id)sender {
     if (self.pageTypeFrom == secondHandHouse) {
         if (_isSayHello)
         {
             [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_XIAOQU_BACK page:potential_client_xiaoqu note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
         }else
         {
             [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF_XIAOQU_BACK page:CHAT_ESF_XIAOQU note:nil];
         }
         
     }else {
         [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF_XIAOQU_BACK page:CHAT_ZF_XIAOQU note:nil];
     }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
