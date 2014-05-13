//
//  SystemSettingViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AppSettingViewController.h"
#import "RTListCell.h"
#import "AppDelegate.h"
#import "BigZhenzhenButton.h"
#import "AboutUsViewController.h"
#import "VersionUpdateManager.h"
#import "AppManager.h"

#define SECTIONNUM 2
#define NOTIFICCELL 60
#define MORE_CELL_H 96/2
#define UPDATEICONFRAME CGRectMake(120,9,25,30)

@interface AppSettingViewController ()<updateVersionDelegate>
@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) UISwitch *msgSw;
@property(nonatomic, strong) NSDictionary *versionDic;
@property(nonatomic, assign) BOOL isHasNewVersion;
@property(nonatomic, strong) NSString *updateUrl;
@property(nonatomic, strong) NSString *onlineVer;
@property(nonatomic, strong) VersionUpdateManager *versionUpdate;
@end

@implementation AppSettingViewController

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
    
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_006 note:nil];
    
    [self setTitleViewWithString:@"系统设置"];
    self.navigationController.navigationBarHidden = NO;
    
    self.versionUpdate = [[VersionUpdateManager alloc] init];
    self.versionUpdate.versionDelegate = self;
    [self.versionUpdate checkVersion:NO];
    
    // Do any additional setup after loading the view.
    
    self.tableList = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.showsVerticalScrollIndicator = NO;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableList];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, [self windowWidth], CELL_HEIGHT*1.5)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat btnW = 300;
    CGFloat btnH = CELL_HEIGHT - 8;
    BigZhenzhenButton *logoutBtn = [[BigZhenzhenButton alloc] initWithFrame:CGRectMake((footerView.frame.size.width -btnW)/2, (footerView.frame.size.height - btnH)/2, btnW, btnH)];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    self.tableList.tableFooterView = footerView;
}
- (void)updateVersionInfo:(NSDictionary *)dic{
    self.versionDic = [[NSDictionary alloc] initWithDictionary:dic];
    if ([self.versionDic count] != 0) {
        self.updateUrl = [NSString stringWithFormat:@"%@",[self.versionDic objectForKey:@"url"]];
        
        NSString *localVer = [AppManager getBundleVersion];
        self.onlineVer = [self.versionDic objectForKey:@"ver"];
        
        if ([self.versionDic objectForKey:@"ver"] != nil && ![[self.versionDic objectForKey:@"ver"] isEqualToString:@""]) {
            if ([localVer compare:self.onlineVer options:NSNumericSearch] == NSOrderedAscending) {
                self.onlineVer = [self.versionDic objectForKey:@"ver"];
                self.isHasNewVersion = YES;
            }else{
                self.isHasNewVersion = NO;
            }
        }
    }
    [self.tableList reloadData];
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTIONNUM;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return NOTIFICCELL;
    }
    return MORE_CELL_H;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RTListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            
            cell.textLabel.text = @"短信通知";
            
            self.msgSw = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 25 - 35, (MORE_CELL_H - 20)/2-5, 30, 20)];
            [self.msgSw addTarget:self action:@selector(checkSw:) forControlEvents:UIControlEventValueChanged];
            self.msgSw.on = YES;
            [cell.contentView addSubview:self.msgSw];
            
            cell.accessoryView = self.msgSw;
            
            [self checkMsgOpenStatus];
        }else{
            [cell showBottonLineWithCellHeight:NOTIFICCELL];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 20)];
            lab.backgroundColor = [UIColor clearColor];
            lab.text = @"消息通知";
            [cell.contentView addSubview:lab];
            
            UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 290, 20)];
            detailLab.text = @"请在iphone的“设置”-“通知中心”中进行修改";
            detailLab.backgroundColor = [UIColor clearColor];
            detailLab.font = [UIFont systemFontOfSize:12];
            detailLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:detailLab];
        }
    }else{
        if (indexPath.row == 0) {
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1 andOffsetX:15];
            if (!self.isHasNewVersion) {
                cell.textLabel.text = @"当前已经是最新版本";
            }else{
                cell.textLabel.text = @"版本更新";
                
                UIImageView *updateImg = [[UIImageView alloc] init];
                updateImg.frame = UPDATEICONFRAME;
                [updateImg setImage:nil];
                [cell.contentView addSubview:updateImg];
            }
        }else{
            [cell showBottonLineWithCellHeight:CELL_HEIGHT-1];
            cell.textLabel.text = @"关于移动经纪人";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_007 note:nil];
        
        AboutUsViewController *av = [[AboutUsViewController alloc] init];
        [av setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:av animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if (self.isHasNewVersion && self.updateUrl.length != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"发现新%@版本",self.onlineVer] delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即更新", nil];
            alert.delegate = self;
            alert.tag = 100;
            [alert show];
        }
    }
}
- (void)checkSw:(id)sender{
    if (!self.msgSw.on) {
        //短信提醒由开到关
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信提醒" message:@"客户发起微聊后，将不再短信我" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭提醒", nil];
        alert.tag = 10;
        alert.delegate = self;
        [alert show];
    }else{
        //短信提醒由关到开
        [self turnSwich:NO];
    }
}
- (void)checkMsgOpenStatus{
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [[NSMutableDictionary alloc] init];
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
    
    params = [[NSMutableDictionary alloc] init];
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
            if (self.msgSw.on) {
                [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_011 note:nil];
            }else{
                [[BrokerLogger sharedInstance] logWithActionCode:HZ_MORE_010 note:nil];
            }
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
- (void)loginOut {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [av setCancelButtonIndex:0];
    [av show];
}
- (void)requestLoginOut {
    if (![self isNetworkOkay]) {
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

#pragma mark - UIAlert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10 && buttonIndex == 1) {
        [self turnSwich:YES];
        return;
    }else if (alertView.tag == 10 && buttonIndex == 0){
        self.msgSw.on = YES;
        return;
    }else if (alertView.tag == 100 && buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end