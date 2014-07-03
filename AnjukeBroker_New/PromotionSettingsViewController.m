//
//  PromotionSettingsViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/30/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "PromotionSettingsViewController.h"
#import "RTListCell.h"

#define MORE_CELL_H 44
@interface PromotionSettingsViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSrouce;
@property(nonatomic,strong) UISwitch *ESFPricePromotionSwitch;
@property(nonatomic,strong) UISwitch *ZFPricePromotionSwitch;
@property(nonatomic,strong) UILabel  *ESFPlanceilingLabel;
@property(nonatomic,strong) UILabel  *ZFPlanceilingLabel;
@property(nonatomic,strong) NSString *ESFPrice;
@property(nonatomic,strong) NSString *ESFPriceUnit;
@property(nonatomic,strong) NSString *ZFPrice;
@property(nonatomic,strong) NSString *ZFPriceUnit;

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
    
#warning 测试text
    self.ESFPrice     = @"100";
    self.ESFPriceUnit = @"元";
    self.ZFPrice      = @"100";
    self.ZFPriceUnit  = @"元";
    self.ESFPlanceilingLabel.text = @"100元";
    self.ZFPlanceilingLabel.text  = @"100元";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStyleGrouped];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    tableView.rowHeight    = 44;
    tableView.sectionFooterHeight = 0;
    self.tableView         = tableView;
    [self.view addSubview:tableView];
    
    DLog(@"view did load");
    [self requestPromotionSettingsDataWithBrokerId:@"147468"];
    
}

- (void)requestPromotionSettingsDataWithBrokerId:(NSString *)brokerId
{
    
    NSString *method     = @"anjuke/fix/summary/";// 二手房
//    NSString *method = @"batch/";
#warning 测试
    NSDictionary *params = @{@"brokerId":brokerId,@"is_nocheck":@"1"};
#warning 一次请求两个接口
//    NSMutableDictionary *requeseParams1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId", @"1",@"is_nocheck",nil];
//    
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"GET",@"method",
//                                 @"anjuke/fix/summary/",@"relative_url",
//                                 requeseParams1,@"query_params",nil];
//    
//    NSMutableDictionary *requeseParams2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",[LoginManager getCity_id],@"cityId",@"1",@"is_nocheck", nil];
//    
//    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"GET",@"method",
//                                 @"zufang/fix/summary/",@"relative_url",
//                                 requeseParams2,@"query_params",nil];
//    
//    NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 dic1, @"fix",
//                                 dic2, @"choice", nil];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
//    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              jsonString, @"requests", nil];
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleESFRequestData:)];
    
    method = @"zufang/fix/summary/";
    params = @{@"brokerId":brokerId,@"cityId":@"11",@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleZFRequestData:)];
    
}

- (void)handleESFRequestData:(RTNetworkResponse *)response
{
    if (response.status == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);
        
        
    }
    NSDictionary *dic = [response.content valueForKey:@"data"];
    self.ESFPlanceilingLabel.text = [NSString stringWithFormat:@"%@%@",[dic valueForKey:@"budget"],[dic valueForKey:@"budgetUnit"]];
    self.ESFPricePromotionSwitch.on = [[dic valueForKey:@"planStatus"] intValue];
}

- (void)handleZFRequestData:(RTNetworkResponse *)response
{
    if (response.status == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);
        
        
    }
    NSDictionary *dic = [response.content valueForKey:@"data"];
    self.ZFPlanceilingLabel.text   = [NSString stringWithFormat:@"%@%@",[dic valueForKey:@"budget"],[dic valueForKey:@"budgetUnit"]];
    self.ZFPricePromotionSwitch.on = [[dic valueForKey:@"planStatus"] intValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"view will appear");
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
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(255, 7, 30, 20)];
    sw.on        = NO;
    return sw;
}

- (UILabel *)commonPriceLabel
{
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
    label.textColor = [UIColor brokerLightGrayColor];
    label.font      = [UIFont systemFontOfSize:15];
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1) {
        
        switch (indexPath.section) {
                
            case 0:
                
                break;
            case 1:
                
                break;
            default:
                break;
        }
        
    }
    
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
        
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二手房定价推广" message:@"关闭后，所有定价房源将暂停推广" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
       alert.tag      = 10;
       [alert show];
        
    } else {
        
        
    }
}

- (void)checkZFPricePromotionSwitch:(id)sender
{
    
    if (!self.ZFPricePromotionSwitch.on) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"租房定价推广" message:@"关闭后，所有定价房源将暂停推广" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
        alert.tag      = 20;
        [alert show];
        
    } else {
        
    }
    
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10 && buttonIndex == 0) {
        
        self.ESFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 10 && buttonIndex == 1){
        
        self.ESFPricePromotionSwitch.on = NO;
        
    } else if (alertView.tag == 20 && buttonIndex == 0) {
        
        self.ZFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 20 && buttonIndex == 1) {
        
        self.ZFPricePromotionSwitch.on = NO;
        
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
