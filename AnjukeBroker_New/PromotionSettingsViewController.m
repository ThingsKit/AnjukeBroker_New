//
//  PromotionSettingsViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/30/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "PromotionSettingsViewController.h"
#import "RTListCell.h"
#import "HudTipsUtils.h"

#define MORE_CELL_H 44
@interface PromotionSettingsViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSrouce;
@property(nonatomic,strong) UISwitch *ESFPricePromotionSwitch;
@property(nonatomic,strong) UISwitch *ZFPricePromotionSwitch;
@property(nonatomic,strong) UILabel  *ESFPlanceilingLabel;
@property(nonatomic,strong) UILabel  *ZFPlanceilingLabel;
@property(nonatomic,strong) NSString *ZFPlanId;
@property(nonatomic,strong) NSString *ESFPlanId;

@end

@implementation PromotionSettingsViewController

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
    self.dataSrouce = @[@[@"二手房定价推广",@"二手房每日限额"],@[@"租房定价推广",@"租房每日限额"]];
    [self setTitleViewWithString:@"推广设置"];
    self.ESFPricePromotionSwitch = [self commonSwitch];
    self.ZFPricePromotionSwitch  = [self commonSwitch];
    [self.ESFPricePromotionSwitch addTarget:self action:@selector(checkESFPricePromotionSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.ZFPricePromotionSwitch  addTarget:self action:@selector(checkZFPricePromotionSwitch:) forControlEvents:UIControlEventValueChanged];
    
    self.ESFPlanceilingLabel = [self commonPriceLabel];
    self.ZFPlanceilingLabel  = [self commonPriceLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStyleGrouped];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    tableView.rowHeight    = 44;
    tableView.sectionFooterHeight = 0;
    self.tableView         = tableView;
    [self.view addSubview:tableView];
    
    DLog(@"view did load");
    [self requestPromotionSettingsDataWithBrokerId:[LoginManager getUserID]];
}

- (void)requestPromotionSettingsDataWithBrokerId:(NSString *)brokerId
{
    
    NSString *method = @"batch/";
    NSDictionary *params = nil;
    NSDictionary *requeseParams1 = @{@"token":[LoginManager getToken],@"brokerId":[LoginManager getUserID]};
    NSDictionary *dic1 =  @{ @"method":@"GET",@"relative_url":@"anjuke/fix/summary/",@"query_params":requeseParams1};
    
    NSDictionary *requeseParams2 = @{@"token":[LoginManager getToken],@"brokerId":[LoginManager getUserID],@"cityId":@"11"};
    NSDictionary *dic2 = @{@"method":@"GET",@"relative_url":@"zufang/fix/summary/",@"query_params":requeseParams2};
    
    NSDictionary *dics = @{@"esf":dic1,@"zf":dic2};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    params = @{@"requests":jsonString};
    
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
    
}

- (void)handleRequestData:(RTNetworkResponse *)response
{

    if (![self checkWithResponse:response]) {
        return;
    }
    
    NSDictionary *responsesData = response.content[@"data"][@"responses"];
    NSDictionary *esfDic = [self dictionaryWithDataDic:responsesData apiType:@"esf"];
    NSDictionary *zfDic  = [self dictionaryWithDataDic:responsesData apiType:@"zf"];
    if (![self checkWithDictionaryData:esfDic]) {
        return;
    }
    NSDictionary *esfData = esfDic[@"data"];
    self.ESFPlanceilingLabel.text   = [NSString stringWithFormat:@"%@%@",esfData[@"budget"],esfData[@"budgetUnit"]];
    self.ESFPricePromotionSwitch.on = [esfData[@"planStatus"] intValue];
    self.ESFPlanId                  = esfData[@"planId"];
    if (![self checkWithDictionaryData:zfDic]) {
        return;
    }
    NSDictionary *zfData = zfDic[@"data"];
    self.ZFPlanceilingLabel.text   = [NSString stringWithFormat:@"%@%@",zfData[@"budget"],zfData[@"budgetUnit"]];
    self.ZFPricePromotionSwitch.on = [zfData[@"planStatus"] intValue];
    self.ZFPlanId                  = zfData[@"planId"];
    
}

- (BOOL)checkWithResponse:(RTNetworkResponse *)response
{
    if (response.status == RTNetworkResponseStatusFailed) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络链接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return false;
    }
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"error message--->>%@",[[response content] objectForKey:@"message"]);
       [self displayHUDWithStatus:response.content[@"status"] Message:response.content[@"message"] ErrCode:@"1"];
        return false;
    }
    return true;
}

- (BOOL)checkWithDictionaryData:(NSDictionary *)dic
{
    if ([dic[@"status"] isEqualToString:@"error"]) {
        DLog(@"data request error ---->>%@",dic[@"message"]);
        return false;
    }
    return true;
}

- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode {
    [[HudTipsUtils sharedInstance] displayHUDWithStatus:status Message:message ErrCode:errCode toView:self.view];
}

- (NSDictionary *)dictionaryWithDataDic:(NSDictionary *)dataDic apiType:(NSString *)apiType
{
    NSString *jsonString = [[dataDic valueForKey:apiType] valueForKey:@"body"];
    NSData *data         = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
   
    return dic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSrouce count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSrouce objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"idenfifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:self.ESFPricePromotionSwitch];
                }
                    break;
                case 1:
                {
                    [cell addSubview:self.ZFPricePromotionSwitch];
                }
                    break;
                default:
                    break;
            }
            
        } else if (indexPath.row == 1) {
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:self.ESFPlanceilingLabel];
                }
                    break;
                case 1:
                {
                    [cell addSubview:self.ZFPlanceilingLabel];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    cell.textLabel.text = [[self.dataSrouce objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
   
    return cell;
}

- (UISwitch *)commonSwitch
{
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(255, 9, 7, 20)];
    if ([[UIDevice currentDevice].systemVersion compare:@"7.0"] < 0) {
        sw.frame = CGRectMake(225, 9, 7, 20);
    }
    sw.on        = NO;
    return sw;
}

- (UILabel *)commonPriceLabel
{
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
    label.textColor = [UIColor brokerLightGrayColor];
    label.font      = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)checkESFPricePromotionSwitch:(id)sender
{
    if (!self.ESFPricePromotionSwitch.on) {
        
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二手房定价推广"
                                                       message:@"关闭后，所有定价房源将暂停推广"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"关闭", nil];
       alert.tag = 10;
       [alert show];
        
    } else {
        [self esfSpreadRequestWithMethod:@"anjuke/fix/spreadstart/" switchStatus:YES];
        [self esfLogWithSwitchStatus:YES];
    }
}

- (void)checkZFPricePromotionSwitch:(id)sender
{
    if (!self.ZFPricePromotionSwitch.on) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"租房定价推广"
                                                        message:@"关闭后，所有定价房源将暂停推广"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"关闭", nil];
        alert.tag = 20;
        [alert show];
        
    } else {
         [self zfSpreadRequestWithMethod:@"zufang/fix/spreadstart/" switchStatus:YES];
         [self zfLogWithSwitchStatus:YES];
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10 && buttonIndex == 0) {

        self.ESFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 10 && buttonIndex == 1){
        
        [self esfSpreadRequestWithMethod:@"anjuke/fix/spreadstop/" switchStatus:NO];
        [self esfLogWithSwitchStatus:NO];
        
    } else if (alertView.tag == 20 && buttonIndex == 0) {
        
        self.ZFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 20 && buttonIndex == 1) {
        
        [self zfSpreadRequestWithMethod:@"zufang/fix/spreadstop/" switchStatus:NO];
        [self zfLogWithSwitchStatus:NO];
        
    }
    
}

- (void)esfSpreadRequestWithMethod:(NSString *)method switchStatus:(BOOL)switchStatus
{
    if ([self isEmpty:self.ESFPlanId]) {
        return;
    }
    NSDictionary *params = @{@"brokerId":[LoginManager getUserID],@"token":[LoginManager getToken],@"planId":self.ESFPlanId};
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleESFRequestData:)];
    [self showLoadingActivity:YES];
    self.isLoading = true;
    self.ESFPricePromotionSwitch.on = switchStatus;
    
}

- (void)zfSpreadRequestWithMethod:(NSString *)method switchStatus:(BOOL)switchStatus
{
    if ([self isEmpty:self.ZFPlanId]) {
        return;
    }
    NSDictionary *params = @{@"brokerId":[LoginManager getUserID],@"token":[LoginManager getToken],@"planId":self.ZFPlanId};
   [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleZFRequestData:)];
    [self showLoadingActivity:YES];
    self.isLoading = true;
    self.ZFPricePromotionSwitch.on = switchStatus;
    
}

- (void)handleESFRequestData:(RTNetworkResponse *)response
{
    self.isLoading = NO;
    [self hideLoadWithAnimated:YES];
    if (![self checkWithResponse:response]) {
        
    } else if ([response.content[@"status"] isEqualToString:@"ok"]) {
        
        [self displayHUDWithStatus:@"ok" Message:@"操作成功" ErrCode:nil];
    }
}

- (void)handleZFRequestData:(RTNetworkResponse *)response
{
    self.isLoading = NO;
    [self hideLoadWithAnimated:YES];
    if (![self checkWithResponse:response]) {
        
    } else if ([response.content[@"status"] isEqualToString:@"ok"]) {
        [self displayHUDWithStatus:@"ok" Message:@"操作成功" ErrCode:nil];
    }
}

#pragma mark - log
/**
 *  页面可见，二手房定价推广on-off,二手房定价推广off-on,租房定价推广on-off,租房定价推广off-on,点击返回
 */
- (void)sendAppearLog
{
   [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_ONVIEW page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)esfLogWithSwitchStatus:(BOOL)switchStatus
{
    if (switchStatus == YES) {
        
        [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_DJ_OFFON page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    } else {
        
        [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_DJ_ONOFF page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

- (void)zfLogWithSwitchStatus:(BOOL)switchStatus
{
    if (switchStatus == YES) {
        [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_ZFDJ_OFFON page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_ZFDJ_ONOFF page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
}

- (void)doBack:(id)sender
{
    [[BrokerLogger sharedInstance] logWithActionCode:TG_SETTING_BACK page:TG_SETTING_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isEmpty:(NSString *)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return true;
    }
    return false;
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