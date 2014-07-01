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

@interface NoPlanPromotionPropertySingleViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *priceUnit;
@property (nonatomic,strong) PropertyDetailTableViewCellModel  *model;


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
    self.tableView                     = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStyleGrouped];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate            = self;
    self.tableView.dataSource          = self;
    [self.view addSubview:self.tableView];
    
#warning hardCode测试数据
    self.price     = @"1.2";
    self.priceUnit = @"元";
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData
{
#warning 含有hardCode测试数据
    NSString     *method = @"anjuke/prop/summary/";
//    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":@"858573",@"cityId":@"11",@"is_nocheck":@"1"};
    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":@"858573",@"propId":@"168783092",@"is_nocheck":@"1"};
//    NSDictionary *params = @{@"brokerId":@"858573",@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
}

- (void)handleRequestData:(RTNetworkResponse *)response
{
    
    NSDictionary *dic = [response.content objectForKey:@"data"];
    self.model        = [[PropertyDetailTableViewCellModel alloc] initWithDataDic:dic];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    if (indexPath.section == 0) {
        cellHeight = 99;
    } else if (indexPath.section == 1){
        cellHeight = 121;
        
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    if (indexPath.section == 0) {
        
        PropertyDetailTableViewCell *cell     = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.propertyDetailTableViewCellModel = self.model;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell     = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *promotionLable   = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
        promotionLable.text       = @"定价推广";
        promotionLable.font       = [UIFont systemFontOfSize:17];
        UILabel *priceLable       = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 200, 15)];
        priceLable.text           = [NSString stringWithFormat:@"点击单价：%@%@",self.price,self.priceUnit];
        priceLable.textColor      = [UIColor brokerLightGrayColor];
        priceLable.font           = [UIFont systemFontOfSize:15];
        UIButton *promotionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 290, 42)];
        promotionButton.backgroundColor    = [UIColor brokerBabyBlueColor];
        promotionButton.layer.borderColor  = [UIColor brokerBabyBlueColor].CGColor;
        promotionButton.layer.borderWidth  = 1;
        promotionButton.layer.cornerRadius = 3;
        [promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:promotionLable];
        [cell addSubview:priceLable];
        [cell addSubview:promotionButton];
        
        return cell;
    }
    
    return nil;
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
