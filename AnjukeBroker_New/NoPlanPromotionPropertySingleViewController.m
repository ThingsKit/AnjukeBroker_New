//
//  NoPlanPromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 7/1/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "NoPlanPromotionPropertySingleViewController.h"
#import "PropertyDetailTableViewCell.h"
#import "PropertyDetailTableViewCellModel.h"
#import "PropertyDetailTableViewFooter.h"
#import "ImmediatePromotionCell.h"


@interface NoPlanPromotionPropertySingleViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *priceUnit;
@property (nonatomic,strong) NSString *publishDay;
@property (nonatomic,strong) NSString *propId;    //房源ID
@property (nonatomic,strong) NSString *brokerId;
@property (nonatomic,strong) PropertyDetailTableViewCellModel  *dataModel;
@property (nonatomic) BOOL isZF;
@end

@implementation NoPlanPromotionPropertySingleViewController

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
    [self setTitleViewWithString:@"房源详情"];
    self.tableView                     = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate            = self;
    self.tableView.dataSource          = self;
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor     = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    __weak NoPlanPromotionPropertySingleViewController *this = self;
    PropertyDetailTableViewFooter *footer = [[PropertyDetailTableViewFooter alloc] init];
    footer.editBlock   = ^(){
        
        PropertyEditViewController *propertyEditViewController = [[PropertyEditViewController alloc] init];
        propertyEditViewController.propertyID = this.propId;
        propertyEditViewController.backType   = RTSelectorBackTypePopBack;
        [this.navigationController pushViewController:propertyEditViewController animated:YES];
        
    };
    footer.deleteBlock = ^(){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要删除该房源" message:@"" delegate:this cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertView show];
        
    };
    [self.view addSubview:footer];
    
#warning hardCode测试数据
    self.price      = @"1.2";
    self.priceUnit  = @"元";
    self.publishDay = @"30";
    [self loadDataWithPropId:@"168783092" brokerId:@"858573"];
    // Do any additional setup after loading the view.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.isLoading = YES;
        // 删除房源信息
        if (![self isNetworkOkayWithNoInfo]) {
            [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
            self.isLoading = NO;
            return;
        }
        [self showLoadingActivity:YES];
        NSDictionary *params = nil;
        NSString     *method = nil;
        if (self.isZF) {
            params = @{@"cityId":[LoginManager getCity_id], @"token":[LoginManager getToken], @"brokerId": [LoginManager getUserID], @"propIds":self.propId};
            method = @"zufang/prop/delprops/";
        }
        else {
            params = @{@"token":[LoginManager getToken], @"brokerId":[LoginManager getUserID],@"propIds":self.propId};
            method = @"anjuke/prop/delprops/";
        }
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeletePropFinished:)];
 
    }
}

- (void)onDeletePropFinished:(RTNetworkResponse *)response
{
    DLog(@"--delete Prop。。。response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    //延迟一秒再dismiss页面，已让API端更新房源删除数据
    [self performSelector:@selector(doDeletePop) withObject:nil afterDelay:1];
    
}

- (void)doDeletePop {
    [self hideLoadWithAnimated:YES];
    [self showInfo:@"删除房源成功"];
    self.isLoading = NO;
    if ([self.propertyDelegate respondsToSelector:@selector(propertyDidDelete)]) {
        [self.propertyDelegate propertyDidDelete];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button action

- (void)promoteImmediately:(id)sender
{
    
    DLog(@"ImmediatePromotionButton click");
    
}

#pragma mark - requestData
- (void)loadDataWithPropId:(NSString *)propId brokerId:(NSString *)brokerId
{
#warning 含有hardCode测试数据
    self.propId   = propId;
    self.brokerId = brokerId;
    NSString     *method = @"anjuke/prop/summary/";
    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":brokerId,@"propId":propId,@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
}

- (void)handleRequestData:(RTNetworkResponse *)response
{
    
    NSDictionary *dic = [response.content objectForKey:@"data"];
    self.dataModel    = [[PropertyDetailTableViewCellModel alloc] initWithDataDic:dic];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat cellHeight = 0.0;
    if (indexPath.row == 0 || indexPath.row == 2) {
        cellHeight = 15;
    } else if (indexPath.row == 1) {
        cellHeight = 99;
    } else if (indexPath.row == 3){
        cellHeight = 121;
    } else if (indexPath.row == 4) {
        cellHeight = 10;
    } else if (indexPath.row == 5) {
        cellHeight = 15;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    if (indexPath.row == 1) {
        
        PropertyDetailTableViewCell *cell     = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.propertyDetailTableViewCellModel = self.dataModel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    } else if (indexPath.row == 3) {
        
        ImmediatePromotionCell *cell = [[ImmediatePromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.price = @"1.2";
        cell.priceUnit = @"元";
        [cell addImediatePromotionButtonTarget:self action:@selector(promoteImmediately:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.row == 5) {
        
        UITableViewCell *cell          = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *publishDataLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 305, 15)];
        publishDataLabel.text          = [NSString stringWithFormat:@"%@天前发布",self.publishDay];
        publishDataLabel.textColor     = [UIColor brokerLightGrayColor];
        publishDataLabel.font          = [UIFont systemFontOfSize:14];
        publishDataLabel.textAlignment = UITextAlignmentRight;
        
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:publishDataLabel];
        return cell;
        
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor  = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
