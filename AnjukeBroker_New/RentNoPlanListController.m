//
//  RantNoPlanListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentNoPlanListController.h"
#import "RentFixedDetailController.h"
#import "SaleNoPlanListCell.h"
#import "RentGroupListController.h"
#import "LoginManager.h"
#import "SaleNoPlanListManager.h"
#import "SaleFixedManager.h"
#import "Util_UI.h"

#define SELECT_ALL_STR @"全选"
#define UNSELECT_ALL_STR @"取消全选"

#define TOOL_BAR_HEIGHT 44

@interface RentNoPlanListController ()
{
    
}
@property (nonatomic, strong) UIView *contentView;
//@property (nonatomic, strong) UIBarButtonItem *seleceAllItem; //全选btnItem
@property int singleSelectBtnRow; //记录最后打勾按钮所在indexPath.row
@property (nonatomic, strong) UIButton *editBtn; //编辑按钮

@end

@implementation RentNoPlanListController
@synthesize contentView;
//@synthesize seleceAllItem;
@synthesize singleSelectBtnRow;
@synthesize editBtn;
@synthesize tempDic;
@synthesize fixedObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initModel_];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDisplay_];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initModel_{
    self.tempDic = [NSDictionary dictionary];
}
- (void)initDisplay_ {
    self.myTable.frame = FRAME_BETWEEN_NAV_TAB;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - TOOL_BAR_HEIGHT, [self windowWidth], TOOL_BAR_HEIGHT)];
    self.contentView.backgroundColor = SYSTEM_NAVIBAR_COLOR;
    [self addRightButton:@"确定" andPossibleTitle:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}
//#pragma mark - Request 定价推广
//-(void)doFixed{
//    if(![self isNetworkOkay]){
//        return;
//    }
//    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  @"187275101", @"proIds", @"388666", @"planId", nil];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self getStringFromArray:self.sele], @"propIds", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"], @"planId", nil];
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/addpropstoplan/" params:params target:self action:@selector(onFixedSuccess:)];
//    [self showLoadingActivity:YES];
//    self.isLoading = YES;
//}
//
//- (void)onFixedSuccess:(RTNetworkResponse *)response {
//    DLog(@"------response [%@]", [response content]);
//    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
//        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        [self hideLoadWithAnimated:YES];
//        self.isLoading = NO;
//        
//        return;
//    }
//    [self hideLoadWithAnimated:YES];
//    self.isLoading = NO;
//    
//    RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
//    controller.backType = RTSelectorBackTypePopToRoot;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"] forKey:@"fixPlanId"];
//    controller.tempDic = dic;
//    [self.navigationController pushViewController:controller animated:YES];
//}
//-(NSString *)getStringFromArray:(NSArray *) array{
//    NSMutableString *tempStr = [NSMutableString string];
//    for (int i=0;i<[array count];i++) {
//        SalePropertyObject *pro = (SalePropertyObject *)[array objectAtIndex:i];
//        if(tempStr.length == 0){
//            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
//        }else{
//            [tempStr appendString:@","];
//            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
//        }
//    }
//    DLog(@"====%@",tempStr);
//    return tempStr;
//}

#pragma mark - 请求可定价房源列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/getfixprops/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
//    NSMutableArray *result = [SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]];
//    [self.myArray removeAllObjects];
//    [self.myArray addObjectsFromArray:result];
//    [self.myTable reloadData];
//    [self hideLoadWithAnimated:YES];
//    self.isLoading = NO;
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
//    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    [self.myArray removeAllObjects];
//    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]]];
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - TableView Delegate & Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
        cell.clickDelegate = self;
    }
    [cell configureCell:[self.myArray objectAtIndex:indexPath.row] withIndex:indexPath.row];
//    [cell configureCellWithDic:[self.myArray objectAtIndex:indexPath.row]];
//    [cell configureCell:nil withIndex:indexPath.row];
    if([self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_selected@2x.png"];
    }else{
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doCheckmarkAtRow:indexPath.row];
}

#pragma mark - Checkmark Btn Delegate

- (void)checkmarkBtnClickedWithRow:(int)row {
    DLog(@"row -[%d]", row);
    
    [self doCheckmarkAtRow:row];
}

#pragma mark - PrivateMethod
//***打勾操作***
- (void)doCheckmarkAtRow:(int)row {
    self.singleSelectBtnRow = row;
    
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:row]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:row]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:row]];
    }
    [self.myTable reloadData];
    
//    [self setEditBtnEnableStatus];
}

-(void)rightButtonAction:(id)sender{
    RentGroupListController *controller = [[RentGroupListController alloc] init];
    controller.propertyArray = self.selectedArray;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
