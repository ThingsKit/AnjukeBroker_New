//
//  AJK_MoreViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreListCell.h"
#import "AppManager.h"
#import "AboutUsViewController.h"
#import "LoginManager.h"
#import "Util_UI.h"
#import "AppDelegate.h"
#import "BrokerAccountController.h"
#import "BigZhenzhenButton.h"
#import "AXChatMessageCenter.h"
#import "BrokerCallAlert.h"

#define CALL_ANJUKE_NUMBER @"400-620-9008"
#define CALL_ANJUKE_ROW 6
#define CALL_CLIENT_ROW 5

#define ABOUT_US_ROW 4
#define CALL_CHECKVER 3
#define CALL_CHECKMSG 2
#define CALL_ACCOUNT_ROW 0
#define NOTIFICATION_ROW 1

@interface MoreViewController ()
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) UITableView *tvList;

@property (nonatomic, strong) NSDictionary *clientDic;
@property (nonatomic, strong) UISwitch *msgSw;
@end

@implementation MoreViewController
@synthesize taskArray, tvList;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleViewWithString:@"设置"];
    
    if (self.clientDic.count == 0) {
        [self doRequest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - private method

- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"个人信息", @"提醒设置", @"短信通知", @"检查更新", @"关于移动经纪人", @"联系客户主任", @"客服热线", nil];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
//    tv.layer.borderColor = [UIColor blackColor].CGColor;
//    tv.layer.borderWidth = 1;
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT*1.5)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat btnW = 300;
    CGFloat btnH = CELL_HEIGHT - 8;
    BigZhenzhenButton *logoutBtn = [[BigZhenzhenButton alloc] initWithFrame:CGRectMake((footerView.frame.size.width -btnW)/2, (footerView.frame.size.height - btnH)/2, btnW, btnH)];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    self.tvList.tableFooterView = footerView;
}

- (NSString *)getClientName {
    NSString *str = [NSString string];
    
    if (self.clientDic.count == 0) {
        str = @"";
    }
    else {
        str = [self.clientDic objectForKey:@"saleManagerName"];
        if (str.length == 0) {
            str = [self.clientDic objectForKey:@"saleManagerTel"];
        }
    }
    
    return str;
}

- (void)messageSw: (id)sender {
    UISwitch *sw = (UISwitch *)sender;
    
    NSString *code = [NSString string];
    if (sw.on) {
        DLog(@"推送打开");
        code = HZ_MORE_005;
    }
    else {
        DLog(@"推送关闭");
        code = HZ_MORE_004;
    }
    
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
}

- (void)loginOut {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [av setCancelButtonIndex:0];
    [av show];
    
}

#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    method = @"broker/getsalemanager/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)checkMsgOpenStatus{
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"from_idc", nil];
    method = [NSString stringWithFormat:@"message/getRemindBrokerSwitchStatus/%@",[LoginManager getChatID]];

    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTAnjukeXRESTServiceID methodName:method params:params target:self action:@selector(checkMsgOpenStatusOnRequestFinished:)];
}
- (void)turnSwich:(BOOL)openOrHide{
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }

    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"from_idc", nil];
    method = [NSString stringWithFormat:@"message/changeRemindBrokerSwitchStatus/%@/%@",[LoginManager getChatID],[NSNumber numberWithBool:openOrHide]];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTAnjukeXRESTServiceID methodName:method params:params target:self action:@selector(OnTurnSwichRequestFinished:)];
}
- (void)OnTurnSwichRequestFinished:(RTNetworkResponse *)response {
    self.isLoading = NO;
    [self hideLoadWithAnimated:YES];
    
    DLog(@"[response content]-->>%@",[response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self showInfo:@"请求失败"];
    }
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSString *result = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"result"]];
        if ([result isEqualToString:@"1"] || [result isEqualToString:@"0"]) {
            [self showInfo:@"修改成功"];
        }else{
            self.msgSw.on = !self.msgSw.on;
            [self showInfo:@"修改失败"];
        }
    }else{
        self.msgSw.on = !self.msgSw.on;
    }

}
- (void)checkMsgOpenStatusOnRequestFinished:(RTNetworkResponse *)response {
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        return;
    }
    DLog(@"checkMsgOpenStatusOnRequestFinished-->>%@",[response content]);
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSString *msgOpenStatus = nil;
        msgOpenStatus = [NSString stringWithFormat:@"%@",[[[response content] objectForKey:@"result"] objectForKey:@"sms_receive_switch"]];
        if ([msgOpenStatus isEqualToString:@"0"]) {
            self.msgSw.on = YES;
        }else{
            self.msgSw.on = NO;
        }
    }
}
- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
        return;
    }
    
    self.clientDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerInfo"];
    
    [self.tvList reloadData];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}

- (void)requestLoginOut {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    method = @"logout/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onLoginOutFinished:)];
}

- (void)onLoginOutFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]) {
        //退出登录
        [[AppDelegate sharedAppDelegate] doLogOut];
    }
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MORE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        
    }
    
    [cell configureCell:self.taskArray withIndex:indexPath.row];
    
    if (indexPath.row == NOTIFICATION_ROW) {
        //显示消息提醒
//        [cell showSwitch];
//        [cell.messageSwtich addTarget:self action:@selector(messageSw:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.row == CALL_CHECKMSG){
        self.msgSw = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 25 - 35, (MORE_CELL_H - 20)/2-5, 30, 20)];
        [self.msgSw addTarget:self action:@selector(checkSw:) forControlEvents:UIControlEventValueChanged];
        self.msgSw.on = YES;
        [cell.contentView addSubview:self.msgSw];

        cell.accessoryView = self.msgSw;

        [self checkMsgOpenStatus];
    }
    else if (indexPath.row == CALL_CLIENT_ROW) { //客户主任
        [cell setDetailText:[self getClientName]];
    }
    else if (indexPath.row == CALL_ANJUKE_ROW) {
        [cell setDetailText:CALL_ANJUKE_NUMBER];
    }
    if (indexPath.row != CALL_CHECKMSG) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row == CALL_ACCOUNT_ROW || indexPath.row == NOTIFICATION_ROW || indexPath.row == 3 || indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)checkSw:(id)sender{
    if (!self.msgSw.on) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信提醒" message:@"客户发起微聊后，将不再短信我" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭提醒", nil];
        alert.tag = 10;
        alert.delegate = self;
        [alert show];
    }else{
        [self turnSwich:NO];
    }
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    switch (indexPath.row) {
        case CALL_ACCOUNT_ROW:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_003 note:nil];
            
            //broker acunt
            BrokerAccountController *controller = [[BrokerAccountController alloc] init];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case NOTIFICATION_ROW:{ //消息提醒
            //            NotificationSetupViewController *controller = [[NotificationSetupViewController alloc] init];
            //            [controller setHidesBottomBarWhenPushed:YES];
            //            [self.navigationController pushViewController:controller animated:YES];
            
            NSString *message = @"如需打开/关闭消息推送请到设置-->通知-->通知中心-->移动经纪人进行设置";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case CALL_ANJUKE_ROW:
        {
            
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_009 note:nil];
            
            //make call
            [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:CALL_ANJUKE_NUMBER];
        }
            break;
        case CALL_CHECKVER:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_006 note:nil];
            
            //check version
            [[AppDelegate sharedAppDelegate] setBoolNeedAlert:YES];
            [[AppDelegate sharedAppDelegate] checkVersionForMore:YES];
        }
            break;
        case CALL_CLIENT_ROW:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_008 note:nil];
            
            //make call
            [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系客户主任%@：",[self getClientName]] callPhone:[self.clientDic objectForKey:@"saleManagerTel"]];
        }
            break;
        case ABOUT_US_ROW:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_007 note:nil];
            
            AboutUsViewController *av = [[AboutUsViewController alloc] init];
            [av setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:av animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10 && buttonIndex == 1) {
        [self turnSwich:YES];
        return;
    }else if (alertView.tag == 10 && buttonIndex == 0){
        self.msgSw.on = YES;
        return;
    }
    switch (buttonIndex) {
        case 1:
        {
            [self requestLoginOut];
        }
            break;
            
        default:
            break;
    }
}
@end
