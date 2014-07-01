//
//  BrokerRegisterInfoViewController.m
//  AnjukeBroker_New
//
//  Created by wyf on 6/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerRegisterInfoViewController.h"
#import "AJKListTableViewCell.h"
#import "MainBusinessViewController.h"
#import "WorkPropertyViewController.h"
#import "SearchCompanyController.h"
#import "SearchStoreController.h"
#import "BrokerRegisterWorkDistrictViewController.h"
#import "BrokerRegisterWorkCityViewController.h"
#import "BrokerRegisterWorkBlockViewController.h"
#import <RTLineView.h>
#import "MainBusinessViewController.h"
#import "WorkPropertyViewController.h"

@interface BrokerRegisterInfoViewController () <UITableViewDataSource, UITableViewDelegate,BrokerRegisterWorkCityDelegate,BrokerRegisterWorkRangeDelegate, MainBusinessDelegate, WorkPropertyDelegate, companyDelegate,UITextFieldDelegate,storeDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *detailDataArray;
@property (nonatomic, strong) NSDictionary *natureDic;
@property (nonatomic, strong) NSDictionary *businessDic;
@property (nonatomic, strong) NSDictionary *companyDic;
@property (nonatomic, strong) NSDictionary *storeDic;
@property (nonatomic, strong) NSDictionary *cityDic;
@property (nonatomic, strong) NSDictionary *workRangeDic;
@property (nonatomic, strong) NSString *brokerName;

@end

@implementation BrokerRegisterInfoViewController

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
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    self.dataArray = @[@"",@"所在城市",@"主营业务",@"公司属性",@"所属公司",@"所在门店",@"工作范围"];
    self.detailDataArray = [NSMutableArray array];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    [self.detailDataArray addObject:@""];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bottom) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [self setupTableViewFootView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"注册"];
}

- (UIView *)setupTableViewFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 190)];
    UIButton *finishRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishRegisterBtn.frame = CGRectMake(15, 20, 290, 44);
    [finishRegisterBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [finishRegisterBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_login_button_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    [finishRegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [finishRegisterBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:finishRegisterBtn];
    return view;
}

- (void)registerAction {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    if (self.beforeDic && self.brokerName && self.cityDic && self.businessDic && self.companyDic && self.workRangeDic) {
//          NSString *string = [NSString stringWithFormat:@"%@-%@",workRangeDic[@"block"][@"blockName"],workRangeDic[@"district"][@"districtName"]];
        
        NSDictionary *param = @{@"is_nocheck":@"1",@"mobile":self.beforeDic[@"mobile"], @"password":self.beforeDic[@"password"], @"truename":self.brokerName, @"cityId":self.cityDic[@"cityId"], @"mainBusiness":self.businessDic[@"businessId"],@"companyId":self.companyDic[@"companyId"], @"storeId":self.storeDic[@"storeId"],@"blockId":self.workRangeDic[@"block"][@"blockId"],@"districtId":self.workRangeDic[@"district"][@"districtId"]};
        
        [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"broker/register/" params:param target:self action:@selector(onRegisterAction:)];
        
        [self showLoadingActivity:YES];
    }
    
}

- (void)onRegisterAction:(RTNetworkResponse *)response {
    DLog(@"response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];
//    response [{
//        data =     {
//            brokerId = 7790059;
//        };
//        status = ok;
//    }]
    if ([response.content[@"status"] isEqualToString:@"ok"]) {
        NSString *brokerId = response.content[@"data"][@"brokerId"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MainBusinessDelegate
- (void)processMainBusinessNameWithDic:(NSDictionary *)dic {
    if (!dic) {
        return;
    }
    self.businessDic = dic;
    NSString *businessName = dic[@"businessName"];
    [self.detailDataArray replaceObjectAtIndex:2 withObject:businessName];
    [self.tableView reloadData];
}

#pragma mark - WorkPropertyDelegate
- (void)processWorkPropertyNameWithDic:(NSDictionary *)dic {
    if (!dic) {
        return;
    }
    self.natureDic = dic;
    NSString *natureName = dic[@"natureName"];
    [self.detailDataArray replaceObjectAtIndex:3 withObject:natureName];
    [self.tableView reloadData];
}

#pragma mark - companyDelegate
- (void)processCompanyNameWithDic:(NSDictionary *)dic {
    self.companyDic = dic;
    [self.detailDataArray replaceObjectAtIndex:4 withObject:dic[@"companyName"]];
    [self.tableView reloadData];
}

#pragma mark - storeDelegate
- (void)processStoreNameWithDic:(NSDictionary *)dic {
    self.storeDic = dic;
    [self.detailDataArray replaceObjectAtIndex:5 withObject:dic[@"storeName"]];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.brokerName = textField.text;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *nameLbl = [UILabel new];
        nameLbl.frame = CGRectMake(15, 0, 100, 44);
        nameLbl.font = [UIFont systemFontOfSize:15];
        nameLbl.text = @"真实姓名";
        
        UITextField *nameTextField = [UITextField new];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = CGRectMake(160, 0, 120, 44);
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.delegate = self;
        if (self.brokerName) {
            nameTextField.text = self.brokerName;
        }
        self.nameTextField = nameTextField;
        
        RTLineView *lineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, 44, 305, 1)];
        [cell addSubview:lineView];
        
        [cell addSubview:nameLbl];
        [cell addSubview:nameTextField];
        return cell;
    }
    NSString *identifier = @"identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        RTLineView *lineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, 44, 305, 1)];
        [cell addSubview:lineView];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = self.detailDataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"didselect at index %d",indexPath.row);
    switch (indexPath.row) {
            case 0:
        {
            [self.nameTextField becomeFirstResponder];
        }
            break;
        case 1:
        {
            BrokerRegisterWorkCityViewController *workCity = [BrokerRegisterWorkCityViewController new];
            workCity.delegate = self;
            [self.navigationController pushViewController:workCity animated:YES];
            break;
        }
        case 2:
        {
            //跳至主营业务
            MainBusinessViewController *mainBusiness = [[MainBusinessViewController alloc] init];
            mainBusiness.delegate = self;
            mainBusiness.selectCellInfo = self.businessDic;
            mainBusiness.cityId = self.cityDic[@"cityId"];
            [self.navigationController pushViewController:mainBusiness animated:YES];

        }
            break;
        case 3:
        {
            //跳至工作性质
            WorkPropertyViewController *workProperty = [[WorkPropertyViewController alloc] init];
            workProperty.delegate = self;
            workProperty.selectCellInfo = self.natureDic;
            [self.navigationController pushViewController:workProperty animated:YES];

        }
            break;
        case 4:
        {
            //跳至所属公司
            SearchCompanyController *searchCompany = [[SearchCompanyController alloc] init];
            searchCompany.delegate = self;
            searchCompany.cityId = self.cityDic[@"cityId"];
            [self.navigationController pushViewController:searchCompany animated:YES];
        }
            break;
        case 5:
        {
            //跳至所属门店
            SearchStoreController *searchStore = [[SearchStoreController alloc] init];
            searchStore.delegate = self;
            searchStore.cityId = self.cityDic[@"cityId"];
            searchStore.companyId = self.companyDic[@"companyId"];
            [self.navigationController pushViewController:searchStore animated:YES];
            
        }
            break;
        case 6:
        {
#warning  自测数据
            BrokerRegisterWorkDistrictViewController *workDistrictViewController = [[BrokerRegisterWorkDistrictViewController alloc] init];
            workDistrictViewController.delegate = self;
            [workDistrictViewController loadDistrictDataWithCityId:self.cityDic[@"cityId"]];
            [self.navigationController pushViewController:workDistrictViewController animated:YES];
            break;
            
        }

        default:
            break;
    }
    

}

#pragma mark - BrokerRegisterWorkCityDelegate
- (void)didSelectCity:(NSDictionary *)city {
    
    DLog(@"city:%@",city);
    self.cityDic = city;
    [self.detailDataArray replaceObjectAtIndex:1 withObject:city[@"cityName"]];
    [self.tableView reloadData];
    
}

#pragma mark - BrokerRegisterWorkRangeDelegate
- (void)didSelectWorkRange:(NSDictionary *)workRangeDic {
    
    DLog(@"workRangeDic:%@",workRangeDic);
    self.workRangeDic = workRangeDic;
//    {
//        block =     {
//            blockId = 85;
//            blockName = "\U51c9\U57ce";
//        };
//        district =     {
//            districtId = 8;
//            districtName = "\U8679\U53e3";
//        };
//    }
     NSString *string = [NSString stringWithFormat:@"%@-%@",workRangeDic[@"block"][@"blockName"],workRangeDic[@"district"][@"districtName"]];
    [self.detailDataArray replaceObjectAtIndex:6 withObject:string];
    [self.tableView reloadData];
    
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
