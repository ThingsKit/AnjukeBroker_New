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
#import "AppDelegate.h"
#import "AccountManager.h"
#import "MyUserProtocolController.h"
#import "RTGestureBackNavigationController.h"
#import "BrokerCallAlert.h"

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
@property (nonatomic, strong) UIButton *registerBtn;

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bottom-41-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [self setupTableViewFootView];
    
    
    UILabel *problemLbl = [[UILabel alloc] initWithFrame:CGRectMake(37, self.view.height-41-64, 150, 21)];
    problemLbl.font = [UIFont ajkH5Font];
    problemLbl.textColor = [UIColor brokerMiddleGrayColor];
    problemLbl.text = @"如注册遇到问题，请拨打：";
    
    UIButton *dailPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dailPhoneBtn.frame = CGRectMake(problemLbl.right, problemLbl.top, 80, problemLbl.height);
    [dailPhoneBtn setTitle:@"400-620-9008" forState:UIControlStateNormal];
    [dailPhoneBtn setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    dailPhoneBtn.titleLabel.font = [UIFont ajkH5Font];
    [dailPhoneBtn addTarget:self action:@selector(dialPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:problemLbl];
    [self.view addSubview:dailPhoneBtn];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitleViewWithString:@"注册"];
}

- (void)dialPhone {
    //make call
    [[BrokerCallAlert sharedCallAlert] callAlert:@"您是否要拨打客服热线：" callPhone:@"4006209008" appLogKey:PERSONAL_CLICK_CONFIRM_CSCALL page:PERSONAL completion:^(CFAbsoluteTime time) {
        nil;
    }];
}

- (UIView *)setupTableViewFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 190)];
    UIButton *finishRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishRegisterBtn.frame = CGRectMake(15, 20, 290, 44);
    [finishRegisterBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [finishRegisterBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    
    [finishRegisterBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_lost"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateDisabled];
    [finishRegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [finishRegisterBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [finishRegisterBtn setEnabled:NO];
    
    self.registerBtn = finishRegisterBtn;
    
    [view addSubview:finishRegisterBtn];
    
    UILabel *agreeLbl = [[UILabel alloc] init];
    agreeLbl.frame = CGRectMake(40, finishRegisterBtn.bottom+15, 145, 21);
    agreeLbl.font = [UIFont ajkH5Font];
    agreeLbl.textColor = [UIColor brokerMiddleGrayColor];
    agreeLbl.text = @"点击“注册”即表示你同意";
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(agreeLbl.right-20, agreeLbl.top, 120, agreeLbl.height);
    [agreeBtn setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor brokerBabyBlueColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont ajkH5Font];
    [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:agreeLbl];
    [view addSubview:agreeBtn];
    
    return view;
}

- (void)agreeAction {
    MyUserProtocolController *userProtocolController = [[MyUserProtocolController alloc] init];
    RTGestureBackNavigationController *navController = [[RTGestureBackNavigationController alloc ] initWithRootViewController:userProtocolController];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)registerAction {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    if (self.beforeDic && self.brokerName && self.cityDic && self.businessDic &&self.workRangeDic) {
        if (!self.companyDic) {
            self.companyDic = @{@"companyId":@"11"};
        }
        if (!self.storeDic) {
            self.storeDic = @{@"storeId":@"0"};
        }
        NSDictionary *param = @{@"mobile":self.beforeDic[@"mobile"], @"password":self.beforeDic[@"password"],@"checkPassword":self.beforeDic[@"password"], @"truename":self.brokerName, @"cityId":self.cityDic[@"cityId"], @"mainBusiness":self.businessDic[@"businessId"],@"companyId":self.companyDic[@"companyId"], @"storeId":self.storeDic[@"storeId"],@"blockId":self.workRangeDic[@"block"][@"blockId"],@"districtId":self.workRangeDic[@"district"][@"districtId"]};

        
        [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"broker/register/" params:param target:self action:@selector(onRegisterAction:)];
        
        [self showLoadingActivity:YES];
    }
    
}

- (void)onRegisterAction:(RTNetworkResponse *)response {
    DLog(@"response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];

    if ([response.content[@"status"] isEqualToString:@"ok"]) {
        //保存用户登录数据
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"brokerId"] forKey:@"id"]; //用户id
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"userName"] forKey:@"username"]; //用户登录名
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userPhoto"]; //用户头像
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"cityId"] forKey:@"city_id"]; //city_id
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"mobile"] forKey:@"phone"]; //联系电话
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"trueName"] forKey:@"name"]; //用户名
        [[NSUserDefaults standardUserDefaults] setValue:response.content[@"data"][@"token"] forKey:@"token"]; //**token
        //每次重新登录请求配置数据
        [[AppDelegate sharedAppDelegate] requestSalePropertyConfig];
        [[AccountManager sharedInstance] registerNotification];
        
        TabBarViewController *tb = [[TabBarViewController alloc] init];
        [AppDelegate sharedAppDelegate].window.rootViewController = tb;
    } else if ([response.content[@"status"] isEqualToString:@"error"]) {
        if (response.content[@"message"]) {
            [self showInfo:response.content[@"message"]];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MainBusinessDelegate
- (void)processMainBusinessNameWithDic:(NSDictionary *)dic {

    if (!dic || (self.businessDic && [dic[@"businessId"] isEqualToString:self.businessDic[@"businessId"]])) {
        return;
    }
    
    self.natureDic = nil;
    self.companyDic = nil;
    self.storeDic = nil;
    self.workRangeDic = nil;
    
    [self.detailDataArray replaceObjectAtIndex:3 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:4 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:5 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:6 withObject:@""];
    
    if (!dic) {
        return;
    }

    self.businessDic = dic;
    NSString *businessName = dic[@"businessName"];
    [self.detailDataArray replaceObjectAtIndex:2 withObject:businessName];
    [self checkRegisterIsEnable];
    [self.tableView reloadData];
}

#pragma mark - WorkPropertyDelegate
- (void)processWorkPropertyNameWithDic:(NSDictionary *)dic {
    if (!dic || (self.natureDic && [dic[@"natureId"] isEqualToString:self.natureDic[@"natureId"]])) {
        return;
    }
    
    self.companyDic = nil;
    self.storeDic = nil;
    self.workRangeDic = nil;
    
    [self.detailDataArray replaceObjectAtIndex:4 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:5 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:6 withObject:@""];
    
    if (!dic) {
        return;
    }

    self.natureDic = dic;
    NSString *natureName = dic[@"natureName"];
    [self.detailDataArray replaceObjectAtIndex:3 withObject:natureName];
    [self checkRegisterIsEnable];
    [self.tableView reloadData];
}

#pragma mark - companyDelegate
- (void)processCompanyNameWithDic:(NSDictionary *)dic {

    if (!dic || (self.companyDic && [self.companyDic[@"companyId"] isEqualToString:dic[@"companyId"]])) {
        return;
    }
    self.storeDic = nil;
    self.workRangeDic = nil;
    
    [self.detailDataArray replaceObjectAtIndex:5 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:6 withObject:@""];
    
    self.companyDic = dic;
    [self.detailDataArray replaceObjectAtIndex:4 withObject:dic[@"companyName"]];
    [self checkRegisterIsEnable];
    [self.tableView reloadData];
}

#pragma mark - storeDelegate
- (void)processStoreNameWithDic:(NSDictionary *)dic {

    if (!dic || (self.storeDic && [self.storeDic[@"storeId"] isEqualToString:dic[@"storeId"]])) {
        return;
    }
    self.workRangeDic = nil;
    [self.detailDataArray replaceObjectAtIndex:6 withObject:@""];
//    {
//    storeId: "98023",
//    storeName: "中原soho店",
//    districtId: "876",
//    districtName: "王府井",
//    blockId: "677",
//    blockName: "京西"
//    },
    if (![dic[@"districtId"] isEqualToString:@""] && ![dic[@"blockId"] isEqualToString:@""]) {
        NSDictionary *workRangeDic = @{@"district":@{@"districtId":dic[@"districtId"],@"districtName":dic[@"districtName"]}, @"block":@{@"blockId": dic[@"blockId"], @"blockName":dic[@"blockName"]}};
        NSString *string = [NSString stringWithFormat:@"%@-%@",workRangeDic[@"block"][@"blockName"],workRangeDic[@"district"][@"districtName"]];
        self.workRangeDic = workRangeDic;
        
        [self.detailDataArray replaceObjectAtIndex:6 withObject:string];
    }
    
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

    self.storeDic = dic;
    [self.detailDataArray replaceObjectAtIndex:5 withObject:dic[@"storeName"]];
    [self checkRegisterIsEnable];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.brokerName = textField.text;
    [self checkRegisterIsEnable];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
}

#pragma mark - others
- (void)checkEnableCell:(UITableViewCell *) cell withIndex:(NSIndexPath *)indexPath {
    if (!self.cityDic) {
        switch (indexPath.row) {
            case 1:
                cell.userInteractionEnabled = YES;
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                cell.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }
    } else if (!self.businessDic) {
        switch (indexPath.row) {
            case 1:
            case 2:
                cell.userInteractionEnabled = YES;
                break;
            case 3:
            case 4:
            case 5:
            case 6:
                cell.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }
    } else if (!self.natureDic) {
        switch (indexPath.row) {
            case 1:
            case 2:
            case 3:
                cell.userInteractionEnabled = YES;
                break;
            case 4:
            case 5:
            case 6:
                cell.userInteractionEnabled = NO;
                break;
            default:
                break;
        }
    } else {
        NSString *natureId = self.natureDic[@"natureId"];
        //        {
        //        natureId: "1",
        //        natureName: "有所属公司",
        //        companyId: ""
        //        },
        //        {
        //        natureId: "2",
        //        natureName: "无所属公司/独立经纪人",
        //        companyId: "11"
        //        }
        
        if ([natureId isEqualToString:@"2"]) {
            switch (indexPath.row) {
                case 1:
                case 2:
                case 3:
                    cell.userInteractionEnabled = YES;
                    break;
                case 4:
                case 5:
                    cell.userInteractionEnabled = NO;
                    break;
                case 6:
                    cell.userInteractionEnabled = YES;
                    break;
                    
                default:
                    break;
            }
        } else {
            if (!self.companyDic) {
                switch (indexPath.row) {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        cell.userInteractionEnabled = YES;
                        break;
                    case 5:
                    case 6:
                        cell.userInteractionEnabled = NO;
                        break;
                        
                    default:
                        break;
                }
            } else {
                if (!self.storeDic) {
                    //公司ID（0：其他公司；11：独立经纪人/其他公司
                    if ([self.companyDic[@"companyId"] isEqualToString:@"0"]) {
                        switch (indexPath.row) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                                cell.userInteractionEnabled = YES;
                                break;
                            case 5:
                                cell.userInteractionEnabled = NO;
                                break;
                            case 6:
                                cell.userInteractionEnabled = YES;
                                break;
                                
                            default:
                                break;
                        }
                    } else {
                        switch (indexPath.row) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                                cell.userInteractionEnabled = YES;
                                break;
                            case 6:
                                cell.userInteractionEnabled = NO;
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                } else {
                    switch (indexPath.row) {
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                        case 6:
                            cell.userInteractionEnabled = YES;
                            break;
                            
                        default:
                            break;
                    }
                }
                
            }
            
        }
    }
//    @property (nonatomic, strong) NSDictionary *natureDic;
//    @property (nonatomic, strong) NSDictionary *businessDic;
//    @property (nonatomic, strong) NSDictionary *companyDic;
//    @property (nonatomic, strong) NSDictionary *storeDic;
//    @property (nonatomic, strong) NSDictionary *cityDic;
//    @property (nonatomic, strong) NSDictionary *workRangeDic;
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
        nameLbl.font =  [UIFont ajkH2Font];
        nameLbl.text = @"真实姓名";
        nameLbl.textColor = [UIColor brokerMiddleGrayColor];
        
        UITextField *nameTextField = [UITextField new];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = CGRectMake(160, 0, 120, 44);
        nameTextField.textAlignment = NSTextAlignmentRight;
        nameTextField.delegate = self;
        nameTextField.font = [UIFont ajkH2Font];
        nameTextField.textColor = [UIColor brokerBlackColor];
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

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        RTLineView *lineView = [[RTLineView alloc] initWithFrame:CGRectMake(15, 44, 305, 1)];
        [cell addSubview:lineView];
    }

//    cell.userInteractionEnabled = NO;
    [self checkEnableCell:cell withIndex:indexPath];

    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont ajkH2Font];
    cell.textLabel.textColor = [UIColor brokerMiddleGrayColor];
    cell.detailTextLabel.text = self.detailDataArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont ajkH2Font];
    cell.detailTextLabel.textColor = [UIColor brokerBlackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //
    
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
    if (!city || (self.cityDic && [city[@"cityId"] isEqualToString:self.cityDic[@"cityId"]])) {
        return;
    }
    self.businessDic = nil;
    self.natureDic = nil;
    self.companyDic = nil;
    self.storeDic = nil;
    self.workRangeDic = nil;
    [self.detailDataArray replaceObjectAtIndex:2 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:3 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:4 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:5 withObject:@""];
    [self.detailDataArray replaceObjectAtIndex:6 withObject:@""];
    
    
    self.cityDic = city;
    [self.detailDataArray replaceObjectAtIndex:1 withObject:city[@"cityName"]];
    [self checkRegisterIsEnable];
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
    [self checkRegisterIsEnable];
    [self.tableView reloadData];
    
}

- (void)checkRegisterIsEnable {
    if (self.workRangeDic && self.nameTextField.text.length > 0) {
        [self.registerBtn setEnabled:YES];
    } else {
        [self.registerBtn setEnabled:NO];
    }
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
